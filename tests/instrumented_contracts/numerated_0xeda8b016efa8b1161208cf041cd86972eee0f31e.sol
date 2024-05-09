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
104 
105 
106 /**
107  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
108  *
109  * Based on code by FirstBlood:
110  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, SafeMathLib {
113   /* Token supply got increased and a new owner received these tokens */
114   event Minted(address receiver, uint256 amount);
115 
116   /* Actual balances of token holders */
117   mapping(address => uint) balances;
118 
119   /* approve() allowances */
120   mapping (address => mapping (address => uint256)) allowed;
121 
122   function transfer(address _to, uint256 _value)
123   public
124   returns (bool) 
125   { 
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = safeSub(balances[msg.sender],_value);
131     balances[_to] = safeAdd(balances[_to],_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134     
135   }
136 
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     uint _allowance = allowed[_from][msg.sender];
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= _allowance);
142     require(balances[_to] + _value > balances[_to]);
143 
144     balances[_to] = safeAdd(balances[_to],_value);
145     balances[_from] = safeSub(balances[_from],_value);
146     allowed[_from][msg.sender] = safeSub(_allowance,_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   function balanceOf(address _owner) public constant returns (uint balance) {
152     return balances[_owner];
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165 
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182    /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 /**
222  * @title Burnable Token
223  * @dev Token that can be irreversibly burned (destroyed).
224  */
225 contract BurnableToken is StandardToken {
226 
227   event Burn(address indexed burner, uint256 value);
228 
229   /**
230    * @dev Burns a specific amount of tokens.
231    * @param _value The amount of token to be burned.
232    */
233   function burn(uint256 _value) public {
234     require(_value <= balances[msg.sender]);
235     // no need to require value <= totalSupply, since that would imply the
236     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
237 
238     address burner = msg.sender;
239     balances[burner] = safeSub(balances[burner],_value);
240     totalSupply = safeSub(totalSupply,_value);
241     Burn(burner, _value);
242   }
243 }
244 
245 /**
246  * Upgrade agent interface inspired by Lunyr.
247  *
248  * Upgrade agent transfers tokens to a new contract.
249  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
250  */
251 contract UpgradeAgent {
252   uint public originalSupply;
253   /** Interface marker */
254   function isUpgradeAgent() public pure returns (bool) {
255     return true;
256   }
257   function upgradeFrom(address _from, uint256 _value) public;
258 }
259 
260 
261 /**
262  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
263  *
264  * First envisioned by Golem and Lunyr projects.
265  */
266 contract UpgradeableToken is StandardToken {
267 
268   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
269   address public upgradeMaster;
270 
271   /** The next contract where the tokens will be migrated. */
272   UpgradeAgent public upgradeAgent;
273 
274   /** How many tokens we have upgraded by now. */
275   uint256 public totalUpgraded;
276 
277   /**
278    * Upgrade states.
279    *
280    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
281    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
282    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
283    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
284    *
285    */
286   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
287 
288   /**
289    * Somebody has upgraded some of his tokens.
290    */
291   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
292 
293   /**
294    * New upgrade agent available.
295    */
296   event UpgradeAgentSet(address agent);
297 
298   /**
299    * Do not allow construction without upgrade master set.
300    */
301   function UpgradeableToken(address _upgradeMaster) public {
302     upgradeMaster = _upgradeMaster;
303   }
304 
305   /**
306    * Allow the token holder to upgrade some of their tokens to a new contract.
307    */
308   function upgrade(uint256 value) public {
309     UpgradeState state = getUpgradeState();
310     require((state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
311 
312     // Validate input value.
313     require (value != 0);
314 
315     balances[msg.sender] = safeSub(balances[msg.sender],value);
316 
317     // Take tokens out from circulation
318     totalSupply = safeSub(totalSupply,value);
319     totalUpgraded = safeAdd(totalUpgraded,value);
320 
321     // Upgrade agent reissues the tokens
322     upgradeAgent.upgradeFrom(msg.sender, value);
323     Upgrade(msg.sender, upgradeAgent, value);
324   }
325 
326   /**
327    * Set an upgrade agent that handles
328    */
329   function setUpgradeAgent(address agent) external {
330     require(canUpgrade());
331 
332     require(agent != 0x0);
333     // Only a master can designate the next agent
334     require(msg.sender == upgradeMaster);
335     // Upgrade has already begun for an agent
336     require(getUpgradeState() != UpgradeState.Upgrading);
337 
338     upgradeAgent = UpgradeAgent(agent);
339 
340     // Bad interface
341     require(upgradeAgent.isUpgradeAgent());
342     // Make sure that token supplies match in source and target
343     require(upgradeAgent.originalSupply() == totalSupply);
344 
345     UpgradeAgentSet(upgradeAgent);
346   }
347 
348   /**
349    * Get the state of the token upgrade.
350    */
351   function getUpgradeState() public constant returns(UpgradeState) {
352     if(!canUpgrade()) return UpgradeState.NotAllowed;
353     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
354     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
355     else return UpgradeState.Upgrading;
356   }
357 
358   /**
359    * Change the upgrade master.
360    *
361    * This allows us to set a new owner for the upgrade mechanism.
362    */
363   function setUpgradeMaster(address master) public {
364     require(master != 0x0);
365     require(msg.sender == upgradeMaster);
366     upgradeMaster = master;
367   }
368 
369   /**
370    * Child contract can enable to provide the condition when the upgrade can begun.
371    */
372   function canUpgrade() public view returns(bool) {
373      return true;
374   }
375 
376 }
377 
378 /**
379  * Define interface for releasing the token transfer after a successful crowdsale.
380  */
381 contract ReleasableToken is ERC20, Ownable {
382 
383   /* The finalizer contract that allows unlift the transfer limits on this token */
384   address public releaseAgent;
385 
386   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
387   bool public released = false;
388 
389   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
390   mapping (address => bool) public transferAgents;
391 
392   /**
393    * Limit token transfer until the crowdsale is over.
394    *
395    */
396   modifier canTransfer(address _sender) {
397 
398     if(!released) {
399         require(transferAgents[_sender]);
400     }
401 
402     _;
403   }
404 
405   /**
406    * Set the contract that can call release and make the token transferable.
407    *
408    * Design choice. Allow reset the release agent to fix fat finger mistakes.
409    */
410   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
411 
412     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
413     releaseAgent = addr;
414   }
415 
416   /**
417    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
418    */
419   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
420     transferAgents[addr] = state;
421   }
422 
423   /**
424    * One way function to release the tokens to the wild.
425    *
426    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
427    */
428   function releaseTokenTransfer() public onlyReleaseAgent {
429     released = true;
430   }
431 
432   /** The function can be called only before or after the tokens have been releasesd */
433   modifier inReleaseState(bool releaseState) {
434     require(releaseState == released);
435     _;
436   }
437 
438   /** The function can be called only by a whitelisted release agent. */
439   modifier onlyReleaseAgent() {
440     require(msg.sender == releaseAgent);
441     _;
442   }
443 
444   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
445     // Call StandardToken.transfer()
446    return super.transfer(_to, _value);
447   }
448 
449   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
450     // Call StandardToken.transferForm()
451     return super.transferFrom(_from, _to, _value);
452   }
453 
454 }
455 
456 /**
457  * A token that can increase its supply by another contract.
458  *
459  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
460  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
461  *
462  */
463 contract MintableToken is StandardToken, Ownable {
464 
465   bool public mintingFinished = false;
466 
467   /** List of agents that are allowed to create new tokens */
468   mapping (address => bool) public mintAgents;
469 
470   event MintingAgentChanged(address addr, bool state);
471   event Mint(address indexed to, uint256 amount);
472 
473   /**
474    * Create new tokens and allocate them to an address..
475    *
476    * Only callably by a crowdsale contract (mint agent).
477    */
478   function mint(address receiver, uint256 amount) onlyMintAgent canMint public returns(bool){
479     totalSupply = safeAdd(totalSupply, amount);
480     balances[receiver] = safeAdd(balances[receiver], amount);
481 
482     // This will make the mint transaction apper in EtherScan.io
483     // We can remove this after there is a standardized minting event
484     Mint(receiver, amount);
485     Transfer(0, receiver, amount);
486     return true;
487   }
488 
489   /**
490    * Owner can allow a crowdsale contract to mint new tokens.
491    */
492   function setMintAgent(address addr, bool state) onlyOwner canMint public {
493     mintAgents[addr] = state;
494     MintingAgentChanged(addr, state);
495   }
496 
497   modifier onlyMintAgent() {
498     // Only crowdsale contracts are allowed to mint new tokens
499     require(mintAgents[msg.sender]);
500     _;
501   }
502 
503   /** Make sure we are not done yet. */
504   modifier canMint() {
505     require(!mintingFinished);
506     _;
507   }
508 }
509 
510 /**
511  * A crowdsaled token.
512  *
513  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
514  *
515  * - The token transfer() is disabled until the crowdsale is over
516  * - The token contract gives an opt-in upgrade path to a new contract
517  * - The same token can be part of several crowdsales through approve() mechanism
518  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
519  *
520  */
521 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, BurnableToken {
522 
523   event UpdatedTokenInformation(string newName, string newSymbol);
524 
525   string public name;
526 
527   string public symbol;
528 
529   uint8 public decimals;
530 
531   /**
532    * Construct the token.
533    *
534    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
535    *
536    * @param _name Token name
537    * @param _symbol Token symbol - should be all caps
538    * @param _initialSupply How many tokens we start with
539    * @param _decimals Number of decimal places
540    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
541    */
542   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint8 _decimals, bool _mintable)
543     public
544     UpgradeableToken(msg.sender) 
545   {
546 
547     // Create any address, can be transferred
548     // to team multisig via changeOwner(),
549     // also remember to call setUpgradeMaster()
550     owner = msg.sender;
551 
552     name = _name;
553     symbol = _symbol;
554 
555     totalSupply = _initialSupply;
556 
557     decimals = _decimals;
558 
559     // Create initially all balance on the team multisig
560     balances[owner] = totalSupply;
561 
562     if(totalSupply > 0) {
563       Minted(owner, totalSupply);
564     }
565 
566     // No more new supply allowed after the token creation
567     if(!_mintable) {
568       mintingFinished = true;
569       require(totalSupply != 0);
570     }
571   }
572 
573   /**
574    * When token is released to be transferable, enforce no new tokens can be created.
575    */
576   function releaseTokenTransfer() public onlyReleaseAgent {
577     mintingFinished = true;
578     super.releaseTokenTransfer();
579   }
580 
581   /**
582    * Allow upgrade agent functionality kick in only if the crowdsale was success.
583    */
584   function canUpgrade() public view returns(bool) {
585     return released && super.canUpgrade();
586   }
587 
588   /**
589    * Owner can update token information here
590    */
591   function setTokenInformation(string _name, string _symbol) onlyOwner public {
592     name = _name;
593     symbol = _symbol;
594     UpdatedTokenInformation(name, symbol);
595   }
596 
597 }
598 
599 /**
600  * Finalize agent defines what happens at the end of succeseful crowdsale.
601  *
602  * - Allocate tokens for founders, bounties and community
603  * - Make tokens transferable
604  * - etc.
605  */
606 contract FinalizeAgent {
607 
608   function isFinalizeAgent() public pure returns(bool) {
609     return true;
610   }
611 
612   /** Return true if we can run finalizeCrowdsale() properly.
613    *
614    * This is a safety check function that doesn't allow crowdsale to begin
615    * unless the finalizer has been set up properly.
616    */
617   function isSane() public view returns (bool);
618 
619   /** Called once by crowdsale finalize() if the sale was success. */
620   function finalizeCrowdsale() public ;
621 
622 }
623 
624 /**
625  * Interface for defining crowdsale pricing.
626  */
627 contract PricingStrategy {
628 
629   /** Interface declaration. */
630   function isPricingStrategy() public pure returns (bool) {
631     return true;
632   }
633 
634   /** Self check if all references are correctly set.
635    *
636    * Checks that pricing strategy matches crowdsale parameters.
637    */
638   function isSane(address crowdsale) public view returns (bool) {
639     return true;
640   }
641 
642   /**
643    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
644    *
645    *
646    * @param value - What is the value of the transaction send in as wei
647    * @param tokensSold - how much tokens have been sold this far
648    * @param weiRaised - how much money has been raised this far
649    * @param msgSender - who is the investor of this transaction
650    * @param decimals - how many decimal units the token has
651    * @return Amount of tokens the investor receives
652    */
653   function calculatePrice(uint256 value, uint256 weiRaised, uint256 tokensSold, address msgSender, uint256 decimals) public constant returns (uint256 tokenAmount);
654 }
655 
656 /*
657  * Haltable
658  *
659  * Abstract contract that allows children to implement an
660  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
661  *
662  *
663  * Originally envisioned in FirstBlood ICO contract.
664  */
665 contract Haltable is Ownable {
666   bool public halted;
667 
668   modifier stopInEmergency {
669     require(!halted);
670     _;
671   }
672 
673   modifier onlyInEmergency {
674     require(halted);
675     _;
676   }
677 
678   // called by the owner on emergency, triggers stopped state
679   function halt() external onlyOwner {
680     halted = true;
681   }
682 
683   // called by the owner on end of emergency, returns to normal state
684   function unhalt() external onlyOwner onlyInEmergency {
685     halted = false;
686   }
687 
688 }
689 contract Allocatable is Ownable {
690 
691   /** List of agents that are allowed to allocate new tokens */
692   mapping (address => bool) public allocateAgents;
693 
694   event AllocateAgentChanged(address addr, bool state  );
695 
696   /**
697    * Owner can allow a crowdsale contract to allocate new tokens.
698    */
699   function setAllocateAgent(address addr, bool state) onlyOwner public {
700     allocateAgents[addr] = state;
701     AllocateAgentChanged(addr, state);
702   }
703 
704   modifier onlyAllocateAgent() {
705     // Only crowdsale contracts are allowed to allocate new tokens
706     require(allocateAgents[msg.sender]);
707     _;
708   }
709 }
710 
711 /**
712  * Abstract base contract for token sales.
713  *
714  * Handle
715  * - start and end dates
716  * - accepting investments
717  * - minimum funding goal and refund
718  * - various statistics during the crowdfund
719  * - different pricing strategies
720  * - different investment policies (require server side customer id, allow only whitelisted addresses)
721  *
722  */
723 contract Crowdsale is Allocatable, Haltable, SafeMathLib {
724 
725   /* Max investment count when we are still allowed to change the multisig address */
726   uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
727 
728   /* The token we are selling */
729   FractionalERC20 public token;
730 
731   /* Token Vesting Contract */
732   address public tokenVestingAddress;
733 
734   /* How we are going to price our offering */
735   PricingStrategy public pricingStrategy;
736 
737   /* Post-success callback */
738   FinalizeAgent public finalizeAgent;
739 
740   /* tokens will be transfered from this address */
741   address public multisigWallet;
742 
743   /* if the funding goal is not reached, investors may withdraw their funds */
744   uint256 public minimumFundingGoal;
745 
746   /* the UNIX timestamp start date of the crowdsale */
747   uint256 public startsAt;
748 
749   /* the UNIX timestamp end date of the crowdsale */
750   uint256 public endsAt;
751 
752   /* the number of tokens already sold through this contract*/
753   uint256 public tokensSold = 0;
754 
755   /* How many wei of funding we have raised */
756   uint256 public weiRaised = 0;
757 
758   /* How many distinct addresses have invested */
759   uint256 public investorCount = 0;
760 
761   /* How much wei we have returned back to the contract after a failed crowdfund. */
762   uint256 public loadedRefund = 0;
763 
764   /* How much wei we have given back to investors.*/
765   uint256 public weiRefunded = 0;
766 
767   /* Has this crowdsale been finalized */
768   bool public finalized;
769 
770   /* Do we need to have unique contributor id for each customer */
771   bool public requireCustomerId;
772 
773   /**
774     * Do we verify that contributor has been cleared on the server side (accredited investors only).
775     * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
776     */
777   bool public requiredSignedAddress;
778 
779   /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
780   address public signerAddress;
781 
782   /** How much ETH each address has invested to this crowdsale */
783   mapping (address => uint256) public investedAmountOf;
784 
785   /** How much tokens this crowdsale has credited for each investor address */
786   mapping (address => uint256) public tokenAmountOf;
787 
788   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
789   mapping (address => bool) public earlyParticipantWhitelist;
790 
791   /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
792   uint256 public ownerTestValue;
793 
794   uint256 public earlyPariticipantWeiPrice =82815734989648;
795 
796   uint256 public whitelistBonusPercentage = 15;
797   uint256 public whitelistPrincipleLockPercentage = 50;
798   uint256 public whitelistBonusLockPeriod = 7776000;
799   uint256 public whitelistPrincipleLockPeriod = 7776000;
800 
801   /** State machine
802    *
803    * - Preparing: All contract initialization calls and variables have not been set yet
804    * - Prefunding: We have not passed start time yet
805    * - Funding: Active crowdsale
806    * - Success: Minimum funding goal reached
807    * - Failure: Minimum funding goal not reached before ending time
808    * - Finalized: The finalized has been called and succesfully executed
809    * - Refunding: Refunds are loaded on the contract for reclaim.
810    */
811   enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
812 
813   // A new investment was made
814   event Invested(address investor, uint256 weiAmount, uint256 tokenAmount, uint128 customerId);
815 
816   // Refund was processed for a contributor
817   event Refund(address investor, uint256 weiAmount);
818 
819   // The rules were changed what kind of investments we accept
820   event InvestmentPolicyChanged(bool requireCustId, bool requiredSignedAddr, address signerAddr);
821 
822   // Address early participation whitelist status changed
823   event Whitelisted(address addr, bool status);
824 
825   // Crowdsale end time has been changed
826   event EndsAtChanged(uint256 endAt);
827 
828   // Crowdsale start time has been changed
829   event StartAtChanged(uint256 endsAt);
830 
831   function Crowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, 
832   uint256 _start, uint256 _end, uint256 _minimumFundingGoal, address _tokenVestingAddress) public 
833   {
834 
835     owner = msg.sender;
836 
837     token = FractionalERC20(_token);
838 
839     tokenVestingAddress = _tokenVestingAddress;
840 
841     setPricingStrategy(_pricingStrategy);
842 
843     multisigWallet = _multisigWallet;
844     require(multisigWallet != 0);
845 
846     require(_start != 0);
847 
848     startsAt = _start;
849 
850     require(_end != 0);
851 
852     endsAt = _end;
853 
854     // Don't mess the dates
855     require(startsAt < endsAt);
856 
857     // Minimum funding goal can be zero
858     minimumFundingGoal = _minimumFundingGoal;
859 
860   }
861 
862   /**
863    * Don't expect to just send in money and get tokens.
864    */
865   function() payable public {
866     invest(msg.sender);
867   }
868 
869   /** Function to set default vesting schedule parameters. */
870     function setDefaultWhitelistVestingParameters(uint256 _bonusPercentage, uint256 _principleLockPercentage, uint256 _bonusLockPeriod, uint256 _principleLockPeriod, uint256 _earlyPariticipantWeiPrice) onlyAllocateAgent public {
871 
872         whitelistBonusPercentage = _bonusPercentage;
873         whitelistPrincipleLockPercentage = _principleLockPercentage;
874         whitelistBonusLockPeriod = _bonusLockPeriod;
875         whitelistPrincipleLockPeriod = _principleLockPeriod;
876         earlyPariticipantWeiPrice = _earlyPariticipantWeiPrice;
877     }
878 
879   /**
880    * Make an investment.
881    *
882    * Crowdsale must be running for one to invest.
883    * We must have not pressed the emergency brake.
884    *
885    * @param receiver The Ethereum address who receives the tokens
886    * @param customerId (optional) UUID v4 to track the successful payments on the server side
887    *
888    */
889   function investInternal(address receiver, uint128 customerId) stopInEmergency private {
890 
891     uint256 tokenAmount;
892     uint256 weiAmount = msg.value;
893     // Determine if it's a good time to accept investment from this participant
894     if (getState() == State.PreFunding) {
895         // Are we whitelisted for early deposit
896         require(earlyParticipantWhitelist[receiver]);
897         require(weiAmount >= safeMul(15, uint(10 ** 18)));
898         require(weiAmount <= safeMul(50, uint(10 ** 18)));
899         tokenAmount = safeDiv(safeMul(weiAmount, uint(10) ** token.decimals()), earlyPariticipantWeiPrice);
900         
901         if (investedAmountOf[receiver] == 0) {
902           // A new investor
903           investorCount++;
904         }
905 
906         // Update investor
907         investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
908         tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
909 
910         // Update totals
911         weiRaised = safeAdd(weiRaised,weiAmount);
912         tokensSold = safeAdd(tokensSold,tokenAmount);
913 
914         // Check that we did not bust the cap
915         require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
916 
917         if (safeAdd(whitelistPrincipleLockPercentage,whitelistBonusPercentage) > 0) {
918 
919             uint256 principleAmount = safeDiv(safeMul(tokenAmount, 100), safeAdd(whitelistBonusPercentage, 100));
920             uint256 bonusLockAmount = safeDiv(safeMul(whitelistBonusPercentage, principleAmount), 100);
921             uint256 principleLockAmount = safeDiv(safeMul(whitelistPrincipleLockPercentage, principleAmount), 100);
922 
923             uint256 totalLockAmount = safeAdd(principleLockAmount, bonusLockAmount);
924             TokenVesting tokenVesting = TokenVesting(tokenVestingAddress);
925             
926             // to prevent minting of tokens which will be useless as vesting amount cannot be updated
927             require(!tokenVesting.isVestingSet(receiver));
928             require(totalLockAmount <= tokenAmount);
929             assignTokens(tokenVestingAddress,totalLockAmount);
930             
931             // set vesting with default schedule
932             tokenVesting.setVesting(receiver, principleLockAmount, whitelistPrincipleLockPeriod, bonusLockAmount, whitelistBonusLockPeriod); 
933         }
934 
935         // assign remaining tokens to contributor
936         if (tokenAmount - totalLockAmount > 0) {
937             assignTokens(receiver, tokenAmount - totalLockAmount);
938         }
939 
940         // Pocket the money
941         require(multisigWallet.send(weiAmount));
942 
943         // Tell us invest was success
944         Invested(receiver, weiAmount, tokenAmount, customerId);       
945 
946     
947     } else if(getState() == State.Funding) {
948         // Retail participants can only come in when the crowdsale is running
949         tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, tokensSold, msg.sender, token.decimals());
950         require(tokenAmount != 0);
951 
952 
953         if(investedAmountOf[receiver] == 0) {
954           // A new investor
955           investorCount++;
956         }
957 
958         // Update investor
959         investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
960         tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
961 
962         // Update totals
963         weiRaised = safeAdd(weiRaised,weiAmount);
964         tokensSold = safeAdd(tokensSold,tokenAmount);
965 
966         // Check that we did not bust the cap
967         require(!isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold));
968 
969         assignTokens(receiver, tokenAmount);
970 
971         // Pocket the money
972         require(multisigWallet.send(weiAmount));
973 
974         // Tell us invest was success
975         Invested(receiver, weiAmount, tokenAmount, customerId);
976 
977     } else {
978       // Unwanted state
979       require(false);
980     }
981   }
982 
983   /**
984    * allocate tokens for the early investors.
985    *
986    * Preallocated tokens have been sold before the actual crowdsale opens.
987    * This function mints the tokens and moves the crowdsale needle.
988    *
989    * Investor count is not handled; it is assumed this goes for multiple investors
990    * and the token distribution happens outside the smart contract flow.
991    *
992    * No money is exchanged, as the crowdsale team already have received the payment.
993    *
994    * @param weiPrice Price of a single full token in wei
995    *
996    */
997   function preallocate(address receiver, uint256 tokenAmount, uint256 weiPrice, uint256 principleLockAmount, uint256 principleLockPeriod, uint256 bonusLockAmount, uint256 bonusLockPeriod) public onlyAllocateAgent {
998 
999 
1000     uint256 weiAmount = (weiPrice * tokenAmount)/10**uint256(token.decimals()); // This can be also 0, we give out tokens for free
1001     uint256 totalLockAmount = 0;
1002     weiRaised = safeAdd(weiRaised,weiAmount);
1003     tokensSold = safeAdd(tokensSold,tokenAmount);
1004 
1005     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver],weiAmount);
1006     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver],tokenAmount);
1007 
1008     // cannot lock more than total tokens
1009     totalLockAmount = safeAdd(principleLockAmount, bonusLockAmount);
1010     require(totalLockAmount <= tokenAmount);
1011 
1012     // assign locked token to Vesting contract
1013     if (totalLockAmount > 0) {
1014 
1015       TokenVesting tokenVesting = TokenVesting(tokenVestingAddress);
1016       
1017       // to prevent minting of tokens which will be useless as vesting amount cannot be updated
1018       require(!tokenVesting.isVestingSet(receiver));
1019       assignTokens(tokenVestingAddress,totalLockAmount);
1020       
1021       // set vesting with default schedule
1022       tokenVesting.setVesting(receiver, principleLockAmount, principleLockPeriod, bonusLockAmount, bonusLockPeriod); 
1023     }
1024 
1025     // assign remaining tokens to contributor
1026     if (tokenAmount - totalLockAmount > 0) {
1027       assignTokens(receiver, tokenAmount - totalLockAmount);
1028     }
1029 
1030     // Tell us invest was success
1031     Invested(receiver, weiAmount, tokenAmount, 0);
1032   }
1033 
1034   /**
1035    * Track who is the customer making the payment so we can send thank you email.
1036    */
1037   function investWithCustomerId(address addr, uint128 customerId) public payable {
1038     require(!requiredSignedAddress);
1039     require(customerId != 0);
1040     investInternal(addr, customerId);
1041   }
1042 
1043   /**
1044    * Allow anonymous contributions to this crowdsale.
1045    */
1046   function invest(address addr) public payable {
1047     require(!requireCustomerId);
1048     
1049     require(!requiredSignedAddress);
1050     investInternal(addr, 0);
1051   }
1052 
1053   /**
1054    * Invest to tokens, recognize the payer and clear his address.
1055    *
1056    */
1057   
1058   // function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1059   //   investWithSignedAddress(msg.sender, customerId, v, r, s);
1060   // }
1061 
1062   /**
1063    * Invest to tokens, recognize the payer.
1064    *
1065    */
1066   function buyWithCustomerId(uint128 customerId) public payable {
1067     investWithCustomerId(msg.sender, customerId);
1068   }
1069 
1070   /**
1071    * The basic entry point to participate the crowdsale process.
1072    *
1073    * Pay for funding, get invested tokens back in the sender address.
1074    */
1075   function buy() public payable {
1076     invest(msg.sender);
1077   }
1078 
1079   /**
1080    * Finalize a succcesful crowdsale.
1081    *
1082    * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
1083    */
1084   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1085 
1086     // Already finalized
1087     require(!finalized);
1088 
1089     // Finalizing is optional. We only call it if we are given a finalizing agent.
1090     if(address(finalizeAgent) != 0) {
1091       finalizeAgent.finalizeCrowdsale();
1092     }
1093 
1094     finalized = true;
1095   }
1096 
1097   /**
1098    * Allow to (re)set finalize agent.
1099    *
1100    * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
1101    */
1102   function setFinalizeAgent(FinalizeAgent addr) public onlyOwner {
1103     finalizeAgent = addr;
1104 
1105     // Don't allow setting bad agent
1106     require(finalizeAgent.isFinalizeAgent());
1107   }
1108 
1109   /**
1110    * Set policy do we need to have server-side customer ids for the investments.
1111    *
1112    */
1113   function setRequireCustomerId(bool value) public onlyOwner {
1114     requireCustomerId = value;
1115     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1116   }
1117 
1118   /**
1119    * Allow addresses to do early participation.
1120    *
1121    * TODO: Fix spelling error in the name
1122    */
1123   function setEarlyParicipantWhitelist(address addr, bool status) public onlyAllocateAgent {
1124     earlyParticipantWhitelist[addr] = status;
1125     Whitelisted(addr, status);
1126   }
1127 
1128   function setWhiteList(address[] _participants) public onlyAllocateAgent {
1129       
1130       require(_participants.length > 0);
1131       uint256 participants = _participants.length;
1132 
1133       for (uint256 j=0; j<participants; j++) {
1134       require(_participants[j] != 0);
1135       earlyParticipantWhitelist[_participants[j]] = true;
1136       Whitelisted(_participants[j], true);
1137     }
1138 
1139   }
1140 
1141   /**
1142    * Allow crowdsale owner to close early or extend the crowdsale.
1143    *
1144    * This is useful e.g. for a manual soft cap implementation:
1145    * - after X amount is reached determine manual closing
1146    *
1147    * This may put the crowdsale to an invalid state,
1148    * but we trust owners know what they are doing.
1149    *
1150    */
1151   function setEndsAt(uint time) public onlyOwner {
1152 
1153     require(now <= time);
1154 
1155     endsAt = time;
1156     EndsAtChanged(endsAt);
1157   }
1158 
1159   /**
1160    * Allow crowdsale owner to begin early or extend the crowdsale.
1161    *
1162    * This is useful e.g. for a manual soft cap implementation:
1163    * - after X amount is reached determine manual closing
1164    *
1165    * This may put the crowdsale to an invalid state,
1166    * but we trust owners know what they are doing.
1167    *
1168    */
1169   function setStartAt(uint time) public onlyOwner {
1170 
1171     startsAt = time;
1172     StartAtChanged(endsAt);
1173   }
1174 
1175   /**
1176    * Allow to (re)set pricing strategy.
1177    *
1178    * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1179    */
1180   function setPricingStrategy(PricingStrategy _pricingStrategy) public onlyOwner {
1181     pricingStrategy = _pricingStrategy;
1182 
1183     // Don't allow setting bad agent
1184     require(pricingStrategy.isPricingStrategy());
1185   }
1186 
1187   /**
1188    * Allow to change the team multisig address in the case of emergency.
1189    *
1190    * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1191    * (we have done only few test transactions). After the crowdsale is going
1192    * then multisig address stays locked for the safety reasons.
1193    */
1194   function setMultisig(address addr) public onlyOwner {
1195 
1196     // Change
1197     require(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
1198 
1199     multisigWallet = addr;
1200   }
1201 
1202   /**
1203    * Allow load refunds back on the contract for the refunding.
1204    *
1205    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1206    */
1207   function loadRefund() public payable inState(State.Failure) {
1208     require(msg.value != 0);
1209     loadedRefund = safeAdd(loadedRefund,msg.value);
1210   }
1211 
1212   /**
1213    * Investors can claim refund.
1214    */
1215   function refund() public inState(State.Refunding) {
1216     uint256 weiValue = investedAmountOf[msg.sender];
1217     require(weiValue != 0);
1218     investedAmountOf[msg.sender] = 0;
1219     weiRefunded = safeAdd(weiRefunded,weiValue);
1220     Refund(msg.sender, weiValue);
1221     require(msg.sender.send(weiValue));
1222   }
1223 
1224   /**
1225    * @return true if the crowdsale has raised enough money to be a succes
1226    */
1227   function isMinimumGoalReached() public constant returns (bool reached) {
1228     return weiRaised >= minimumFundingGoal;
1229   }
1230 
1231   /**
1232    * Check if the contract relationship looks good.
1233    */
1234   function isFinalizerSane() public constant returns (bool sane) {
1235     return finalizeAgent.isSane();
1236   }
1237 
1238   /**
1239    * Check if the contract relationship looks good.
1240    */
1241   function isPricingSane() public constant returns (bool sane) {
1242     return pricingStrategy.isSane(address(this));
1243   }
1244 
1245   /**
1246    * Crowdfund state machine management.
1247    *
1248    * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1249    */
1250   function getState() public constant returns (State) {
1251     if(finalized) return State.Finalized;
1252     else if (address(finalizeAgent) == 0) return State.Preparing;
1253     else if (!finalizeAgent.isSane()) return State.Preparing;
1254     else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1255     else if (block.timestamp < startsAt) return State.PreFunding;
1256     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1257     else if (isMinimumGoalReached()) return State.Success;
1258     else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1259     else return State.Failure;
1260   }
1261 
1262   /** This is for manual testing of multisig wallet interaction */
1263   function setOwnerTestValue(uint val) public onlyOwner {
1264     ownerTestValue = val;
1265   }
1266 
1267   /** Interface marker. */
1268   function isCrowdsale() public pure returns (bool) {
1269     return true;
1270   }
1271 
1272   //
1273   // Modifiers
1274   //
1275 
1276   /** Modified allowing execution only if the crowdsale is currently running.  */
1277   modifier inState(State state) {
1278     require(getState() == state);
1279     _;
1280   }
1281 
1282 
1283   //
1284   // Abstract functions
1285   //
1286 
1287   /**
1288    * Check if the current invested breaks our cap rules.
1289    *
1290    *
1291    * The child contract must define their own cap setting rules.
1292    * We allow a lot of flexibility through different capping strategies (ETH, token count)
1293    * Called from invest().
1294    *
1295    * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1296    * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1297    * @param weiRaisedTotal What would be our total raised balance after this transaction
1298    * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1299    *
1300    * @return true if taking this investment would break our cap rules
1301    */
1302   function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) public constant returns (bool limitBroken);
1303   /**
1304    * Check if the current crowdsale is full and we can no longer sell any tokens.
1305    */
1306   function isCrowdsaleFull() public constant returns (bool);
1307 
1308   /**
1309    * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1310    */
1311   function assignTokens(address receiver, uint tokenAmount) private;
1312 }
1313 
1314 /**
1315  * At the end of the successful crowdsale allocate % bonus of tokens to the team.
1316  *
1317  * Unlock tokens.
1318  *
1319  * BonusAllocationFinal must be set as the minting agent for the MintableToken.
1320  *
1321  */
1322 contract BonusFinalizeAgent is FinalizeAgent, SafeMathLib {
1323 
1324   CrowdsaleToken public token;
1325   Crowdsale public crowdsale;
1326   uint256 public allocatedTokens;
1327   uint256 tokenCap;
1328   address walletAddress;
1329 
1330 
1331   function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint256 _tokenCap, address _walletAddress) public {
1332     token = _token;
1333     crowdsale = _crowdsale;
1334 
1335     //crowdsale address must not be 0
1336     require(address(crowdsale) != 0);
1337 
1338     tokenCap = _tokenCap;
1339     walletAddress = _walletAddress;
1340   }
1341 
1342   /* Can we run finalize properly */
1343   function isSane() public view returns (bool) {
1344     return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
1345   }
1346 
1347   /** Called once by crowdsale finalize() if the sale was success. */
1348   function finalizeCrowdsale() public {
1349 
1350     // if finalized is not being called from the crowdsale 
1351     // contract then throw
1352     require (msg.sender == address(crowdsale));
1353 
1354     // get the total sold tokens count.
1355     uint256 tokenSupply = token.totalSupply();
1356 
1357     allocatedTokens = safeSub(tokenCap,tokenSupply);
1358     
1359     if ( allocatedTokens > 0) {
1360       token.mint(walletAddress, allocatedTokens);
1361     }
1362 
1363     token.releaseTokenTransfer();
1364   }
1365 
1366 }
1367 
1368 /**
1369  * ICO crowdsale contract that is capped by amout of ETH.
1370  *
1371  * - Tokens are dynamically created during the crowdsale
1372  *
1373  *
1374  */
1375 contract MintedEthCappedCrowdsale is Crowdsale {
1376 
1377   /* Maximum amount of wei this crowdsale can raise. */
1378   uint public weiCap;
1379 
1380   function MintedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, 
1381     address _multisigWallet, uint256 _start, uint256 _end, uint256 _minimumFundingGoal, uint256 _weiCap, address _tokenVestingAddress) 
1382     Crowdsale(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal,_tokenVestingAddress) public
1383     { 
1384       weiCap = _weiCap;
1385     }
1386 
1387   /**
1388    * Called from invest() to confirm if the curret investment does not break our cap rule.
1389    */
1390   function isBreakingCap(uint256 weiAmount, uint256 tokenAmount, uint256 weiRaisedTotal, uint256 tokensSoldTotal) public constant returns (bool limitBroken) {
1391     return weiRaisedTotal > weiCap;
1392   }
1393 
1394   function isCrowdsaleFull() public constant returns (bool) {
1395     return weiRaised >= weiCap;
1396   }
1397 
1398   /**
1399    * Dynamically create tokens and assign them to the investor.
1400    */
1401   function assignTokens(address receiver, uint256 tokenAmount) private {
1402     MintableToken mintableToken = MintableToken(token);
1403     mintableToken.mint(receiver, tokenAmount);
1404   }
1405 }
1406 
1407 
1408 /// @dev Tranche based pricing with special support for pre-ico deals.
1409 ///      Implementing "first price" tranches, meaning, that if byers order is
1410 ///      covering more than one tranche, the price of the lowest tranche will apply
1411 ///      to the whole order.
1412 contract EthTranchePricing is PricingStrategy, Ownable, SafeMathLib {
1413 
1414   uint public constant MAX_TRANCHES = 10;
1415  
1416  
1417   // This contains all pre-ICO addresses, and their prices (weis per token)
1418   mapping (address => uint256) public preicoAddresses;
1419 
1420   /**
1421   * Define pricing schedule using tranches.
1422   */
1423 
1424   struct Tranche {
1425       // Amount in weis when this tranche becomes active
1426       uint amount;
1427       // How many tokens per wei you will get while this tranche is active
1428       uint price;
1429   }
1430 
1431   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
1432   // Tranche 0 is always (0, 0)
1433   // (TODO: change this when we confirm dynamic arrays are explorable)
1434   Tranche[10] public tranches;
1435 
1436   // How many active tranches we have
1437   uint public trancheCount;
1438 
1439   /// @dev Contruction, creating a list of tranches
1440   /// @param _tranches uint[] tranches Pairs of (start amount, price)
1441   function EthTranchePricing(uint[] _tranches) public {
1442 
1443     // Need to have tuples, length check
1444     require(!(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2));
1445     trancheCount = _tranches.length / 2;
1446     uint256 highestAmount = 0;
1447     for(uint256 i=0; i<_tranches.length/2; i++) {
1448       tranches[i].amount = _tranches[i*2];
1449       tranches[i].price = _tranches[i*2+1];
1450       // No invalid steps
1451       require(!((highestAmount != 0) && (tranches[i].amount <= highestAmount)));
1452       highestAmount = tranches[i].amount;
1453     }
1454 
1455     // We need to start from zero, otherwise we blow up our deployment
1456     require(tranches[0].amount == 0);
1457 
1458     // Last tranche price must be zero, terminating the crowdale
1459     require(tranches[trancheCount-1].price == 0);
1460   }
1461 
1462   /// @dev This is invoked once for every pre-ICO address, set pricePerToken
1463   ///      to 0 to disable
1464   /// @param preicoAddress PresaleFundCollector address
1465   /// @param pricePerToken How many weis one token cost for pre-ico investors
1466   function setPreicoAddress(address preicoAddress, uint pricePerToken)
1467     public
1468     onlyOwner
1469   {
1470     preicoAddresses[preicoAddress] = pricePerToken;
1471   }
1472 
1473   /// @dev Iterate through tranches. You reach end of tranches when price = 0
1474   /// @return tuple (time, price)
1475   function getTranche(uint256 n) public constant returns (uint, uint) {
1476     return (tranches[n].amount, tranches[n].price);
1477   }
1478 
1479   function getFirstTranche() private constant returns (Tranche) {
1480     return tranches[0];
1481   }
1482 
1483   function getLastTranche() private constant returns (Tranche) {
1484     return tranches[trancheCount-1];
1485   }
1486 
1487   function getPricingStartsAt() public constant returns (uint) {
1488     return getFirstTranche().amount;
1489   }
1490 
1491   function getPricingEndsAt() public constant returns (uint) {
1492     return getLastTranche().amount;
1493   }
1494 
1495   function isSane(address _crowdsale) public view returns(bool) {
1496     // Our tranches are not bound by time, so we can't really check are we sane
1497     // so we presume we are ;)
1498     // In the future we could save and track raised tokens, and compare it to
1499     // the Crowdsale contract.
1500     return true;
1501   }
1502 
1503   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
1504   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1505   /// @return {[type]} [description]
1506   function getCurrentTranche(uint256 weiRaised) private constant returns (Tranche) {
1507     uint i;
1508     for(i=0; i < tranches.length; i++) {
1509       if(weiRaised < tranches[i].amount) {
1510         return tranches[i-1];
1511       }
1512     }
1513   }
1514 
1515   /// @dev Get the current price.
1516   /// @param weiRaised total amount of weis raised, for calculating the current tranche
1517   /// @return The current price or 0 if we are outside trache ranges
1518   function getCurrentPrice(uint256 weiRaised) public constant returns (uint256 result) {
1519     return getCurrentTranche(weiRaised).price;
1520   }
1521 
1522   /// @dev Calculate the current price for buy in amount.
1523   function calculatePrice(uint256 value, uint256 weiRaised, uint256 tokensSold, address msgSender, uint256 decimals) public constant returns (uint256) {
1524 
1525     uint256 multiplier = 10 ** decimals;
1526 
1527     // This investor is coming through pre-ico
1528     if(preicoAddresses[msgSender] > 0) {
1529       return safeMul(value, multiplier) / preicoAddresses[msgSender];
1530     }
1531 
1532     uint256 price = getCurrentPrice(weiRaised);
1533     
1534     return safeMul(value, multiplier) / price;
1535   }
1536 
1537   function() payable public {
1538     revert(); // No money on this contract
1539   }
1540 
1541 }
1542 
1543 /**
1544  * Contract to enforce Token Vesting
1545  */
1546 contract TokenVesting is Allocatable, SafeMathLib {
1547 
1548     address public TokenAddress;
1549 
1550     /** keep track of total tokens yet to be released, 
1551      * this should be less than or equal to tokens held by this contract. 
1552      */
1553     uint256 public totalUnreleasedTokens;
1554 
1555 
1556     struct VestingSchedule {
1557         uint256 startAt;
1558         uint256 principleLockAmount;
1559         uint256 principleLockPeriod;
1560         uint256 bonusLockAmount;
1561         uint256 bonusLockPeriod;
1562         uint256 amountReleased;
1563         bool isPrincipleReleased;
1564         bool isBonusReleased;
1565     }
1566 
1567     mapping (address => VestingSchedule) public vestingMap;
1568 
1569     event VestedTokensReleased(address _adr, uint256 _amount);
1570 
1571 
1572     function TokenVesting(address _TokenAddress) public {
1573         TokenAddress = _TokenAddress;
1574     }
1575 
1576 
1577 
1578     /** Function to set/update vesting schedule. PS - Amount cannot be changed once set */
1579     function setVesting(address _adr, uint256 _principleLockAmount, uint256 _principleLockPeriod, uint256 _bonusLockAmount, uint256 _bonuslockPeriod) public onlyAllocateAgent {
1580 
1581         VestingSchedule storage vestingSchedule = vestingMap[_adr];
1582 
1583         // data validation
1584         require(safeAdd(_principleLockAmount, _bonusLockAmount) > 0);
1585 
1586         //startAt is set current time as start time.
1587 
1588         vestingSchedule.startAt = block.timestamp;
1589         vestingSchedule.bonusLockPeriod = safeAdd(block.timestamp,_bonuslockPeriod);
1590         vestingSchedule.principleLockPeriod = safeAdd(block.timestamp,_principleLockPeriod);
1591 
1592         // check if enough tokens are held by this contract
1593         ERC20 token = ERC20(TokenAddress);
1594         uint256 _totalAmount = safeAdd(_principleLockAmount, _bonusLockAmount);
1595         require(token.balanceOf(this) >= safeAdd(totalUnreleasedTokens, _totalAmount));
1596         vestingSchedule.principleLockAmount = _principleLockAmount;
1597         vestingSchedule.bonusLockAmount = _bonusLockAmount;
1598         vestingSchedule.isPrincipleReleased = false;
1599         vestingSchedule.isBonusReleased = false;
1600         totalUnreleasedTokens = safeAdd(totalUnreleasedTokens, _totalAmount);
1601         vestingSchedule.amountReleased = 0;
1602     }
1603 
1604     function isVestingSet(address adr) public constant returns (bool isSet) {
1605         return vestingMap[adr].principleLockAmount != 0 || vestingMap[adr].bonusLockAmount != 0;
1606     }
1607 
1608 
1609     /** Release tokens as per vesting schedule, called by contributor  */
1610     function releaseMyVestedTokens() public {
1611         releaseVestedTokens(msg.sender);
1612     }
1613 
1614     /** Release tokens as per vesting schedule, called by anyone  */
1615     function releaseVestedTokens(address _adr) public {
1616         VestingSchedule storage vestingSchedule = vestingMap[_adr];
1617         
1618         uint256 _totalTokens = safeAdd(vestingSchedule.principleLockAmount, vestingSchedule.bonusLockAmount);
1619         // check if all tokens are not vested
1620         require(safeSub(_totalTokens, vestingSchedule.amountReleased) > 0);
1621         
1622         // calculate total vested tokens till now        
1623         uint256 amountToRelease = 0;
1624 
1625         if (block.timestamp >= vestingSchedule.principleLockPeriod && !vestingSchedule.isPrincipleReleased) {
1626             amountToRelease = safeAdd(amountToRelease,vestingSchedule.principleLockAmount);
1627             vestingSchedule.amountReleased = safeAdd(vestingSchedule.amountReleased, amountToRelease);
1628             vestingSchedule.isPrincipleReleased = true;
1629         }
1630         if (block.timestamp >= vestingSchedule.bonusLockPeriod && !vestingSchedule.isBonusReleased) {
1631             amountToRelease = safeAdd(amountToRelease,vestingSchedule.bonusLockAmount);
1632             vestingSchedule.amountReleased = safeAdd(vestingSchedule.amountReleased, amountToRelease);
1633             vestingSchedule.isBonusReleased = true;
1634         }
1635 
1636         // transfer vested tokens
1637         require(amountToRelease > 0);
1638         ERC20 token = ERC20(TokenAddress);
1639         token.transfer(_adr, amountToRelease);
1640         // decrement overall unreleased token count
1641         totalUnreleasedTokens = safeSub(totalUnreleasedTokens, amountToRelease);
1642         VestedTokensReleased(_adr, amountToRelease);
1643     }
1644 
1645 }