1 pragma solidity ^0.4.18;
2 
3 /**
4  * Interface for the standard token.
5  * Based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6  */
7 contract EIP20Token {
8 
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool success);
12   function transferFrom(address from, address to, uint256 value) public returns (bool success);
13   function approve(address spender, uint256 value) public returns (bool success);
14   function allowance(address owner, address spender) public view returns (uint256 remaining);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18   /**
19   ** Optional functions
20   *
21   function name() public view returns (string name);
22   function symbol() public view returns (string symbol);
23   function decimals() public view returns (uint8 decimals);
24   *
25   **/
26 
27 }
28 pragma solidity ^0.4.18;
29 
30 /**
31  * Originally from  https://github.com/OpenZeppelin/zeppelin-solidity
32  * Modified by https://www.coinfabrik.com/
33  */
34 
35 /**
36  * Math operations with safety checks
37  */
38 library SafeMath {
39   function mul(uint a, uint b) internal pure returns (uint) {
40     uint c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function div(uint a, uint b) internal pure returns (uint) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint a, uint b) internal pure returns (uint) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint a, uint b) internal pure returns (uint) {
58     uint c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 
63   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
64     return a >= b ? a : b;
65   }
66 
67   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
68     return a < b ? a : b;
69   }
70 
71   function max256(uint a, uint b) internal pure returns (uint) {
72     return a >= b ? a : b;
73   }
74 
75   function min256(uint a, uint b) internal pure returns (uint) {
76     return a < b ? a : b;
77   }
78 }
79 
80 pragma solidity ^0.4.18;
81 
82 // Interface for burning tokens
83 contract Burnable {
84   // @dev Destroys tokens for an account
85   // @param account Account whose tokens are destroyed
86   // @param value Amount of tokens to destroy
87   function burnTokens(address account, uint value) internal;
88   event Burned(address account, uint value);
89 }
90 pragma solidity ^0.4.18;
91 
92 /**
93  * Authored by https://www.coinfabrik.com/
94  */
95 
96 
97 /**
98  * Internal interface for the minting of tokens.
99  */
100 contract Mintable {
101 
102   /**
103    * @dev Mints tokens for an account
104    * This function should emit the Minted event.
105    */
106   function mintInternal(address receiver, uint amount) internal;
107 
108   /** Token supply got increased and a new owner received these tokens */
109   event Minted(address receiver, uint amount);
110 }
111 
112 /**
113  * @title Standard token
114  * @dev Basic implementation of the EIP20 standard token (also known as ERC20 token).
115  */
116 contract StandardToken is EIP20Token, Burnable, Mintable {
117   using SafeMath for uint;
118 
119   uint private total_supply;
120   mapping(address => uint) private balances;
121   mapping(address => mapping (address => uint)) private allowed;
122 
123 
124   function totalSupply() public view returns (uint) {
125     return total_supply;
126   }
127 
128   /**
129    * @dev transfer token for a specified address
130    * @param to The address to transfer to.
131    * @param value The amount to be transferred.
132    */
133   function transfer(address to, uint value) public returns (bool success) {
134     balances[msg.sender] = balances[msg.sender].sub(value);
135     balances[to] = balances[to].add(value);
136     Transfer(msg.sender, to, value);
137     return true;
138   }
139 
140   /**
141    * @dev Gets the balance of the specified address.
142    * @param account The address whose balance is to be queried.
143    * @return An uint representing the amount owned by the passed address.
144    */
145   function balanceOf(address account) public view returns (uint balance) {
146     return balances[account];
147   }
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param from address The address which you want to send tokens from
152    * @param to address The address which you want to transfer to
153    * @param value uint the amout of tokens to be transfered
154    */
155   function transferFrom(address from, address to, uint value) public returns (bool success) {
156     uint allowance = allowed[from][msg.sender];
157 
158     // Check is not needed because sub(allowance, value) will already throw if this condition is not met
159     // require(value <= allowance);
160     // SafeMath uses assert instead of require though, beware when using an analysis tool
161 
162     balances[from] = balances[from].sub(value);
163     balances[to] = balances[to].add(value);
164     allowed[from][msg.sender] = allowance.sub(value);
165     Transfer(from, to, value);
166     return true;
167   }
168 
169   /**
170    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint value) public returns (bool success) {
175 
176     // To change the approve amount you first have to reduce the addresses'
177     //  allowance to zero by calling `approve(spender, 0)` if it is not
178     //  already 0 to mitigate the race condition described here:
179     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180     require (value == 0 || allowed[msg.sender][spender] == 0);
181 
182     allowed[msg.sender][spender] = value;
183     Approval(msg.sender, spender, value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens than an owner allowed to a spender.
189    * @param account address The address which owns the funds.
190    * @param spender address The address which will spend the funds.
191    * @return A uint specifing the amount of tokens still avaible for the spender.
192    */
193   function allowance(address account, address spender) public view returns (uint remaining) {
194     return allowed[account][spender];
195   }
196 
197   /**
198    * Atomic increment of approved spending
199    *
200    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    *
202    */
203   function addApproval(address spender, uint addedValue) public returns (bool success) {
204       uint oldValue = allowed[msg.sender][spender];
205       allowed[msg.sender][spender] = oldValue.add(addedValue);
206       Approval(msg.sender, spender, allowed[msg.sender][spender]);
207       return true;
208   }
209 
210   /**
211    * Atomic decrement of approved spending.
212    *
213    * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    */
215   function subApproval(address spender, uint subtractedValue) public returns (bool success) {
216 
217       uint oldVal = allowed[msg.sender][spender];
218 
219       if (subtractedValue > oldVal) {
220           allowed[msg.sender][spender] = 0;
221       } else {
222           allowed[msg.sender][spender] = oldVal.sub(subtractedValue);
223       }
224       Approval(msg.sender, spender, allowed[msg.sender][spender]);
225       return true;
226   }
227 
228   /**
229    * @dev Provides an internal function for destroying tokens. Useful for upgrades.
230    */
231   function burnTokens(address account, uint value) internal {
232     balances[account] = balances[account].sub(value);
233     total_supply = total_supply.sub(value);
234     Transfer(account, 0, value);
235     Burned(account, value);
236   }
237 
238   /**
239    * @dev Provides an internal minting function.
240    */
241   function mintInternal(address receiver, uint amount) internal {
242     total_supply = total_supply.add(amount);
243     balances[receiver] = balances[receiver].add(amount);
244     Minted(receiver, amount);
245 
246     // Beware: Address zero may be used for special transactions in a future fork.
247     // This will make the mint transaction appear in EtherScan.io
248     // We can remove this after there is a standardized minting event
249     Transfer(0, receiver, amount);
250   }
251   
252 }
253 pragma solidity ^0.4.18;
254 
255 /**
256  * Originally from https://github.com/OpenZeppelin/zeppelin-solidity
257  * Modified by https://www.coinfabrik.com/
258  */
259 
260 /**
261  * @title Ownable
262  * @dev The Ownable contract has an owner address, and provides basic authorization control 
263  * functions, this simplifies the implementation of "user permissions". 
264  */
265 contract Ownable {
266   address public owner;
267 
268 
269   /** 
270    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
271    * account.
272    */
273   function Ownable() internal {
274     owner = msg.sender;
275   }
276 
277 
278   /**
279    * @dev Throws if called by any account other than the owner. 
280    */
281   modifier onlyOwner() {
282     require(msg.sender == owner);
283     _;
284   }
285 
286 
287   /**
288    * @dev Allows the current owner to transfer control of the contract to a newOwner.
289    * @param newOwner The address to transfer ownership to. 
290    */
291   function transferOwnership(address newOwner) onlyOwner public {
292     require(newOwner != address(0));
293     owner = newOwner;
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
343   modifier canTransfer(address sender) {
344     require(released || transferAgents[sender]);
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
361   function transfer(address to, uint value) public canTransfer(msg.sender) returns (bool success) {
362     // Call StandardToken.transfer()
363    return super.transfer(to, value);
364   }
365 
366   /** We restrict transferFrom by overriding it */
367   function transferFrom(address from, address to, uint value) public canTransfer(from) returns (bool success) {
368     // Call StandardToken.transferForm()
369     return super.transferFrom(from, to, value);
370   }
371 
372 }
373 
374 
375 
376 pragma solidity ^0.4.18;
377 
378 /**
379  * First envisioned by Golem and Lunyr projects.
380  * Originally from https://github.com/TokenMarketNet/ico
381  * Modified by https://www.coinfabrik.com/
382  */
383 
384 pragma solidity ^0.4.18;
385 
386 /**
387  * Inspired by Lunyr.
388  * Originally from https://github.com/TokenMarketNet/ico
389  */
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
560 pragma solidity ^0.4.18;
561 
562 /**
563  * Authored by https://www.coinfabrik.com/
564  */
565 
566 
567 // This contract aims to provide an inheritable way to recover tokens from a contract not meant to hold tokens
568 // To use this contract, have your token-ignoring contract inherit this one and implement getLostAndFoundMaster to decide who can move lost tokens.
569 // Of course, this contract imposes support costs upon whoever is the lost and found master.
570 contract LostAndFoundToken {
571   /**
572    * @return Address of the account that handles movements.
573    */
574   function getLostAndFoundMaster() internal view returns (address);
575 
576   /**
577    * @param agent Address that will be able to move tokens with transferFrom
578    * @param tokens Amount of tokens approved for transfer
579    * @param token_contract Contract of the token
580    */
581   function enableLostAndFound(address agent, uint tokens, EIP20Token token_contract) public {
582     require(msg.sender == getLostAndFoundMaster());
583     // We use approve instead of transfer to minimize the possibility of the lost and found master
584     //  getting them stuck in another address by accident.
585     token_contract.approve(agent, tokens);
586   }
587 }
588 pragma solidity ^0.4.18;
589 
590 /**
591  * Originally from https://github.com/TokenMarketNet/ico
592  * Modified by https://www.coinfabrik.com/
593  */
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
656 /**
657  * A crowdsale token.
658  *
659  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
660  *
661  * - The token transfer() is disabled until the crowdsale is over
662  * - The token contract gives an opt-in upgrade path to a new contract
663  * - The same token can be part of several crowdsales through the approve() mechanism
664  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
665  * - ERC20 tokens transferred to this contract can be recovered by a lost and found master
666  *
667  */
668 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken, LostAndFoundToken {
669 
670   string public name = "Ubanx";
671 
672   string public symbol = "BANX";
673 
674   uint8 public decimals;
675 
676   address public lost_and_found_master;
677 
678   /**
679    * Construct the token.
680    *
681    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
682    *
683    * @param initial_supply How many tokens we start with.
684    * @param token_decimals Number of decimal places.
685    * @param team_multisig Address of the multisig that receives the initial supply and is set as the upgrade master.
686    * @param mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
687    * @param token_retriever Address of the account that handles ERC20 tokens that were accidentally sent to this contract.
688    */
689   function CrowdsaleToken(uint initial_supply, uint8 token_decimals, address team_multisig, bool mintable, address token_retriever) public
690   UpgradeableToken(team_multisig) MintableToken(initial_supply, team_multisig, mintable) {
691     require(token_retriever != address(0));
692     decimals = token_decimals;
693     lost_and_found_master = token_retriever;
694   }
695 
696   /**
697    * When token is released to be transferable, prohibit new token creation.
698    */
699   function releaseTokenTransfer() public onlyReleaseAgent {
700     mintingFinished = true;
701     super.releaseTokenTransfer();
702   }
703 
704   /**
705    * Allow upgrade agent functionality to kick in only if the crowdsale was a success.
706    */
707   function canUpgrade() public view returns(bool) {
708     return released && super.canUpgrade();
709   }
710 
711   function getLostAndFoundMaster() internal view returns(address) {
712     return lost_and_found_master;
713   }
714 
715   /**
716    * We allow anyone to burn their tokens if they wish to do so.
717    * We want to use this in the finalize function of the crowdsale in particular.
718    */
719   function burn(uint amount) public {
720     burnTokens(msg.sender, amount);
721   }
722 
723 }