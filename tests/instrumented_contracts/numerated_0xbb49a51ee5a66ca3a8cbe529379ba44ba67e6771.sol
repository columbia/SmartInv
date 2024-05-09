1 pragma solidity ^0.4.19;
2 
3 /**
4  * Originally from https://github.com/TokenMarketNet/ico
5  * Modified by https://www.coinfabrik.com/
6  */
7 
8 pragma solidity ^0.4.19;
9 
10 /**
11  * Originally from https://github.com/TokenMarketNet/ico
12  * Modified by https://www.coinfabrik.com/
13  */
14 
15 pragma solidity ^0.4.19;
16 
17 /**
18  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
19  * Modified by https://www.coinfabrik.com/
20  */
21 
22 pragma solidity ^0.4.19;
23 
24 /**
25  * Interface for the standard token.
26  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
27  */
28 contract EIP20Token {
29 
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address who) public view returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool success);
33   function transferFrom(address from, address to, uint256 value) public returns (bool success);
34   function approve(address spender, uint256 value) public returns (bool success);
35   function allowance(address owner, address spender) public view returns (uint256 remaining);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39   /**
40   ** Optional functions
41   *
42   function name() public view returns (string name);
43   function symbol() public view returns (string symbol);
44   function decimals() public view returns (uint8 decimals);
45   *
46   **/
47 
48 }
49 pragma solidity ^0.4.19;
50 
51 /**
52  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
53  * Modified by https://www.coinfabrik.com/
54  */
55 
56 /**
57  * Math operations with safety checks
58  */
59 library SafeMath {
60   function mul(uint a, uint b) internal pure returns (uint) {
61     uint c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function div(uint a, uint b) internal pure returns (uint) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint a, uint b) internal pure returns (uint) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint a, uint b) internal pure returns (uint) {
79     uint c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 
84   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
85     return a >= b ? a : b;
86   }
87 
88   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
89     return a < b ? a : b;
90   }
91 
92   function max256(uint a, uint b) internal pure returns (uint) {
93     return a >= b ? a : b;
94   }
95 
96   function min256(uint a, uint b) internal pure returns (uint) {
97     return a < b ? a : b;
98   }
99 }
100 
101 pragma solidity ^0.4.19;
102 
103 // Interface for burning tokens
104 contract Burnable {
105   // @dev Destroys tokens for an account
106   // @param account Account whose tokens are destroyed
107   // @param value Amount of tokens to destroy
108   function burnTokens(address account, uint value) internal;
109   event Burned(address account, uint value);
110 }
111 pragma solidity ^0.4.19;
112 
113 /**
114  * Authored by https://www.coinfabrik.com/
115  */
116 
117 
118 /**
119  * Internal interface for the minting of tokens.
120  */
121 contract Mintable {
122 
123   /**
124    * @dev Mints tokens for an account
125    * This function should the Minted event.
126    */
127   function mintInternal(address receiver, uint amount) internal;
128 
129   /** Token supply got increased and a new owner received these tokens */
130   event Minted(address receiver, uint amount);
131 }
132 
133 /**
134  * @title Standard token
135  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
136  */
137 contract StandardToken is EIP20Token, Burnable, Mintable {
138   using SafeMath for uint;
139 
140   uint private total_supply;
141   mapping(address => uint) private balances;
142   mapping(address => mapping (address => uint)) private allowed;
143 
144 
145   function totalSupply() public view returns (uint) {
146     return total_supply;
147   }
148 
149   /**
150    * @dev transfer token for a specified address
151    * @param to The address to transfer to.
152    * @param value The amount to be transferred.
153    */
154   function transfer(address to, uint value) public returns (bool success) {
155     balances[msg.sender] = balances[msg.sender].sub(value);
156     balances[to] = balances[to].add(value);
157     Transfer(msg.sender, to, value);
158     return true;
159   }
160 
161   /**
162    * @dev Gets the balance of the specified address.
163    * @param account The address whose balance is to be queried.
164    * @return An uint representing the amount owned by the passed address.
165    */
166   function balanceOf(address account) public view returns (uint balance) {
167     return balances[account];
168   }
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param from address The address which you want to send tokens from
173    * @param to address The address which you want to transfer to
174    * @param value uint the amout of tokens to be transfered
175    */
176   function transferFrom(address from, address to, uint value) public returns (bool success) {
177     uint allowance = allowed[from][msg.sender];
178 
179     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
180     // require(value <= allowance);
181     // SafeMath uses assert instead of require though, beware when using an analysis tool
182 
183     balances[from] = balances[from].sub(value);
184     balances[to] = balances[to].add(value);
185     allowed[from][msg.sender] = allowance.sub(value);
186     Transfer(from, to, value);
187     return true;
188   }
189 
190   /**
191    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    * @param spender The address which will spend the funds.
193    * @param value The amount of tokens to be spent.
194    */
195   function approve(address spender, uint value) public returns (bool success) {
196 
197     // To change the approve amount you first have to reduce the addresses'
198     //  allowance to zero by calling `approve(spender, 0)` if it is not
199     //  already 0 to mitigate the race condition described here:
200     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201     require (value == 0 || allowed[msg.sender][spender] == 0);
202 
203     allowed[msg.sender][spender] = value;
204     Approval(msg.sender, spender, value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens than an owner allowed to a spender.
210    * @param account address The address which owns the funds.
211    * @param spender address The address which will spend the funds.
212    * @return A uint specifing the amount of tokens still avaible for the spender.
213    */
214   function allowance(address account, address spender) public view returns (uint remaining) {
215     return allowed[account][spender];
216   }
217 
218   /**
219    * Atomic increment of approved spending
220    *
221    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    *
223    */
224   function addApproval(address spender, uint addedValue) public returns (bool success) {
225       uint oldValue = allowed[msg.sender][spender];
226       allowed[msg.sender][spender] = oldValue.add(addedValue);
227       Approval(msg.sender, spender, allowed[msg.sender][spender]);
228       return true;
229   }
230 
231   /**
232    * Atomic decrement of approved spending.
233    *
234    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    */
236   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
237 
238       uint oldVal = allowed[msg.sender][spender];
239 
240       if (subtractedValue > oldVal) {
241           allowed[msg.sender][spender] = 0;
242       } else {
243           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
244       }
245       Approval(msg.sender, spender, allowed[msg.sender][spender]);
246       return true;
247   }
248 
249   /**
250    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
251    */
252   function burnTokens(address account, uint value) internal {
253     balances[account] = balances[account].sub(value);
254     total_supply = total_supply.sub(value);
255     Transfer(account, 0, value);
256     Burned(account, value);
257   }
258 
259   /**
260    * @dev Provides an internal minting function.
261    */
262   function mintInternal(address receiver, uint amount) internal {
263     total_supply = total_supply.add(amount);
264     balances[receiver] = balances[receiver].add(amount);
265     Minted(receiver, amount);
266 
267     // Beware: Address zero may be used for special transactions in a future fork.
268     // This will make the mint transaction appear in EtherScan.io
269     // We can remove this after there is a standardized minting event
270     Transfer(0, receiver, amount);
271   }
272   
273 }
274 pragma solidity ^0.4.19;
275 
276 /**
277  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
278  * Modified by https://www.coinfabrik.com/
279  */
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control 
284  * functions, this simplifies the implementation of "user permissions". 
285  */
286 contract Ownable {
287   address public owner;
288 
289 
290   /** 
291    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
292    * account.
293    */
294   function Ownable() internal {
295     owner = msg.sender;
296   }
297 
298 
299   /**
300    * @dev Throws if called by any account other than the owner. 
301    */
302   modifier onlyOwner() {
303     require(msg.sender == owner);
304     _;
305   }
306 
307 
308   /**
309    * @dev Allows the current owner to transfer control of the contract to a newOwner.
310    * @param newOwner The address to transfer ownership to. 
311    */
312   function transferOwnership(address newOwner) onlyOwner public {
313     require(newOwner != address(0));
314     owner = newOwner;
315   }
316 
317 }
318 
319 /**
320  * Define interface for releasing the token transfer after a successful crowdsale.
321  */
322 contract ReleasableToken is StandardToken, Ownable {
323 
324   /* The finalizer contract that allows lifting the transfer limits on this token */
325   address public releaseAgent;
326 
327   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
328   bool public released = false;
329 
330   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
331   mapping (address => bool) public transferAgents;
332 
333   /**
334    * Set the contract that can call release and make the token transferable.
335    *
336    * Since the owner of this contract is (or should be) the crowdsale,
337    * it can only be called by a corresponding exposed API in the crowdsale contract in case of input error.
338    */
339   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
340     // We don't do interface check here as we might want to have a normal wallet address to act as a release agent.
341     releaseAgent = addr;
342   }
343 
344   /**
345    * Owner can allow a particular address (e.g. a crowdsale contract) to transfer tokens despite the lock up period.
346    */
347   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
348     transferAgents[addr] = state;
349   }
350 
351   /**
352    * One way function to release the tokens into the wild.
353    *
354    * Can be called only from the release agent that should typically be the finalize agent ICO contract.
355    * In the scope of the crowdsale, it is only called if the crowdsale has been a success (first milestone reached).
356    */
357   function releaseTokenTransfer() public onlyReleaseAgent {
358     released = true;
359   }
360 
361   /**
362    * Limit token transfer until the crowdsale is over.
363    */
364   modifier canTransfer(address sender) {
365     require(released || transferAgents[sender]);
366     _;
367   }
368 
369   /** The function can be called only before or after the tokens have been released */
370   modifier inReleaseState(bool releaseState) {
371     require(releaseState == released);
372     _;
373   }
374 
375   /** The function can be called only by a whitelisted release agent. */
376   modifier onlyReleaseAgent() {
377     require(msg.sender == releaseAgent);
378     _;
379   }
380 
381   /** We restrict transfer by overriding it */
382   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
383     // Call StandardToken.transfer()
384    return super.transfer(to, value);
385   }
386 
387   /** We restrict transferFrom by overriding it */
388   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
389     // Call StandardToken.transferForm()
390     return super.transferFrom(from, to, value);
391   }
392 
393 }
394 
395 
396 
397 pragma solidity ^0.4.19;
398 
399 /**
400  * First envisioned by Golem and Lunyr projects.
401  * Originally from https://github.com/TokenMarketNet/ico
402  * Modified by https://www.coinfabrik.com/
403  */
404 
405 pragma solidity ^0.4.19;
406 
407 /**
408  * Inspired by Lunyr.
409  * Originally from https://github.com/TokenMarketNet/ico
410  */
411 
412 /**
413  * Upgrade agent transfers tokens to a new contract.
414  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
415  *
416  * The Upgrade agent is the interface used to implement a token
417  * migration in the case of an emergency.
418  * The function upgradeFrom has to implement the part of the creation
419  * of new tokens on behalf of the user doing the upgrade.
420  *
421  * The new token can implement this interface directly, or use.
422  */
423 contract UpgradeAgent {
424 
425   /** This value should be the same as the original token's total supply */
426   uint public originalSupply;
427 
428   /** Interface to ensure the contract is correctly configured */
429   function isUpgradeAgent() public pure returns (bool) {
430     return true;
431   }
432 
433   /**
434   Upgrade an account
435 
436   When the token contract is in the upgrade status the each user will
437   have to call `upgrade(value)` function from UpgradeableToken.
438 
439   The upgrade function adjust the balance of the user and the supply
440   of the previous token and then call `upgradeFrom(value)`.
441 
442   The UpgradeAgent is the responsible to create the tokens for the user
443   in the new contract.
444 
445   * @param from Account to upgrade.
446   * @param value Tokens to upgrade.
447 
448   */
449   function upgradeFrom(address from, uint value) public;
450 
451 }
452 
453 
454 /**
455  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
456  *
457  */
458 contract UpgradeableToken is EIP20Token, Burnable {
459   using SafeMath for uint;
460 
461   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
462   address public upgradeMaster;
463 
464   /** The next contract where the tokens will be migrated. */
465   UpgradeAgent public upgradeAgent;
466 
467   /** How many tokens we have upgraded by now. */
468   uint public totalUpgraded = 0;
469 
470   /**
471    * Upgrade states.
472    *
473    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
474    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
475    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet. This allows changing the upgrade agent while there is time.
476    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
477    *
478    */
479   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
480 
481   /**
482    * Somebody has upgraded some of his tokens.
483    */
484   event Upgrade(address indexed from, address to, uint value);
485 
486   /**
487    * New upgrade agent available.
488    */
489   event UpgradeAgentSet(address agent);
490 
491   /**
492    * Do not allow construction without upgrade master set.
493    */
494   function UpgradeableToken(address master) internal {
495     setUpgradeMaster(master);
496   }
497 
498   /**
499    * Allow the token holder to upgrade some of their tokens to a new contract.
500    */
501   function upgrade(uint value) public {
502     UpgradeState state = getUpgradeState();
503     // Ensure it's not called in a bad state
504     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
505 
506     // Validate input value.
507     require(value != 0);
508 
509     // Upgrade agent reissues the tokens
510     upgradeAgent.upgradeFrom(msg.sender, value);
511     
512     // Take tokens out from circulation
513     burnTokens(msg.sender, value);
514     totalUpgraded = totalUpgraded.add(value);
515 
516     Upgrade(msg.sender, upgradeAgent, value);
517   }
518 
519   /**
520    * Set an upgrade agent that handles the upgrade process
521    */
522   function setUpgradeAgent(address agent) onlyMaster external {
523     // Check whether the token is in a state that we could think of upgrading
524     require(canUpgrade());
525 
526     require(agent != 0x0);
527     // Upgrade has already begun for an agent
528     require(getUpgradeState() != UpgradeState.Upgrading);
529 
530     upgradeAgent = UpgradeAgent(agent);
531 
532     // Bad interface
533     require(upgradeAgent.isUpgradeAgent());
534     // Make sure that token supplies match in source and target
535     require(upgradeAgent.originalSupply() == totalSupply());
536 
537     UpgradeAgentSet(upgradeAgent);
538   }
539 
540   /**
541    * Get the state of the token upgrade.
542    */
543   function getUpgradeState() public view returns(UpgradeState) {
544     if (!canUpgrade()) return UpgradeState.NotAllowed;
545     else if (address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
546     else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
547     else return UpgradeState.Upgrading;
548   }
549 
550   /**
551    * Change the upgrade master.
552    *
553    * This allows us to set a new owner for the upgrade mechanism.
554    */
555   function changeUpgradeMaster(address new_master) onlyMaster public {
556     setUpgradeMaster(new_master);
557   }
558 
559   /**
560    * Internal upgrade master setter.
561    */
562   function setUpgradeMaster(address new_master) private {
563     require(new_master != 0x0);
564     upgradeMaster = new_master;
565   }
566 
567   /**
568    * Child contract can override to provide the condition in which the upgrade can begin.
569    */
570   function canUpgrade() public view returns(bool) {
571      return true;
572   }
573 
574 
575   modifier onlyMaster() {
576     require(msg.sender == upgradeMaster);
577     _;
578   }
579 }
580 
581 pragma solidity ^0.4.19;
582 
583 /**
584  * Authored by https://www.coinfabrik.com/
585  */
586 
587 
588 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
589 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
590 // Of course, this contract imposes support costs upon whoever is the lost and found master.
591 contract LostAndFoundToken {
592   /**
593    * @return Address of the account that handles movements.
594    */
595   function getLostAndFoundMaster() internal view returns (address);
596 
597   /**
598    * @param agent Address that will be able to move tokens with transferFrom
599    * @param tokens Amount of tokens approved for transfer
600    * @param token_contract Contract of the token
601    */
602   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
603     require(msg.sender == getLostAndFoundMaster());
604     // We use approve instead of transfer to minimize the possibility of the lost and found master
605     //  getting them stuck in another address by accident.
606     token_contract.approve(agent, tokens);
607   }
608 }
609 pragma solidity ^0.4.19;
610 
611 /**
612  * Originally from https://github.com/TokenMarketNet/ico
613  * Modified by https://www.coinfabrik.com/
614  */
615 
616 
617 /**
618  * A public interface to increase the supply of a token.
619  *
620  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
621  * Only mint agents, usually contracts whitelisted by the owner, can mint new tokens.
622  *
623  */
624 contract MintableToken is Mintable, Ownable {
625 
626   using SafeMath for uint;
627 
628   bool public mintingFinished = false;
629 
630   /** List of agents that are allowed to create new tokens */
631   mapping (address => bool) public mintAgents;
632 
633   event MintingAgentChanged(address addr, bool state);
634 
635 
636   function MintableToken(uint initialSupply, address multisig, bool mintable) internal {
637     require(multisig != address(0));
638     // Cannot create a token without supply and no minting
639     require(mintable || initialSupply != 0);
640     // Create initially all balance on the team multisig
641     if (initialSupply > 0)
642       mintInternal(multisig, initialSupply);
643     // No more new supply allowed after the token creation
644     mintingFinished = !mintable;
645   }
646 
647   /**
648    * Create new tokens and allocate them to an address.
649    *
650    * Only callable by a mint agent (e.g. crowdsale contract).
651    */
652   function mint(address receiver, uint amount) onlyMintAgent canMint public {
653     mintInternal(receiver, amount);
654   }
655 
656   /**
657    * Owner can allow a crowdsale contract to mint new tokens.
658    */
659   function setMintAgent(address addr, bool state) onlyOwner canMint public {
660     mintAgents[addr] = state;
661     MintingAgentChanged(addr, state);
662   }
663 
664   modifier onlyMintAgent() {
665     // Only mint agents are allowed to mint new tokens
666     require(mintAgents[msg.sender]);
667     _;
668   }
669 
670   /** Make sure we are not done yet. */
671   modifier canMint() {
672     require(!mintingFinished);
673     _;
674   }
675 }
676 
677 /**
678  * A crowdsale token.
679  *
680  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
681  *
682  * - The token transfer() is disabled until the crowdsale is over
683  * - The token contract gives an opt-in upgrade path to a new contract
684  * - The same token can be part of several crowdsales through the approve() mechanism
685  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
686  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
687  *
688  */
689 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
690 
691   string public name = "Cryptosolartech";
692 
693   string public symbol = "CST";
694 
695   uint8 public decimals;
696 
697   address public lost_and_found_master;
698 
699   /**
700    * Construct the token.
701    *
702    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
703    *
704    * @param initial_supply How many tokens we start with.
705    * @param token_decimals Number of decimal places.
706    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
707    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
708    */
709   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, address token_retriever) public
710   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, true) {
711     require(token_retriever != address(0));
712     decimals = token_decimals;
713     lost_and_found_master = token_retriever;
714   }
715 
716   /**
717    * When token is released to be transferable, prohibit new token creation.
718    */
719   function releaseTokenTransfer() public onlyReleaseAgent {
720     mintingFinished = true;
721     super.releaseTokenTransfer();
722   }
723 
724   /**
725    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
726    */
727   function canUpgrade() public view returns(bool) {
728     return released && super.canUpgrade();
729   }
730 
731   function burn(uint value) public {
732     burnTokens(msg.sender, value);
733   }
734 
735   function getLostAndFoundMaster() internal view returns(address) {
736     return lost_and_found_master;
737   }
738 }