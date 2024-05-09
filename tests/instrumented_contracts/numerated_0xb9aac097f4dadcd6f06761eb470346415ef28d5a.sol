1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to. 
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     require(newOwner != address(0));
37     owner = newOwner;
38   }
39 
40 }
41 
42 /**
43  * Abstract contract that allows children to implement an
44  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
45  *
46  */
47 contract Haltable is Ownable {
48   bool public halted;
49 
50   event Halted(bool halted);
51 
52   modifier stopInEmergency {
53     require(!halted);
54     _;
55   }
56 
57   modifier onlyInEmergency {
58     require(halted);
59     _;
60   }
61 
62   // called by the owner on emergency, triggers stopped state
63   function halt() external onlyOwner {
64     halted = true;
65     Halted(true);
66   }
67 
68   // called by the owner on end of emergency, returns to normal state
69   function unhalt() external onlyOwner onlyInEmergency {
70     halted = false;
71     Halted(false);
72   }
73 
74 }
75 
76 /**
77  * Math operations with safety checks
78  */
79 library SafeMath {
80   function mul(uint a, uint b) internal returns (uint) {
81     uint c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint a, uint b) internal returns (uint) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint a, uint b) internal returns (uint) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   function add(uint a, uint b) internal returns (uint) {
99     uint c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 
104   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
105     return a >= b ? a : b;
106   }
107 
108   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
109     return a < b ? a : b;
110   }
111 
112   function max256(uint a, uint b) internal constant returns (uint) {
113     return a >= b ? a : b;
114   }
115 
116   function min256(uint a, uint b) internal constant returns (uint) {
117     return a < b ? a : b;
118   }
119 }
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20Basic {
127   uint public totalSupply;
128   function balanceOf(address who) public constant returns (uint);
129   function transfer(address to, uint value) public returns (bool ok);
130   event Transfer(address indexed from, address indexed to, uint value);
131 }
132 
133 
134 /**
135  * @title ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/20
137  */
138 contract ERC20 is ERC20Basic {
139   function allowance(address owner, address spender) public constant returns (uint);
140   function transferFrom(address from, address to, uint value) public returns (bool ok);
141   function approve(address spender, uint value) public returns (bool ok);
142   event Approval(address indexed owner, address indexed spender, uint value);
143 }
144 
145 /**
146  * A token that defines fractional units as decimals.
147  */
148 contract FractionalERC20 is ERC20 {
149 
150   uint8 public decimals;
151 
152 }
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances. 
157  */
158 contract BasicToken is ERC20Basic {
159   using SafeMath for uint;
160 
161   mapping(address => uint) balances;
162 
163   /**
164    * Obsolete. Removed this check based on:
165    * https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure/
166    * @dev Fix for the ERC20 short address attack.
167    *
168    * modifier onlyPayloadSize(uint size) {
169    *    require(msg.data.length >= size + 4);
170    *    _;
171    * }
172    */
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint _value) public returns (bool success) {
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     Transfer(msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of. 
189   * @return An uint representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) public constant returns (uint balance) {
192     return balances[_owner];
193   }
194   
195 }
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  */
203 contract StandardToken is BasicToken, ERC20 {
204 
205   /* Token supply got increased and a new owner received these tokens */
206   event Minted(address receiver, uint amount);
207 
208   mapping (address => mapping (address => uint)) allowed;
209 
210   /* Interface declaration */
211   function isToken() public constant returns (bool weAre) {
212     return true;
213   }
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint the amout of tokens to be transfered
220    */
221   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
222     uint _allowance = allowed[_from][msg.sender];
223 
224     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
225     // require(_value <= _allowance);
226     // SafeMath uses assert instead of require though, beware when using an analysis tool
227 
228     balances[_to] = balances[_to].add(_value);
229     balances[_from] = balances[_from].sub(_value);
230     allowed[_from][msg.sender] = _allowance.sub(_value);
231     Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint _value) public returns (bool success) {
241 
242     // To change the approve amount you first have to reduce the addresses'
243     //  allowance to zero by calling `approve(_spender, 0)` if it is not
244     //  already 0 to mitigate the race condition described here:
245     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246     require (_value == 0 || allowed[msg.sender][_spender] == 0);
247 
248     allowed[msg.sender][_spender] = _value;
249     Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens than an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint specifing the amount of tokens still avaible for the spender.
258    */
259   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
260     return allowed[_owner][_spender];
261   }
262 
263   /**
264    * Atomic increment of approved spending
265    *
266    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267    *
268    */
269   function addApproval(address _spender, uint _addedValue) public
270   returns (bool success) {
271       uint oldValue = allowed[msg.sender][_spender];
272       allowed[msg.sender][_spender] = oldValue.add(_addedValue);
273       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274       return true;
275   }
276 
277   /**
278    * Atomic decrement of approved spending.
279    *
280    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281    */
282   function subApproval(address _spender, uint _subtractedValue) public
283   returns (bool success) {
284 
285       uint oldVal = allowed[msg.sender][_spender];
286 
287       if (_subtractedValue > oldVal) {
288           allowed[msg.sender][_spender] = 0;
289       } else {
290           allowed[msg.sender][_spender] = oldVal.sub(_subtractedValue);
291       }
292       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293       return true;
294   }
295   
296 }
297 
298 /**
299  * Define interface for releasing the token transfer after a successful crowdsale.
300  */
301 contract ReleasableToken is StandardToken, Ownable {
302 
303   /* The finalizer contract that allows lifting the transfer limits on this token */
304   address public releaseAgent;
305 
306   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
307   bool public released = false;
308 
309   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
310   mapping (address => bool) public transferAgents;
311 
312   /**
313    * Set the contract that can call release and make the token transferable.
314    *
315    * Since the owner of this contract is (or should be) the crowdsale,
316    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
317    */
318   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
319     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
320     releaseAgent = addr;
321   }
322 
323   /**
324    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
325    */
326   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
327     transferAgents[addr] = state;
328   }
329 
330   /**
331    * One way function to release the tokens into the wild.
332    *
333    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
334    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
335    */
336   function releaseTokenTransfer() public onlyReleaseAgent {
337     released = true;
338   }
339 
340   /**
341    * Limit token transfer until the crowdsale is over.
342    */
343   modifier canTransfer(address _sender) {
344     require(released || transferAgents[_sender]);
345     _;
346   }
347 
348   /** The function can be called only before or after the tokens have been released */
349   modifier inReleaseState(bool releaseState) {
350     require(releaseState == released);
351     _;
352   }
353 
354   /** The function can be called only by a whitelisted release agent. */
355   modifier onlyReleaseAgent() {
356     require(msg.sender == releaseAgent);
357     _;
358   }
359 
360   /** We restrict transfer by overriding it */
361   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
362     // Call StandardToken.transfer()
363    return super.transfer(_to, _value);
364   }
365 
366   /** We restrict transferFrom by overriding it */
367   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
368     // Call StandardToken.transferForm()
369     return super.transferFrom(_from, _to, _value);
370   }
371 
372 }
373 
374 /**
375  * A token that can increase its supply by another contract.
376  *
377  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
378  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
379  *
380  */
381 contract MintableToken is StandardToken, Ownable {
382 
383   using SafeMath for uint;
384 
385   bool public mintingFinished = false;
386 
387   /** List of agents that are allowed to create new tokens */
388   mapping (address => bool) public mintAgents;
389 
390   event MintingAgentChanged(address addr, bool state);
391 
392 
393   function MintableToken(uint _initialSupply, address _multisig, bool _mintable) internal {
394     require(_multisig != address(0));
395     // Cannot create a token without supply and no minting
396     require(_mintable || _initialSupply != 0);
397     // Create initially all balance on the team multisig
398     if (_initialSupply > 0)
399         mintInternal(_multisig, _initialSupply);
400     // No more new supply allowed after the token creation
401     mintingFinished = !_mintable;
402   }
403 
404   /**
405    * Create new tokens and allocate them to an address.
406    *
407    * Only callable by a crowdsale contract (mint agent).
408    */
409   function mint(address receiver, uint amount) onlyMintAgent public {
410     mintInternal(receiver, amount);
411   }
412 
413   function mintInternal(address receiver, uint amount) canMint private {
414     totalSupply = totalSupply.add(amount);
415     balances[receiver] = balances[receiver].add(amount);
416 
417     // Removed because this may be confused with anonymous transfers in the upcoming fork.
418     // This will make the mint transaction appear in EtherScan.io
419     // We can remove this after there is a standardized minting event
420     // Transfer(0, receiver, amount);
421 
422     Minted(receiver, amount);
423   }
424 
425   /**
426    * Owner can allow a crowdsale contract to mint new tokens.
427    */
428   function setMintAgent(address addr, bool state) onlyOwner canMint public {
429     mintAgents[addr] = state;
430     MintingAgentChanged(addr, state);
431   }
432 
433   modifier onlyMintAgent() {
434     // Only mint agents are allowed to mint new tokens
435     require(mintAgents[msg.sender]);
436     _;
437   }
438 
439   /** Make sure we are not done yet. */
440   modifier canMint() {
441     require(!mintingFinished);
442     _;
443   }
444 }
445 
446 /**
447  * Upgrade agent transfers tokens to a new contract.
448  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
449  *
450  * The Upgrade agent is the interface used to implement a token
451  * migration in the case of an emergency.
452  * The function upgradeFrom has to implement the part of the creation
453  * of new tokens on behalf of the user doing the upgrade.
454  *
455  * The new token can implement this interface directly, or use.
456  */
457 contract UpgradeAgent {
458 
459   /** This value should be the same as the original token's total supply */
460   uint public originalSupply;
461 
462   /** Interface to ensure the contract is correctly configured */
463   function isUpgradeAgent() public constant returns (bool) {
464     return true;
465   }
466 
467   /**
468   Upgrade an account
469 
470   When the token contract is in the upgrade status the each user will
471   have to call `upgrade(value)` function from UpgradeableToken.
472 
473   The upgrade function adjust the balance of the user and the supply
474   of the previous token and then call `upgradeFrom(value)`.
475 
476   The UpgradeAgent is the responsible to create the tokens for the user
477   in the new contract.
478 
479   * @param _from Account to upgrade.
480   * @param _value Tokens to upgrade.
481 
482   */
483   function upgradeFrom(address _from, uint _value) public;
484 
485 }
486 
487 /**
488  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
489  *
490  */
491 contract UpgradeableToken is StandardToken {
492 
493   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
494   address public upgradeMaster;
495 
496   /** The next contract where the tokens will be migrated. */
497   UpgradeAgent public upgradeAgent;
498 
499   /** How many tokens we have upgraded by now. */
500   uint public totalUpgraded;
501 
502   /**
503    * Upgrade states.
504    *
505    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
506    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
507    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
508    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
509    *
510    */
511   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
512 
513   /**
514    * Somebody has upgraded some of his tokens.
515    */
516   event Upgrade(address indexed _from, address indexed _to, uint _value);
517 
518   /**
519    * New upgrade agent available.
520    */
521   event UpgradeAgentSet(address agent);
522 
523   /**
524    * Do not allow construction without upgrade master set.
525    */
526   function UpgradeableToken(address _upgradeMaster) {
527     setUpgradeMaster(_upgradeMaster);
528   }
529 
530   /**
531    * Allow the token holder to upgrade some of their tokens to a new contract.
532    */
533   function upgrade(uint value) public {
534     UpgradeState state = getUpgradeState();
535     // Ensure it's not called in a bad state
536     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
537 
538     // Validate input value.
539     require(value != 0);
540 
541     balances[msg.sender] = balances[msg.sender].sub(value);
542 
543     // Take tokens out from circulation
544     totalSupply = totalSupply.sub(value);
545     totalUpgraded = totalUpgraded.add(value);
546 
547     // Upgrade agent reissues the tokens
548     upgradeAgent.upgradeFrom(msg.sender, value);
549     Upgrade(msg.sender, upgradeAgent, value);
550   }
551 
552   /**
553    * Set an upgrade agent that handles the upgrade process
554    */
555   function setUpgradeAgent(address agent) external {
556     // Check whether the token is in a state that we could think of upgrading
557     require(canUpgrade());
558 
559     require(agent != 0x0);
560     // Only a master can designate the next agent
561     require(msg.sender == upgradeMaster);
562     // Upgrade has already begun for an agent
563     require(getUpgradeState() != UpgradeState.Upgrading);
564 
565     upgradeAgent = UpgradeAgent(agent);
566 
567     // Bad interface
568     require(upgradeAgent.isUpgradeAgent());
569     // Make sure that token supplies match in source and target
570     require(upgradeAgent.originalSupply() == totalSupply);
571 
572     UpgradeAgentSet(upgradeAgent);
573   }
574 
575   /**
576    * Get the state of the token upgrade.
577    */
578   function getUpgradeState() public constant returns(UpgradeState) {
579     if (!canUpgrade()) return UpgradeState.NotAllowed;
580     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
581     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
582     else return UpgradeState.Upgrading;
583   }
584 
585   /**
586    * Change the upgrade master.
587    *
588    * This allows us to set a new owner for the upgrade mechanism.
589    */
590   function changeUpgradeMaster(address new_master) public {
591     require(msg.sender == upgradeMaster);
592     setUpgradeMaster(new_master);
593   }
594 
595   /**
596    * Internal upgrade master setter.
597    */
598   function setUpgradeMaster(address new_master) private {
599     require(new_master != 0x0);
600     upgradeMaster = new_master;
601   }
602 
603   /**
604    * Child contract can enable to provide the condition when the upgrade can begin.
605    */
606   function canUpgrade() public constant returns(bool) {
607      return true;
608   }
609 
610 }
611 
612 
613 /**
614  * A crowdsale token.
615  *
616  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
617  *
618  * - The token transfer() is disabled until the crowdsale is over
619  * - The token contract gives an opt-in upgrade path to a new contract
620  * - The same token can be part of several crowdsales through the approve() mechanism
621  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
622  *
623  */
624 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, FractionalERC20 {
625 
626   event UpdatedTokenInformation(string newName, string newSymbol);
627 
628   string public name;
629 
630   string public symbol;
631 
632   /**
633    * Construct the token.
634    *
635    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
636    *
637    * @param _name Token name
638    * @param _symbol Token symbol - typically it's all caps
639    * @param _initialSupply How many tokens we start with
640    * @param _decimals Number of decimal places
641    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
642    */
643   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, address _multisig, bool _mintable)
644     UpgradeableToken(_multisig) MintableToken(_initialSupply, _multisig, _mintable) {
645     name = _name;
646     symbol = _symbol;
647     decimals = _decimals;
648   }
649 
650   /**
651    * When token is released to be transferable, prohibit new token creation.
652    */
653   function releaseTokenTransfer() public onlyReleaseAgent {
654     mintingFinished = true;
655     super.releaseTokenTransfer();
656   }
657 
658   /**
659    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
660    */
661   function canUpgrade() public constant returns(bool) {
662     return released && super.canUpgrade();
663   }
664 
665   /**
666    * Owner can update token information here
667    */
668   function setTokenInformation(string _name, string _symbol) onlyOwner {
669     name = _name;
670     symbol = _symbol;
671 
672     UpdatedTokenInformation(name, symbol);
673   }
674 
675 }
676 
677 /**
678  * Abstract base contract for token sales.
679  *
680  * Handles
681  * - start and end dates
682  * - accepting investments
683  * - minimum funding goal and refund
684  * - various statistics during the crowdfund
685  * - different pricing strategies
686  * - different investment policies (require server side customer id, allow only whitelisted addresses)
687  *
688  */
689 contract Crowdsale is Haltable {
690 
691   using SafeMath for uint;
692 
693   /* The token we are selling */
694   CrowdsaleToken public token;
695 
696   /* How we are going to price our offering */
697   PricingStrategy public pricingStrategy;
698 
699   /* How we are going to limit our offering */
700   CeilingStrategy public ceilingStrategy;
701 
702   /* Post-success callback */
703   FinalizeAgent public finalizeAgent;
704 
705   /* ether will be transferred to this address */
706   address public multisigWallet;
707 
708   /* if the funding goal is not reached, investors may withdraw their funds */
709   uint public minimumFundingGoal;
710 
711   /* the funding cannot exceed this cap; may be set later on during the crowdsale */
712   uint public weiFundingCap = 0;
713 
714   /* the starting block number of the crowdsale */
715   uint public startsAt;
716 
717   /* the ending block number of the crowdsale */
718   uint public endsAt;
719 
720   /* the number of tokens already sold through this contract*/
721   uint public tokensSold = 0;
722 
723   /* How many wei of funding we have raised */
724   uint public weiRaised = 0;
725 
726   /* How many distinct addresses have invested */
727   uint public investorCount = 0;
728 
729   /* How many wei we have returned back to the contract after a failed crowdfund. */
730   uint public loadedRefund = 0;
731 
732   /* How many wei we have given back to investors.*/
733   uint public weiRefunded = 0;
734 
735   /* Has this crowdsale been finalized */
736   bool public finalized;
737 
738   /* Do we need to have a unique contributor id for each customer */
739   bool public requireCustomerId;
740 
741   /** How many ETH each address has invested in this crowdsale */
742   mapping (address => uint) public investedAmountOf;
743 
744   /** How many tokens this crowdsale has credited for each investor address */
745   mapping (address => uint) public tokenAmountOf;
746 
747   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
748   mapping (address => bool) public earlyParticipantWhitelist;
749 
750   /** This is for manual testing of the interaction with the owner's wallet. You can set it to any value and inspect this in a blockchain explorer to see that crowdsale interaction works. */
751   uint8 public ownerTestValue;
752 
753   /** State machine
754    *
755    * - Prefunding: We have not reached the starting block yet
756    * - Funding: Active crowdsale
757    * - Success: Minimum funding goal reached
758    * - Failure: Minimum funding goal not reached before the ending block
759    * - Finalized: The finalize function has been called and succesfully executed
760    * - Refunding: Refunds are loaded on the contract to be reclaimed by investors.
761    */
762   enum State{Unknown, PreFunding, Funding, Success, Failure, Finalized, Refunding}
763 
764 
765   // A new investment was made
766   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
767 
768   // Refund was processed for a contributor
769   event Refund(address investor, uint weiAmount);
770 
771   // The rules about what kind of investments we accept were changed
772   event InvestmentPolicyChanged(bool requireCId);
773 
774   // Address early participation whitelist status changed
775   event Whitelisted(address addr, bool status);
776 
777   // Crowdsale's finalize function has been called
778   event Finalized();
779 
780   // A new funding cap has been set
781   event FundingCapSet(uint newFundingCap);
782 
783   function Crowdsale(address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal) internal {
784     setMultisig(_multisigWallet);
785 
786     // Don't mess the dates
787     require(_start != 0 && _end != 0);
788     require(block.number < _start && _start < _end);
789     startsAt = _start;
790     endsAt = _end;
791 
792     // Minimum funding goal can be zero
793     minimumFundingGoal = _minimumFundingGoal;
794   }
795 
796   /**
797    * Don't expect to just send in money and get tokens.
798    */
799   function() payable {
800     require(false);
801   }
802 
803   /**
804    * Make an investment.
805    *
806    * Crowdsale must be running for one to invest.
807    * We must have not pressed the emergency brake.
808    *
809    * @param receiver The Ethereum address who receives the tokens
810    * @param customerId (optional) UUID v4 to track the successful payments on the server side
811    *
812    */
813   function investInternal(address receiver, uint128 customerId) stopInEmergency notFinished private {
814     // Determine if it's a good time to accept investment from this participant
815     if (getState() == State.PreFunding) {
816       // Are we whitelisted for early deposit
817       require(earlyParticipantWhitelist[receiver]);
818     }
819 
820     uint weiAmount = ceilingStrategy.weiAllowedToReceive(msg.value, weiRaised, investedAmountOf[receiver], weiFundingCap);
821     uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
822     
823     // Dust transaction if no tokens can be given
824     require(tokenAmount != 0);
825 
826     if (investedAmountOf[receiver] == 0) {
827       // A new investor
828       investorCount++;
829     }
830     updateInvestorFunds(tokenAmount, weiAmount, receiver, customerId);
831 
832     // Pocket the money
833     multisigWallet.transfer(weiAmount);
834 
835     // Return excess of money
836     uint weiToReturn = msg.value.sub(weiAmount);
837     if (weiToReturn > 0) {
838       msg.sender.transfer(weiToReturn);
839     }
840   }
841 
842   /**
843    * Preallocate tokens for the early investors.
844    *
845    * Preallocated tokens have been sold before the actual crowdsale opens.
846    * This function mints the tokens and moves the crowdsale needle.
847    *
848    * No money is exchanged, as the crowdsale team already have received the payment.
849    *
850    * @param fullTokens tokens as full tokens - decimal places added internally
851    * @param weiPrice Price of a single full token in wei
852    *
853    */
854   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner notFinished {
855     require(receiver != address(0));
856     uint tokenAmount = fullTokens.mul(10**uint(token.decimals()));
857     require(tokenAmount != 0);
858     uint weiAmount = weiPrice.mul(tokenAmount); // This can also be 0, in which case we give out tokens for free
859     updateInvestorFunds(tokenAmount, weiAmount, receiver , 0);
860   }
861 
862   /**
863    * Private function to update accounting in the crowdsale.
864    */
865   function updateInvestorFunds(uint tokenAmount, uint weiAmount, address receiver, uint128 customerId) private {
866     // Update investor
867     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
868     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
869 
870     // Update totals
871     weiRaised = weiRaised.add(weiAmount);
872     tokensSold = tokensSold.add(tokenAmount);
873 
874     assignTokens(receiver, tokenAmount);
875     // Tell us that the investment was completed successfully
876     Invested(receiver, weiAmount, tokenAmount, customerId);
877   }
878 
879 
880   /**
881    * Allow the owner to set a funding cap on the crowdsale.
882    * The new cap should be higher than the minimum funding goal.
883    * 
884    * @param newCap minimum target cap that may be relaxed if it was already broken.
885    */
886   function setFundingCap(uint newCap) public onlyOwner notFinished {
887     weiFundingCap = ceilingStrategy.relaxFundingCap(newCap, weiRaised);
888     require(weiFundingCap >= minimumFundingGoal);
889     FundingCapSet(weiFundingCap);
890   }
891 
892   /**
893    * Invest to tokens, recognize the payer.
894    *
895    */
896   function buyWithCustomerId(uint128 customerId) public payable {
897     require(customerId != 0);  // UUIDv4 sanity check
898     investInternal(msg.sender, customerId);
899   }
900 
901   /**
902    * The basic entry point to participate in the crowdsale process.
903    *
904    * Pay for funding, get invested tokens back in the sender address.
905    */
906   function buy() public payable {
907     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
908     investInternal(msg.sender, 0);
909   }
910 
911   /**
912    * Finalize a succcesful crowdsale.
913    *
914    * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
915    */
916   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
917     finalizeAgent.finalizeCrowdsale(token);
918     finalized = true;
919     Finalized();
920   }
921 
922   /**
923    * Set policy do we need to have server-side customer ids for the investments.
924    *
925    */
926   function setRequireCustomerId(bool value) public onlyOwner stopInEmergency {
927     requireCustomerId = value;
928     InvestmentPolicyChanged(requireCustomerId);
929   }
930 
931   /**
932    * Allow addresses to do early participation.
933    *
934    */
935   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
936     earlyParticipantWhitelist[addr] = status;
937     Whitelisted(addr, status);
938   }
939 
940   /**
941    * Allow to (re)set pricing strategy.
942    */
943   function setPricingStrategy(PricingStrategy addr) internal {
944     // Disallow setting a bad agent
945     require(addr.isPricingStrategy());
946     pricingStrategy = addr;
947   }
948 
949   /**
950    * Allow to (re)set ceiling strategy.
951    */
952   function setCeilingStrategy(CeilingStrategy addr) internal {
953     // Disallow setting a bad agent
954     require(addr.isCeilingStrategy());
955     ceilingStrategy = addr;
956   }
957 
958   /**
959    * Allow to (re)set finalize agent.
960    */
961   function setFinalizeAgent(FinalizeAgent addr) internal {
962     // Disallow setting a bad agent
963     require(addr.isFinalizeAgent());
964     finalizeAgent = addr;
965     require(isFinalizerSane());
966   }
967 
968   /**
969    * Internal setter for the multisig wallet
970    */
971   function setMultisig(address addr) internal {
972     require(addr != 0);
973     multisigWallet = addr;
974   }
975 
976   /**
977    * Allow load refunds back on the contract for the refunding.
978    *
979    * The team can transfer the funds back on the smart contract in the case that the minimum goal was not reached.
980    */
981   function loadRefund() public payable inState(State.Failure) stopInEmergency {
982     require(msg.value >= weiRaised);
983     require(weiRefunded == 0);
984     uint excedent = msg.value.sub(weiRaised);
985     loadedRefund = loadedRefund.add(msg.value.sub(excedent));
986     investedAmountOf[msg.sender].add(excedent);
987   }
988 
989   /**
990    * Investors can claim refund.
991    */
992   function refund() public inState(State.Refunding) stopInEmergency {
993     uint weiValue = investedAmountOf[msg.sender];
994     require(weiValue != 0);
995     investedAmountOf[msg.sender] = 0;
996     weiRefunded = weiRefunded.add(weiValue);
997     Refund(msg.sender, weiValue);
998     msg.sender.transfer(weiValue);
999   }
1000 
1001   /**
1002    * @return true if the crowdsale has raised enough money to be a success
1003    */
1004   function isMinimumGoalReached() public constant returns (bool reached) {
1005     return weiRaised >= minimumFundingGoal;
1006   }
1007 
1008   /**
1009    * Check if the contract relationship looks good.
1010    */
1011   function isFinalizerSane() public constant returns (bool sane) {
1012     return finalizeAgent.isSane(token);
1013   }
1014 
1015   /**
1016    * Crowdfund state machine management.
1017    *
1018    * This function has the timed transition builtin.
1019    * So there is no chance of the variable being stale.
1020    */
1021   function getState() public constant returns (State) {
1022     if (finalized) return State.Finalized;
1023     else if (block.number < startsAt) return State.PreFunding;
1024     else if (block.number <= endsAt && !ceilingStrategy.isCrowdsaleFull(weiRaised, weiFundingCap)) return State.Funding;
1025     else if (isMinimumGoalReached()) return State.Success;
1026     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1027     else return State.Failure;
1028   }
1029 
1030   /** This is for manual testing of multisig wallet interaction */
1031   function setOwnerTestValue(uint8 val) public onlyOwner stopInEmergency {
1032     ownerTestValue = val;
1033   }
1034 
1035   function assignTokens(address receiver, uint tokenAmount) private {
1036     token.mint(receiver, tokenAmount);
1037   }
1038 
1039   /** Interface marker. */
1040   function isCrowdsale() public constant returns (bool) {
1041     return true;
1042   }
1043 
1044   //
1045   // Modifiers
1046   //
1047 
1048   /** Modifier allowing execution only if the crowdsale is currently running.  */
1049   modifier inState(State state) {
1050     require(getState() == state);
1051     _;
1052   }
1053 
1054   modifier notFinished() {
1055     State current_state = getState();
1056     require(current_state == State.PreFunding || current_state == State.Funding);
1057     _;
1058   }
1059 
1060 }
1061 
1062 /**
1063  * Interface for defining crowdsale pricing.
1064  */
1065 contract PricingStrategy {
1066 
1067   /** Interface declaration. */
1068   function isPricingStrategy() public constant returns (bool) {
1069     return true;
1070   }
1071 
1072   /**
1073    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
1074    *
1075    *
1076    * @param value - What is the value of the transaction sent in as wei
1077    * @param weiRaised - how much money has been raised this far
1078    * @param tokensSold - how many tokens have been sold this far
1079    * @param msgSender - who is the investor of this transaction
1080    * @param decimals - how many decimal units the token has
1081    * @return Amount of tokens the investor receives
1082    */
1083   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
1084 }
1085 
1086 /**
1087  * Fixed crowdsale pricing - everybody gets the same price.
1088  */
1089 contract FlatPricing is PricingStrategy {
1090 
1091   using SafeMath for uint;
1092 
1093   /* How many weis one token costs */
1094   uint public oneTokenInWei;
1095 
1096   function FlatPricing(uint _oneTokenInWei) {
1097     oneTokenInWei = _oneTokenInWei;
1098   }
1099 
1100   /**
1101    * Calculate the current price for buy in amount.
1102    *
1103    * @ param  {uint value} Buy-in value in wei.
1104    * @ param
1105    * @ param
1106    * @ param
1107    * @ param  {uint decimals} The decimals used by the token representation (e.g. given by FractionalERC20).
1108    */
1109   function calculatePrice(uint value, uint, uint, address, uint decimals) public constant returns (uint) {
1110     uint multiplier = 10 ** decimals;
1111     return value.mul(multiplier).div(oneTokenInWei);
1112   }
1113 
1114 }
1115 
1116 /**
1117  * Interface for defining crowdsale ceiling.
1118  */
1119 contract CeilingStrategy {
1120 
1121   /** Interface declaration. */
1122   function isCeilingStrategy() public constant returns (bool) {
1123     return true;
1124   }
1125 
1126   /**
1127    * When somebody tries to buy tokens for X wei, calculate how many weis they are allowed to use.
1128    *
1129    *
1130    * @param _value - What is the value of the transaction sent in as wei.
1131    * @param _weiRaised - How much money has been raised so far.
1132    * @param _weiInvestedBySender - the investment made by the address that is sending the transaction.
1133    * @param _weiFundingCap - the caller's declared total cap. May be reinterpreted by the implementation of the CeilingStrategy.
1134    * @return Amount of wei the crowdsale can receive.
1135    */
1136   function weiAllowedToReceive(uint _value, uint _weiRaised, uint _weiInvestedBySender, uint _weiFundingCap) public constant returns (uint amount);
1137 
1138   function isCrowdsaleFull(uint _weiRaised, uint _weiFundingCap) public constant returns (bool);
1139 
1140   /**
1141    * Calculate a new cap if the provided one is not above the amount already raised.
1142    *
1143    *
1144    * @param _newCap - The potential new cap.
1145    * @param _weiRaised - How much money has been raised so far.
1146    * @return The adjusted cap.
1147    */
1148   function relaxFundingCap(uint _newCap, uint _weiRaised) public constant returns (uint);
1149 
1150 }
1151 
1152 /**
1153  * Fixed cap investment per address and crowdsale
1154  */
1155 contract FixedCeiling is CeilingStrategy {
1156     using SafeMath for uint;
1157 
1158     /* When relaxing a cap is necessary, we use this multiple to determine the relaxed cap */
1159     uint public chunkedWeiMultiple;
1160     /* The limit an individual address can invest */
1161     uint public weiLimitPerAddress;
1162 
1163     function FixedCeiling(uint multiple, uint limit) {
1164         chunkedWeiMultiple = multiple;
1165         weiLimitPerAddress = limit;
1166     }
1167 
1168     function weiAllowedToReceive(uint tentativeAmount, uint weiRaised, uint weiInvestedBySender, uint weiFundingCap) public constant returns (uint) {
1169         // First, we limit per address investment
1170         uint totalOfSender = tentativeAmount.add(weiInvestedBySender);
1171         if (totalOfSender > weiLimitPerAddress) tentativeAmount = weiLimitPerAddress.sub(weiInvestedBySender);
1172         // Then, we check the funding cap
1173         if (weiFundingCap == 0) return tentativeAmount;
1174         uint total = tentativeAmount.add(weiRaised);
1175         if (total < weiFundingCap) return tentativeAmount;
1176         else return weiFundingCap.sub(weiRaised);
1177     }
1178 
1179     function isCrowdsaleFull(uint weiRaised, uint weiFundingCap) public constant returns (bool) {
1180         return weiFundingCap > 0 && weiRaised >= weiFundingCap;
1181     }
1182 
1183     /* If the new target cap has not been reached yet, it's fine as it is */
1184     function relaxFundingCap(uint newCap, uint weiRaised) public constant returns (uint) {
1185         if (newCap > weiRaised) return newCap;
1186         else return weiRaised.div(chunkedWeiMultiple).add(1).mul(chunkedWeiMultiple);
1187     }
1188 
1189 }
1190 
1191 /**
1192  * Finalize agent defines what happens at the end of a succesful crowdsale.
1193  *
1194  * - Allocate tokens for founders, bounties and community
1195  * - Make tokens transferable
1196  * - etc.
1197  */
1198 contract FinalizeAgent {
1199 
1200   function isFinalizeAgent() public constant returns(bool) {
1201     return true;
1202   }
1203 
1204   /** Return true if we can run finalizeCrowdsale() properly.
1205    *
1206    * This is a safety check function that doesn't allow crowdsale to begin
1207    * unless the finalizer has been set up properly.
1208    */
1209   function isSane(CrowdsaleToken token) public constant returns (bool);
1210 
1211   /** Called once by crowdsale finalize() if the sale was a success. */
1212   function finalizeCrowdsale(CrowdsaleToken token) public;
1213 
1214 }
1215 
1216 /**
1217  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1218  *
1219  * Unlock tokens.
1220  *
1221  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1222  *
1223  */
1224 contract BonusFinalizeAgent is FinalizeAgent {
1225 
1226   using SafeMath for uint;
1227 
1228   Crowdsale public crowdsale;
1229 
1230   /** Total percent of tokens minted to the team at the end of the sale as base points
1231   bonus tokens = tokensSold * bonusBasePoints * 0.0001         */
1232   uint public bonusBasePoints;
1233 
1234   /** Implementation detail. This is the divisor of the base points **/
1235   uint private constant basePointsDivisor = 10000;
1236 
1237   /** Where we move the tokens at the end of the sale. */
1238   address public teamMultisig;
1239 
1240   /* How many bonus tokens we allocated */
1241   uint public allocatedBonus;
1242 
1243   function BonusFinalizeAgent(Crowdsale _crowdsale, uint _bonusBasePoints, address _teamMultisig) {
1244     require(address(_crowdsale) != 0 && address(_teamMultisig) != 0);
1245     crowdsale = _crowdsale;
1246     teamMultisig = _teamMultisig;
1247     bonusBasePoints = _bonusBasePoints;
1248   }
1249 
1250   /* Can we run finalize properly */
1251   function isSane(CrowdsaleToken token) public constant returns (bool) {
1252     return token.mintAgents(address(this)) && token.releaseAgent() == address(this);
1253   }
1254 
1255   /** Called once by crowdsale finalize() if the sale was a success. */
1256   function finalizeCrowdsale(CrowdsaleToken token) {
1257     require(msg.sender == address(crowdsale));
1258 
1259     // How many % points of tokens the founders and others get
1260     uint tokensSold = crowdsale.tokensSold();
1261     uint saleBasePoints = basePointsDivisor.sub(bonusBasePoints);
1262     allocatedBonus = tokensSold.mul(bonusBasePoints).div(saleBasePoints);
1263 
1264     // Move tokens to the team multisig wallet
1265     token.mint(teamMultisig, allocatedBonus);
1266 
1267     // Make token transferable
1268     token.releaseTokenTransfer();
1269   }
1270 
1271 }
1272 
1273 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1274 contract HubiiCrowdsale is Crowdsale {
1275     uint private constant chunked_multiple = 18000 * (10 ** 18); // in wei
1276     uint private constant limit_per_address = 100000 * (10 ** 18); // in wei
1277     uint private constant hubii_minimum_funding = 17000 * (10 ** 18); // in wei
1278     uint private constant token_initial_supply = 0;
1279     uint8 private constant token_decimals = 15;
1280     bool private constant token_mintable = true;
1281     string private constant token_name = "Hubiits";
1282     string private constant token_symbol = "HBT";
1283     uint private constant token_in_wei = 10 ** 15;
1284     // The fraction of 10,000 out of the total target tokens that is used to mint bonus tokens. These are allocated to the team's multisig wallet.
1285     uint private constant bonus_base_points = 3000;
1286     function HubiiCrowdsale(address _teamMultisig, uint _start, uint _end) Crowdsale(_teamMultisig, _start, _end, hubii_minimum_funding) public {
1287         PricingStrategy p_strategy = new FlatPricing(token_in_wei);
1288         CeilingStrategy c_strategy = new FixedCeiling(chunked_multiple, limit_per_address);
1289         FinalizeAgent f_agent = new BonusFinalizeAgent(this, bonus_base_points, _teamMultisig); 
1290         setPricingStrategy(p_strategy);
1291         setCeilingStrategy(c_strategy);
1292         // Testing values
1293         token = new CrowdsaleToken(token_name, token_symbol, token_initial_supply, token_decimals, _teamMultisig, token_mintable);
1294         token.setMintAgent(address(this), true);
1295         token.setMintAgent(address(f_agent), true);
1296         token.setReleaseAgent(address(f_agent));
1297         setFinalizeAgent(f_agent);
1298     }
1299 
1300     // These two setters are present only to correct block numbers if they are off from their target date by more than, say, a day
1301     function setStartingBlock(uint startingBlock) public onlyOwner inState(State.PreFunding) {
1302         require(startingBlock > block.number && startingBlock < endsAt);
1303         startsAt = startingBlock;
1304     }
1305 
1306     function setEndingBlock(uint endingBlock) public onlyOwner notFinished {
1307         require(endingBlock > block.number && endingBlock > startsAt);
1308         endsAt = endingBlock;
1309     }
1310 }