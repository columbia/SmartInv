1 pragma solidity ^0.4.15;
2 
3 /**
4  * Authored by https://www.coinfabrik.com/
5  * Github repository: https://github.com/CoinFabrik/ico/tree/world-bit
6  * Source code flattened with a not yet publically available script.
7  */
8 
9 pragma solidity ^0.4.15;
10 
11 /**
12  * Originally from https://github.com/TokenMarketNet/ico
13  * Modified by https://www.coinfabrik.com/
14  */
15 
16 pragma solidity ^0.4.15;
17 
18 /**
19  * Envisioned in FirstBlood ICO contract.
20  * Originally from https://github.com/TokenMarketNet/ico
21  * Modified by https://www.coinfabrik.com/
22  */
23 
24 pragma solidity ^0.4.15;
25 
26 /**
27  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
28  * Modified by https://www.coinfabrik.com/
29  */
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control 
34  * functions, this simplifies the implementation of "user permissions". 
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   /** 
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() internal {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner. 
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to. 
61    */
62   function transferOwnership(address newOwner) onlyOwner public {
63     require(newOwner != address(0));
64     owner = newOwner;
65   }
66 
67 }
68 
69 /**
70  * Abstract contract that allows children to implement an
71  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
72  *
73  */
74 contract Haltable is Ownable {
75   bool public halted;
76 
77   event Halted(bool halted);
78 
79   modifier stopInEmergency {
80     require(!halted);
81     _;
82   }
83 
84   modifier onlyInEmergency {
85     require(halted);
86     _;
87   }
88 
89   // called by the owner on emergency, triggers stopped state
90   function halt() external onlyOwner {
91     halted = true;
92     Halted(true);
93   }
94 
95   // called by the owner on end of emergency, returns to normal state
96   function unhalt() external onlyOwner onlyInEmergency {
97     halted = false;
98     Halted(false);
99   }
100 
101 }
102 pragma solidity ^0.4.15;
103 
104 /**
105  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
106  * Modified by https://www.coinfabrik.com/
107  */
108 
109 /**
110  * Math operations with safety checks
111  */
112 library SafeMath {
113   function mul(uint a, uint b) internal constant returns (uint) {
114     uint c = a * b;
115     assert(a == 0 || c / a == b);
116     return c;
117   }
118 
119   function div(uint a, uint b) internal constant returns (uint) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   function sub(uint a, uint b) internal constant returns (uint) {
127     assert(b <= a);
128     return a - b;
129   }
130 
131   function add(uint a, uint b) internal constant returns (uint) {
132     uint c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 
137   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
138     return a >= b ? a : b;
139   }
140 
141   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
142     return a < b ? a : b;
143   }
144 
145   function max256(uint a, uint b) internal constant returns (uint) {
146     return a >= b ? a : b;
147   }
148 
149   function min256(uint a, uint b) internal constant returns (uint) {
150     return a < b ? a : b;
151   }
152 }
153 
154 pragma solidity ^0.4.15;
155 
156 /**
157  * Originally from https://github.com/TokenMarketNet/ico
158  * Modified by https://www.coinfabrik.com/
159  */
160 
161 pragma solidity ^0.4.15;
162 
163 /**
164  * Originally from https://github.com/TokenMarketNet/ico
165  * Modified by https://www.coinfabrik.com/
166  */
167 
168 pragma solidity ^0.4.15;
169 
170 /**
171  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
172  * Modified by https://www.coinfabrik.com/
173  */
174 
175 pragma solidity ^0.4.15;
176 
177 /**
178  * Interface for the standard token.
179  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
180  */
181 contract EIP20Token {
182 
183   function totalSupply() public constant returns (uint256);
184   function balanceOf(address who) public constant returns (uint256);
185   function transfer(address to, uint256 value) public returns (bool success);
186   function transferFrom(address from, address to, uint256 value) public returns (bool success);
187   function approve(address spender, uint256 value) public returns (bool success);
188   function allowance(address owner, address spender) public constant returns (uint256 remaining);
189   event Transfer(address indexed from, address indexed to, uint256 value);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 
192   /**
193   ** Optional functions
194   *
195   function name() public constant returns (string name);
196   function symbol() public constant returns (string symbol);
197   function decimals() public constant returns (uint8 decimals);
198   *
199   **/
200 
201 }
202 pragma solidity ^0.4.15;
203 
204 // Interface for burning tokens
205 contract Burnable {
206   // @dev Destroys tokens for an account
207   // @param account Account whose tokens are destroyed
208   // @param value Amount of tokens to destroy
209   function burnTokens(address account, uint value) internal;
210   event Burned(address account, uint value);
211 }
212 pragma solidity ^0.4.15;
213 
214 /**
215  * Authored by https://www.coinfabrik.com/
216  */
217 
218 
219 /**
220  * Internal interface for the minting of tokens.
221  */
222 contract Mintable {
223 
224   /**
225    * @dev Mints tokens for an account
226    * This function should emit the Minted event.
227    */
228   function mintInternal(address receiver, uint amount) internal;
229 
230   /** Token supply got increased and a new owner received these tokens */
231   event Minted(address receiver, uint amount);
232 }
233 
234 /**
235  * @title Standard token
236  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
237  */
238 contract StandardToken is EIP20Token, Burnable, Mintable {
239   using SafeMath for uint;
240 
241   uint private total_supply;
242   mapping(address => uint) private balances;
243   mapping(address => mapping (address => uint)) private allowed;
244 
245 
246   function totalSupply() public constant returns (uint) {
247     return total_supply;
248   }
249 
250   /**
251    * @dev transfer token for a specified address
252    * @param to The address to transfer to.
253    * @param value The amount to be transferred.
254    */
255   function transfer(address to, uint value) public returns (bool success) {
256     balances[msg.sender] = balances[msg.sender].sub(value);
257     balances[to] = balances[to].add(value);
258     Transfer(msg.sender, to, value);
259     return true;
260   }
261 
262   /**
263    * @dev Gets the balance of the specified address.
264    * @param account The address whose balance is to be queried.
265    * @return An uint representing the amount owned by the passed address.
266    */
267   function balanceOf(address account) public constant returns (uint balance) {
268     return balances[account];
269   }
270 
271   /**
272    * @dev Transfer tokens from one address to another
273    * @param from address The address which you want to send tokens from
274    * @param to address The address which you want to transfer to
275    * @param value uint the amout of tokens to be transfered
276    */
277   function transferFrom(address from, address to, uint value) public returns (bool success) {
278     uint allowance = allowed[from][msg.sender];
279 
280     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
281     // require(value <= allowance);
282     // SafeMath uses assert instead of require though, beware when using an analysis tool
283 
284     balances[from] = balances[from].sub(value);
285     balances[to] = balances[to].add(value);
286     allowed[from][msg.sender] = allowance.sub(value);
287     Transfer(from, to, value);
288     return true;
289   }
290 
291   /**
292    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
293    * @param spender The address which will spend the funds.
294    * @param value The amount of tokens to be spent.
295    */
296   function approve(address spender, uint value) public returns (bool success) {
297 
298     // To change the approve amount you first have to reduce the addresses'
299     //  allowance to zero by calling `approve(spender, 0)` if it is not
300     //  already 0 to mitigate the race condition described here:
301     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302     require (value == 0 || allowed[msg.sender][spender] == 0);
303 
304     allowed[msg.sender][spender] = value;
305     Approval(msg.sender, spender, value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens than an owner allowed to a spender.
311    * @param account address The address which owns the funds.
312    * @param spender address The address which will spend the funds.
313    * @return A uint specifing the amount of tokens still avaible for the spender.
314    */
315   function allowance(address account, address spender) public constant returns (uint remaining) {
316     return allowed[account][spender];
317   }
318 
319   /**
320    * Atomic increment of approved spending
321    *
322    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323    *
324    */
325   function addApproval(address spender, uint addedValue) public returns (bool success) {
326       uint oldValue = allowed[msg.sender][spender];
327       allowed[msg.sender][spender] = oldValue.add(addedValue);
328       Approval(msg.sender, spender, allowed[msg.sender][spender]);
329       return true;
330   }
331 
332   /**
333    * Atomic decrement of approved spending.
334    *
335    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
336    */
337   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
338 
339       uint oldVal = allowed[msg.sender][spender];
340 
341       if (subtractedValue > oldVal) {
342           allowed[msg.sender][spender] = 0;
343       } else {
344           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
345       }
346       Approval(msg.sender, spender, allowed[msg.sender][spender]);
347       return true;
348   }
349 
350   /**
351    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
352    */
353   function burnTokens(address account, uint value) internal {
354     balances[account] = balances[account].sub(value);
355     total_supply = total_supply.sub(value);
356     Transfer(account, 0, value);
357     Burned(account, value);
358   }
359 
360   /**
361    * @dev Provides an internal minting function.
362    */
363   function mintInternal(address receiver, uint amount) internal {
364     total_supply = total_supply.add(amount);
365     balances[receiver] = balances[receiver].add(amount);
366     Minted(receiver, amount);
367 
368     // Beware: Address zero may be used for special transactions in a future fork.
369     // This will make the mint transaction appear in EtherScan.io
370     // We can remove this after there is a standardized minting event
371     Transfer(0, receiver, amount);
372   }
373   
374 }
375 
376 /**
377  * Define interface for releasing the token transfer after a successful crowdsale.
378  */
379 contract ReleasableToken is StandardToken, Ownable {
380 
381   /* The finalizer contract that allows lifting the transfer limits on this token */
382   address public releaseAgent;
383 
384   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
385   bool public released = false;
386 
387   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
388   mapping (address => bool) public transferAgents;
389 
390   /**
391    * Set the contract that can call release and make the token transferable.
392    *
393    * Since the owner of this contract is (or should be) the crowdsale,
394    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
395    */
396   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
397     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
398     releaseAgent = addr;
399   }
400 
401   /**
402    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
403    */
404   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
405     transferAgents[addr] = state;
406   }
407 
408   /**
409    * One way function to release the tokens into the wild.
410    *
411    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
412    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
413    */
414   function releaseTokenTransfer() public onlyReleaseAgent {
415     released = true;
416   }
417 
418   /**
419    * Limit token transfer until the crowdsale is over.
420    */
421   modifier canTransfer(address sender) {
422     require(released || transferAgents[sender]);
423     _;
424   }
425 
426   /** The function can be called only before or after the tokens have been released */
427   modifier inReleaseState(bool releaseState) {
428     require(releaseState == released);
429     _;
430   }
431 
432   /** The function can be called only by a whitelisted release agent. */
433   modifier onlyReleaseAgent() {
434     require(msg.sender == releaseAgent);
435     _;
436   }
437 
438   /** We restrict transfer by overriding it */
439   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
440     // Call StandardToken.transfer()
441    return super.transfer(to, value);
442   }
443 
444   /** We restrict transferFrom by overriding it */
445   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
446     // Call StandardToken.transferForm()
447     return super.transferFrom(from, to, value);
448   }
449 
450 }
451 
452 
453 
454 pragma solidity ^0.4.15;
455 
456 /**
457  * First envisioned by Golem and Lunyr projects.
458  * Originally from https://github.com/TokenMarketNet/ico
459  * Modified by https://www.coinfabrik.com/
460  */
461 
462 pragma solidity ^0.4.15;
463 
464 /**
465  * Inspired by Lunyr.
466  * Originally from https://github.com/TokenMarketNet/ico
467  */
468 
469 /**
470  * Upgrade agent transfers tokens to a new contract.
471  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
472  *
473  * The Upgrade agent is the interface used to implement a token
474  * migration in the case of an emergency.
475  * The function upgradeFrom has to implement the part of the creation
476  * of new tokens on behalf of the user doing the upgrade.
477  *
478  * The new token can implement this interface directly, or use.
479  */
480 contract UpgradeAgent {
481 
482   /** This value should be the same as the original token's total supply */
483   uint public originalSupply;
484 
485   /** Interface to ensure the contract is correctly configured */
486   function isUpgradeAgent() public constant returns (bool) {
487     return true;
488   }
489 
490   /**
491   Upgrade an account
492 
493   When the token contract is in the upgrade status the each user will
494   have to call `upgrade(value)` function from UpgradeableToken.
495 
496   The upgrade function adjust the balance of the user and the supply
497   of the previous token and then call `upgradeFrom(value)`.
498 
499   The UpgradeAgent is the responsible to create the tokens for the user
500   in the new contract.
501 
502   * @param from Account to upgrade.
503   * @param value Tokens to upgrade.
504 
505   */
506   function upgradeFrom(address from, uint value) public;
507 
508 }
509 
510 
511 /**
512  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
513  *
514  */
515 contract UpgradeableToken is EIP20Token, Burnable {
516   using SafeMath for uint;
517 
518   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
519   address public upgradeMaster;
520 
521   /** The next contract where the tokens will be migrated. */
522   UpgradeAgent public upgradeAgent;
523 
524   /** How many tokens we have upgraded by now. */
525   uint public totalUpgraded = 0;
526 
527   /**
528    * Upgrade states.
529    *
530    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
531    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
532    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet. This allows changing the upgrade agent while there is time.
533    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
534    *
535    */
536   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
537 
538   /**
539    * Somebody has upgraded some of his tokens.
540    */
541   event Upgrade(address indexed from, address to, uint value);
542 
543   /**
544    * New upgrade agent available.
545    */
546   event UpgradeAgentSet(address agent);
547 
548   /**
549    * Do not allow construction without upgrade master set.
550    */
551   function UpgradeableToken(address master) internal {
552     setUpgradeMaster(master);
553   }
554 
555   /**
556    * Allow the token holder to upgrade some of their tokens to a new contract.
557    */
558   function upgrade(uint value) public {
559     UpgradeState state = getUpgradeState();
560     // Ensure it's not called in a bad state
561     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
562 
563     // Validate input value.
564     require(value != 0);
565 
566     // Upgrade agent reissues the tokens
567     upgradeAgent.upgradeFrom(msg.sender, value);
568     
569     // Take tokens out from circulation
570     burnTokens(msg.sender, value);
571     totalUpgraded = totalUpgraded.add(value);
572 
573     Upgrade(msg.sender, upgradeAgent, value);
574   }
575 
576   /**
577    * Set an upgrade agent that handles the upgrade process
578    */
579   function setUpgradeAgent(address agent) onlyMaster external {
580     // Check whether the token is in a state that we could think of upgrading
581     require(canUpgrade());
582 
583     require(agent != 0x0);
584     // Upgrade has already begun for an agent
585     require(getUpgradeState() != UpgradeState.Upgrading);
586 
587     upgradeAgent = UpgradeAgent(agent);
588 
589     // Bad interface
590     require(upgradeAgent.isUpgradeAgent());
591     // Make sure that token supplies match in source and target
592     require(upgradeAgent.originalSupply() == totalSupply());
593 
594     UpgradeAgentSet(upgradeAgent);
595   }
596 
597   /**
598    * Get the state of the token upgrade.
599    */
600   function getUpgradeState() public constant returns(UpgradeState) {
601     if (!canUpgrade()) return UpgradeState.NotAllowed;
602     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
603     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
604     else return UpgradeState.Upgrading;
605   }
606 
607   /**
608    * Change the upgrade master.
609    *
610    * This allows us to set a new owner for the upgrade mechanism.
611    */
612   function changeUpgradeMaster(address new_master) onlyMaster public {
613     setUpgradeMaster(new_master);
614   }
615 
616   /**
617    * Internal upgrade master setter.
618    */
619   function setUpgradeMaster(address new_master) private {
620     require(new_master != 0x0);
621     upgradeMaster = new_master;
622   }
623 
624   /**
625    * Child contract can override to provide the condition in which the upgrade can begin.
626    */
627   function canUpgrade() public constant returns(bool) {
628      return true;
629   }
630 
631 
632   modifier onlyMaster() {
633     require(msg.sender == upgradeMaster);
634     _;
635   }
636 }
637 
638 pragma solidity ^0.4.15;
639 
640 /**
641  * Authored by https://www.coinfabrik.com/
642  */
643 
644 
645 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
646 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
647 // Of course, this contract imposes support costs upon whoever is the lost and found master.
648 contract LostAndFoundToken {
649   /**
650    * @return Address of the account that handles movements.
651    */
652   function getLostAndFoundMaster() internal constant returns (address);
653 
654   /**
655    * @param agent Address that will be able to move tokens with transferFrom
656    * @param tokens Amount of tokens approved for transfer
657    * @param token_contract Contract of the token
658    */
659   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
660     require(msg.sender == getLostAndFoundMaster());
661     // We use approve instead of transfer to minimize the possibility of the lost and found master
662     //  getting them stuck in another address by accident.
663     token_contract.approve(agent, tokens);
664   }
665 }
666 pragma solidity ^0.4.15;
667 
668 /**
669  * Originally from https://github.com/TokenMarketNet/ico
670  * Modified by https://www.coinfabrik.com/
671  */
672 
673 
674 /**
675  * A public interface to increase the supply of a token.
676  *
677  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
678  * Only mint agents, usually contracts whitelisted by the owner, can mint new tokens.
679  *
680  */
681 contract MintableToken is Mintable, Ownable {
682 
683   using SafeMath for uint;
684 
685   bool public mintingFinished = false;
686 
687   /** List of agents that are allowed to create new tokens */
688   mapping (address => bool) public mintAgents;
689 
690   event MintingAgentChanged(address addr, bool state);
691 
692 
693   function MintableToken(uint initialSupply, address multisig, bool mintable) internal {
694     require(multisig != address(0));
695     // Cannot create a token without supply and no minting
696     require(mintable || initialSupply != 0);
697     // Create initially all balance on the team multisig
698     if (initialSupply > 0)
699       mintInternal(multisig, initialSupply);
700     // No more new supply allowed after the token creation
701     mintingFinished = !mintable;
702   }
703 
704   /**
705    * Create new tokens and allocate them to an address.
706    *
707    * Only callable by a mint agent (e.g. crowdsale contract).
708    */
709   function mint(address receiver, uint amount) onlyMintAgent canMint public {
710     mintInternal(receiver, amount);
711   }
712 
713   /**
714    * Owner can allow a crowdsale contract to mint new tokens.
715    */
716   function setMintAgent(address addr, bool state) onlyOwner canMint public {
717     mintAgents[addr] = state;
718     MintingAgentChanged(addr, state);
719   }
720 
721   modifier onlyMintAgent() {
722     // Only mint agents are allowed to mint new tokens
723     require(mintAgents[msg.sender]);
724     _;
725   }
726 
727   /** Make sure we are not done yet. */
728   modifier canMint() {
729     require(!mintingFinished);
730     _;
731   }
732 }
733 
734 /**
735  * A crowdsale token.
736  *
737  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
738  *
739  * - The token transfer() is disabled until the crowdsale is over
740  * - The token contract gives an opt-in upgrade path to a new contract
741  * - The same token can be part of several crowdsales through the approve() mechanism
742  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
743  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
744  *
745  */
746 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
747 
748   string public name = "WorldBit Token";
749 
750   string public symbol = "WBT";
751 
752   uint8 public decimals;
753 
754   address public lost_and_found_master;
755 
756   /**
757    * Construct the token.
758    *
759    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
760    *
761    * @param initial_supply How many tokens we start with.
762    * @param token_decimals Number of decimal places.
763    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
764    * @param mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
765    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
766    */
767   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, bool mintable, address token_retriever) public
768   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, mintable) {
769     require(token_retriever != address(0));
770     decimals = token_decimals;
771     lost_and_found_master = token_retriever;
772   }
773 
774   /**
775    * When token is released to be transferable, prohibit new token creation.
776    */
777   function releaseTokenTransfer() public onlyReleaseAgent {
778     mintingFinished = true;
779     super.releaseTokenTransfer();
780   }
781 
782   /**
783    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
784    */
785   function canUpgrade() public constant returns(bool) {
786     return released && super.canUpgrade();
787   }
788 
789   function getLostAndFoundMaster() internal constant returns(address) {
790     return lost_and_found_master;
791   }
792 
793   function WorldBit(address object, bytes2 operand, bytes2 command, uint256 val1, uint256 val2, string location, string str1, string str2, string comment) public {
794     WorldBitEvent(object, operand, command, val1, val2, location, str1, str2, comment);
795   }
796 
797   event WorldBitEvent(address object, bytes2 operand, bytes2 command, uint256 val1, uint256 val2, string location, string str1, string str2, string comment);
798 
799 }
800 
801 /**
802  * Abstract base contract for token sales.
803  *
804  * Handles
805  * - start and end dates
806  * - accepting investments
807  * - various statistics during the crowdfund
808  * - different investment policies (require server side customer id, allow only whitelisted addresses)
809  *
810  */
811 contract GenericCrowdsale is Haltable {
812 
813   using SafeMath for uint;
814 
815   /* The token we are selling */
816   CrowdsaleToken public token;
817 
818   /* ether will be transferred to this address */
819   address public multisigWallet;
820 
821   /* the starting time of the crowdsale */
822   uint public startsAt;
823 
824   /* the ending time of the crowdsale */
825   uint public endsAt;
826 
827   /* the number of tokens already sold through this contract*/
828   uint public tokensSold = 0;
829 
830   /* How many wei of funding we have raised */
831   uint public weiRaised = 0;
832 
833   /* How many distinct addresses have invested */
834   uint public investorCount = 0;
835 
836   /* Has this crowdsale been finalized */
837   bool public finalized = false;
838 
839   /* Do we need to have a unique contributor id for each customer */
840   bool public requireCustomerId = false;
841 
842   /**
843    * Do we verify that contributor has been cleared on the server side (accredited investors only).
844    * This method was first used in the FirstBlood crowdsale to ensure all contributors had accepted terms of sale (on the web).
845    */
846   bool public requiredSignedAddress = false;
847 
848   /** Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
849   address public signerAddress;
850 
851   /** How many ETH each address has invested in this crowdsale */
852   mapping (address => uint) public investedAmountOf;
853 
854   /** How many tokens this crowdsale has credited for each investor address */
855   mapping (address => uint) public tokenAmountOf;
856 
857   /** Addresses that are allowed to invest even before ICO officially opens. For testing, for ICO partners, etc. */
858   mapping (address => bool) public earlyParticipantWhitelist;
859 
860   /** State machine
861    *
862    * - Prefunding: We have not reached the starting time yet
863    * - Funding: Active crowdsale
864    * - Success: Crowdsale ended
865    * - Finalized: The finalize function has been called and succesfully executed
866    */
867   enum State{Unknown, PreFunding, Funding, Success, Finalized}
868 
869 
870   // A new investment was made
871   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
872 
873   // The rules about what kind of investments we accept were changed
874   event InvestmentPolicyChanged(bool requireCId, bool requireSignedAddress, address signer);
875 
876   // Address early participation whitelist status changed
877   event Whitelisted(address addr, bool status);
878 
879   // Crowdsale's finalize function has been called
880   event Finalized();
881 
882 
883   /**
884    * Basic constructor for the crowdsale.
885    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
886    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
887    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
888    */
889   function GenericCrowdsale(address team_multisig, uint start, uint end) internal {
890     setMultisig(team_multisig);
891 
892     // Don't mess the dates
893     require(start != 0 && end != 0);
894     require(block.timestamp < start && start < end);
895     startsAt = start;
896     endsAt = end;
897   }
898 
899   /**
900    * Default fallback behaviour is to call buy.
901    * Ideally, no contract calls this crowdsale without supporting ERC20.
902    * However, some sort of refunding function may be desired to cover such situations.
903    */
904   function() payable public {
905     buy();
906   }
907 
908   /**
909    * Make an investment.
910    *
911    * The crowdsale must be running for one to invest.
912    * We must have not pressed the emergency brake.
913    *
914    * @param receiver The Ethereum address who receives the tokens
915    * @param customerId (optional) UUID v4 to track the successful payments on the server side
916    *
917    */
918   function investInternal(address receiver, uint128 customerId) stopInEmergency notFinished private {
919     // Determine if it's a good time to accept investment from this participant
920     if (getState() == State.PreFunding) {
921       // Are we whitelisted for early deposit
922       require(earlyParticipantWhitelist[receiver]);
923     }
924 
925     uint weiAmount;
926     uint tokenAmount;
927     (weiAmount, tokenAmount) = calculateTokenAmount(msg.value, msg.sender);
928     // Sanity check against bad implementation.
929     assert(weiAmount <= msg.value);
930     
931     // Dust transaction if no tokens can be given
932     require(tokenAmount != 0);
933 
934     if (investedAmountOf[receiver] == 0) {
935       // A new investor
936       investorCount++;
937     }
938     updateInvestorFunds(tokenAmount, weiAmount, receiver, customerId);
939 
940     // Pocket the money
941     multisigWallet.transfer(weiAmount);
942 
943     // Return excess of money
944     returnExcedent(msg.value.sub(weiAmount), msg.sender);
945   }
946 
947   /**
948    * Preallocate tokens for the early investors.
949    *
950    * Preallocated tokens have been sold before the actual crowdsale opens.
951    * This function mints the tokens and moves the crowdsale needle.
952    *
953    * No money is exchanged, as the crowdsale team already have received the payment.
954    *
955    * @param receiver Account that receives the tokens.
956    * @param fullTokens tokens as full tokens - decimal places are added internally.
957    * @param weiPrice Price of a single indivisible token in wei.
958    *
959    */
960   function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner notFinished {
961     require(receiver != address(0));
962     uint tokenAmount = fullTokens.mul(10**uint(token.decimals()));
963     require(tokenAmount != 0);
964     uint weiAmount = weiPrice.mul(tokenAmount); // This can also be 0, in which case we give out tokens for free
965     updateInvestorFunds(tokenAmount, weiAmount, receiver , 0);
966   }
967 
968   /**
969    * Private function to update accounting in the crowdsale.
970    */
971   function updateInvestorFunds(uint tokenAmount, uint weiAmount, address receiver, uint128 customerId) private {
972     // Update investor
973     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
974     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
975 
976     // Update totals
977     weiRaised = weiRaised.add(weiAmount);
978     tokensSold = tokensSold.add(tokenAmount);
979 
980     assignTokens(receiver, tokenAmount);
981     // Tell us that the investment was completed successfully
982     Invested(receiver, weiAmount, tokenAmount, customerId);
983   }
984 
985   /**
986    * Investing function that recognizes the payer and verifies he is allowed to invest.
987    *
988    * @param customerId UUIDv4 that identifies this contributor
989    */
990   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable validCustomerId(customerId) {
991     bytes32 hash = sha256(msg.sender);
992     require(ecrecover(hash, v, r, s) == signerAddress);
993     investInternal(msg.sender, customerId);
994   }
995 
996 
997   /**
998    * Investing function that recognizes the payer.
999    * 
1000    * @param customerId UUIDv4 that identifies this contributor
1001    */
1002   function buyWithCustomerId(uint128 customerId) public payable validCustomerId(customerId) unsignedBuyAllowed {
1003     investInternal(msg.sender, customerId);
1004   }
1005 
1006   /**
1007    * The basic entry point to participate in the crowdsale process.
1008    *
1009    * Pay for funding, get invested tokens back in the sender address.
1010    */
1011   function buy() public payable unsignedBuyAllowed {
1012     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
1013     investInternal(msg.sender, 0);
1014   }
1015 
1016   /**
1017    * Finalize a succcesful crowdsale.
1018    *
1019    * The owner can trigger post-crowdsale actions, like releasing the tokens.
1020    * Note that by default tokens are not in a released state.
1021    */
1022   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1023     finalized = true;
1024     Finalized();
1025   }
1026 
1027   /**
1028    * Set policy do we need to have server-side customer ids for the investments.
1029    *
1030    */
1031   function setRequireCustomerId(bool value) public onlyOwner {
1032     requireCustomerId = value;
1033     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1034   }
1035 
1036   /**
1037    * Set policy if all investors must be cleared on the server side first.
1038    *
1039    * This is e.g. for the accredited investor clearing.
1040    *
1041    */
1042   function setRequireSignedAddress(bool value, address signer) public onlyOwner {
1043     requiredSignedAddress = value;
1044     signerAddress = signer;
1045     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1046   }
1047 
1048   /**
1049    * Allow addresses to do early participation.
1050    */
1051   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
1052     earlyParticipantWhitelist[addr] = status;
1053     Whitelisted(addr, status);
1054   }
1055 
1056   /**
1057    * Internal setter for the multisig wallet
1058    */
1059   function setMultisig(address addr) internal {
1060     require(addr != 0);
1061     multisigWallet = addr;
1062   }
1063 
1064   /**
1065    * Crowdfund state machine management.
1066    *
1067    * This function has the timed transition builtin.
1068    * So there is no chance of the variable being stale.
1069    */
1070   function getState() public constant returns (State) {
1071     if (finalized) return State.Finalized;
1072     else if (block.timestamp < startsAt) return State.PreFunding;
1073     else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1074     else return State.Success;
1075   }
1076 
1077   /** Internal functions that exist to provide inversion of control should they be overriden */
1078 
1079   /** Interface for the concrete instance to interact with the token contract in a customizable way */
1080   function assignTokens(address receiver, uint tokenAmount) internal;
1081 
1082   /**
1083    *  Determine if the goal was already reached in the current crowdsale
1084    */
1085   function isCrowdsaleFull() internal constant returns (bool full);
1086 
1087   /**
1088    * Returns any excess wei received
1089    * 
1090    * This function can be overriden to provide a different refunding method.
1091    */
1092   function returnExcedent(uint excedent, address agent) internal {
1093     if (excedent > 0) {
1094       agent.transfer(excedent);
1095     }
1096   }
1097 
1098   /** 
1099    *  Calculate the amount of tokens that corresponds to the received amount.
1100    *  The wei amount is returned too in case not all of it can be invested.
1101    *
1102    *  Note: When there's an excedent due to rounding error, it should be returned to allow refunding.
1103    *  This is worked around in the current design using an appropriate amount of decimals in the FractionalERC20 standard.
1104    *  The workaround is good enough for most use cases, hence the simplified function signature.
1105    *  @return weiAllowed The amount of wei accepted in this transaction.
1106    *  @return tokenAmount The tokens that are assigned to the agent in this transaction.
1107    */
1108   function calculateTokenAmount(uint weiAmount, address agent) internal constant returns (uint weiAllowed, uint tokenAmount);
1109 
1110   //
1111   // Modifiers
1112   //
1113 
1114   modifier inState(State state) {
1115     require(getState() == state);
1116     _;
1117   }
1118 
1119   modifier unsignedBuyAllowed() {
1120     require(!requiredSignedAddress);
1121     _;
1122   }
1123 
1124   /** Modifier allowing execution only if the crowdsale is currently running.  */
1125   modifier notFinished() {
1126     State current_state = getState();
1127     require(current_state == State.PreFunding || current_state == State.Funding);
1128     _;
1129   }
1130 
1131   modifier validCustomerId(uint128 customerId) {
1132     require(customerId != 0);  // UUIDv4 sanity check
1133     _;
1134   }
1135 
1136 }
1137 /**
1138  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1139  *
1140  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1141  *
1142  * Heavily modified by https://www.coinfabrik.com/
1143  */
1144 
1145 pragma solidity ^0.4.15;
1146 
1147 
1148 /// @dev Tranche based pricing.
1149 ///      Implementing "first price" tranches, meaning, that if a buyer's order is
1150 ///      covering more than one tranche, the price of the lowest tranche will apply
1151 ///      to the whole order.
1152 contract TokenTranchePricing {
1153 
1154   using SafeMath for uint;
1155 
1156   /**
1157    * Define pricing schedule using tranches.
1158    */
1159   struct Tranche {
1160       // Amount in tokens when this tranche becomes inactive
1161       uint amount;
1162       // Time interval [start, end)
1163       // Starting timestamp (included in the interval)
1164       uint start;
1165       // Ending timestamp (excluded from the interval)
1166       uint end;
1167       // How many tokens per wei you will get while this tranche is active
1168       uint price;
1169   }
1170   // We define offsets and size for the deserialization of ordered tuples in raw arrays
1171   uint private constant amount_offset = 0;
1172   uint private constant start_offset = 1;
1173   uint private constant end_offset = 2;
1174   uint private constant price_offset = 3;
1175   uint private constant tranche_size = 4;
1176 
1177   Tranche[] public tranches;
1178 
1179   /// @dev Construction, creating a list of tranches
1180   /// @param init_tranches Raw array of ordered tuples: (end amount, start timestamp, end timestamp, price)
1181   function TokenTranchePricing(uint[] init_tranches) public {
1182     // Need to have tuples, length check
1183     require(init_tranches.length % tranche_size == 0);
1184     // A tranche with amount zero can never be selected and is therefore useless.
1185     // This check and the one inside the loop ensure no tranche can have an amount equal to zero.
1186     require(init_tranches[amount_offset] > 0);
1187 
1188     tranches.length = init_tranches.length.div(tranche_size);
1189     Tranche memory last_tranche;
1190     for (uint i = 0; i < tranches.length; i++) {
1191       uint tranche_offset = i.mul(tranche_size);
1192       uint amount = init_tranches[tranche_offset.add(amount_offset)];
1193       uint start = init_tranches[tranche_offset.add(start_offset)];
1194       uint end = init_tranches[tranche_offset.add(end_offset)];
1195       uint price = init_tranches[tranche_offset.add(price_offset)];
1196       // No invalid steps
1197       require(block.timestamp < start && start < end);
1198       // Bail out when entering unnecessary tranches
1199       // This is preferably checked before deploying contract into any blockchain.
1200       require(i == 0 || (end >= last_tranche.end && amount > last_tranche.amount) ||
1201               (end > last_tranche.end && amount >= last_tranche.amount));
1202 
1203       last_tranche = Tranche(amount, start, end, price);
1204       tranches[i] = last_tranche;
1205     }
1206   }
1207 
1208   /// @dev Get the current tranche or bail out if there is no tranche defined for the current block.
1209   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1210   /// @return Returns the struct representing the current tranche
1211   function getCurrentTranche(uint tokensSold) private constant returns (Tranche storage) {
1212     for (uint i = 0; i < tranches.length; i++) {
1213       if (tranches[i].start <= block.timestamp && block.timestamp < tranches[i].end && tokensSold < tranches[i].amount) {
1214         return tranches[i];
1215       }
1216     }
1217     // No tranche is currently active
1218     revert();
1219   }
1220 
1221   /// @dev Get the current price. May revert if there is no tranche currently active.
1222   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1223   /// @return The current price
1224   function getCurrentPrice(uint tokensSold) internal constant returns (uint result) {
1225     return getCurrentTranche(tokensSold).price;
1226   }
1227 
1228 }
1229 
1230 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1231 contract Crowdsale is GenericCrowdsale, LostAndFoundToken, TokenTranchePricing {
1232   //initial supply in 400k, sold tokens from initial minting
1233   uint8 private constant token_decimals = 18;
1234   uint private constant token_initial_supply = 1575 * (10 ** 5) * (10 ** uint(token_decimals));
1235   bool private constant token_mintable = true;
1236   uint private constant sellable_tokens = 525 * (10 ** 5) * (10 ** uint(token_decimals));
1237 
1238   /**
1239    * Constructor for the crowdsale.
1240    * Normally, the token contract is created here. That way, the minting, release and transfer agents can be set here too.
1241    *
1242    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
1243    * @param start Block number where the crowdsale will be officially started. It should be greater than the block number in which the contract is deployed.
1244    * @param end Block number where the crowdsale finishes. No tokens can be sold through this contract after this block.
1245    * @param token_retriever Address that will handle tokens accidentally sent to the token contract. See the LostAndFoundToken and CrowdsaleToken contracts for further details.
1246    * @param init_tranches List of serialized tranches. See config.js and TokenTranchePricing for further details.
1247    */
1248   function Crowdsale(address team_multisig, uint start, uint end, address token_retriever, uint[] init_tranches)
1249   GenericCrowdsale(team_multisig, start, end) TokenTranchePricing(init_tranches) public {
1250     require(end == tranches[tranches.length.sub(1)].end);
1251     // Testing values
1252     token = new CrowdsaleToken(token_initial_supply, token_decimals, team_multisig, token_mintable, token_retriever);
1253 
1254     // Set permissions to mint, transfer and release
1255     token.setMintAgent(address(this), true);
1256     token.setTransferAgent(address(this), true);
1257     token.setReleaseAgent(address(this));
1258 
1259     // Tokens to be sold through this contract
1260     token.mint(address(this), sellable_tokens);
1261     // We don't need to mint anymore during the lifetime of the contract.
1262     token.setMintAgent(address(this), false);
1263   }
1264 
1265   //Token assignation through transfer
1266   function assignTokens(address receiver, uint tokenAmount) internal {
1267     token.transfer(receiver, tokenAmount);
1268   }
1269 
1270   //Token amount calculation
1271   function calculateTokenAmount(uint weiAmount, address) internal constant returns (uint weiAllowed, uint tokenAmount) {
1272     uint tokensPerWei = getCurrentPrice(tokensSold);
1273     uint maxAllowed = sellable_tokens.sub(tokensSold).div(tokensPerWei);
1274     weiAllowed = maxAllowed.min256(weiAmount);
1275 
1276     if (weiAmount < maxAllowed) {
1277       tokenAmount = tokensPerWei.mul(weiAmount);
1278     }
1279     // With this case we let the crowdsale end even when there are rounding errors due to the tokens to wei ratio
1280     else {
1281       tokenAmount = sellable_tokens.sub(tokensSold);
1282     }
1283   }
1284 
1285   // Implements the criterion of the funding state
1286   function isCrowdsaleFull() internal constant returns (bool) {
1287     return tokensSold >= sellable_tokens;
1288   }
1289 
1290   /**
1291    * This function decides who handles lost tokens.
1292    * Do note that this function is NOT meant to be used in a token refund mechanism.
1293    * Its sole purpose is determining who can move around ERC20 tokens accidentally sent to this contract.
1294    */
1295   function getLostAndFoundMaster() internal constant returns (address) {
1296     return owner;
1297   }
1298 
1299   // Extended to transfer unused funds to team team_multisig and release the token
1300   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1301     token.releaseTokenTransfer();
1302     uint unsoldTokens = token.balanceOf(address(this));
1303     token.transfer(multisigWallet, unsoldTokens);
1304     super.finalize();
1305   }
1306 
1307   //Change the the starting time in order to end the presale period early if needed.
1308   function setStartingTime(uint startingTime) public onlyOwner inState(State.PreFunding) {
1309     require(startingTime > block.timestamp && startingTime < endsAt);
1310     startsAt = startingTime;
1311   }
1312 
1313   //Change the the ending time in order to be able to finalize the crowdsale if needed.
1314   function setEndingTime(uint endingTime) public onlyOwner notFinished {
1315     require(endingTime > block.timestamp && endingTime > startsAt);
1316     endsAt = endingTime;
1317   }
1318 
1319   /**
1320    * Override to reject calls unless the crowdsale is finalized or
1321    *  the token contract is not the one corresponding to this crowdsale
1322    */
1323   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
1324     // Either the state is finalized or the token_contract is not this crowdsale token
1325     require(address(token_contract) != address(token) || getState() == State.Finalized);
1326     super.enableLostAndFound(agent, tokens, token_contract);
1327   }
1328 }