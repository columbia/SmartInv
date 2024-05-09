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