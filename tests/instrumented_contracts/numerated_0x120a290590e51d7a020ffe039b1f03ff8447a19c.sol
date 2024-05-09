1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() internal {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to. 
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     owner = newOwner;
37   }
38 
39 }
40 
41 /**
42  * Abstract contract that allows children to implement an
43  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
44  *
45  */
46 contract Haltable is Ownable {
47   bool public halted;
48 
49   event Halted(bool halted);
50 
51   modifier stopInEmergency {
52     require(!halted);
53     _;
54   }
55 
56   modifier onlyInEmergency {
57     require(halted);
58     _;
59   }
60 
61   // called by the owner on emergency, triggers stopped state
62   function halt() external onlyOwner {
63     halted = true;
64     Halted(true);
65   }
66 
67   // called by the owner on end of emergency, returns to normal state
68   function unhalt() external onlyOwner onlyInEmergency {
69     halted = false;
70     Halted(false);
71   }
72 
73 }
74 
75 /**
76  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
77  * Modified by https://www.coinfabrik.com/
78  */
79 
80 /**
81  * Math operations with safety checks
82  */
83 library SafeMath {
84   function mul(uint a, uint b) internal pure returns (uint) {
85     uint c = a * b;
86     assert(a == 0 || c / a == b);
87     return c;
88   }
89 
90   function div(uint a, uint b) internal pure returns (uint) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   function sub(uint a, uint b) internal pure returns (uint) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   function add(uint a, uint b) internal pure returns (uint) {
103     uint c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 
108   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
109     return a >= b ? a : b;
110   }
111 
112   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
113     return a < b ? a : b;
114   }
115 
116   function max256(uint a, uint b) internal pure returns (uint) {
117     return a >= b ? a : b;
118   }
119 
120   function min256(uint a, uint b) internal pure returns (uint) {
121     return a < b ? a : b;
122   }
123 }
124 
125 /**
126  * Interface for the standard token.
127  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
128  */
129 interface EIP20Token {
130 
131   function totalSupply() public view returns (uint256);
132   function balanceOf(address who) public view returns (uint256);
133   function transfer(address to, uint256 value) public returns (bool success);
134   function transferFrom(address from, address to, uint256 value) public returns (bool success);
135   function approve(address spender, uint256 value) public returns (bool success);
136   function allowance(address owner, address spender) public view returns (uint256 remaining);
137   event Transfer(address indexed from, address indexed to, uint256 value);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 
140   /**
141   ** Optional functions
142   *
143   function name() public view returns (string name);
144   function symbol() public view returns (string symbol);
145   function decimals() public view returns (uint8 decimals);
146   *
147   **/
148 
149 }
150 
151 // Interface for burning tokens
152 contract Burnable {
153   // @dev Destroys tokens for an account
154   // @param account Account whose tokens are destroyed
155   // @param value Amount of tokens to destroy
156   function burnTokens(address account, uint value) internal;
157   event Burned(address account, uint value);
158 }
159 
160 /**
161  * Authored by https://www.coinfabrik.com/
162  */
163 
164 
165 /**
166  * Internal interface for the minting of tokens.
167  */
168 contract Mintable {
169 
170   /**
171    * @dev Mints tokens for an account
172    * This function should emit the Minted event.
173    */
174   function mintInternal(address receiver, uint amount) internal;
175 
176   /** Token supply got increased and a new owner received these tokens */
177   event Minted(address receiver, uint amount);
178 }
179 
180 /**
181  * @title Standard token
182  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
183  */
184 contract StandardToken is EIP20Token, Burnable, Mintable {
185   using SafeMath for uint;
186 
187   uint private total_supply;
188   mapping(address => uint) private balances;
189   mapping(address => mapping (address => uint)) private allowed;
190 
191 
192   function totalSupply() public view returns (uint) {
193     return total_supply;
194   }
195 
196   /**
197    * @dev transfer token for a specified address
198    * @param to The address to transfer to.
199    * @param value The amount to be transferred.
200    */
201   function transfer(address to, uint value) public returns (bool success) {
202     balances[msg.sender] = balances[msg.sender].sub(value);
203     balances[to] = balances[to].add(value);
204     Transfer(msg.sender, to, value);
205     return true;
206   }
207 
208   /**
209    * @dev Gets the balance of the specified address.
210    * @param account The address whose balance is to be queried.
211    * @return An uint representing the amount owned by the passed address.
212    */
213   function balanceOf(address account) public view returns (uint balance) {
214     return balances[account];
215   }
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param from address The address which you want to send tokens from
220    * @param to address The address which you want to transfer to
221    * @param value uint the amout of tokens to be transfered
222    */
223   function transferFrom(address from, address to, uint value) public returns (bool success) {
224     uint allowance = allowed[from][msg.sender];
225 
226     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
227     // require(value <= allowance);
228     // SafeMath uses assert instead of require though, beware when using an analysis tool
229 
230     balances[from] = balances[from].sub(value);
231     balances[to] = balances[to].add(value);
232     allowed[from][msg.sender] = allowance.sub(value);
233     Transfer(from, to, value);
234     return true;
235   }
236 
237   /**
238    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    * @param spender The address which will spend the funds.
240    * @param value The amount of tokens to be spent.
241    */
242   function approve(address spender, uint value) public returns (bool success) {
243 
244     // To change the approve amount you first have to reduce the addresses'
245     //  allowance to zero by calling `approve(spender, 0)` if it is not
246     //  already 0 to mitigate the race condition described here:
247     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248     require (value == 0 || allowed[msg.sender][spender] == 0);
249 
250     allowed[msg.sender][spender] = value;
251     Approval(msg.sender, spender, value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens than an owner allowed to a spender.
257    * @param account address The address which owns the funds.
258    * @param spender address The address which will spend the funds.
259    * @return A uint specifing the amount of tokens still avaible for the spender.
260    */
261   function allowance(address account, address spender) public view returns (uint remaining) {
262     return allowed[account][spender];
263   }
264 
265   /**
266    * Atomic increment of approved spending
267    *
268    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    *
270    */
271   function addApproval(address spender, uint addedValue) public returns (bool success) {
272       uint oldValue = allowed[msg.sender][spender];
273       allowed[msg.sender][spender] = oldValue.add(addedValue);
274       Approval(msg.sender, spender, allowed[msg.sender][spender]);
275       return true;
276   }
277 
278   /**
279    * Atomic decrement of approved spending.
280    *
281    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282    */
283   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
284 
285       uint oldVal = allowed[msg.sender][spender];
286 
287       if (subtractedValue > oldVal) {
288           allowed[msg.sender][spender] = 0;
289       } else {
290           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
291       }
292       Approval(msg.sender, spender, allowed[msg.sender][spender]);
293       return true;
294   }
295 
296   /**
297    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
298    */
299   function burnTokens(address account, uint value) internal {
300     balances[account] = balances[account].sub(value);
301     total_supply = total_supply.sub(value);
302     Transfer(account, 0, value);
303     Burned(account, value);
304   }
305 
306   /**
307    * @dev Provides an internal minting function.
308    */
309   function mintInternal(address receiver, uint amount) internal {
310     total_supply = total_supply.add(amount);
311     balances[receiver] = balances[receiver].add(amount);
312     Minted(receiver, amount);
313 
314     // Beware: Address zero may be used for special transactions in a future fork.
315     // This will make the mint transaction appear in EtherScan.io
316     // We can remove this after there is a standardized minting event
317     Transfer(0, receiver, amount);
318   }
319   
320 }
321 
322 /**
323  * Define interface for releasing the token transfer after a successful crowdsale.
324  */
325 contract ReleasableToken is StandardToken, Ownable {
326 
327   /* The finalizer contract that allows lifting the transfer limits on this token */
328   address public releaseAgent;
329 
330   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
331   bool public released = false;
332 
333   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
334   mapping (address => bool) public transferAgents;
335 
336   /**
337    * Set the contract that can call release and make the token transferable.
338    *
339    * Since the owner of this contract is (or should be) the crowdsale,
340    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
341    */
342   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
343     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
344     releaseAgent = addr;
345   }
346 
347   /**
348    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
349    */
350   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
351     transferAgents[addr] = state;
352   }
353 
354   /**
355    * One way function to release the tokens into the wild.
356    *
357    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
358    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
359    */
360   function releaseTokenTransfer() public onlyReleaseAgent {
361     released = true;
362   }
363 
364   /**
365    * Limit token transfer until the crowdsale is over.
366    */
367   modifier canTransfer(address sender) {
368     require(released || transferAgents[sender]);
369     _;
370   }
371 
372   /** The function can be called only before or after the tokens have been released */
373   modifier inReleaseState(bool releaseState) {
374     require(releaseState == released);
375     _;
376   }
377 
378   /** The function can be called only by a whitelisted release agent. */
379   modifier onlyReleaseAgent() {
380     require(msg.sender == releaseAgent);
381     _;
382   }
383 
384   /** We restrict transfer by overriding it */
385   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
386     // Call StandardToken.transfer()
387    return super.transfer(to, value);
388   }
389 
390   /** We restrict transferFrom by overriding it */
391   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
392     // Call StandardToken.transferForm()
393     return super.transferFrom(from, to, value);
394   }
395 
396 }
397 
398 /**
399  * Inspired by Lunyr.
400  * Originally from https://github.com/TokenMarketNet/ico
401  */
402 
403 /**
404  * Upgrade agent transfers tokens to a new contract.
405  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
406  *
407  * The Upgrade agent is the interface used to implement a token
408  * migration in the case of an emergency.
409  * The function upgradeFrom has to implement the part of the creation
410  * of new tokens on behalf of the user doing the upgrade.
411  *
412  * The new token can implement this interface directly, or use.
413  */
414 contract UpgradeAgent {
415 
416   /** This value should be the same as the original token's total supply */
417   uint public originalSupply;
418 
419   /** Interface to ensure the contract is correctly configured */
420   function isUpgradeAgent() public pure returns (bool) {
421     return true;
422   }
423 
424   /**
425   Upgrade an account
426 
427   When the token contract is in the upgrade status the each user will
428   have to call `upgrade(value)` function from UpgradeableToken.
429 
430   The upgrade function adjust the balance of the user and the supply
431   of the previous token and then call `upgradeFrom(value)`.
432 
433   The UpgradeAgent is the responsible to create the tokens for the user
434   in the new contract.
435 
436   * @param from Account to upgrade.
437   * @param value Tokens to upgrade.
438 
439   */
440   function upgradeFrom(address from, uint value) public;
441 
442 }
443 
444 
445 /**
446  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
447  *
448  */
449 contract UpgradeableToken is EIP20Token, Burnable {
450   using SafeMath for uint;
451 
452   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
453   address public upgradeMaster;
454 
455   /** The next contract where the tokens will be migrated. */
456   UpgradeAgent public upgradeAgent;
457 
458   /** How many tokens we have upgraded by now. */
459   uint public totalUpgraded = 0;
460 
461   /**
462    * Upgrade states.
463    *
464    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
465    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
466    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet. This allows changing the upgrade agent while there is time.
467    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
468    *
469    */
470   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
471 
472   /**
473    * Somebody has upgraded some of his tokens.
474    */
475   event Upgrade(address indexed from, address to, uint value);
476 
477   /**
478    * New upgrade agent available.
479    */
480   event UpgradeAgentSet(address agent);
481 
482   /**
483    * Do not allow construction without upgrade master set.
484    */
485   function UpgradeableToken(address master) internal {
486     setUpgradeMaster(master);
487   }
488 
489   /**
490    * Allow the token holder to upgrade some of their tokens to a new contract.
491    */
492   function upgrade(uint value) public {
493     UpgradeState state = getUpgradeState();
494     // Ensure it's not called in a bad state
495     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
496 
497     // Validate input value.
498     require(value != 0);
499 
500     // Upgrade agent reissues the tokens
501     upgradeAgent.upgradeFrom(msg.sender, value);
502     
503     // Take tokens out from circulation
504     burnTokens(msg.sender, value);
505     totalUpgraded = totalUpgraded.add(value);
506 
507     Upgrade(msg.sender, upgradeAgent, value);
508   }
509 
510   /**
511    * Set an upgrade agent that handles the upgrade process
512    */
513   function setUpgradeAgent(address agent) onlyMaster external {
514     // Check whether the token is in a state that we could think of upgrading
515     require(canUpgrade());
516 
517     require(agent != 0x0);
518     // Upgrade has already begun for an agent
519     require(getUpgradeState() != UpgradeState.Upgrading);
520 
521     upgradeAgent = UpgradeAgent(agent);
522 
523     // Bad interface
524     require(upgradeAgent.isUpgradeAgent());
525     // Make sure that token supplies match in source and target
526     require(upgradeAgent.originalSupply() == totalSupply());
527 
528     UpgradeAgentSet(upgradeAgent);
529   }
530 
531   /**
532    * Get the state of the token upgrade.
533    */
534   function getUpgradeState() public view returns(UpgradeState) {
535     if (!canUpgrade()) return UpgradeState.NotAllowed;
536     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
537     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
538     else return UpgradeState.Upgrading;
539   }
540 
541   /**
542    * Change the upgrade master.
543    *
544    * This allows us to set a new owner for the upgrade mechanism.
545    */
546   function changeUpgradeMaster(address new_master) onlyMaster public {
547     setUpgradeMaster(new_master);
548   }
549 
550   /**
551    * Internal upgrade master setter.
552    */
553   function setUpgradeMaster(address new_master) private {
554     require(new_master != 0x0);
555     upgradeMaster = new_master;
556   }
557 
558   /**
559    * Child contract can override to provide the condition in which the upgrade can begin.
560    */
561   function canUpgrade() public view returns(bool) {
562      return true;
563   }
564 
565 
566   modifier onlyMaster() {
567     require(msg.sender == upgradeMaster);
568     _;
569   }
570 }
571 
572 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
573 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
574 // Of course, this contract imposes support costs upon whoever is the lost and found master.
575 contract LostAndFoundToken {
576   /**
577    * @return Address of the account that handles movements.
578    */
579   function getLostAndFoundMaster() internal view returns (address);
580 
581   /**
582    * @param agent Address that will be able to move tokens with transferFrom
583    * @param tokens Amount of tokens approved for transfer
584    * @param token_contract Contract of the token
585    */
586   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
587     require(msg.sender == getLostAndFoundMaster());
588     // We use approve instead of transfer to minimize the possibility of the lost and found master
589     //  getting them stuck in another address by accident.
590     token_contract.approve(agent, tokens);
591   }
592 }
593 
594 
595 
596 /**
597  * A public interface to increase the supply of a token.
598  *
599  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
600  * Only mint agents, usually contracts whitelisted by the owner, can mint new tokens.
601  *
602  */
603 contract MintableToken is Mintable, Ownable {
604 
605   using SafeMath for uint;
606 
607   bool public mintingFinished = false;
608 
609   /** List of agents that are allowed to create new tokens */
610   mapping (address => bool) public mintAgents;
611 
612   event MintingAgentChanged(address addr, bool state);
613 
614 
615   function MintableToken(uint initialSupply, address multisig, bool mintable) internal {
616     require(multisig != address(0));
617     // Cannot create a token without supply and no minting
618     require(mintable || initialSupply != 0);
619     // Create initially all balance on the team multisig
620     if (initialSupply > 0)
621       mintInternal(multisig, initialSupply);
622     // No more new supply allowed after the token creation
623     mintingFinished = !mintable;
624   }
625 
626   /**
627    * Create new tokens and allocate them to an address.
628    *
629    * Only callable by a mint agent (e.g. crowdsale contract).
630    */
631   function mint(address receiver, uint amount) onlyMintAgent canMint public {
632     mintInternal(receiver, amount);
633   }
634 
635   /**
636    * Owner can allow a crowdsale contract to mint new tokens.
637    */
638   function setMintAgent(address addr, bool state) onlyOwner canMint public {
639     mintAgents[addr] = state;
640     MintingAgentChanged(addr, state);
641   }
642 
643   modifier onlyMintAgent() {
644     // Only mint agents are allowed to mint new tokens
645     require(mintAgents[msg.sender]);
646     _;
647   }
648 
649   /** Make sure we are not done yet. */
650   modifier canMint() {
651     require(!mintingFinished);
652     _;
653   }
654 }
655 
656 
657 /**
658  * A crowdsale token.
659  *
660  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
661  *
662  * - The token transfer() is disabled until the crowdsale is over
663  * - The token contract gives an opt-in upgrade path to a new contract
664  * - The same token can be part of several crowdsales through the approve() mechanism
665  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
666  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
667  *
668  */
669 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
670 
671   string public name = "TokenHome";
672 
673   string public symbol = "TH";
674 
675   uint8 public decimals;
676 
677   address public lost_and_found_master;
678 
679   /**
680    * Construct the token.
681    *
682    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
683    *
684    * @param initial_supply How many tokens we start with.
685    * @param token_decimals Number of decimal places.
686    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
687    * @param mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
688    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
689    */
690   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, bool mintable, address token_retriever) public
691   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, mintable) {
692     require(token_retriever != address(0));
693     decimals = token_decimals;
694     lost_and_found_master = token_retriever;
695   }
696 
697   /**
698    * When token is released to be transferable, prohibit new token creation.
699    */
700   function releaseTokenTransfer() public onlyReleaseAgent {
701     mintingFinished = true;
702     super.releaseTokenTransfer();
703   }
704 
705   function burn( uint value) public {
706     burnTokens(msg.sender, value);
707   }
708 
709   /**
710    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
711    */
712   function canUpgrade() public view returns(bool) {
713     return released && super.canUpgrade();
714   }
715 
716   function getLostAndFoundMaster() internal view returns(address) {
717     return lost_and_found_master;
718   }
719 
720 }
721 /**
722  * Abstract base contract for token sales.
723  *
724  * Handles
725  * - start and end dates
726  * - accepting investments
727  * - various statistics during the crowdfund
728  * - different investment policies (require server side customer id, allow only whitelisted addresses)
729  *
730  */
731 contract GenericCrowdsale is Haltable {
732 
733   using SafeMath for uint;
734 
735   /* The token we are selling */
736   CrowdsaleToken public token;
737 
738   /* ether will be transferred to this address */
739   address public multisigWallet;
740 
741   /* the starting block number of the crowdsale */
742   uint public startsAt;
743 
744   /* the ending block number of the crowdsale */
745   uint public endsAt;
746 
747   /* the number of tokens already sold through this contract*/
748   uint public tokensSold = 0;
749 
750   /* How many wei of funding we have raised */
751   uint public weiRaised = 0;
752 
753   /* How many distinct addresses have invested */
754   uint public investorCount = 0;
755 
756   /* Has this crowdsale been finalized */
757   bool public finalized = false;
758 
759   /* Do we need to have a unique contributor id for each customer */
760   bool public requireCustomerId = false;
761 
762   /**
763    * Do we verify that contributor has been cleared on the server side (accredited investors only).
764    * This method was first used in the FirstBlood crowdsale to ensure all contributors had accepted terms of sale (on the web).
765    */
766   bool public requiredSignedAddress = true;
767 
768   /** Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
769   address public signerAddress;
770 
771   /** How many ETH each address has invested in this crowdsale */
772   mapping (address => uint) public investedAmountOf;
773 
774   /** How many tokens this crowdsale has credited for each investor address */
775   mapping (address => uint) public tokenAmountOf;
776 
777   /** Addresses that are allowed to invest even before ICO officially opens. For testing, for ICO partners, etc. */
778   mapping (address => bool) public earlyParticipantWhitelist;
779 
780   /** State machine
781    *
782    * - Prefunding: We have not reached the starting block yet
783    * - Funding: Active crowdsale
784    * - Success: Crowdsale ended
785    * - Finalized: The finalize function has been called and succesfully executed
786    */
787   enum State{Unknown, PreFunding, Funding, Success, Finalized}
788 
789 
790   // A new investment was made
791   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
792 
793   // The rules about what kind of investments we accept were changed
794   event InvestmentPolicyChanged(bool requireCId, bool requireSignedAddress, address signer);
795 
796   // Address early participation whitelist status changed
797   event Whitelisted(address addr, bool status);
798 
799   // Crowdsale's finalize function has been called
800   event Finalized();
801 
802 
803   /**
804    * Basic constructor for the crowdsale.
805    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
806    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
807    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
808    */
809   function GenericCrowdsale(address team_multisig, uint start, uint end) internal {
810     setMultisig(team_multisig);
811 
812     // Don't mess the dates
813     require(start != 0 && end != 0);
814     require(block.timestamp < start && start < end);
815     startsAt = start;
816     endsAt = end;
817   }
818 
819   /**
820    * Default fallback behaviour is to call buy.
821    * Ideally, no contract calls this crowdsale without supporting ERC20.
822    * However, some sort of refunding function may be desired to cover such situations.
823    */
824   function() payable public {
825     buy();
826   }
827 
828   /**
829    * Make an investment.
830    *
831    * The crowdsale must be running for one to invest.
832    * We must have not pressed the emergency brake.
833    *
834    * @param receiver The Ethereum address who receives the tokens
835    * @param customerId (optional) UUID v4 to track the successful payments on the server side
836    *
837    */
838   function investInternal(address receiver, uint128 customerId) stopInEmergency notFinished private {
839     // Determine if it's a good time to accept investment from this participant
840     if (getState() == State.PreFunding) {
841       // Are we whitelisted for early deposit
842       require(earlyParticipantWhitelist[msg.sender]);
843     }
844 
845     uint weiAmount;
846     uint tokenAmount;
847     (weiAmount, tokenAmount) = calculateTokenAmount(msg.value, receiver);
848     // Sanity check against bad implementation.
849     assert(weiAmount <= msg.value);
850     
851     // Dust transaction if no tokens can be given
852     require(tokenAmount != 0);
853 
854     if (investedAmountOf[receiver] == 0) {
855       // A new investor
856       investorCount++;
857     }
858     updateInvestorFunds(tokenAmount, weiAmount, receiver, customerId);
859 
860     // Pocket the money
861     multisigWallet.transfer(weiAmount);
862 
863     // Return excess of money
864     returnExcedent(msg.value.sub(weiAmount), msg.sender);
865   }
866 
867   /**
868    * Preallocate tokens for the early investors.
869    *
870    * Preallocated tokens have been sold before the actual crowdsale opens.
871    * This function mints the tokens and moves the crowdsale needle.
872    *
873    * No money is exchanged, as the crowdsale team already have received the payment.
874    *
875    * @param receiver Account that receives the tokens.
876    * @param fullTokens tokens as full tokens - decimal places are added internally.
877    * @param weiPrice Price of a single indivisible token in wei.
878    *
879    */
880   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner notFinished {
881     require(receiver != address(0));
882     uint tokenAmount = fullTokens.mul(10**uint(token.decimals()));
883     require(tokenAmount != 0);
884     uint weiAmount = weiPrice.mul(tokenAmount); // This can also be 0, in which case we give out tokens for free
885     updateInvestorFunds(tokenAmount, weiAmount, receiver , 0);
886   }
887 
888   /**
889    * Private function to update accounting in the crowdsale.
890    */
891   function updateInvestorFunds(uint tokenAmount, uint weiAmount, address receiver, uint128 customerId) private {
892     // Update investor
893     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
894     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
895 
896     // Update totals
897     weiRaised = weiRaised.add(weiAmount);
898     tokensSold = tokensSold.add(tokenAmount);
899 
900     assignTokens(receiver, tokenAmount);
901     // Tell us that the investment was completed successfully
902     Invested(receiver, weiAmount, tokenAmount, customerId);
903   }
904 
905   /**
906    * Investing function that recognizes the receiver and verifies he is allowed to invest.
907    *
908    * @param customerId UUIDv4 that identifies this contributor
909    */
910   function buyOnBehalfWithSignedAddress(address receiver, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable validCustomerId(customerId) {
911     bytes32 hash = sha256(receiver);
912     require(ecrecover(hash, v, r, s) == signerAddress);
913     investInternal(receiver, customerId);
914   }
915 
916   /**
917    * Investing function that recognizes the receiver.
918    * 
919    * @param customerId UUIDv4 that identifies this contributor
920    */
921   function buyOnBehalfWithCustomerId(address receiver, uint128 customerId) public payable validCustomerId(customerId) unsignedBuyAllowed {
922     investInternal(receiver, customerId);
923   }
924 
925   /**
926    * Buys tokens on behalf of an address.
927    *
928    * Pay for funding, get invested tokens back in the receiver address.
929    */
930   function buyOnBehalf(address receiver) public payable unsignedBuyAllowed {
931     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
932     investInternal(receiver, 0);
933   }
934 
935   /**
936    * Investing function that recognizes the payer and verifies he is allowed to invest.
937    *
938    * @param customerId UUIDv4 that identifies this contributor
939    */
940   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
941     buyOnBehalfWithSignedAddress(msg.sender, customerId, v, r, s);
942   }
943 
944 
945   /**
946    * Investing function that recognizes the payer.
947    * 
948    * @param customerId UUIDv4 that identifies this contributor
949    */
950   function buyWithCustomerId(uint128 customerId) public payable {
951     buyOnBehalfWithCustomerId(msg.sender, customerId);
952   }
953 
954   /**
955    * The basic entry point to participate in the crowdsale process.
956    *
957    * Pay for funding, get invested tokens back in the sender address.
958    */
959   function buy() public payable {
960     buyOnBehalf(msg.sender);
961   }
962 
963   /**
964    * Finalize a succcesful crowdsale.
965    *
966    * The owner can trigger post-crowdsale actions, like releasing the tokens.
967    * Note that by default tokens are not in a released state.
968    */
969   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
970     finalized = true;
971     Finalized();
972   }
973 
974   /**
975    * Set policy do we need to have server-side customer ids for the investments.
976    *
977    */
978   function setRequireCustomerId(bool value) public onlyOwner {
979     requireCustomerId = value;
980     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
981   }
982 
983   /**
984    * Set policy if all investors must be cleared on the server side first.
985    *
986    * This is e.g. for the accredited investor clearing.
987    *
988    */
989   function setRequireSignedAddress(bool value, address signer) public onlyOwner {
990     requiredSignedAddress = value;
991     signerAddress = signer;
992     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
993   }
994 
995   /**
996    * Allow addresses to do early participation.
997    */
998   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
999     earlyParticipantWhitelist[addr] = status;
1000     Whitelisted(addr, status);
1001   }
1002 
1003   /**
1004    * Internal setter for the multisig wallet
1005    */
1006   function setMultisig(address addr) internal {
1007     require(addr != 0);
1008     multisigWallet = addr;
1009   }
1010 
1011   /**
1012    * Crowdfund state machine management.
1013    *
1014    * This function has the timed transition builtin.
1015    * So there is no chance of the variable being stale.
1016    */
1017   function getState() public view returns (State) {
1018     if (finalized) return State.Finalized;
1019     else if (block.timestamp < startsAt) return State.PreFunding;
1020     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1021     else return State.Success;
1022   }
1023 
1024   /** Internal functions that exist to provide inversion of control should they be overriden */
1025 
1026   /** Interface for the concrete instance to interact with the token contract in a customizable way */
1027   function assignTokens(address receiver, uint tokenAmount) internal;
1028 
1029   /**
1030    *  Determine if the goal was already reached in the current crowdsale
1031    */
1032   function isCrowdsaleFull() internal view returns (bool full);
1033 
1034   /**
1035    * Returns any excess wei received
1036    * 
1037    * This function can be overriden to provide a different refunding method.
1038    */
1039   function returnExcedent(uint excedent, address receiver) internal {
1040     if (excedent > 0) {
1041       receiver.transfer(excedent);
1042     }
1043   }
1044 
1045   /** 
1046    *  Calculate the amount of tokens that corresponds to the received amount.
1047    *  The wei amount is returned too in case not all of it can be invested.
1048    *
1049    *  Note: When there's an excedent due to rounding error, it should be returned to allow refunding.
1050    *  This is worked around in the current design using an appropriate amount of decimals in the FractionalERC20 standard.
1051    *  The workaround is good enough for most use cases, hence the simplified function signature.
1052    *  @return weiAllowed The amount of wei accepted in this transaction.
1053    *  @return tokenAmount The tokens that are assigned to the receiver in this transaction.
1054    */
1055   function calculateTokenAmount(uint weiAmount, address receiver) internal view returns (uint weiAllowed, uint tokenAmount);
1056 
1057   //
1058   // Modifiers
1059   //
1060 
1061   modifier inState(State state) {
1062     require(getState() == state);
1063     _;
1064   }
1065 
1066   modifier unsignedBuyAllowed() {
1067     require(!requiredSignedAddress);
1068     _;
1069   }
1070 
1071   /** Modifier allowing execution only if the crowdsale is currently running.  */
1072   modifier notFinished() {
1073     State current_state = getState();
1074     require(current_state == State.PreFunding || current_state == State.Funding);
1075     _;
1076   }
1077 
1078   modifier validCustomerId(uint128 customerId) {
1079     require(customerId != 0);  // UUIDv4 sanity check
1080     _;
1081   }
1082 
1083 }
1084 
1085 
1086 
1087 
1088 
1089 // Simple deployment information store inside contract storage.
1090 contract DeploymentInfo {
1091   uint private deployed_on;
1092 
1093   function DeploymentInfo() public {
1094     deployed_on = block.number;
1095   }
1096 
1097 
1098   function getDeploymentBlock() public view returns (uint) {
1099     return deployed_on;
1100   }
1101 }
1102 
1103 
1104 /// @dev Tranche based pricing.
1105 ///      Implementing "first price" tranches, meaning, that if a buyer's order is
1106 ///      covering more than one tranche, the price of the lowest tranche will apply
1107 ///      to the whole order.
1108 contract TokenTranchePricing {
1109 
1110   using SafeMath for uint;
1111 
1112   /**
1113    * Define pricing schedule using tranches.
1114    */
1115   struct Tranche {
1116       // Amount in tokens when this tranche becomes inactive
1117       uint amount;
1118       // Block interval [start, end)
1119       // Starting block (included in the interval)
1120       uint start;
1121       // Ending block (excluded from the interval)
1122       uint end;
1123       // How many tokens per wei you will get while this tranche is active
1124       uint price;
1125   }
1126   // We define offsets and size for the deserialization of ordered tuples in raw arrays
1127   uint private constant amount_offset = 0;
1128   uint private constant start_offset = 1;
1129   uint private constant end_offset = 2;
1130   uint private constant price_offset = 3;
1131   uint private constant tranche_size = 4;
1132 
1133   Tranche[] public tranches;
1134 
1135   function getTranchesLength() public view returns (uint) {
1136     return tranches.length;
1137   }
1138 
1139   /// @dev Construction, creating a list of tranches
1140   /// @param init_tranches Raw array of ordered tuples: (start amount, start block, end block, price)
1141   function TokenTranchePricing(uint[] init_tranches) public {
1142     // Need to have tuples, length check
1143     require(init_tranches.length % tranche_size == 0);
1144     // A tranche with amount zero can never be selected and is therefore useless.
1145     // This check and the one inside the loop ensure no tranche can have an amount equal to zero.
1146     require(init_tranches[amount_offset] > 0);
1147 
1148     uint input_tranches_length = init_tranches.length.div(tranche_size);
1149     Tranche memory last_tranche;
1150     for (uint i = 0; i < input_tranches_length; i++) {
1151       uint tranche_offset = i.mul(tranche_size);
1152       uint amount = init_tranches[tranche_offset.add(amount_offset)];
1153       uint start = init_tranches[tranche_offset.add(start_offset)];
1154       uint end = init_tranches[tranche_offset.add(end_offset)];
1155       uint price = init_tranches[tranche_offset.add(price_offset)];
1156       // No invalid steps
1157       require(block.timestamp < start && start < end);
1158       // Bail out when entering unnecessary tranches
1159       // This is preferably checked before deploying contract into any blockchain.
1160       require(i == 0 || (end >= last_tranche.end && amount > last_tranche.amount) ||
1161               (end > last_tranche.end && amount >= last_tranche.amount));
1162 
1163       last_tranche = Tranche(amount, start, end, price);
1164       tranches.push(last_tranche);
1165     }
1166   }
1167 
1168   /// @dev Get the current tranche or bail out if there is no tranche defined for the current block.
1169   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1170   /// @return Returns the struct representing the current tranche
1171   function getCurrentTranche(uint tokensSold) private view returns (Tranche storage) {
1172     for (uint i = 0; i < tranches.length; i++) {
1173       if (tranches[i].start <= block.timestamp && block.timestamp < tranches[i].end && tokensSold < tranches[i].amount) {
1174         return tranches[i];
1175       }
1176     }
1177     // No tranche is currently active
1178     revert();
1179   }
1180 
1181   /// @dev Get the current price. May revert if there is no tranche currently active.
1182   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1183   /// @return The current price
1184   function getCurrentPrice(uint tokensSold) internal view returns (uint result) {
1185     return getCurrentTranche(tokensSold).price;
1186   }
1187 
1188 }
1189 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1190 contract Crowdsale is GenericCrowdsale, LostAndFoundToken, DeploymentInfo, TokenTranchePricing{
1191   //
1192   uint private constant token_initial_supply = 805 * (10 ** 5) * (10 ** uint(token_decimals));
1193   uint8 private constant token_decimals = 18;
1194   bool private constant token_mintable = true;
1195   uint private constant sellable_tokens = 322 * (10 ** 6) * (10 ** uint(token_decimals));
1196   uint public milieurs_per_eth;
1197   /**
1198    * Constructor for the crowdsale.
1199    * Normally, the token contract is created here. That way, the minting, release and transfer agents can be set here too.
1200    *
1201    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
1202    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
1203    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
1204    * @param token_retriever Address that will handle tokens accidentally sent to the token contract. See the LostAndFoundToken and CrowdsaleToken contracts for further details.
1205    */
1206   function Crowdsale(address team_multisig, uint start, uint end, address token_retriever, uint[] init_tranches, uint mili_eurs_per_eth) GenericCrowdsale(team_multisig, start, end) TokenTranchePricing(init_tranches) public {
1207 
1208     require(end == tranches[tranches.length.sub(1)].end);
1209     // Testing values
1210     token = new CrowdsaleToken(token_initial_supply, token_decimals, team_multisig, token_mintable, token_retriever);
1211     
1212     // Set permissions to mint, transfer and release
1213     token.setMintAgent(address(this), true);
1214     token.setTransferAgent(address(this), true);
1215     token.setReleaseAgent(address(this));
1216     
1217     // Tokens to be sold through this contract
1218     token.mint(address(this), sellable_tokens);
1219     
1220     // We don't need to mint anymore during the lifetime of the contract.
1221     token.setMintAgent(address(this), false);
1222     
1223     //Give multisig permision to send tokens to partners
1224     token.setTransferAgent(team_multisig, true);
1225 
1226     updateEursPerEth(mili_eurs_per_eth);
1227   }
1228 
1229   //Token assignation through transfer
1230   function assignTokens(address receiver, uint tokenAmount) internal{
1231     token.transfer(receiver, tokenAmount);
1232   }
1233 
1234   //Token amount calculation
1235   function calculateTokenAmount(uint weiAmount, address) internal view returns (uint weiAllowed, uint tokenAmount){
1236     uint tokensPerEth = getCurrentPrice(tokensSold).mul(milieurs_per_eth).div(1000);
1237     uint maxWeiAllowed = sellable_tokens.sub(tokensSold).mul(1 ether).div(tokensPerEth);
1238     weiAllowed = maxWeiAllowed.min256(weiAmount);
1239 
1240     if (weiAmount < maxWeiAllowed) {
1241       //Divided by 1000 because eth eth_price_in_eurs is multiplied by 1000
1242       tokenAmount = tokensPerEth.mul(weiAmount).div(1 ether);
1243     }
1244     // With this case we let the crowdsale end even when there are rounding errors due to the tokens to wei ratio
1245     else {
1246       tokenAmount = sellable_tokens.sub(tokensSold);
1247     }
1248   }
1249 
1250   // Crowdsale is full once all sellable_tokens are sold.
1251   function isCrowdsaleFull() internal view returns (bool full) {
1252     return tokensSold >= sellable_tokens;
1253   }
1254 
1255   /**
1256    * Finalize a succcesful crowdsale.
1257    *
1258    * The owner can trigger post-crowdsale actions, like releasing the tokens.
1259    * Note that by default tokens are not in a released state.
1260    */
1261   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1262     token.releaseTokenTransfer();
1263     uint unsoldTokens = token.balanceOf(address(this));
1264     token.burn(unsoldTokens);
1265     super.finalize();
1266   }
1267 
1268 
1269   //Change the the starting time in order to end the presale period early if needed.
1270   function setStartingTime(uint startingTime) public onlyOwner inState(State.PreFunding) {
1271     require(startingTime > block.timestamp && startingTime < endsAt);
1272     startsAt = startingTime;
1273   }
1274 
1275   //Change the the ending time in order to be able to finalize the crowdsale if needed.
1276   function setEndingTime(uint endingTime) public onlyOwner notFinished {
1277     require(endingTime > block.timestamp && endingTime > startsAt);
1278     endsAt = endingTime;
1279   }
1280 
1281   /**
1282    * This function decides who handles lost tokens.
1283    * Do note that this function is NOT meant to be used in a token refund mecahnism.
1284    * Its sole purpose is determining who can move around ERC20 tokens accidentally sent to this contract.
1285    */
1286   function getLostAndFoundMaster() internal view returns (address) {
1287     return owner;
1288   }
1289   
1290   //Update ETH value in milieurs
1291   function updateEursPerEth (uint milieurs_amount) public onlyOwner {
1292     require(milieurs_amount >= 100);
1293     milieurs_per_eth = milieurs_amount;
1294   }
1295   /**
1296    * Override to reject calls unless the crowdsale is finalized or
1297    *  the token contract is not the one corresponding to this crowdsale
1298    */
1299   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
1300     // Either the state is finalized or the token_contract is not this crowdsale token
1301     require(address(token_contract) != address(token) || getState() == State.Finalized);
1302     super.enableLostAndFound(agent, tokens, token_contract);
1303   }
1304 }