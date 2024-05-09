1 pragma solidity ^0.4.20;
2 
3 /**
4  * Authored by https://www.coinfabrik.com/
5  */
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control 
10  * functions, this simplifies the implementation of "user permissions". 
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   /** 
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() internal {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner. 
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to. 
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * Abstract contract that allows children to implement an
47  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
48  *
49  */
50 contract Haltable is Ownable {
51   bool public halted;
52 
53   event Halted(bool halted);
54 
55   modifier stopInEmergency {
56     require(!halted);
57     _;
58   }
59 
60   modifier onlyInEmergency {
61     require(halted);
62     _;
63   }
64 
65   // called by the owner on emergency, triggers stopped state
66   function halt() external onlyOwner {
67     halted = true;
68     Halted(true);
69   }
70 
71   // called by the owner on end of emergency, returns to normal state
72   function unhalt() external onlyOwner onlyInEmergency {
73     halted = false;
74     Halted(false);
75   }
76 
77 }
78 /**
79  * Math operations with safety checks
80  */
81 library SafeMath {
82   function mul(uint a, uint b) internal pure returns (uint) {
83     uint c = a * b;
84     assert(a == 0 || c / a == b);
85     return c;
86   }
87 
88   function div(uint a, uint b) internal pure returns (uint) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     uint c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   function sub(uint a, uint b) internal pure returns (uint) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   function add(uint a, uint b) internal pure returns (uint) {
101     uint c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 
106   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
107     return a >= b ? a : b;
108   }
109 
110   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
111     return a < b ? a : b;
112   }
113 
114   function max256(uint a, uint b) internal pure returns (uint) {
115     return a >= b ? a : b;
116   }
117 
118   function min256(uint a, uint b) internal pure returns (uint) {
119     return a < b ? a : b;
120   }
121 }
122 
123 /**
124  * Interface for the standard token.
125  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
126  */
127 interface EIP20Token {
128 
129   function totalSupply() public view returns (uint256);
130   function balanceOf(address who) public view returns (uint256);
131   function transfer(address to, uint256 value) public returns (bool success);
132   function transferFrom(address from, address to, uint256 value) public returns (bool success);
133   function approve(address spender, uint256 value) public returns (bool success);
134   function allowance(address owner, address spender) public view returns (uint256 remaining);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138   /**
139   ** Optional functions
140   *
141   function name() public view returns (string name);
142   function symbol() public view returns (string symbol);
143   function decimals() public view returns (uint8 decimals);
144   *
145   **/
146 
147 }
148 
149 // Interface for burning tokens
150 contract Burnable {
151   // @dev Destroys tokens for an account
152   // @param account Account whose tokens are destroyed
153   // @param value Amount of tokens to destroy
154   function burnTokens(address account, uint value) internal;
155   event Burned(address account, uint value);
156 }
157 
158 /**
159  * Internal interface for the minting of tokens.
160  */
161 contract Mintable {
162 
163   /**
164    * @dev Mints tokens for an account
165    * This function should emit the Minted event.
166    */
167   function mintInternal(address receiver, uint amount) internal;
168 
169   /** Token supply got increased and a new owner received these tokens */
170   event Minted(address receiver, uint amount);
171 }
172 
173 /**
174  * @title Standard token
175  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
176  */
177 contract StandardToken is EIP20Token, Burnable, Mintable {
178   using SafeMath for uint;
179 
180   uint private total_supply;
181   mapping(address => uint) private balances;
182   mapping(address => mapping (address => uint)) private allowed;
183 
184 
185   function totalSupply() public view returns (uint) {
186     return total_supply;
187   }
188 
189   /**
190    * @dev transfer token for a specified address
191    * @param to The address to transfer to.
192    * @param value The amount to be transferred.
193    */
194   function transfer(address to, uint value) public returns (bool success) {
195     balances[msg.sender] = balances[msg.sender].sub(value);
196     balances[to] = balances[to].add(value);
197     Transfer(msg.sender, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Gets the balance of the specified address.
203    * @param account The address whose balance is to be queried.
204    * @return An uint representing the amount owned by the passed address.
205    */
206   function balanceOf(address account) public view returns (uint balance) {
207     return balances[account];
208   }
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param from address The address which you want to send tokens from
213    * @param to address The address which you want to transfer to
214    * @param value uint the amout of tokens to be transfered
215    */
216   function transferFrom(address from, address to, uint value) public returns (bool success) {
217     uint allowance = allowed[from][msg.sender];
218 
219     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
220     // require(value <= allowance);
221     // SafeMath uses assert instead of require though, beware when using an analysis tool
222 
223     balances[from] = balances[from].sub(value);
224     balances[to] = balances[to].add(value);
225     allowed[from][msg.sender] = allowance.sub(value);
226     Transfer(from, to, value);
227     return true;
228   }
229 
230   /**
231    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    * @param spender The address which will spend the funds.
233    * @param value The amount of tokens to be spent.
234    */
235   function approve(address spender, uint value) public returns (bool success) {
236 
237     // To change the approve amount you first have to reduce the addresses'
238     //  allowance to zero by calling `approve(spender, 0)` if it is not
239     //  already 0 to mitigate the race condition described here:
240     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241     require (value == 0 || allowed[msg.sender][spender] == 0);
242 
243     allowed[msg.sender][spender] = value;
244     Approval(msg.sender, spender, value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens than an owner allowed to a spender.
250    * @param account address The address which owns the funds.
251    * @param spender address The address which will spend the funds.
252    * @return A uint specifing the amount of tokens still avaible for the spender.
253    */
254   function allowance(address account, address spender) public view returns (uint remaining) {
255     return allowed[account][spender];
256   }
257 
258   /**
259    * Atomic increment of approved spending
260    *
261    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    *
263    */
264   function addApproval(address spender, uint addedValue) public returns (bool success) {
265       uint oldValue = allowed[msg.sender][spender];
266       allowed[msg.sender][spender] = oldValue.add(addedValue);
267       Approval(msg.sender, spender, allowed[msg.sender][spender]);
268       return true;
269   }
270 
271   /**
272    * Atomic decrement of approved spending.
273    *
274    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    */
276   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
277 
278       uint oldVal = allowed[msg.sender][spender];
279 
280       if (subtractedValue > oldVal) {
281           allowed[msg.sender][spender] = 0;
282       } else {
283           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
284       }
285       Approval(msg.sender, spender, allowed[msg.sender][spender]);
286       return true;
287   }
288 
289   /**
290    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
291    */
292   function burnTokens(address account, uint value) internal {
293     balances[account] = balances[account].sub(value);
294     total_supply = total_supply.sub(value);
295     Transfer(account, 0, value);
296     Burned(account, value);
297   }
298 
299   /**
300    * @dev Provides an internal minting function.
301    */
302   function mintInternal(address receiver, uint amount) internal {
303     total_supply = total_supply.add(amount);
304     balances[receiver] = balances[receiver].add(amount);
305     Minted(receiver, amount);
306 
307     // Beware: Address zero may be used for special transactions in a future fork.
308     // This will make the mint transaction appear in EtherScan.io
309     // We can remove this after there is a standardized minting event
310     Transfer(0, receiver, amount);
311   }
312   
313 }
314 
315 /**
316  * Define interface for releasing the token transfer after a successful crowdsale.
317  */
318 contract ReleasableToken is StandardToken, Ownable {
319 
320   /* The finalizer contract that allows lifting the transfer limits on this token */
321   address public releaseAgent;
322 
323   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
324   bool public released = false;
325 
326   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
327   mapping (address => bool) public transferAgents;
328 
329   /**
330    * Set the contract that can call release and make the token transferable.
331    *
332    * Since the owner of this contract is (or should be) the crowdsale,
333    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
334    */
335   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
336     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
337     releaseAgent = addr;
338   }
339 
340   /**
341    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
342    */
343   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
344     transferAgents[addr] = state;
345   }
346 
347   /**
348    * One way function to release the tokens into the wild.
349    *
350    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
351    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
352    */
353   function releaseTokenTransfer() public onlyReleaseAgent {
354     released = true;
355   }
356 
357   /**
358    * Limit token transfer until the crowdsale is over.
359    */
360   modifier canTransfer(address sender) {
361     require(released || transferAgents[sender]);
362     _;
363   }
364 
365   /** The function can be called only before or after the tokens have been released */
366   modifier inReleaseState(bool releaseState) {
367     require(releaseState == released);
368     _;
369   }
370 
371   /** The function can be called only by a whitelisted release agent. */
372   modifier onlyReleaseAgent() {
373     require(msg.sender == releaseAgent);
374     _;
375   }
376 
377   /** We restrict transfer by overriding it */
378   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
379     // Call StandardToken.transfer()
380    return super.transfer(to, value);
381   }
382 
383   /** We restrict transferFrom by overriding it */
384   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
385     // Call StandardToken.transferForm()
386     return super.transferFrom(from, to, value);
387   }
388 
389 }
390 
391 /**
392  * Upgrade agent transfers tokens to a new contract.
393  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
394  *
395  * The Upgrade agent is the interface used to implement a token
396  * migration in the case of an emergency.
397  * The function upgradeFrom has to implement the part of the creation
398  * of new tokens on behalf of the user doing the upgrade.
399  *
400  * The new token can implement this interface directly, or use.
401  */
402 contract UpgradeAgent {
403 
404   /** This value should be the same as the original token's total supply */
405   uint public originalSupply;
406 
407   /** Interface to ensure the contract is correctly configured */
408   function isUpgradeAgent() public pure returns (bool) {
409     return true;
410   }
411 
412   /**
413   Upgrade an account
414 
415   When the token contract is in the upgrade status the each user will
416   have to call `upgrade(value)` function from UpgradeableToken.
417 
418   The upgrade function adjust the balance of the user and the supply
419   of the previous token and then call `upgradeFrom(value)`.
420 
421   The UpgradeAgent is the responsible to create the tokens for the user
422   in the new contract.
423 
424   * @param from Account to upgrade.
425   * @param value Tokens to upgrade.
426 
427   */
428   function upgradeFrom(address from, uint value) public;
429 
430 }
431 
432 
433 /**
434  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
435  *
436  */
437 contract UpgradeableToken is EIP20Token, Burnable {
438   using SafeMath for uint;
439 
440   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
441   address public upgradeMaster;
442 
443   /** The next contract where the tokens will be migrated. */
444   UpgradeAgent public upgradeAgent;
445 
446   /** How many tokens we have upgraded by now. */
447   uint public totalUpgraded = 0;
448 
449   /**
450    * Upgrade states.
451    *
452    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
453    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
454    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet. This allows changing the upgrade agent while there is time.
455    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
456    *
457    */
458   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
459 
460   /**
461    * Somebody has upgraded some of his tokens.
462    */
463   event Upgrade(address indexed from, address to, uint value);
464 
465   /**
466    * New upgrade agent available.
467    */
468   event UpgradeAgentSet(address agent);
469 
470   /**
471    * Do not allow construction without upgrade master set.
472    */
473   function UpgradeableToken(address master) internal {
474     setUpgradeMaster(master);
475   }
476 
477   /**
478    * Allow the token holder to upgrade some of their tokens to a new contract.
479    */
480   function upgrade(uint value) public {
481     UpgradeState state = getUpgradeState();
482     // Ensure it's not called in a bad state
483     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
484 
485     // Validate input value.
486     require(value != 0);
487 
488     // Upgrade agent reissues the tokens
489     upgradeAgent.upgradeFrom(msg.sender, value);
490     
491     // Take tokens out from circulation
492     burnTokens(msg.sender, value);
493     totalUpgraded = totalUpgraded.add(value);
494 
495     Upgrade(msg.sender, upgradeAgent, value);
496   }
497 
498   /**
499    * Set an upgrade agent that handles the upgrade process
500    */
501   function setUpgradeAgent(address agent) onlyMaster external {
502     // Check whether the token is in a state that we could think of upgrading
503     require(canUpgrade());
504 
505     require(agent != 0x0);
506     // Upgrade has already begun for an agent
507     require(getUpgradeState() != UpgradeState.Upgrading);
508 
509     upgradeAgent = UpgradeAgent(agent);
510 
511     // Bad interface
512     require(upgradeAgent.isUpgradeAgent());
513     // Make sure that token supplies match in source and target
514     require(upgradeAgent.originalSupply() == totalSupply());
515 
516     UpgradeAgentSet(upgradeAgent);
517   }
518 
519   /**
520    * Get the state of the token upgrade.
521    */
522   function getUpgradeState() public view returns(UpgradeState) {
523     if (!canUpgrade()) return UpgradeState.NotAllowed;
524     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
525     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
526     else return UpgradeState.Upgrading;
527   }
528 
529   /**
530    * Change the upgrade master.
531    *
532    * This allows us to set a new owner for the upgrade mechanism.
533    */
534   function changeUpgradeMaster(address new_master) onlyMaster public {
535     setUpgradeMaster(new_master);
536   }
537 
538   /**
539    * Internal upgrade master setter.
540    */
541   function setUpgradeMaster(address new_master) private {
542     require(new_master != 0x0);
543     upgradeMaster = new_master;
544   }
545 
546   /**
547    * Child contract can override to provide the condition in which the upgrade can begin.
548    */
549   function canUpgrade() public view returns(bool) {
550      return true;
551   }
552 
553 
554   modifier onlyMaster() {
555     require(msg.sender == upgradeMaster);
556     _;
557   }
558 }
559 
560 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
561 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
562 // Of course, this contract imposes support costs upon whoever is the lost and found master.
563 contract LostAndFoundToken {
564   /**
565    * @return Address of the account that handles movements.
566    */
567   function getLostAndFoundMaster() internal view returns (address);
568 
569   /**
570    * @param agent Address that will be able to move tokens with transferFrom
571    * @param tokens Amount of tokens approved for transfer
572    * @param token_contract Contract of the token
573    */
574   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
575     require(msg.sender == getLostAndFoundMaster());
576     // We use approve instead of transfer to minimize the possibility of the lost and found master
577     //  getting them stuck in another address by accident.
578     token_contract.approve(agent, tokens);
579   }
580 }
581 
582 /**
583  * A public interface to increase the supply of a token.
584  *
585  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
586  * Only mint agents, usually contracts whitelisted by the owner, can mint new tokens.
587  *
588  */
589 contract MintableToken is Mintable, Ownable {
590 
591   using SafeMath for uint;
592 
593   bool public mintingFinished = false;
594 
595   /** List of agents that are allowed to create new tokens */
596   mapping (address => bool) public mintAgents;
597 
598   event MintingAgentChanged(address addr, bool state);
599 
600 
601   function MintableToken(uint initialSupply, address multisig, bool mintable) internal {
602     require(multisig != address(0));
603     // Cannot create a token without supply and no minting
604     require(mintable || initialSupply != 0);
605     // Create initially all balance on the team multisig
606     if (initialSupply > 0)
607       mintInternal(multisig, initialSupply);
608     // No more new supply allowed after the token creation
609     mintingFinished = !mintable;
610   }
611 
612   /**
613    * Create new tokens and allocate them to an address.
614    *
615    * Only callable by a mint agent (e.g. crowdsale contract).
616    */
617   function mint(address receiver, uint amount) onlyMintAgent canMint public {
618     mintInternal(receiver, amount);
619   }
620 
621   /**
622    * Owner can allow a crowdsale contract to mint new tokens.
623    */
624   function setMintAgent(address addr, bool state) onlyOwner canMint public {
625     mintAgents[addr] = state;
626     MintingAgentChanged(addr, state);
627   }
628 
629   modifier onlyMintAgent() {
630     // Only mint agents are allowed to mint new tokens
631     require(mintAgents[msg.sender]);
632     _;
633   }
634 
635   /** Make sure we are not done yet. */
636   modifier canMint() {
637     require(!mintingFinished);
638     _;
639   }
640 }
641 
642 /**
643  * A crowdsale token.
644  *
645  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
646  *
647  * - The token transfer() is disabled until the crowdsale is over
648  * - The token contract gives an opt-in upgrade path to a new contract
649  * - The same token can be part of several crowdsales through the approve() mechanism
650  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
651  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
652  *
653  */
654 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
655 
656   string public name = "Ubanx";
657 
658   string public symbol = "BANX";
659 
660   uint8 public decimals;
661 
662   address public lost_and_found_master;
663 
664   /**
665    * Construct the token.
666    *
667    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
668    *
669    * @param initial_supply How many tokens we start with.
670    * @param token_decimals Number of decimal places.
671    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
672    * @param mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
673    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
674    */
675   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, bool mintable, address token_retriever) public
676   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, mintable) {
677     require(token_retriever != address(0));
678     decimals = token_decimals;
679     lost_and_found_master = token_retriever;
680   }
681 
682   /**
683    * When token is released to be transferable, prohibit new token creation.
684    */
685   function releaseTokenTransfer() public onlyReleaseAgent {
686     mintingFinished = true;
687     super.releaseTokenTransfer();
688   }
689 
690   /**
691    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
692    */
693   function canUpgrade() public view returns(bool) {
694     return released && super.canUpgrade();
695   }
696 
697   function getLostAndFoundMaster() internal view returns(address) {
698     return lost_and_found_master;
699   }
700 
701   /**
702    * We allow anyone to burn their tokens if they wish to do so.
703    * We want to use this in the finalize function of the crowdsale in particular.
704    */
705   function burn(uint amount) public {
706     burnTokens(msg.sender, amount);
707   }
708 
709 }
710 
711 /**
712  * Abstract base contract for token sales.
713  *
714  * Handles
715  * - start and end dates
716  * - accepting investments
717  * - various statistics during the crowdfund
718  * - different investment policies (require server side customer id, allow only whitelisted addresses)
719  *
720  */
721 contract GenericCrowdsale is Haltable {
722 
723   using SafeMath for uint;
724 
725   /* The token we are selling */
726   CrowdsaleToken public token;
727 
728   /* ether will be transferred to this address */
729   address public multisigWallet;
730 
731   /* a contract may be deployed to function as a gateway for investments */
732   address public investmentGateway;
733 
734   /* the starting time of the crowdsale */
735   uint public startsAt;
736 
737   /* the ending time of the crowdsale */
738   uint public endsAt;
739 
740   /* the number of tokens already sold through this contract*/
741   uint public tokensSold = 0;
742 
743   /* How many wei of funding we have raised */
744   uint public weiRaised = 0;
745 
746   /* How many distinct addresses have invested */
747   uint public investorCount = 0;
748 
749   /* Has this crowdsale been finalized */
750   bool public finalized = false;
751 
752   /* Do we need to have a unique contributor id for each customer */
753   bool public requireCustomerId = false;
754 
755   /**
756    * Do we verify that contributor has been cleared on the server side (accredited investors only).
757    * This method was first used in the FirstBlood crowdsale to ensure all contributors had accepted terms of sale (on the web).
758    */
759   bool public requiredSignedAddress = false;
760 
761   /** Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
762   address public signerAddress;
763 
764   /** How many ETH each address has invested in this crowdsale */
765   mapping (address => uint) public investedAmountOf;
766 
767   /** How many tokens this crowdsale has credited for each investor address */
768   mapping (address => uint) public tokenAmountOf;
769 
770   /** Addresses that are allowed to invest even before ICO officially opens. For testing, for ICO partners, etc. */
771   mapping (address => bool) public earlyParticipantWhitelist;
772 
773   /** State machine
774    *
775    * - Prefunding: We have not reached the starting time yet
776    * - Funding: Active crowdsale
777    * - Success: Crowdsale ended
778    * - Finalized: The finalize function has been called and succesfully executed
779    */
780   enum State{Unknown, PreFunding, Funding, Success, Finalized}
781 
782 
783   // A new investment was made
784   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
785 
786   // The rules about what kind of investments we accept were changed
787   event InvestmentPolicyChanged(bool requireCId, bool requireSignedAddress, address signer);
788 
789   // Address early participation whitelist status changed
790   event Whitelisted(address addr, bool status);
791 
792   // Crowdsale's finalize function has been called
793   event Finalized();
794 
795 
796   /**
797    * Basic constructor for the crowdsale.
798    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
799    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
800    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
801    */
802   function GenericCrowdsale(address team_multisig, uint start, uint end) internal {
803     setMultisig(team_multisig);
804 
805     // Don't mess the dates
806     require(start != 0 && end != 0);
807     require(block.timestamp < start && start < end);
808     startsAt = start;
809     endsAt = end;
810   }
811 
812   /**
813    * Default fallback behaviour is to call buy.
814    * Ideally, no contract calls this crowdsale without supporting ERC20.
815    * However, some sort of refunding function may be desired to cover such situations.
816    */
817   function() payable public {
818     buy();
819   }
820 
821   /**
822    * Make an investment.
823    *
824    * The crowdsale must be running for one to invest.
825    * We must have not pressed the emergency brake.
826    *
827    * @param receiver The Ethereum address who receives the tokens
828    * @param customerId (optional) UUID v4 to track the successful payments on the server side
829    *
830    */
831   function investInternal(address receiver, uint128 customerId) stopInEmergency notFinished private {
832     // Determine if it's a good time to accept investment from this participant
833     if (getState() == State.PreFunding) {
834       // Are we whitelisted for early deposit
835       require(earlyParticipantWhitelist[msg.sender]);
836     }
837 
838     uint weiAmount;
839     uint tokenAmount;
840     (weiAmount, tokenAmount) = calculateTokenAmount(msg.value, receiver);
841     // Sanity check against bad implementation.
842     assert(weiAmount <= msg.value);
843     
844     // Dust transaction if no tokens can be given
845     require(tokenAmount != 0);
846 
847     if (investedAmountOf[receiver] == 0) {
848       // A new investor
849       investorCount++;
850     }
851     updateInvestorFunds(tokenAmount, weiAmount, receiver, customerId);
852 
853     // Pocket the money
854     multisigWallet.transfer(weiAmount);
855 
856     // Return excess of money
857     returnExcedent(msg.value.sub(weiAmount), msg.sender);
858   }
859 
860   /**
861    * Preallocate tokens for the early investors.
862    *
863    * Preallocated tokens have been sold before the actual crowdsale opens.
864    * This function mints the tokens and moves the crowdsale needle.
865    *
866    * No money is exchanged, as the crowdsale team already have received the payment.
867    *
868    * @param receiver Account that receives the tokens.
869    * @param fullTokens tokens as full tokens - decimal places are added internally.
870    * @param weiPrice Price of a single indivisible token in wei.
871    *
872    */
873   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner notFinished {
874     require(receiver != address(0));
875     uint tokenAmount = fullTokens.mul(10**uint(token.decimals()));
876     require(tokenAmount != 0);
877     uint weiAmount = weiPrice.mul(tokenAmount); // This can also be 0, in which case we give out tokens for free
878     updateInvestorFunds(tokenAmount, weiAmount, receiver , 0);
879   }
880 
881   /**
882    * Private function to update accounting in the crowdsale.
883    */
884   function updateInvestorFunds(uint tokenAmount, uint weiAmount, address receiver, uint128 customerId) private {
885     // Update investor
886     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
887     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
888 
889     // Update totals
890     weiRaised = weiRaised.add(weiAmount);
891     tokensSold = tokensSold.add(tokenAmount);
892 
893     assignTokens(receiver, tokenAmount);
894     // Tell us that the investment was completed successfully
895     Invested(receiver, weiAmount, tokenAmount, customerId);
896   }
897 
898   /**
899    * Investing function that recognizes the receiver and verifies he is allowed to invest.
900    *
901    * @param customerId UUIDv4 that identifies this contributor
902    */
903   function buyOnBehalfWithSignedAddress(address receiver, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable validCustomerId(customerId) {
904     bytes32 hash = sha256(receiver);
905     require(ecrecover(hash, v, r, s) == signerAddress);
906     investInternal(receiver, customerId);
907   }
908 
909   /**
910    * Investing function that recognizes the receiver.
911    * 
912    * @param customerId UUIDv4 that identifies this contributor
913    */
914   function buyOnBehalfWithCustomerId(address receiver, uint128 customerId) public payable validCustomerId(customerId) unsignedBuyAllowed {
915     investInternal(receiver, customerId);
916   }
917 
918   /**
919    * Buys tokens on behalf of an address.
920    *
921    * Pay for funding, get invested tokens back in the receiver address.
922    */
923   function buyOnBehalf(address receiver) public payable {
924     require(!requiredSignedAddress || msg.sender == investmentGateway);
925     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
926     investInternal(receiver, 0);
927   }
928 
929   function setInvestmentGateway(address gateway) public onlyOwner {
930     require(gateway != address(0));
931     investmentGateway = gateway;
932   }
933 
934   /**
935    * Investing function that recognizes the payer and verifies he is allowed to invest.
936    *
937    * @param customerId UUIDv4 that identifies this contributor
938    */
939   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
940     buyOnBehalfWithSignedAddress(msg.sender, customerId, v, r, s);
941   }
942 
943 
944   /**
945    * Investing function that recognizes the payer.
946    * 
947    * @param customerId UUIDv4 that identifies this contributor
948    */
949   function buyWithCustomerId(uint128 customerId) public payable {
950     buyOnBehalfWithCustomerId(msg.sender, customerId);
951   }
952 
953   /**
954    * The basic entry point to participate in the crowdsale process.
955    *
956    * Pay for funding, get invested tokens back in the sender address.
957    */
958   function buy() public payable {
959     buyOnBehalf(msg.sender);
960   }
961 
962   /**
963    * Finalize a succcesful crowdsale.
964    *
965    * The owner can trigger post-crowdsale actions, like releasing the tokens.
966    * Note that by default tokens are not in a released state.
967    */
968   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
969     finalized = true;
970     Finalized();
971   }
972 
973   /**
974    * Set policy do we need to have server-side customer ids for the investments.
975    *
976    */
977   function setRequireCustomerId(bool value) public onlyOwner {
978     requireCustomerId = value;
979     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
980   }
981 
982   /**
983    * Set policy if all investors must be cleared on the server side first.
984    *
985    * This is e.g. for the accredited investor clearing.
986    *
987    */
988   function setRequireSignedAddress(bool value, address signer) public onlyOwner {
989     requiredSignedAddress = value;
990     signerAddress = signer;
991     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
992   }
993 
994   /**
995    * Allow addresses to do early participation.
996    */
997   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
998     earlyParticipantWhitelist[addr] = status;
999     Whitelisted(addr, status);
1000   }
1001 
1002   /**
1003    * Internal setter for the multisig wallet
1004    */
1005   function setMultisig(address addr) internal {
1006     require(addr != 0);
1007     multisigWallet = addr;
1008   }
1009 
1010   /**
1011    * Crowdfund state machine management.
1012    *
1013    * This function has the timed transition builtin.
1014    * So there is no chance of the variable being stale.
1015    */
1016   function getState() public view returns (State) {
1017     if (finalized) return State.Finalized;
1018     else if (block.timestamp < startsAt) return State.PreFunding;
1019     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1020     else return State.Success;
1021   }
1022 
1023   /** Internal functions that exist to provide inversion of control should they be overriden */
1024 
1025   /** Interface for the concrete instance to interact with the token contract in a customizable way */
1026   function assignTokens(address receiver, uint tokenAmount) internal;
1027 
1028   /**
1029    *  Determine if the goal was already reached in the current crowdsale
1030    */
1031   function isCrowdsaleFull() internal view returns (bool full);
1032 
1033   /**
1034    * Returns any excess wei received
1035    * 
1036    * This function can be overriden to provide a different refunding method.
1037    */
1038   function returnExcedent(uint excedent, address receiver) internal {
1039     if (excedent > 0) {
1040       receiver.transfer(excedent);
1041     }
1042   }
1043 
1044   /** 
1045    *  Calculate the amount of tokens that corresponds to the received amount.
1046    *  The wei amount is returned too in case not all of it can be invested.
1047    *
1048    *  Note: When there's an excedent due to rounding error, it should be returned to allow refunding.
1049    *  This is worked around in the current design using an appropriate amount of decimals in the FractionalERC20 standard.
1050    *  The workaround is good enough for most use cases, hence the simplified function signature.
1051    *  @return weiAllowed The amount of wei accepted in this transaction.
1052    *  @return tokenAmount The tokens that are assigned to the receiver in this transaction.
1053    */
1054   function calculateTokenAmount(uint weiAmount, address receiver) internal view returns (uint weiAllowed, uint tokenAmount);
1055 
1056   //
1057   // Modifiers
1058   //
1059 
1060   modifier inState(State state) {
1061     require(getState() == state);
1062     _;
1063   }
1064 
1065   modifier unsignedBuyAllowed() {
1066     require(!requiredSignedAddress);
1067     _;
1068   }
1069 
1070   /** Modifier allowing execution only if the crowdsale is currently running.  */
1071   modifier notFinished() {
1072     State current_state = getState();
1073     require(current_state == State.PreFunding || current_state == State.Funding);
1074     _;
1075   }
1076 
1077   modifier validCustomerId(uint128 customerId) {
1078     require(customerId != 0);  // UUIDv4 sanity check
1079     _;
1080   }
1081 
1082 }
1083 
1084 /// @dev Tranche based pricing.
1085 ///      Implementing "first price" tranches, meaning, that if a buyer's order is
1086 ///      covering more than one tranche, the price of the lowest tranche will apply
1087 ///      to the whole order.
1088 contract TokenTranchePricing {
1089 
1090   using SafeMath for uint;
1091 
1092   /**
1093    * Define pricing schedule using tranches.
1094    */
1095   struct Tranche {
1096       // Amount in tokens when this tranche becomes inactive
1097       uint amount;
1098       // Time interval [start, end)
1099       // Starting timestamp (included in the interval)
1100       uint start;
1101       // Ending timestamp (excluded from the interval)
1102       uint end;
1103       // How many tokens per asset unit you will get while this tranche is active
1104       uint price;
1105   }
1106   // We define offsets and size for the deserialization of ordered tuples in raw arrays
1107   uint private constant amount_offset = 0;
1108   uint private constant start_offset = 1;
1109   uint private constant end_offset = 2;
1110   uint private constant price_offset = 3;
1111   uint private constant tranche_size = 4;
1112 
1113   Tranche[] public tranches;
1114 
1115   function getTranchesLength() public view returns (uint) {
1116     return tranches.length;
1117   }
1118 
1119   /// @dev Construction, creating a list of tranches
1120   /// @param init_tranches Raw array of ordered tuples: (end amount, start timestamp, end timestamp, price)
1121   function TokenTranchePricing(uint[] init_tranches) public {
1122     // Need to have tuples, length check
1123     require(init_tranches.length % tranche_size == 0);
1124     // A tranche with amount zero can never be selected and is therefore useless.
1125     // This check and the one inside the loop ensure no tranche can have an amount equal to zero.
1126     require(init_tranches[amount_offset] > 0);
1127 
1128     uint input_tranches_length = init_tranches.length.div(tranche_size);
1129     Tranche memory last_tranche;
1130     for (uint i = 0; i < input_tranches_length; i++) {
1131       uint tranche_offset = i.mul(tranche_size);
1132       uint amount = init_tranches[tranche_offset.add(amount_offset)];
1133       uint start = init_tranches[tranche_offset.add(start_offset)];
1134       uint end = init_tranches[tranche_offset.add(end_offset)];
1135       uint price = init_tranches[tranche_offset.add(price_offset)];
1136       // No invalid steps
1137       require(block.timestamp < start && start < end);
1138       // Bail out when entering unnecessary tranches
1139       // This is preferably checked before deploying contract into any blockchain.
1140       require(i == 0 || (end >= last_tranche.end && amount > last_tranche.amount) ||
1141               (end > last_tranche.end && amount >= last_tranche.amount));
1142 
1143       last_tranche = Tranche(amount, start, end, price);
1144       tranches.push(last_tranche);
1145     }
1146   }
1147 
1148   /// @dev Get the current tranche or bail out if there is no tranche defined for the current block.
1149   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1150   /// @return Returns the struct representing the current tranche
1151   function getCurrentTranche(uint tokensSold) private view returns (Tranche storage) {
1152     for (uint i = 0; i < tranches.length; i++) {
1153       if (tranches[i].start <= block.timestamp && block.timestamp < tranches[i].end && tokensSold < tranches[i].amount) {
1154         return tranches[i];
1155       }
1156     }
1157     // No tranche is currently active
1158     revert();
1159   }
1160 
1161   /// @dev Get the current price. May revert if there is no tranche currently active.
1162   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1163   /// @return The current price
1164   function getCurrentPrice(uint tokensSold) internal view returns (uint result) {
1165     return getCurrentTranche(tokensSold).price;
1166   }
1167 
1168 }
1169 
1170 // Simple deployment information store inside contract storage.
1171 contract DeploymentInfo {
1172   uint private deployed_on;
1173 
1174   function DeploymentInfo() public {
1175     deployed_on = block.number;
1176   }
1177 
1178 
1179   function getDeploymentBlock() public view returns (uint) {
1180     return deployed_on;
1181   }
1182 }
1183 
1184 
1185 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1186 contract Crowdsale is GenericCrowdsale, LostAndFoundToken, TokenTranchePricing, DeploymentInfo {
1187   uint8 private constant token_decimals = 18;
1188   // Initial supply is 400k, tokens put up on sale are obtained from the initial minting
1189   uint private constant token_initial_supply = 4 * (10 ** 8) * (10 ** uint(token_decimals));
1190   bool private constant token_mintable = true;
1191   uint private constant sellable_tokens = 6 * (10 ** 8) * (10 ** uint(token_decimals));
1192   
1193   // Sets minimum value that can be bought
1194   uint public minimum_buy_value = 18 * 1 ether / 1000;
1195   // Eth price multiplied by 1000;
1196   uint public milieurs_per_eth;
1197   // Address allowed to update eth price.
1198   address rate_admin;
1199 
1200   /**
1201    * Constructor for the crowdsale.
1202    * Normally, the token contract is created here. That way, the minting, release and transfer agents can be set here too.
1203    *
1204    * @param eth_price_in_eurs Ether price in EUR.
1205    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
1206    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
1207    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
1208    * @param token_retriever Address that will handle tokens accidentally sent to the token contract. See the LostAndFoundToken and CrowdsaleToken contracts for further details.
1209    * @param init_tranches List of serialized tranches. See config.js and TokenTranchePricing for further details.
1210    */
1211   function Crowdsale(uint eth_price_in_eurs, address team_multisig, uint start, uint end, address token_retriever, uint[] init_tranches)
1212   GenericCrowdsale(team_multisig, start, end) TokenTranchePricing(init_tranches) public {
1213     require(end == tranches[tranches.length.sub(1)].end);
1214     // Testing values
1215     token = new CrowdsaleToken(token_initial_supply, token_decimals, team_multisig, token_mintable, token_retriever);
1216     
1217     //Set eth price in EUR (multiplied by one thousand)
1218     updateEursPerEth(eth_price_in_eurs);
1219 
1220     // Set permissions to mint, transfer and release
1221     token.setMintAgent(address(this), true);
1222     token.setTransferAgent(address(this), true);
1223     token.setReleaseAgent(address(this));
1224 
1225     // Allow the multisig to transfer tokens
1226     token.setTransferAgent(team_multisig, true);
1227 
1228     // Tokens to be sold through this contract
1229     token.mint(address(this), sellable_tokens);
1230     // We don't need to mint anymore during the lifetime of the contract.
1231     token.setMintAgent(address(this), false);
1232   }
1233 
1234   //Token assignation through transfer
1235   function assignTokens(address receiver, uint tokenAmount) internal {
1236     token.transfer(receiver, tokenAmount);
1237   }
1238 
1239   //Token amount calculation
1240   function calculateTokenAmount(uint weiAmount, address) internal view returns (uint weiAllowed, uint tokenAmount) {
1241     uint tokensPerEth = getCurrentPrice(tokensSold).mul(milieurs_per_eth).div(1000);
1242     uint maxWeiAllowed = sellable_tokens.sub(tokensSold).mul(1 ether).div(tokensPerEth);
1243     weiAllowed = maxWeiAllowed.min256(weiAmount);
1244 
1245     if (weiAmount < maxWeiAllowed) {
1246       //Divided by 1000 because eth eth_price_in_eurs is multiplied by 1000
1247       tokenAmount = tokensPerEth.mul(weiAmount).div(1 ether);
1248     }
1249     // With this case we let the crowdsale end even when there are rounding errors due to the tokens to wei ratio
1250     else {
1251       tokenAmount = sellable_tokens.sub(tokensSold);
1252     }
1253   }
1254 
1255   // Implements the criterion of the funding state
1256   function isCrowdsaleFull() internal view returns (bool) {
1257     return tokensSold >= sellable_tokens;
1258   }
1259 
1260   /**
1261    * This function decides who handles lost tokens.
1262    * Do note that this function is NOT meant to be used in a token refund mechanism.
1263    * Its sole purpose is determining who can move around ERC20 tokens accidentally sent to this contract.
1264    */
1265   function getLostAndFoundMaster() internal view returns (address) {
1266     return owner;
1267   }
1268 
1269   /**
1270    * @dev Sets new minimum buy value for a transaction. Only the owner can call it.
1271    */
1272   function setMinimumBuyValue(uint newValue) public onlyOwner {
1273     minimum_buy_value = newValue;
1274   }
1275 
1276   /**
1277    * Investing function that recognizes the payer and verifies that he is allowed to invest.
1278    *
1279    * Overwritten to add configurable minimum value
1280    *
1281    * @param customerId UUIDv4 that identifies this contributor
1282    */
1283   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable investmentIsBigEnough(msg.sender) validCustomerId(customerId) {
1284     super.buyWithSignedAddress(customerId, v, r, s);
1285   }
1286 
1287 
1288   /**
1289    * Investing function that recognizes the payer.
1290    * 
1291    * @param customerId UUIDv4 that identifies this contributor
1292    */
1293   function buyWithCustomerId(uint128 customerId) public payable investmentIsBigEnough(msg.sender) validCustomerId(customerId) unsignedBuyAllowed {
1294     super.buyWithCustomerId(customerId);
1295   }
1296 
1297   /**
1298    * The basic entry point to participate in the crowdsale process.
1299    *
1300    * Pay for funding, get invested tokens back in the sender address.
1301    */
1302   function buy() public payable investmentIsBigEnough(msg.sender) unsignedBuyAllowed {
1303     super.buy();
1304   }
1305 
1306   // Extended to transfer half of the unused funds to the team's multisig and release the token
1307   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1308     token.releaseTokenTransfer();
1309     uint unsoldTokens = token.balanceOf(address(this));
1310     token.transfer(multisigWallet, unsoldTokens);
1311     super.finalize();
1312   }
1313 
1314   //Change the the starting time in order to end the presale period early if needed.
1315   function setStartingTime(uint startingTime) public onlyOwner inState(State.PreFunding) {
1316     require(startingTime > block.timestamp && startingTime < endsAt);
1317     startsAt = startingTime;
1318   }
1319 
1320   //Change the the ending time in order to be able to finalize the crowdsale if needed.
1321   function setEndingTime(uint endingTime) public onlyOwner notFinished {
1322     require(endingTime > block.timestamp && endingTime > startsAt);
1323     endsAt = endingTime;
1324   }
1325 
1326   /**
1327    * Override to reject calls unless the crowdsale is finalized or
1328    *  the token contract is not the one corresponding to this crowdsale
1329    */
1330   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
1331     // Either the state is finalized or the token_contract is not this crowdsale token
1332     require(address(token_contract) != address(token) || getState() == State.Finalized);
1333     super.enableLostAndFound(agent, tokens, token_contract);
1334   }
1335 
1336   function updateEursPerEth(uint milieurs_amount) public {
1337     require(msg.sender == owner || msg.sender == rate_admin);
1338     require(milieurs_amount >= 100);
1339     milieurs_per_eth = milieurs_amount;
1340   }
1341 
1342   function setRateAdmin(address admin) public onlyOwner {
1343     rate_admin = admin;
1344   }
1345 
1346 
1347   modifier investmentIsBigEnough(address agent) {
1348     require(msg.value.add(investedAmountOf[agent]) >= minimum_buy_value);
1349     _;
1350   }
1351 }