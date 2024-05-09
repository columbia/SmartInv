1 pragma solidity ^0.4.19;
2 
3 /**
4  * Authored by https://www.coinfabrik.com/
5  */
6 
7 pragma solidity ^0.4.19;
8 
9 /**
10  * Originally from https://github.com/TokenMarketNet/ico
11  * Modified by https://www.coinfabrik.com/
12  */
13 
14 pragma solidity ^0.4.19;
15 
16 /**
17  * Envisioned in FirstBlood ICO contract.
18  * Originally from https://github.com/TokenMarketNet/ico
19  * Modified by https://www.coinfabrik.com/
20  */
21 
22 pragma solidity ^0.4.19;
23 
24 /**
25  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
26  * Modified by https://www.coinfabrik.com/
27  */
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control 
32  * functions, this simplifies the implementation of "user permissions". 
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   /** 
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() internal {
43     owner = msg.sender;
44   }
45 
46 
47   /**
48    * @dev Throws if called by any account other than the owner. 
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to. 
59    */
60   function transferOwnership(address newOwner) onlyOwner public {
61     require(newOwner != address(0));
62     owner = newOwner;
63   }
64 
65 }
66 
67 /**
68  * Abstract contract that allows children to implement an
69  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
70  *
71  */
72 contract Haltable is Ownable {
73   bool public halted;
74 
75   event Halted(bool halted);
76 
77   modifier stopInEmergency {
78     require(!halted);
79     _;
80   }
81 
82   modifier onlyInEmergency {
83     require(halted);
84     _;
85   }
86 
87   // called by the owner on emergency, triggers stopped state
88   function halt() external onlyOwner {
89     halted = true;
90     Halted(true);
91   }
92 
93   // called by the owner on end of emergency, returns to normal state
94   function unhalt() external onlyOwner onlyInEmergency {
95     halted = false;
96     Halted(false);
97   }
98 }
99 pragma solidity ^0.4.19;
100 
101 /**
102  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
103  * Modified by https://www.coinfabrik.com/
104  */
105 
106 /**
107  * Math operations with safety checks
108  */
109 library SafeMath {
110   function mul(uint a, uint b) internal pure returns (uint) {
111     uint c = a * b;
112     assert(a == 0 || c / a == b);
113     return c;
114   }
115 
116   function div(uint a, uint b) internal pure returns (uint) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     uint c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return c;
121   }
122 
123   function sub(uint a, uint b) internal pure returns (uint) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   function add(uint a, uint b) internal pure returns (uint) {
129     uint c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 
134   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
135     return a >= b ? a : b;
136   }
137 
138   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
139     return a < b ? a : b;
140   }
141 
142   function max256(uint a, uint b) internal pure returns (uint) {
143     return a >= b ? a : b;
144   }
145 
146   function min256(uint a, uint b) internal pure returns (uint) {
147     return a < b ? a : b;
148   }
149 }
150 
151 pragma solidity ^0.4.19;
152 
153 /**
154  * Originally from https://github.com/TokenMarketNet/ico
155  * Modified by https://www.coinfabrik.com/
156  */
157 
158 pragma solidity ^0.4.19;
159 
160 /**
161  * Originally from https://github.com/TokenMarketNet/ico
162  * Modified by https://www.coinfabrik.com/
163  */
164 
165 pragma solidity ^0.4.19;
166 
167 /**
168  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
169  * Modified by https://www.coinfabrik.com/
170  */
171 
172 pragma solidity ^0.4.19;
173 
174 /**
175  * Interface for the standard token.
176  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
177  */
178 contract EIP20Token {
179 
180   function totalSupply() public view returns (uint256);
181   function balanceOf(address who) public view returns (uint256);
182   function transfer(address to, uint256 value) public returns (bool success);
183   function transferFrom(address from, address to, uint256 value) public returns (bool success);
184   function approve(address spender, uint256 value) public returns (bool success);
185   function allowance(address owner, address spender) public view returns (uint256 remaining);
186   event Transfer(address indexed from, address indexed to, uint256 value);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 
189   /**
190   ** Optional functions
191   *
192   function name() public view returns (string name);
193   function symbol() public view returns (string symbol);
194   function decimals() public view returns (uint8 decimals);
195   *
196   **/
197 
198 }
199 pragma solidity ^0.4.19;
200 
201 // Interface for burning tokens
202 contract Burnable {
203   // @dev Destroys tokens for an account
204   // @param account Account whose tokens are destroyed
205   // @param value Amount of tokens to destroy
206   function burnTokens(address account, uint value) internal;
207   event Burned(address account, uint value);
208 }
209 pragma solidity ^0.4.19;
210 
211 /**
212  * Authored by https://www.coinfabrik.com/
213  */
214 
215 
216 /**
217  * Internal interface for the minting of tokens.
218  */
219 contract Mintable {
220 
221   /**
222    * @dev Mints tokens for an account
223    * This function should the Minted event.
224    */
225   function mintInternal(address receiver, uint amount) internal;
226 
227   /** Token supply got increased and a new owner received these tokens */
228   event Minted(address receiver, uint amount);
229 }
230 
231 /**
232  * @title Standard token
233  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
234  */
235 contract StandardToken is EIP20Token, Burnable, Mintable {
236   using SafeMath for uint;
237 
238   uint private total_supply;
239   mapping(address => uint) private balances;
240   mapping(address => mapping (address => uint)) private allowed;
241 
242 
243   function totalSupply() public view returns (uint) {
244     return total_supply;
245   }
246 
247   /**
248    * @dev transfer token for a specified address
249    * @param to The address to transfer to.
250    * @param value The amount to be transferred.
251    */
252   function transfer(address to, uint value) public returns (bool success) {
253     balances[msg.sender] = balances[msg.sender].sub(value);
254     balances[to] = balances[to].add(value);
255     Transfer(msg.sender, to, value);
256     return true;
257   }
258 
259   /**
260    * @dev Gets the balance of the specified address.
261    * @param account The address whose balance is to be queried.
262    * @return An uint representing the amount owned by the passed address.
263    */
264   function balanceOf(address account) public view returns (uint balance) {
265     return balances[account];
266   }
267 
268   /**
269    * @dev Transfer tokens from one address to another
270    * @param from address The address which you want to send tokens from
271    * @param to address The address which you want to transfer to
272    * @param value uint the amout of tokens to be transfered
273    */
274   function transferFrom(address from, address to, uint value) public returns (bool success) {
275     uint allowance = allowed[from][msg.sender];
276 
277     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
278     // require(value <= allowance);
279     // SafeMath uses assert instead of require though, beware when using an analysis tool
280 
281     balances[from] = balances[from].sub(value);
282     balances[to] = balances[to].add(value);
283     allowed[from][msg.sender] = allowance.sub(value);
284     Transfer(from, to, value);
285     return true;
286   }
287 
288   /**
289    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
290    * @param spender The address which will spend the funds.
291    * @param value The amount of tokens to be spent.
292    */
293   function approve(address spender, uint value) public returns (bool success) {
294 
295     // To change the approve amount you first have to reduce the addresses'
296     //  allowance to zero by calling `approve(spender, 0)` if it is not
297     //  already 0 to mitigate the race condition described here:
298     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299     require (value == 0 || allowed[msg.sender][spender] == 0);
300 
301     allowed[msg.sender][spender] = value;
302     Approval(msg.sender, spender, value);
303     return true;
304   }
305 
306   /**
307    * @dev Function to check the amount of tokens than an owner allowed to a spender.
308    * @param account address The address which owns the funds.
309    * @param spender address The address which will spend the funds.
310    * @return A uint specifing the amount of tokens still avaible for the spender.
311    */
312   function allowance(address account, address spender) public view returns (uint remaining) {
313     return allowed[account][spender];
314   }
315 
316   /**
317    * Atomic increment of approved spending
318    *
319    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320    *
321    */
322   function addApproval(address spender, uint addedValue) public returns (bool success) {
323       uint oldValue = allowed[msg.sender][spender];
324       allowed[msg.sender][spender] = oldValue.add(addedValue);
325       Approval(msg.sender, spender, allowed[msg.sender][spender]);
326       return true;
327   }
328 
329   /**
330    * Atomic decrement of approved spending.
331    *
332    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    */
334   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
335 
336       uint oldVal = allowed[msg.sender][spender];
337 
338       if (subtractedValue > oldVal) {
339           allowed[msg.sender][spender] = 0;
340       } else {
341           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
342       }
343       Approval(msg.sender, spender, allowed[msg.sender][spender]);
344       return true;
345   }
346 
347   /**
348    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
349    */
350   function burnTokens(address account, uint value) internal {
351     balances[account] = balances[account].sub(value);
352     total_supply = total_supply.sub(value);
353     Transfer(account, 0, value);
354     Burned(account, value);
355   }
356 
357   /**
358    * @dev Provides an internal minting function.
359    */
360   function mintInternal(address receiver, uint amount) internal {
361     total_supply = total_supply.add(amount);
362     balances[receiver] = balances[receiver].add(amount);
363     Minted(receiver, amount);
364 
365     // Beware: Address zero may be used for special transactions in a future fork.
366     // This will make the mint transaction appear in EtherScan.io
367     // We can remove this after there is a standardized minting event
368     Transfer(0, receiver, amount);
369   }
370   
371 }
372 
373 /**
374  * Define interface for releasing the token transfer after a successful crowdsale.
375  */
376 contract ReleasableToken is StandardToken, Ownable {
377 
378   /* The finalizer contract that allows lifting the transfer limits on this token */
379   address public releaseAgent;
380 
381   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
382   bool public released = false;
383 
384   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
385   mapping (address => bool) public transferAgents;
386 
387   /**
388    * Set the contract that can call release and make the token transferable.
389    *
390    * Since the owner of this contract is (or should be) the crowdsale,
391    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
392    */
393   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
394     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
395     releaseAgent = addr;
396   }
397 
398   /**
399    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
400    */
401   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
402     transferAgents[addr] = state;
403   }
404 
405   /**
406    * One way function to release the tokens into the wild.
407    *
408    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
409    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
410    */
411   function releaseTokenTransfer() public onlyReleaseAgent {
412     released = true;
413   }
414 
415   /**
416    * Limit token transfer until the crowdsale is over.
417    */
418   modifier canTransfer(address sender) {
419     require(released || transferAgents[sender]);
420     _;
421   }
422 
423   /** The function can be called only before or after the tokens have been released */
424   modifier inReleaseState(bool releaseState) {
425     require(releaseState == released);
426     _;
427   }
428 
429   /** The function can be called only by a whitelisted release agent. */
430   modifier onlyReleaseAgent() {
431     require(msg.sender == releaseAgent);
432     _;
433   }
434 
435   /** We restrict transfer by overriding it */
436   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
437     // Call StandardToken.transfer()
438    return super.transfer(to, value);
439   }
440 
441   /** We restrict transferFrom by overriding it */
442   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
443     // Call StandardToken.transferForm()
444     return super.transferFrom(from, to, value);
445   }
446 
447 }
448 
449 
450 
451 pragma solidity ^0.4.19;
452 
453 /**
454  * First envisioned by Golem and Lunyr projects.
455  * Originally from https://github.com/TokenMarketNet/ico
456  * Modified by https://www.coinfabrik.com/
457  */
458 
459 pragma solidity ^0.4.19;
460 
461 /**
462  * Inspired by Lunyr.
463  * Originally from https://github.com/TokenMarketNet/ico
464  */
465 
466 /**
467  * Upgrade agent transfers tokens to a new contract.
468  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
469  *
470  * The Upgrade agent is the interface used to implement a token
471  * migration in the case of an emergency.
472  * The function upgradeFrom has to implement the part of the creation
473  * of new tokens on behalf of the user doing the upgrade.
474  *
475  * The new token can implement this interface directly, or use.
476  */
477 contract UpgradeAgent {
478 
479   /** This value should be the same as the original token's total supply */
480   uint public originalSupply;
481 
482   /** Interface to ensure the contract is correctly configured */
483   function isUpgradeAgent() public pure returns (bool) {
484     return true;
485   }
486 
487   /**
488   Upgrade an account
489 
490   When the token contract is in the upgrade status the each user will
491   have to call `upgrade(value)` function from UpgradeableToken.
492 
493   The upgrade function adjust the balance of the user and the supply
494   of the previous token and then call `upgradeFrom(value)`.
495 
496   The UpgradeAgent is the responsible to create the tokens for the user
497   in the new contract.
498 
499   * @param from Account to upgrade.
500   * @param value Tokens to upgrade.
501 
502   */
503   function upgradeFrom(address from, uint value) public;
504 
505 }
506 
507 
508 /**
509  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
510  *
511  */
512 contract UpgradeableToken is EIP20Token, Burnable {
513   using SafeMath for uint;
514 
515   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
516   address public upgradeMaster;
517 
518   /** The next contract where the tokens will be migrated. */
519   UpgradeAgent public upgradeAgent;
520 
521   /** How many tokens we have upgraded by now. */
522   uint public totalUpgraded = 0;
523 
524   /**
525    * Upgrade states.
526    *
527    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
528    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
529    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet. This allows changing the upgrade agent while there is time.
530    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
531    *
532    */
533   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
534 
535   /**
536    * Somebody has upgraded some of his tokens.
537    */
538   event Upgrade(address indexed from, address to, uint value);
539 
540   /**
541    * New upgrade agent available.
542    */
543   event UpgradeAgentSet(address agent);
544 
545   /**
546    * Do not allow construction without upgrade master set.
547    */
548   function UpgradeableToken(address master) internal {
549     setUpgradeMaster(master);
550   }
551 
552   /**
553    * Allow the token holder to upgrade some of their tokens to a new contract.
554    */
555   function upgrade(uint value) public {
556     UpgradeState state = getUpgradeState();
557     // Ensure it's not called in a bad state
558     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
559 
560     // Validate input value.
561     require(value != 0);
562 
563     // Upgrade agent reissues the tokens
564     upgradeAgent.upgradeFrom(msg.sender, value);
565     
566     // Take tokens out from circulation
567     burnTokens(msg.sender, value);
568     totalUpgraded = totalUpgraded.add(value);
569 
570     Upgrade(msg.sender, upgradeAgent, value);
571   }
572 
573   /**
574    * Set an upgrade agent that handles the upgrade process
575    */
576   function setUpgradeAgent(address agent) onlyMaster external {
577     // Check whether the token is in a state that we could think of upgrading
578     require(canUpgrade());
579 
580     require(agent != 0x0);
581     // Upgrade has already begun for an agent
582     require(getUpgradeState() != UpgradeState.Upgrading);
583 
584     upgradeAgent = UpgradeAgent(agent);
585 
586     // Bad interface
587     require(upgradeAgent.isUpgradeAgent());
588     // Make sure that token supplies match in source and target
589     require(upgradeAgent.originalSupply() == totalSupply());
590 
591     UpgradeAgentSet(upgradeAgent);
592   }
593 
594   /**
595    * Get the state of the token upgrade.
596    */
597   function getUpgradeState() public view returns(UpgradeState) {
598     if (!canUpgrade()) return UpgradeState.NotAllowed;
599     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
600     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
601     else return UpgradeState.Upgrading;
602   }
603 
604   /**
605    * Change the upgrade master.
606    *
607    * This allows us to set a new owner for the upgrade mechanism.
608    */
609   function changeUpgradeMaster(address new_master) onlyMaster public {
610     setUpgradeMaster(new_master);
611   }
612 
613   /**
614    * Internal upgrade master setter.
615    */
616   function setUpgradeMaster(address new_master) private {
617     require(new_master != 0x0);
618     upgradeMaster = new_master;
619   }
620 
621   /**
622    * Child contract can override to provide the condition in which the upgrade can begin.
623    */
624   function canUpgrade() public view returns(bool) {
625      return true;
626   }
627 
628 
629   modifier onlyMaster() {
630     require(msg.sender == upgradeMaster);
631     _;
632   }
633 }
634 
635 pragma solidity ^0.4.19;
636 
637 /**
638  * Authored by https://www.coinfabrik.com/
639  */
640 
641 
642 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
643 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
644 // Of course, this contract imposes support costs upon whoever is the lost and found master.
645 contract LostAndFoundToken {
646   /**
647    * @return Address of the account that handles movements.
648    */
649   function getLostAndFoundMaster() internal view returns (address);
650 
651   /**
652    * @param agent Address that will be able to move tokens with transferFrom
653    * @param tokens Amount of tokens approved for transfer
654    * @param token_contract Contract of the token
655    */
656   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
657     require(msg.sender == getLostAndFoundMaster());
658     // We use approve instead of transfer to minimize the possibility of the lost and found master
659     //  getting them stuck in another address by accident.
660     token_contract.approve(agent, tokens);
661   }
662 }
663 pragma solidity ^0.4.19;
664 
665 /**
666  * Originally from https://github.com/TokenMarketNet/ico
667  * Modified by https://www.coinfabrik.com/
668  */
669 
670 
671 /**
672  * A public interface to increase the supply of a token.
673  *
674  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
675  * Only mint agents, usually contracts whitelisted by the owner, can mint new tokens.
676  *
677  */
678 contract MintableToken is Mintable, Ownable {
679 
680   using SafeMath for uint;
681 
682   bool public mintingFinished = false;
683 
684   /** List of agents that are allowed to create new tokens */
685   mapping (address => bool) public mintAgents;
686 
687   event MintingAgentChanged(address addr, bool state);
688 
689 
690   function MintableToken(uint initialSupply, address multisig, bool mintable) internal {
691     require(multisig != address(0));
692     // Cannot create a token without supply and no minting
693     require(mintable || initialSupply != 0);
694     // Create initially all balance on the team multisig
695     if (initialSupply > 0)
696       mintInternal(multisig, initialSupply);
697     // No more new supply allowed after the token creation
698     mintingFinished = !mintable;
699   }
700 
701   /**
702    * Create new tokens and allocate them to an address.
703    *
704    * Only callable by a mint agent (e.g. crowdsale contract).
705    */
706   function mint(address receiver, uint amount) onlyMintAgent canMint public {
707     mintInternal(receiver, amount);
708   }
709 
710   /**
711    * Owner can allow a crowdsale contract to mint new tokens.
712    */
713   function setMintAgent(address addr, bool state) onlyOwner canMint public {
714     mintAgents[addr] = state;
715     MintingAgentChanged(addr, state);
716   }
717 
718   modifier onlyMintAgent() {
719     // Only mint agents are allowed to mint new tokens
720     require(mintAgents[msg.sender]);
721     _;
722   }
723 
724   /** Make sure we are not done yet. */
725   modifier canMint() {
726     require(!mintingFinished);
727     _;
728   }
729 }
730 
731 /**
732  * A crowdsale token.
733  *
734  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
735  *
736  * - The token transfer() is disabled until the crowdsale is over
737  * - The token contract gives an opt-in upgrade path to a new contract
738  * - The same token can be part of several crowdsales through the approve() mechanism
739  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
740  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
741  *
742  */
743 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
744 
745   string public name = "TokenHome";
746 
747   string public symbol = "TH";
748 
749   uint8 public decimals;
750 
751   address public lost_and_found_master;
752 
753   /**
754    * Construct the token.
755    *
756    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
757    *
758    * @param initial_supply How many tokens we start with.
759    * @param token_decimals Number of decimal places.
760    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
761    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
762    */
763   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, address token_retriever) public
764   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, true) {
765     require(token_retriever != address(0));
766     decimals = token_decimals;
767     lost_and_found_master = token_retriever;
768   }
769 
770   /**
771    * When token is released to be transferable, prohibit new token creation.
772    */
773   function releaseTokenTransfer() public onlyReleaseAgent {
774     mintingFinished = true;
775     super.releaseTokenTransfer();
776   }
777 
778   /**
779    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
780    */
781   function canUpgrade() public view returns(bool) {
782     return released && super.canUpgrade();
783   }
784 
785   function burn(uint value) public {
786     burnTokens(msg.sender, value);
787   }
788 
789   function getLostAndFoundMaster() internal view returns(address) {
790     return lost_and_found_master;
791   }
792 }
793 
794 /**
795  * Abstract base contract for token sales.
796  *
797  * Handles
798  * - start and end dates
799  * - accepting investments
800  * - various statistics during the crowdfund
801  * - different investment policies (require server side customer id, allow only whitelisted addresses)
802  *
803  */
804 contract GenericCrowdsale is Haltable {
805 
806   using SafeMath for uint;
807 
808   /* The token we are selling */
809   CrowdsaleToken public token;
810 
811   /* ether will be transferred to this address */
812   address public multisigWallet;
813 
814   /* the starting timestamp of the crowdsale */
815   uint public startsAt;
816 
817   /* the ending timestamp of the crowdsale */
818   uint public endsAt;
819 
820   /* the number of tokens already sold through this contract*/
821   uint public tokensSold = 0;
822 
823   /* How many wei of funding we have raised */
824   uint public weiRaised = 0;
825 
826   /* How many distinct addresses have invested */
827   uint public investorCount = 0;
828 
829   /* Has this crowdsale been finalized */
830   bool public finalized = false;
831 
832   /* Do we need to have a unique contributor id for each customer */
833   bool public requireCustomerId = false;
834 
835   /* Has this crowdsale been configured */
836   bool public configured = false;
837 
838   /**
839    * Do we verify that contributor has been cleared on the server side (accredited investors only).
840    * This method was first used in the FirstBlood crowdsale to ensure all contributors had accepted terms of sale (on the web).
841    */
842   bool public requiredSignedAddress = false;
843 
844   /** Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
845   address public signerAddress;
846 
847   /** How many ETH each address has invested in this crowdsale */
848   mapping (address => uint) public investedAmountOf;
849 
850   /** How many tokens this crowdsale has credited for each investor address */
851   mapping (address => uint) public tokenAmountOf;
852 
853   /** Addresses that are allowed to invest even before ICO officially opens. For testing, for ICO partners, etc. */
854   mapping (address => bool) public earlyParticipantWhitelist;
855 
856   /** State machine
857    *
858    * - PendingConfiguration: Crowdsale not yet configured
859    * - Prefunding: We have not reached the starting timestamp yet
860    * - Funding: Active crowdsale
861    * - Success: Crowdsale ended
862    * - Finalized: The finalize function has been called and successfully executed
863    */
864   enum State{Unknown, PendingConfiguration, PreFunding, Funding, Success, Finalized}
865 
866 
867   // A new investment was made
868   event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
869 
870   // The rules about what kind of investments we accept were changed
871   event InvestmentPolicyChanged(bool requireCId, bool requireSignedAddress, address signer);
872 
873   // Address early participation whitelist status changed
874   event Whitelisted(address addr, bool status);
875 
876   // Crowdsale's finalize function has been called
877   event Finalized();
878 
879   /*
880    * The configuration from the constructor was moved to the configurationGenericCrowdsale function.
881    *
882    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
883    * @param start Timestamp where the crowdsale will be officially started. It should be greater than the timestamp in which the contract is deployed.
884    * @param end Timestamp where the crowdsale finishes. No tokens can be sold through this contract after this timestamp.
885    *
886    * configurationGenericCrowdsale can only be called when in State.PendingConfiguration because of the inState modifier.
887    */
888   function configurationGenericCrowdsale(address team_multisig, uint start, uint end) internal inState(State.PendingConfiguration) {
889     setMultisig(team_multisig);
890 
891     // Don't mess the dates
892     require(start != 0 && end != 0);
893     require(now < start && start < end);
894     startsAt = start;
895     endsAt = end;
896     configured = true;
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
922       require(earlyParticipantWhitelist[msg.sender]);
923     }
924 
925     uint weiAmount;
926     uint tokenAmount;
927     (weiAmount, tokenAmount) = calculateTokenAmount(msg.value, receiver);
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
986    * Investing function that recognizes the receiver and verifies he is allowed to invest.
987    *
988    * @param customerId UUIDv4 that identifies this contributor
989    */
990   function buyOnBehalfWithSignedAddress(address receiver, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable validCustomerId(customerId) {
991     bytes32 hash = sha256(receiver);
992     require(ecrecover(hash, v, r, s) == signerAddress);
993     investInternal(receiver, customerId);
994   }
995 
996   /**
997    * Investing function that recognizes the receiver.
998    * 
999    * @param customerId UUIDv4 that identifies this contributor
1000    */
1001   function buyOnBehalfWithCustomerId(address receiver, uint128 customerId) public payable validCustomerId(customerId) unsignedBuyAllowed {
1002     investInternal(receiver, customerId);
1003   }
1004 
1005   /**
1006    * Buys tokens on behalf of an address.
1007    *
1008    * Pay for funding, get invested tokens back in the receiver address.
1009    */
1010   function buyOnBehalf(address receiver) public payable unsignedBuyAllowed {
1011     require(!requireCustomerId); // Crowdsale needs to track participants for thank you email
1012     investInternal(receiver, 0);
1013   }
1014 
1015   /**
1016    * Investing function that recognizes the payer and verifies he is allowed to invest.
1017    *
1018    * @param customerId UUIDv4 that identifies this contributor
1019    */
1020   function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1021     buyOnBehalfWithSignedAddress(msg.sender, customerId, v, r, s);
1022   }
1023 
1024 
1025   /**
1026    * Investing function that recognizes the payer.
1027    * 
1028    * @param customerId UUIDv4 that identifies this contributor
1029    */
1030   function buyWithCustomerId(uint128 customerId) public payable {
1031     buyOnBehalfWithCustomerId(msg.sender, customerId);
1032   }
1033 
1034   /**
1035    * The basic entry point to participate in the crowdsale process.
1036    *
1037    * Pay for funding, get invested tokens back in the sender address.
1038    */
1039   function buy() public payable {
1040     buyOnBehalf(msg.sender);
1041   }
1042 
1043   /**
1044    * Finalize a successful crowdsale.
1045    *
1046    * The owner can trigger post-crowdsale actions, like releasing the tokens.
1047    * Note that by default tokens are not in a released state.
1048    */
1049   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1050     finalized = true;
1051     Finalized();
1052   }
1053 
1054   /**
1055    * Set policy do we need to have server-side customer ids for the investments.
1056    *
1057    */
1058   function setRequireCustomerId(bool value) public onlyOwner {
1059     requireCustomerId = value;
1060     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1061   }
1062 
1063   /**
1064    * Set policy if all investors must be cleared on the server side first.
1065    *
1066    * This is e.g. for the accredited investor clearing.
1067    *
1068    */
1069   function setRequireSignedAddress(bool value, address signer) public onlyOwner {
1070     requiredSignedAddress = value;
1071     signerAddress = signer;
1072     InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1073   }
1074 
1075   /**
1076    * Allow addresses to do early participation.
1077    */
1078   function setEarlyParticipantWhitelist(address addr, bool status) public onlyOwner notFinished stopInEmergency {
1079     earlyParticipantWhitelist[addr] = status;
1080     Whitelisted(addr, status);
1081   }
1082 
1083   /**
1084    * Internal setter for the multisig wallet
1085    */
1086   function setMultisig(address addr) internal {
1087     require(addr != 0);
1088     multisigWallet = addr;
1089   }
1090 
1091   /**
1092    * Crowdfund state machine management.
1093    *
1094    * This function has the timed transition builtin.
1095    * So there is no chance of the variable being stale.
1096    */
1097   function getState() public view returns (State) {
1098     if (finalized) return State.Finalized;
1099     else if (!configured) return State.PendingConfiguration;
1100     else if (now < startsAt) return State.PreFunding;
1101     else if (now <= endsAt && !isCrowdsaleFull()) return State.Funding;
1102     else return State.Success;
1103   }
1104 
1105   /** Internal functions that exist to provide inversion of control should they be overriden */
1106 
1107   /** Interface for the concrete instance to interact with the token contract in a customizable way */
1108   function assignTokens(address receiver, uint tokenAmount) internal;
1109 
1110   /**
1111    *  Determine if the goal was already reached in the current crowdsale
1112    */
1113   function isCrowdsaleFull() internal view returns (bool full);
1114 
1115   /**
1116    * Returns any excess wei received
1117    * 
1118    * This function can be overriden to provide a different refunding method.
1119    */
1120   function returnExcedent(uint excedent, address receiver) internal {
1121     if (excedent > 0) {
1122       receiver.transfer(excedent);
1123     }
1124   }
1125 
1126   /** 
1127    *  Calculate the amount of tokens that corresponds to the received amount.
1128    *  The wei amount is returned too in case not all of it can be invested.
1129    *
1130    *  Note: When there's an excedent due to rounding error, it should be returned to allow refunding.
1131    *  This is worked around in the current design using an appropriate amount of decimals in the FractionalERC20 standard.
1132    *  The workaround is good enough for most use cases, hence the simplified function signature.
1133    *  @return weiAllowed The amount of wei accepted in this transaction.
1134    *  @return tokenAmount The tokens that are assigned to the receiver in this transaction.
1135    */
1136   function calculateTokenAmount(uint weiAmount, address receiver) internal view returns (uint weiAllowed, uint tokenAmount);
1137 
1138   //
1139   // Modifiers
1140   //
1141 
1142   modifier inState(State state) {
1143     require(getState() == state);
1144     _;
1145   }
1146 
1147   modifier unsignedBuyAllowed() {
1148     require(!requiredSignedAddress);
1149     _;
1150   }
1151 
1152   /** Modifier allowing execution only if the crowdsale is currently running.  */
1153   modifier notFinished() {
1154     State current_state = getState();
1155     require(current_state == State.PreFunding || current_state == State.Funding);
1156     _;
1157   }
1158 
1159   modifier validCustomerId(uint128 customerId) {
1160     require(customerId != 0);  // UUIDv4 sanity check
1161     _;
1162   }
1163 }
1164 pragma solidity ^0.4.19;
1165 
1166 // Simple deployment information store inside contract storage.
1167 contract DeploymentInfo {
1168   uint private deployed_on;
1169 
1170   function DeploymentInfo() public {
1171     deployed_on = block.number;
1172   }
1173 
1174 
1175   function getDeploymentBlock() public view returns (uint) {
1176     return deployed_on;
1177   }
1178 }
1179 
1180 /**
1181  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1182  *
1183  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1184  *
1185  * Heavily modified by https://www.coinfabrik.com/
1186  */
1187 
1188 pragma solidity ^0.4.19;
1189 
1190 
1191 /// @dev Tranche based pricing.
1192 ///      Implementing "first price" tranches, meaning, that if a buyer's order is
1193 ///      covering more than one tranche, the price of the lowest tranche will apply
1194 ///      to the whole order.
1195 contract TokenTranchePricing {
1196 
1197   using SafeMath for uint;
1198 
1199   /**
1200    * Define pricing schedule using tranches.
1201    */
1202   struct Tranche {
1203       // Amount in tokens when this tranche becomes inactive
1204       uint amount;
1205       // Timestamp interval [start, end)
1206       // Starting timestamp (included in the interval)
1207       uint start;
1208       // Ending timestamp (excluded from the interval)
1209       uint end;
1210       // How many tokens per wei you will get while this tranche is active
1211       uint price;
1212   }
1213   // We define offsets and size for the deserialization of ordered tuples in raw arrays
1214   uint private constant amount_offset = 0;
1215   uint private constant start_offset = 1;
1216   uint private constant end_offset = 2;
1217   uint private constant price_offset = 3;
1218   uint private constant tranche_size = 4;
1219 
1220   Tranche[] public tranches;
1221 
1222   function getTranchesLength() public view returns (uint) {
1223     return tranches.length;
1224   }
1225   
1226   // The configuration from the constructor was moved to the configurationTokenTranchePricing function.
1227   //
1228   /// @dev Construction, creating a list of tranches
1229   /* @param init_tranches Raw array of ordered tuples: (start amount, start timestamp, end timestamp, price) */
1230   //
1231   function configurationTokenTranchePricing(uint[] init_tranches) internal {
1232     // Need to have tuples, length check
1233     require(init_tranches.length % tranche_size == 0);
1234     // A tranche with amount zero can never be selected and is therefore useless.
1235     // This check and the one inside the loop ensure no tranche can have an amount equal to zero.
1236     require(init_tranches[amount_offset] > 0);
1237 
1238     uint input_tranches_length = init_tranches.length.div(tranche_size);
1239     Tranche memory last_tranche;
1240     for (uint i = 0; i < input_tranches_length; i++) {
1241       uint tranche_offset = i.mul(tranche_size);
1242       uint amount = init_tranches[tranche_offset.add(amount_offset)];
1243       uint start = init_tranches[tranche_offset.add(start_offset)];
1244       uint end = init_tranches[tranche_offset.add(end_offset)];
1245       uint price = init_tranches[tranche_offset.add(price_offset)];
1246       // No invalid steps
1247       require(start < end && now < end);
1248       // Bail out when entering unnecessary tranches
1249       // This is preferably checked before deploying contract into any blockchain.
1250       require(i == 0 || (end >= last_tranche.end && amount > last_tranche.amount) ||
1251               (end > last_tranche.end && amount >= last_tranche.amount));
1252 
1253       last_tranche = Tranche(amount, start, end, price);
1254       tranches.push(last_tranche);
1255     }
1256   }
1257 
1258   /// @dev Get the current tranche or bail out if there is no tranche defined for the current timestamp.
1259   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1260   /// @return Returns the struct representing the current tranche
1261   function getCurrentTranche(uint tokensSold) private view returns (Tranche storage) {
1262     for (uint i = 0; i < tranches.length; i++) {
1263       if (tranches[i].start <= now && now < tranches[i].end && tokensSold < tranches[i].amount) {
1264         return tranches[i];
1265       }
1266     }
1267     // No tranche is currently active
1268     revert();
1269   }
1270 
1271   /// @dev Get the current price. May revert if there is no tranche currently active.
1272   /// @param tokensSold total amount of tokens sold, for calculating the current tranche
1273   /// @return The current price
1274   function getCurrentPrice(uint tokensSold) internal view returns (uint result) {
1275     return getCurrentTranche(tokensSold).price;
1276   }
1277 
1278 }
1279 
1280 // This contract has the sole objective of providing a sane concrete instance of the Crowdsale contract.
1281 contract Crowdsale is GenericCrowdsale, LostAndFoundToken, DeploymentInfo, TokenTranchePricing {
1282   uint public sellable_tokens;
1283   uint public initial_tokens;
1284   uint public milieurs_per_eth; 
1285 
1286   /*
1287    * The constructor for the crowdsale was removed given it didn't receive any arguments nor had any body.
1288    *
1289    * The configuration from the constructor was moved to the configurationCrowdsale function which creates the token contract and also calls the configuration functions from GenericCrowdsale and TokenTranchePricing.
1290    * 
1291    *
1292    * @param team_multisig Address of the multisignature wallet of the team that will receive all the funds contributed in the crowdsale.
1293    * @param start Timestamp where the crowdsale will be officially started. It should be greater than the timestamp in which the contract is deployed.
1294    * @param end Timestamp where the crowdsale finishes. No tokens can be sold through this contract after this timestamp.
1295    * @param token_retriever Address that will handle tokens accidentally sent to the token contract. See the LostAndFoundToken and CrowdsaleToken contracts for further details.
1296    */
1297 
1298   function configurationCrowdsale(address team_multisig, uint start, uint end, address token_retriever, uint[] init_tranches, uint multisig_supply, uint crowdsale_supply, uint8 token_decimals, uint max_tokens_to_sell) public onlyOwner {
1299 
1300       
1301       initial_tokens = multisig_supply;  
1302       token = new CrowdsaleToken(multisig_supply, token_decimals, team_multisig, token_retriever);
1303       // Necessary if assignTokens mints
1304       token.setMintAgent(address(this), true);
1305       // Necessary if finalize is overriden to release the tokens for public trading.
1306       token.setReleaseAgent(address(this));
1307       // Necessary for the execution of buy function and of the subsequent CrowdsaleToken's transfer function. 
1308       token.setTransferAgent(address(this), true);
1309       // Crowdsale mints to himself the initial supply
1310       token.mint(address(this), crowdsale_supply);
1311 
1312       sellable_tokens = max_tokens_to_sell;
1313 
1314       // Configuration functionality for GenericCrowdsale.
1315       configurationGenericCrowdsale(team_multisig, start, end);
1316 
1317       // Configuration functionality for TokenTranchePricing.
1318       configurationTokenTranchePricing(init_tranches);
1319   }
1320 
1321   //token assignation
1322   function assignTokens(address receiver, uint tokenAmount) internal {
1323     token.transfer(receiver, tokenAmount);
1324   }
1325 
1326   //token amount calculation
1327   function calculateTokenAmount(uint weiAmount, address receiver) internal view returns (uint weiAllowed, uint tokenAmount) {
1328     uint tokensPerEth = getCurrentPrice(tokensSold).mul(milieurs_per_eth).div(1000);
1329     uint maxWeiAllowed = sellable_tokens.sub(tokensSold).mul(1 ether).div(tokensPerEth);
1330     weiAllowed = maxWeiAllowed.min256(weiAmount);
1331 
1332     require(token.balanceOf(receiver).add(weiAllowed) >= 100);
1333     
1334     if (weiAmount < maxWeiAllowed) {
1335       //Divided by 1000 because eth eth_price_in_eurs is multiplied by 1000
1336       tokenAmount = tokensPerEth.mul(weiAmount).div(1 ether);
1337     }
1338     // With this case we let the crowdsale end even when there are rounding errors due to the tokens to wei ratio
1339     else {
1340       tokenAmount = sellable_tokens.sub(tokensSold);
1341     }
1342   }
1343 
1344   //TODO: implement to control funding state criterion
1345   function isCrowdsaleFull() internal view returns (bool full) {
1346     return tokensSold >= sellable_tokens;
1347   }
1348 
1349   /**
1350    * Finalize a successful crowdsale.
1351    *
1352    * The owner can trigger post-crowdsale actions, like releasing the tokens.
1353    * Note that by default tokens are not in a released state.
1354    */
1355   function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1356     //Tokens sold + bounties represent 75% of the total, the other 25% goes ti the multisig to the partners and to regulate market 
1357     uint sold = tokensSold.add(  initial_tokens);
1358     uint toShare = sold.mul(25).div(75).mul(10**uint(token.decimals()));
1359     token.setMintAgent(address(this), true);
1360     token.mint(multisigWallet, toShare);
1361     token.setMintAgent(address(this), false);
1362     token.releaseTokenTransfer();
1363     token.burn(token.balanceOf(address(this)));
1364     super.finalize();
1365   }
1366 
1367   /**
1368    * This function decides who handles lost tokens.
1369    * Do note that this function is NOT meant to be used in a token refund mecahnism.
1370    * Its sole purpose is determining who can move around ERC20 tokens accidentally sent to this contract.
1371    */
1372   function getLostAndFoundMaster() internal view returns (address) {
1373     return owner;
1374 
1375   }
1376 
1377   // These two setters are present only to correct timestamps if they are off from their target date by more than, say, a day
1378   function setStartingTime(uint startingTime) public onlyOwner inState(State.PreFunding) {
1379       require(startingTime > now && startingTime < endsAt);
1380       startsAt = startingTime;
1381   }
1382 
1383   function setEndingTime(uint endingTime) public onlyOwner notFinished {
1384        require(endingTime > now && endingTime > startsAt);
1385        endsAt = endingTime;
1386   }
1387 
1388 
1389 
1390   function updateEursPerEth (uint milieurs_amount) public onlyOwner {
1391     require(milieurs_amount >= 100);
1392     milieurs_per_eth = milieurs_amount;
1393   }
1394 }