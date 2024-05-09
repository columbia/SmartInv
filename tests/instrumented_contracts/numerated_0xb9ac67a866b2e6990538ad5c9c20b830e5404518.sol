1 pragma solidity ^0.4.18;
2 
3 /**
4  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
5  * Modified by https://www.coinfabrik.com/
6  */
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control 
11  * functions, this simplifies the implementation of "user permissions". 
12  */
13 contract Ownable {
14   address public owner;
15 
16 
17   /** 
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() internal {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner. 
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to. 
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * Abstract contract that allows children to implement an
48  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
49  *
50  */
51 contract Haltable is Ownable {
52   bool public halted;
53 
54   event Halted(bool halted);
55 
56   modifier stopInEmergency {
57     require(!halted);
58     _;
59   }
60 
61   modifier onlyInEmergency {
62     require(halted);
63     _;
64   }
65 
66   // called by the owner on emergency, triggers stopped state
67   function halt() external onlyOwner {
68     halted = true;
69     Halted(true);
70   }
71 
72   // called by the owner on end of emergency, returns to normal state
73   function unhalt() external onlyOwner onlyInEmergency {
74     halted = false;
75     Halted(false);
76   }
77 
78 }
79 pragma solidity ^0.4.18;
80 
81 /**
82  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
83  * Modified by https://www.coinfabrik.com/
84  */
85 
86 /**
87  * Math operations with safety checks
88  */
89 library SafeMath {
90   function mul(uint a, uint b) internal pure returns (uint) {
91     uint c = a * b;
92     assert(a == 0 || c / a == b);
93     return c;
94   }
95 
96   function div(uint a, uint b) internal pure returns (uint) {
97     // assert(b > 0); // Solidity automatically throws when dividing by 0
98     uint c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100     return c;
101   }
102 
103   function sub(uint a, uint b) internal pure returns (uint) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   function add(uint a, uint b) internal pure returns (uint) {
109     uint c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 
114   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
115     return a >= b ? a : b;
116   }
117 
118   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
119     return a < b ? a : b;
120   }
121 
122   function max256(uint a, uint b) internal pure returns (uint) {
123     return a >= b ? a : b;
124   }
125 
126   function min256(uint a, uint b) internal pure returns (uint) {
127     return a < b ? a : b;
128   }
129 }
130 
131 pragma solidity ^0.4.18;
132 
133 /**
134  * Originally from https://github.com/TokenMarketNet/ico
135  * Modified by https://www.coinfabrik.com/
136  */
137 
138 pragma solidity ^0.4.18;
139 
140 /**
141  * Originally from https://github.com/TokenMarketNet/ico
142  * Modified by https://www.coinfabrik.com/
143  */
144 
145 pragma solidity ^0.4.18;
146 
147 /**
148  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
149  * Modified by https://www.coinfabrik.com/
150  */
151 
152 pragma solidity ^0.4.18;
153 
154 /**
155  * Interface for the standard token.
156  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157  */
158 contract EIP20Token {
159 
160   function totalSupply() public view returns (uint256);
161   function balanceOf(address who) public view returns (uint256);
162   function transfer(address to, uint256 value) public returns (bool success);
163   function transferFrom(address from, address to, uint256 value) public returns (bool success);
164   function approve(address spender, uint256 value) public returns (bool success);
165   function allowance(address owner, address spender) public view returns (uint256 remaining);
166   event Transfer(address indexed from, address indexed to, uint256 value);
167   event Approval(address indexed owner, address indexed spender, uint256 value);
168 
169   /**
170   ** Optional functions
171   *
172   function name() public view returns (string name);
173   function symbol() public view returns (string symbol);
174   function decimals() public view returns (uint8 decimals);
175   *
176   **/
177 
178 }
179 pragma solidity ^0.4.18;
180 
181 // Interface for burning tokens
182 contract Burnable {
183   // @dev Destroys tokens for an account
184   // @param account Account whose tokens are destroyed
185   // @param value Amount of tokens to destroy
186   function burnTokens(address account, uint value) internal;
187   event Burned(address account, uint value);
188 }
189 pragma solidity ^0.4.18;
190 
191 /**
192  * Authored by https://www.coinfabrik.com/
193  */
194 
195 
196 /**
197  * Internal interface for the minting of tokens.
198  */
199 contract Mintable {
200 
201   /**
202    * @dev Mints tokens for an account
203    * This function should emit the Minted event.
204    */
205   function mintInternal(address receiver, uint amount) internal;
206 
207   /** Token supply got increased and a new owner received these tokens */
208   event Minted(address receiver, uint amount);
209 }
210 
211 /**
212  * @title Standard token
213  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
214  */
215 contract StandardToken is EIP20Token, Burnable, Mintable {
216   using SafeMath for uint;
217 
218   uint private total_supply;
219   mapping(address => uint) private balances;
220   mapping(address => mapping (address => uint)) private allowed;
221 
222 
223   function totalSupply() public view returns (uint) {
224     return total_supply;
225   }
226 
227   /**
228    * @dev transfer token for a specified address
229    * @param to The address to transfer to.
230    * @param value The amount to be transferred.
231    */
232   function transfer(address to, uint value) public returns (bool success) {
233     balances[msg.sender] = balances[msg.sender].sub(value);
234     balances[to] = balances[to].add(value);
235     Transfer(msg.sender, to, value);
236     return true;
237   }
238 
239   /**
240    * @dev Gets the balance of the specified address.
241    * @param account The address whose balance is to be queried.
242    * @return An uint representing the amount owned by the passed address.
243    */
244   function balanceOf(address account) public view returns (uint balance) {
245     return balances[account];
246   }
247 
248   /**
249    * @dev Transfer tokens from one address to another
250    * @param from address The address which you want to send tokens from
251    * @param to address The address which you want to transfer to
252    * @param value uint the amout of tokens to be transfered
253    */
254   function transferFrom(address from, address to, uint value) public returns (bool success) {
255     uint allowance = allowed[from][msg.sender];
256 
257     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
258     // require(value <= allowance);
259     // SafeMath uses assert instead of require though, beware when using an analysis tool
260 
261     balances[from] = balances[from].sub(value);
262     balances[to] = balances[to].add(value);
263     allowed[from][msg.sender] = allowance.sub(value);
264     Transfer(from, to, value);
265     return true;
266   }
267 
268   /**
269    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    * @param spender The address which will spend the funds.
271    * @param value The amount of tokens to be spent.
272    */
273   function approve(address spender, uint value) public returns (bool success) {
274 
275     // To change the approve amount you first have to reduce the addresses'
276     //  allowance to zero by calling `approve(spender, 0)` if it is not
277     //  already 0 to mitigate the race condition described here:
278     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279     require (value == 0 || allowed[msg.sender][spender] == 0);
280 
281     allowed[msg.sender][spender] = value;
282     Approval(msg.sender, spender, value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens than an owner allowed to a spender.
288    * @param account address The address which owns the funds.
289    * @param spender address The address which will spend the funds.
290    * @return A uint specifing the amount of tokens still avaible for the spender.
291    */
292   function allowance(address account, address spender) public view returns (uint remaining) {
293     return allowed[account][spender];
294   }
295 
296   /**
297    * Atomic increment of approved spending
298    *
299    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    *
301    */
302   function addApproval(address spender, uint addedValue) public returns (bool success) {
303       uint oldValue = allowed[msg.sender][spender];
304       allowed[msg.sender][spender] = oldValue.add(addedValue);
305       Approval(msg.sender, spender, allowed[msg.sender][spender]);
306       return true;
307   }
308 
309   /**
310    * Atomic decrement of approved spending.
311    *
312    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
313    */
314   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
315 
316       uint oldVal = allowed[msg.sender][spender];
317 
318       if (subtractedValue > oldVal) {
319           allowed[msg.sender][spender] = 0;
320       } else {
321           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
322       }
323       Approval(msg.sender, spender, allowed[msg.sender][spender]);
324       return true;
325   }
326 
327   /**
328    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
329    */
330   function burnTokens(address account, uint value) internal {
331     balances[account] = balances[account].sub(value);
332     total_supply = total_supply.sub(value);
333     Transfer(account, 0, value);
334     Burned(account, value);
335   }
336 
337   /**
338    * @dev Provides an internal minting function.
339    */
340   function mintInternal(address receiver, uint amount) internal {
341     total_supply = total_supply.add(amount);
342     balances[receiver] = balances[receiver].add(amount);
343     Minted(receiver, amount);
344 
345     // Beware: Address zero may be used for special transactions in a future fork.
346     // This will make the mint transaction appear in EtherScan.io
347     // We can remove this after there is a standardized minting event
348     Transfer(0, receiver, amount);
349   }
350   
351 }
352 
353 /**
354  * Define interface for releasing the token transfer after a successful crowdsale.
355  */
356 contract ReleasableToken is StandardToken, Ownable {
357 
358   /* The finalizer contract that allows lifting the transfer limits on this token */
359   address public releaseAgent;
360 
361   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
362   bool public released = false;
363 
364   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
365   mapping (address => bool) public transferAgents;
366 
367   /**
368    * Set the contract that can call release and make the token transferable.
369    *
370    * Since the owner of this contract is (or should be) the crowdsale,
371    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
372    */
373   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
374     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
375     releaseAgent = addr;
376   }
377 
378   /**
379    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
380    */
381   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
382     transferAgents[addr] = state;
383   }
384 
385   /**
386    * One way function to release the tokens into the wild.
387    *
388    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
389    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
390    */
391   function releaseTokenTransfer() public onlyReleaseAgent {
392     released = true;
393   }
394 
395   /**
396    * Limit token transfer until the crowdsale is over.
397    */
398   modifier canTransfer(address sender) {
399     require(released || transferAgents[sender]);
400     _;
401   }
402 
403   /** The function can be called only before or after the tokens have been released */
404   modifier inReleaseState(bool releaseState) {
405     require(releaseState == released);
406     _;
407   }
408 
409   /** The function can be called only by a whitelisted release agent. */
410   modifier onlyReleaseAgent() {
411     require(msg.sender == releaseAgent);
412     _;
413   }
414 
415   /** We restrict transfer by overriding it */
416   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
417     // Call StandardToken.transfer()
418    return super.transfer(to, value);
419   }
420 
421   /** We restrict transferFrom by overriding it */
422   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
423     // Call StandardToken.transferForm()
424     return super.transferFrom(from, to, value);
425   }
426 
427 }
428 
429 
430 
431 pragma solidity ^0.4.18;
432 
433 /**
434  * First envisioned by Golem and Lunyr projects.
435  * Originally from https://github.com/TokenMarketNet/ico
436  * Modified by https://www.coinfabrik.com/
437  */
438 
439 pragma solidity ^0.4.18;
440 
441 /**
442  * Inspired by Lunyr.
443  * Originally from https://github.com/TokenMarketNet/ico
444  */
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
463   function isUpgradeAgent() public pure returns (bool) {
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
479   * @param from Account to upgrade.
480   * @param value Tokens to upgrade.
481 
482   */
483   function upgradeFrom(address from, uint value) public;
484 
485 }
486 
487 
488 /**
489  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
490  *
491  */
492 contract UpgradeableToken is EIP20Token, Burnable {
493   using SafeMath for uint;
494 
495   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
496   address public upgradeMaster;
497 
498   /** The next contract where the tokens will be migrated. */
499   UpgradeAgent public upgradeAgent;
500 
501   /** How many tokens we have upgraded by now. */
502   uint public totalUpgraded = 0;
503 
504   /**
505    * Upgrade states.
506    *
507    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
508    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
509    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet. This allows changing the upgrade agent while there is time.
510    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
511    *
512    */
513   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
514 
515   /**
516    * Somebody has upgraded some of his tokens.
517    */
518   event Upgrade(address indexed from, address to, uint value);
519 
520   /**
521    * New upgrade agent available.
522    */
523   event UpgradeAgentSet(address agent);
524 
525   /**
526    * Do not allow construction without upgrade master set.
527    */
528   function UpgradeableToken(address master) internal {
529     setUpgradeMaster(master);
530   }
531 
532   /**
533    * Allow the token holder to upgrade some of their tokens to a new contract.
534    */
535   function upgrade(uint value) public {
536     UpgradeState state = getUpgradeState();
537     // Ensure it's not called in a bad state
538     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
539 
540     // Validate input value.
541     require(value != 0);
542 
543     // Upgrade agent reissues the tokens
544     upgradeAgent.upgradeFrom(msg.sender, value);
545     
546     // Take tokens out from circulation
547     burnTokens(msg.sender, value);
548     totalUpgraded = totalUpgraded.add(value);
549 
550     Upgrade(msg.sender, upgradeAgent, value);
551   }
552 
553   /**
554    * Set an upgrade agent that handles the upgrade process
555    */
556   function setUpgradeAgent(address agent) onlyMaster external {
557     // Check whether the token is in a state that we could think of upgrading
558     require(canUpgrade());
559 
560     require(agent != 0x0);
561     // Upgrade has already begun for an agent
562     require(getUpgradeState() != UpgradeState.Upgrading);
563 
564     upgradeAgent = UpgradeAgent(agent);
565 
566     // Bad interface
567     require(upgradeAgent.isUpgradeAgent());
568     // Make sure that token supplies match in source and target
569     require(upgradeAgent.originalSupply() == totalSupply());
570 
571     UpgradeAgentSet(upgradeAgent);
572   }
573 
574   /**
575    * Get the state of the token upgrade.
576    */
577   function getUpgradeState() public view returns(UpgradeState) {
578     if (!canUpgrade()) return UpgradeState.NotAllowed;
579     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
580     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
581     else return UpgradeState.Upgrading;
582   }
583 
584   /**
585    * Change the upgrade master.
586    *
587    * This allows us to set a new owner for the upgrade mechanism.
588    */
589   function changeUpgradeMaster(address new_master) onlyMaster public {
590     setUpgradeMaster(new_master);
591   }
592 
593   /**
594    * Internal upgrade master setter.
595    */
596   function setUpgradeMaster(address new_master) private {
597     require(new_master != 0x0);
598     upgradeMaster = new_master;
599   }
600 
601   /**
602    * Child contract can override to provide the condition in which the upgrade can begin.
603    */
604   function canUpgrade() public view returns(bool) {
605      return true;
606   }
607 
608 
609   modifier onlyMaster() {
610     require(msg.sender == upgradeMaster);
611     _;
612   }
613 }
614 
615 pragma solidity ^0.4.18;
616 
617 /**
618  * Authored by https://www.coinfabrik.com/
619  */
620 
621 
622 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
623 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
624 // Of course, this contract imposes support costs upon whoever is the lost and found master.
625 contract LostAndFoundToken {
626   /**
627    * @return Address of the account that handles movements.
628    */
629   function getLostAndFoundMaster() internal view returns (address);
630 
631   /**
632    * @param agent Address that will be able to move tokens with transferFrom
633    * @param tokens Amount of tokens approved for transfer
634    * @param token_contract Contract of the token
635    */
636   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
637     require(msg.sender == getLostAndFoundMaster());
638     // We use approve instead of transfer to minimize the possibility of the lost and found master
639     //  getting them stuck in another address by accident.
640     token_contract.approve(agent, tokens);
641   }
642 }
643 pragma solidity ^0.4.18;
644 
645 /**
646  * Originally from https://github.com/TokenMarketNet/ico
647  * Modified by https://www.coinfabrik.com/
648  */
649 
650 
651 /**
652  * A public interface to increase the supply of a token.
653  *
654  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
655  * Only mint agents, usually contracts whitelisted by the owner, can mint new tokens.
656  *
657  */
658 contract MintableToken is Mintable, Ownable {
659 
660   using SafeMath for uint;
661 
662   bool public mintingFinished = false;
663 
664   /** List of agents that are allowed to create new tokens */
665   mapping (address => bool) public mintAgents;
666 
667   event MintingAgentChanged(address addr, bool state);
668 
669 
670   function MintableToken(uint initialSupply, address multisig, bool mintable) internal {
671     require(multisig != address(0));
672     // Cannot create a token without supply and no minting
673     require(mintable || initialSupply != 0);
674     // Create initially all balance on the team multisig
675     if (initialSupply > 0)
676       mintInternal(multisig, initialSupply);
677     // No more new supply allowed after the token creation
678     mintingFinished = !mintable;
679   }
680 
681   /**
682    * Create new tokens and allocate them to an address.
683    *
684    * Only callable by a mint agent (e.g. crowdsale contract).
685    */
686   function mint(address receiver, uint amount) onlyMintAgent canMint public {
687     mintInternal(receiver, amount);
688   }
689 
690   /**
691    * Owner can allow a crowdsale contract to mint new tokens.
692    */
693   function setMintAgent(address addr, bool state) onlyOwner canMint public {
694     mintAgents[addr] = state;
695     MintingAgentChanged(addr, state);
696   }
697 
698   modifier onlyMintAgent() {
699     // Only mint agents are allowed to mint new tokens
700     require(mintAgents[msg.sender]);
701     _;
702   }
703 
704   /** Make sure we are not done yet. */
705   modifier canMint() {
706     require(!mintingFinished);
707     _;
708   }
709 }
710 
711 /**
712  * A crowdsale token.
713  *
714  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
715  *
716  * - The token transfer() is disabled until the crowdsale is over
717  * - The token contract gives an opt-in upgrade path to a new contract
718  * - The same token can be part of several crowdsales through the approve() mechanism
719  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
720  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
721  *
722  */
723 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
724 
725   string public name = "Ubanx";
726 
727   string public symbol = "BANX";
728 
729   uint8 public decimals;
730 
731   address public lost_and_found_master;
732 
733   /**
734    * Construct the token.
735    *
736    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
737    *
738    * @param initial_supply How many tokens we start with.
739    * @param token_decimals Number of decimal places.
740    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
741    * @param mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
742    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
743    */
744   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, bool mintable, address token_retriever) public
745   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, mintable) {
746     require(token_retriever != address(0));
747     decimals = token_decimals;
748     lost_and_found_master = token_retriever;
749   }
750 
751   /**
752    * When token is released to be transferable, prohibit new token creation.
753    */
754   function releaseTokenTransfer() public onlyReleaseAgent {
755     mintingFinished = true;
756     super.releaseTokenTransfer();
757   }
758 
759   /**
760    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
761    */
762   function canUpgrade() public view returns(bool) {
763     return released && super.canUpgrade();
764   }
765 
766   function getLostAndFoundMaster() internal view returns(address) {
767     return lost_and_found_master;
768   }
769 
770   /**
771    * We allow anyone to burn their tokens if they wish to do so.
772    * We want to use this in the finalize function of the crowdsale in particular.
773    */
774   function burn(uint amount) public {
775     burnTokens(msg.sender, amount);
776   }
777 
778 }
779 
780 /**
781  * Abstract base contract for token sales.
782  *
783  * Handles
784  * - start and end dates
785  * - accepting investments
786  * - various statistics during the crowdfund
787  * - different investment policies (require server side customer id, allow only whitelisted addresses)
788  *
789  */
790 contract GenericCrowdsale is Haltable {
791 
792   using SafeMath for uint;
793 
794   /* The token we are selling */
795   CrowdsaleToken public token;
796 
797   /* ether will be transferred to this address */
798   address public multisigWallet;
799 
800   /* a contract may be deployed to function as a gateway for investments */
801   address public investmentGateway;
802 
803   /* the starting time of the crowdsale */
804   uint public startsAt;
805 
806   /* the ending time of the crowdsale */
807   uint public endsAt;
808 
809   /* the number of tokens already sold through this contract*/
810   uint public tokensSold = 0;
811 
812   /* How many wei of funding we have raised */
813   uint public weiRaised = 0;
814 
815   /* How many distinct addresses have invested */
816   uint public investorCount = 0;
817 
818   /* Has this crowdsale been finalized */
819   bool public finalized = false;
820 
821   /* Do we need to have a unique contributor id for each customer */
822   bool public requireCustomerId = false;
823 
824   /**
825    * Do we verify that contributor has been cleared on the server side (accredited investors only).
826    * This method was first used in the FirstBlood crowdsale to ensure all contributors had accepted terms of sale (on the web).
827    */
828   bool public requiredSignedAddress = false;
829 
830   /** Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
831   address public signerAddress;
832 
833   /** How many ETH each address has invested in this crowdsale */
834   mapping (address => uint) public investedAmountOf;
835 
836   /** How many tokens this crowdsale has credited for each investor address */
837   mapping (address => uint) public tokenAmountOf;
838 
839   /** Addresses that are allowed to invest even before ICO officially opens. For testing, for ICO partners, etc. */
840   mapping (address => bool) public earlyParticipantWhitelist;
841 
842   /** State machine
843    *
844    * - Prefunding: We have not reached the starting time yet
845    * - Funding: Active crowdsale
846    * - Success: Crowdsale ended
847    * - Finalized: The finalize function has been called and succesfully executed
848    */
849   enum State{Unknown, PreFunding, Funding, Success, Finalized}
850 
851 
852   // A new investment was made
853   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
854 
855   // The rules about what kind of investments we accept were changed
856   event InvestmentPolicyChanged(bool requireCId, bool requireSignedAddress, address signer);
857 
858   // Address early participation whitelist status changed
859   event Whitelisted(address addr, bool status);
860 
861   // Crowdsale's finalize function has been called
862   event Finalized();
863 
864 
865   /**
866    * Basic constructor for the crowdsale.
867    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
868    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
869    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
870    */
871   function GenericCrowdsale(address team_multisig, uint start, uint end) internal {
872     setMultisig(team_multisig);
873 
874     // Don't mess the dates
875     require(start != 0 && end != 0);
876     require(block.timestamp < start && start < end);
877     startsAt = start;
878     endsAt = end;
879   }
880 
881   /**
882    * Default fallback behaviour is to call buy.
883    * Ideally, no contract calls this crowdsale without supporting ERC20.
884    * However, some sort of refunding function may be desired to cover such situations.
885    */
886   function() payable public {
887     buy();
888   }
889 
890   /**
891    * Make an investment.
892    *
893    * The crowdsale must be running for one to invest.
894    * We must have not pressed the emergency brake.
895    *
896    * @param receiver The Ethereum address who receives the tokens
897    * @param customerId (optional) UUID v4 to track the successful payments on the server side
898    *
899    */
900   function investInternal(address receiver, uint128 customerId) stopInEmergency notFinished private {
901     // Determine if it's a good time to accept investment from this participant
902     if (getState() == State.PreFunding) {
903       // Are we whitelisted for early deposit
904       require(earlyParticipantWhitelist[msg.sender]);
905     }
906 
907     uint weiAmount;
908     uint tokenAmount;
909     (weiAmount, tokenAmount) = calculateTokenAmount(msg.value, receiver);
910     // Sanity check against bad implementation.
911     assert(weiAmount <= msg.value);
912     
913     // Dust transaction if no tokens can be given
914     require(tokenAmount != 0);
915 
916     if (investedAmountOf[receiver] == 0) {
917       // A new investor
918       investorCount++;
919     }
920     updateInvestorFunds(tokenAmount, weiAmount, receiver, customerId);
921 
922     // Pocket the money
923     multisigWallet.transfer(weiAmount);
924 
925     // Return excess of money
926     returnExcedent(msg.value.sub(weiAmount), msg.sender);
927   }
928 
929   /**
930    * Preallocate tokens for the early investors.
931    *
932    * Preallocated tokens have been sold before the actual crowdsale opens.
933    * This function mints the tokens and moves the crowdsale needle.
934    *
935    * No money is exchanged, as the crowdsale team already have received the payment.
936    *
937    * @param receiver Account that receives the tokens.
938    * @param fullTokens tokens as full tokens - decimal places are added internally.
939    * @param weiPrice Price of a single indivisible token in wei.
940    *
941    */
942   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner notFinished {
943     require(receiver != address(0));
944     uint tokenAmount = fullTokens.mul(10**uint(token.decimals()));
945     require(tokenAmount != 0);
946     uint weiAmount = weiPrice.mul(tokenAmount); // This can also be 0, in which case we give out tokens for free
947     updateInvestorFunds(tokenAmount, weiAmount, receiver , 0);
948   }
949 
950   /**
951    * Private function to update accounting in the crowdsale.
952    */
953   function updateInvestorFunds(uint tokenAmount, uint weiAmount, address receiver, uint128 customerId) private {
954     // Update investor
955     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
956     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
957 
958     // Update totals
959     weiRaised = weiRaised.add(weiAmount);
960     tokensSold = tokensSold.add(tokenAmount);
961 
962     assignTokens(receiver, tokenAmount);
963     // Tell us that the investment was completed successfully
964     Invested(receiver, weiAmount, tokenAmount, customerId);
965   }
966 
967   /**
968    * Investing function that recognizes the receiver and verifies he is allowed to invest.
969    *
970    * @param customerId UUIDv4 that identifies this contributor
971    */
972   function buyOnBehalfWithSignedAddress(address receiver, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable validCustomerId(customerId) {
973     bytes32 hash = sha256(receiver);
974     require(ecrecover(hash, v, r, s) == signerAddress);
975     investInternal(receiver, customerId);
976   }
977 
978   /**
979    * Investing function that recognizes the receiver.
980    * 
981    * @param customerId UUIDv4 that identifies this contributor
982    */
983   function buyOnBehalfWithCustomerId(address receiver, uint128 customerId) public payable validCustomerId(customerId) unsignedBuyAllowed {
984     investInternal(receiver, customerId);
985   }
986 
987   /**
988    * Buys tokens on behalf of an address.
989    *
990    * Pay for funding, get invested tokens back in the receiver address.
991    */
992   function buyOnBehalf(address receiver) public payable {
993     require(!requiredSignedAddress || msg.sender == investmentGateway);
994     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
995     investInternal(receiver, 0);
996   }
997 
998   function setInvestmentGateway(address gateway) public onlyOwner {
999     require(gateway != address(0));
1000     investmentGateway = gateway;
1001   }
1002 
1003   /**
1004    * Investing function that recognizes the payer and verifies he is allowed to invest.
1005    *
1006    * @param customerId UUIDv4 that identifies this contributor
1007    */
1008   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1009     buyOnBehalfWithSignedAddress(msg.sender, customerId, v, r, s);
1010   }
1011 
1012 
1013   /**
1014    * Investing function that recognizes the payer.
1015    * 
1016    * @param customerId UUIDv4 that identifies this contributor
1017    */
1018   function buyWithCustomerId(uint128 customerId) public payable {
1019     buyOnBehalfWithCustomerId(msg.sender, customerId);
1020   }
1021 
1022   /**
1023    * The basic entry point to participate in the crowdsale process.
1024    *
1025    * Pay for funding, get invested tokens back in the sender address.
1026    */
1027   function buy() public payable {
1028     buyOnBehalf(msg.sender);
1029   }
1030 
1031   /**
1032    * Finalize a succcesful crowdsale.
1033    *
1034    * The owner can trigger post-crowdsale actions, like releasing the tokens.
1035    * Note that by default tokens are not in a released state.
1036    */
1037   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1038     finalized = true;
1039     Finalized();
1040   }
1041 
1042   /**
1043    * Set policy do we need to have server-side customer ids for the investments.
1044    *
1045    */
1046   function setRequireCustomerId(bool value) public onlyOwner {
1047     requireCustomerId = value;
1048     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1049   }
1050 
1051   /**
1052    * Set policy if all investors must be cleared on the server side first.
1053    *
1054    * This is e.g. for the accredited investor clearing.
1055    *
1056    */
1057   function setRequireSignedAddress(bool value, address signer) public onlyOwner {
1058     requiredSignedAddress = value;
1059     signerAddress = signer;
1060     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1061   }
1062 
1063   /**
1064    * Allow addresses to do early participation.
1065    */
1066   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
1067     earlyParticipantWhitelist[addr] = status;
1068     Whitelisted(addr, status);
1069   }
1070 
1071   /**
1072    * Internal setter for the multisig wallet
1073    */
1074   function setMultisig(address addr) internal {
1075     require(addr != 0);
1076     multisigWallet = addr;
1077   }
1078 
1079   /**
1080    * Crowdfund state machine management.
1081    *
1082    * This function has the timed transition builtin.
1083    * So there is no chance of the variable being stale.
1084    */
1085   function getState() public view returns (State) {
1086     if (finalized) return State.Finalized;
1087     else if (block.timestamp < startsAt) return State.PreFunding;
1088     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1089     else return State.Success;
1090   }
1091 
1092   /** Internal functions that exist to provide inversion of control should they be overriden */
1093 
1094   /** Interface for the concrete instance to interact with the token contract in a customizable way */
1095   function assignTokens(address receiver, uint tokenAmount) internal;
1096 
1097   /**
1098    *  Determine if the goal was already reached in the current crowdsale
1099    */
1100   function isCrowdsaleFull() internal view returns (bool full);
1101 
1102   /**
1103    * Returns any excess wei received
1104    * 
1105    * This function can be overriden to provide a different refunding method.
1106    */
1107   function returnExcedent(uint excedent, address receiver) internal {
1108     if (excedent > 0) {
1109       receiver.transfer(excedent);
1110     }
1111   }
1112 
1113   /** 
1114    *  Calculate the amount of tokens that corresponds to the received amount.
1115    *  The wei amount is returned too in case not all of it can be invested.
1116    *
1117    *  Note: When there's an excedent due to rounding error, it should be returned to allow refunding.
1118    *  This is worked around in the current design using an appropriate amount of decimals in the FractionalERC20 standard.
1119    *  The workaround is good enough for most use cases, hence the simplified function signature.
1120    *  @return weiAllowed The amount of wei accepted in this transaction.
1121    *  @return tokenAmount The tokens that are assigned to the receiver in this transaction.
1122    */
1123   function calculateTokenAmount(uint weiAmount, address receiver) internal view returns (uint weiAllowed, uint tokenAmount);
1124 
1125   //
1126   // Modifiers
1127   //
1128 
1129   modifier inState(State state) {
1130     require(getState() == state);
1131     _;
1132   }
1133 
1134   modifier unsignedBuyAllowed() {
1135     require(!requiredSignedAddress);
1136     _;
1137   }
1138 
1139   /** Modifier allowing execution only if the crowdsale is currently running.  */
1140   modifier notFinished() {
1141     State current_state = getState();
1142     require(current_state == State.PreFunding || current_state == State.Funding);
1143     _;
1144   }
1145 
1146   modifier validCustomerId(uint128 customerId) {
1147     require(customerId != 0);  // UUIDv4 sanity check
1148     _;
1149   }
1150 
1151 }
1152 /**
1153  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1154  *
1155  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1156  *
1157  * Heavily modified by https://www.coinfabrik.com/
1158  */
1159 
1160 pragma solidity ^0.4.18;
1161 
1162 
1163 /// @dev Tranche based pricing.
1164 ///      Implementing "first price" tranches, meaning, that if a buyer's order is
1165 ///      covering more than one tranche, the price of the lowest tranche will apply
1166 ///      to the whole order.
1167 contract TokenTranchePricing {
1168 
1169   using SafeMath for uint;
1170 
1171   /**
1172    * Define pricing schedule using tranches.
1173    */
1174   struct Tranche {
1175       // Amount in tokens when this tranche becomes inactive
1176       uint amount;
1177       // Time interval [start, end)
1178       // Starting timestamp (included in the interval)
1179       uint start;
1180       // Ending timestamp (excluded from the interval)
1181       uint end;
1182       // How many tokens per asset unit you will get while this tranche is active
1183       uint price;
1184   }
1185   // We define offsets and size for the deserialization of ordered tuples in raw arrays
1186   uint private constant amount_offset = 0;
1187   uint private constant start_offset = 1;
1188   uint private constant end_offset = 2;
1189   uint private constant price_offset = 3;
1190   uint private constant tranche_size = 4;
1191 
1192   Tranche[] public tranches;
1193 
1194   function getTranchesLength() public view returns (uint) {
1195     return tranches.length;
1196   }
1197 
1198   /// @dev Construction, creating a list of tranches
1199   /// @param init_tranches Raw array of ordered tuples: (end amount, start timestamp, end timestamp, price)
1200   function TokenTranchePricing(uint[] init_tranches) public {
1201     // Need to have tuples, length check
1202     require(init_tranches.length % tranche_size == 0);
1203     // A tranche with amount zero can never be selected and is therefore useless.
1204     // This check and the one inside the loop ensure no tranche can have an amount equal to zero.
1205     require(init_tranches[amount_offset] > 0);
1206 
1207     uint input_tranches_length = init_tranches.length.div(tranche_size);
1208     Tranche memory last_tranche;
1209     for (uint i = 0; i < input_tranches_length; i++) {
1210       uint tranche_offset = i.mul(tranche_size);
1211       uint amount = init_tranches[tranche_offset.add(amount_offset)];
1212       uint start = init_tranches[tranche_offset.add(start_offset)];
1213       uint end = init_tranches[tranche_offset.add(end_offset)];
1214       uint price = init_tranches[tranche_offset.add(price_offset)];
1215       // No invalid steps
1216       require(block.timestamp < start && start < end);
1217       // Bail out when entering unnecessary tranches
1218       // This is preferably checked before deploying contract into any blockchain.
1219       require(i == 0 || (end >= last_tranche.end && amount > last_tranche.amount) ||
1220               (end > last_tranche.end && amount >= last_tranche.amount));
1221 
1222       last_tranche = Tranche(amount, start, end, price);
1223       tranches.push(last_tranche);
1224     }
1225   }
1226 
1227   /// @dev Get the current tranche or bail out if there is no tranche defined for the current block.
1228   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1229   /// @return Returns the struct representing the current tranche
1230   function getCurrentTranche(uint tokensSold) private view returns (Tranche storage) {
1231     for (uint i = 0; i < tranches.length; i++) {
1232       if (tranches[i].start <= block.timestamp && block.timestamp < tranches[i].end && tokensSold < tranches[i].amount) {
1233         return tranches[i];
1234       }
1235     }
1236     // No tranche is currently active
1237     revert();
1238   }
1239 
1240   /// @dev Get the current price. May revert if there is no tranche currently active.
1241   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1242   /// @return The current price
1243   function getCurrentPrice(uint tokensSold) internal view returns (uint result) {
1244     return getCurrentTranche(tokensSold).price;
1245   }
1246 
1247 }
1248 pragma solidity ^0.4.18;
1249 
1250 // Simple deployment information store inside contract storage.
1251 contract DeploymentInfo {
1252   uint private deployed_on;
1253 
1254   function DeploymentInfo() public {
1255     deployed_on = block.number;
1256   }
1257 
1258 
1259   function getDeploymentBlock() public view returns (uint) {
1260     return deployed_on;
1261   }
1262 }
1263 
1264 
1265 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1266 contract Crowdsale is GenericCrowdsale, LostAndFoundToken, TokenTranchePricing, DeploymentInfo {
1267   //initial supply in 400k, sold tokens from initial minting
1268   uint8 private constant token_decimals = 18;
1269   uint private constant token_initial_supply = 4 * (10 ** 8) * (10 ** uint(token_decimals));
1270   bool private constant token_mintable = true;
1271   uint private constant sellable_tokens = 6 * (10 ** 8) * (10 ** uint(token_decimals));
1272   
1273   //Sets minimum value that can be bought
1274   uint public minimum_buy_value = 18 * 1 ether / 1000;
1275   //Eth price multiplied by 1000;
1276   uint public milieurs_per_eth;
1277 
1278 
1279   /**
1280    * Constructor for the crowdsale.
1281    * Normally, the token contract is created here. That way, the minting, release and transfer agents can be set here too.
1282    *
1283    * @param eth_price_in_eurs Ether price in EUR.
1284    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
1285    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
1286    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
1287    * @param token_retriever Address that will handle tokens accidentally sent to the token contract. See the LostAndFoundToken and CrowdsaleToken contracts for further details.
1288    * @param init_tranches List of serialized tranches. See config.js and TokenTranchePricing for further details.
1289    */
1290   function Crowdsale(uint eth_price_in_eurs, address team_multisig, uint start, uint end, address token_retriever, uint[] init_tranches)
1291   GenericCrowdsale(team_multisig, start, end) TokenTranchePricing(init_tranches) public {
1292     require(end == tranches[tranches.length.sub(1)].end);
1293     // Testing values
1294     token = new CrowdsaleToken(token_initial_supply, token_decimals, team_multisig, token_mintable, token_retriever);
1295     
1296     //Set eth price in EUR (multiplied by one thousand)
1297     updateEursPerEth(eth_price_in_eurs);
1298 
1299     // Set permissions to mint, transfer and release
1300     token.setMintAgent(address(this), true);
1301     token.setTransferAgent(address(this), true);
1302     token.setReleaseAgent(address(this));
1303 
1304     // Allow the multisig to transfer tokens
1305     token.setTransferAgent(team_multisig, true);
1306 
1307     // Tokens to be sold through this contract
1308     token.mint(address(this), sellable_tokens);
1309     // We don't need to mint anymore during the lifetime of the contract.
1310     token.setMintAgent(address(this), false);
1311   }
1312 
1313   //Token assignation through transfer
1314   function assignTokens(address receiver, uint tokenAmount) internal {
1315     token.transfer(receiver, tokenAmount);
1316   }
1317 
1318   //Token amount calculation
1319   function calculateTokenAmount(uint weiAmount, address) internal view returns (uint weiAllowed, uint tokenAmount) {
1320     uint tokensPerEth = getCurrentPrice(tokensSold).mul(milieurs_per_eth).div(1000);
1321     uint maxWeiAllowed = sellable_tokens.sub(tokensSold).mul(1 ether).div(tokensPerEth);
1322     weiAllowed = maxWeiAllowed.min256(weiAmount);
1323 
1324     if (weiAmount < maxWeiAllowed) {
1325       //Divided by 1000 because eth eth_price_in_eurs is multiplied by 1000
1326       tokenAmount = tokensPerEth.mul(weiAmount).div(1 ether);
1327     }
1328     // With this case we let the crowdsale end even when there are rounding errors due to the tokens to wei ratio
1329     else {
1330       tokenAmount = sellable_tokens.sub(tokensSold);
1331     }
1332   }
1333 
1334   // Implements the criterion of the funding state
1335   function isCrowdsaleFull() internal view returns (bool) {
1336     return tokensSold >= sellable_tokens;
1337   }
1338 
1339   /**
1340    * This function decides who handles lost tokens.
1341    * Do note that this function is NOT meant to be used in a token refund mechanism.
1342    * Its sole purpose is determining who can move around ERC20 tokens accidentally sent to this contract.
1343    */
1344   function getLostAndFoundMaster() internal view returns (address) {
1345     return owner;
1346   }
1347 
1348   /**
1349    * @dev Sets new minimum buy value for a transaction. Only the owner can call it.
1350    */
1351   function setMinimumBuyValue(uint newValue) public onlyOwner {
1352     minimum_buy_value = newValue;
1353   }
1354 
1355   /**
1356    * Investing function that recognizes the payer and verifies that he is allowed to invest.
1357    *
1358    * Overwritten to add configurable minimum value
1359    *
1360    * @param customerId UUIDv4 that identifies this contributor
1361    */
1362   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable investmentIsBigEnough(msg.sender) validCustomerId(customerId) {
1363     super.buyWithSignedAddress(customerId, v, r, s);
1364   }
1365 
1366 
1367   /**
1368    * Investing function that recognizes the payer.
1369    * 
1370    * @param customerId UUIDv4 that identifies this contributor
1371    */
1372   function buyWithCustomerId(uint128 customerId) public payable investmentIsBigEnough(msg.sender) validCustomerId(customerId) unsignedBuyAllowed {
1373     super.buyWithCustomerId(customerId);
1374   }
1375 
1376   /**
1377    * The basic entry point to participate in the crowdsale process.
1378    *
1379    * Pay for funding, get invested tokens back in the sender address.
1380    */
1381   function buy() public payable investmentIsBigEnough(msg.sender) unsignedBuyAllowed {
1382     super.buy();
1383   }
1384 
1385   // Extended to transfer half of the unused funds to the team's multisig and release the token
1386   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1387     token.releaseTokenTransfer();
1388     uint unsoldTokens = token.balanceOf(address(this));
1389     token.burn(unsoldTokens.div(2));
1390     token.transfer(multisigWallet, unsoldTokens - unsoldTokens.div(2));
1391     super.finalize();
1392   }
1393 
1394   //Change the the starting time in order to end the presale period early if needed.
1395   function setStartingTime(uint startingTime) public onlyOwner inState(State.PreFunding) {
1396     require(startingTime > block.timestamp && startingTime < endsAt);
1397     startsAt = startingTime;
1398   }
1399 
1400   //Change the the ending time in order to be able to finalize the crowdsale if needed.
1401   function setEndingTime(uint endingTime) public onlyOwner notFinished {
1402     require(endingTime > block.timestamp && endingTime > startsAt);
1403     endsAt = endingTime;
1404   }
1405 
1406   /**
1407    * Override to reject calls unless the crowdsale is finalized or
1408    *  the token contract is not the one corresponding to this crowdsale
1409    */
1410   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
1411     // Either the state is finalized or the token_contract is not this crowdsale token
1412     require(address(token_contract) != address(token) || getState() == State.Finalized);
1413     super.enableLostAndFound(agent, tokens, token_contract);
1414   }
1415 
1416   function updateEursPerEth (uint milieurs_amount) public onlyOwner {
1417     require(milieurs_amount >= 100);
1418     milieurs_per_eth = milieurs_amount;
1419   }
1420 
1421 
1422   modifier investmentIsBigEnough(address agent) {
1423     require(msg.value.add(investedAmountOf[agent]) >= minimum_buy_value);
1424     _;
1425   }
1426 }