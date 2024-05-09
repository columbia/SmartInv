1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 /**
16  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
17  *
18  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
19  */
20 
21 
22 
23 
24 
25 
26 /**
27  * @title ERC20Basic
28  * @dev Simpler version of ERC20 interface
29  * @dev see https://github.com/ethereum/EIPs/issues/179
30  */
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) public constant returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 
39 
40 /**
41  * @title ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/20
43  */
44 contract ERC20 is ERC20Basic {
45   function allowance(address owner, address spender) public constant returns (uint256);
46   function transferFrom(address from, address to, uint256 value) public returns (bool);
47   function approve(address spender, uint256 value) public returns (bool);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 /**
52  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
53  *
54  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
55  */
56 
57 
58 
59 
60 
61 
62 
63 
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
71     uint256 c = a * b;
72     assert(a == 0 || c / a == b);
73     return c;
74   }
75 
76   function div(uint256 a, uint256 b) internal constant returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   function add(uint256 a, uint256 b) internal constant returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155 
156     uint256 _allowance = allowed[_from][msg.sender];
157 
158     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159     // require (_value <= _allowance);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    */
200   function increaseApproval (address _spender, uint _addedValue)
201     returns (bool success) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   function decreaseApproval (address _spender, uint _subtractedValue)
208     returns (bool success) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 
222 
223 /**
224  * Standard EIP-20 token with an interface marker.
225  *
226  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
227  *
228  */
229 contract StandardTokenExt is StandardToken {
230 
231   /* Interface declaration */
232   function isToken() public constant returns (bool weAre) {
233     return true;
234   }
235 }
236 
237 /**
238  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
239  *
240  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
241  */
242 
243 
244 /**
245  * Upgrade agent interface inspired by Lunyr.
246  *
247  * Upgrade agent transfers tokens to a new contract.
248  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
249  */
250 contract UpgradeAgent {
251 
252   uint public originalSupply;
253 
254   /** Interface marker */
255   function isUpgradeAgent() public constant returns (bool) {
256     return true;
257   }
258 
259   function upgradeFrom(address _from, uint256 _value) public;
260 
261 }
262 
263 
264 /**
265  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
266  *
267  * First envisioned by Golem and Lunyr projects.
268  */
269 contract UpgradeableToken is StandardTokenExt {
270 
271   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
272   address public upgradeMaster;
273 
274   /** The next contract where the tokens will be migrated. */
275   UpgradeAgent public upgradeAgent;
276 
277   /** How many tokens we have upgraded by now. */
278   uint256 public totalUpgraded;
279 
280   /**
281    * Upgrade states.
282    *
283    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
284    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
285    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
286    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
287    *
288    */
289   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
290 
291   /**
292    * Somebody has upgraded some of his tokens.
293    */
294   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
295 
296   /**
297    * New upgrade agent available.
298    */
299   event UpgradeAgentSet(address agent);
300 
301   /**
302    * Do not allow construction without upgrade master set.
303    */
304   function UpgradeableToken(address _upgradeMaster) {
305     upgradeMaster = _upgradeMaster;
306   }
307 
308   /**
309    * Allow the token holder to upgrade some of their tokens to a new contract.
310    */
311   function upgrade(uint256 value) public {
312 
313       UpgradeState state = getUpgradeState();
314       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
315         // Called in a bad state
316         throw;
317       }
318 
319       // Validate input value.
320       if (value == 0) throw;
321 
322       balances[msg.sender] = balances[msg.sender].sub(value);
323 
324       // Take tokens out from circulation
325       totalSupply = totalSupply.sub(value);
326       totalUpgraded = totalUpgraded.add(value);
327 
328       // Upgrade agent reissues the tokens
329       upgradeAgent.upgradeFrom(msg.sender, value);
330       Upgrade(msg.sender, upgradeAgent, value);
331   }
332 
333   /**
334    * Set an upgrade agent that handles
335    */
336   function setUpgradeAgent(address agent) external {
337 
338       if(!canUpgrade()) {
339         // The token is not yet in a state that we could think upgrading
340         throw;
341       }
342 
343       if (agent == 0x0) throw;
344       // Only a master can designate the next agent
345       if (msg.sender != upgradeMaster) throw;
346       // Upgrade has already begun for an agent
347       if (getUpgradeState() == UpgradeState.Upgrading) throw;
348 
349       upgradeAgent = UpgradeAgent(agent);
350 
351       // Bad interface
352       if(!upgradeAgent.isUpgradeAgent()) throw;
353       // Make sure that token supplies match in source and target
354       if (upgradeAgent.originalSupply() != totalSupply) throw;
355 
356       UpgradeAgentSet(upgradeAgent);
357   }
358 
359   /**
360    * Get the state of the token upgrade.
361    */
362   function getUpgradeState() public constant returns(UpgradeState) {
363     if(!canUpgrade()) return UpgradeState.NotAllowed;
364     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
365     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
366     else return UpgradeState.Upgrading;
367   }
368 
369   /**
370    * Change the upgrade master.
371    *
372    * This allows us to set a new owner for the upgrade mechanism.
373    */
374   function setUpgradeMaster(address master) public {
375       if (master == 0x0) throw;
376       if (msg.sender != upgradeMaster) throw;
377       upgradeMaster = master;
378   }
379 
380   /**
381    * Child contract can enable to provide the condition when the upgrade can begun.
382    */
383   function canUpgrade() public constant returns(bool) {
384      return true;
385   }
386 
387 }
388 
389 /**
390  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
391  *
392  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
393  */
394 
395 
396 
397 
398 /**
399  * @title Ownable
400  * @dev The Ownable contract has an owner address, and provides basic authorization control
401  * functions, this simplifies the implementation of "user permissions".
402  */
403 contract Ownable {
404   address public owner;
405 
406 
407   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409 
410   /**
411    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
412    * account.
413    */
414   function Ownable() {
415     owner = msg.sender;
416   }
417 
418 
419   /**
420    * @dev Throws if called by any account other than the owner.
421    */
422   modifier onlyOwner() {
423     require(msg.sender == owner);
424     _;
425   }
426 
427 
428   /**
429    * @dev Allows the current owner to transfer control of the contract to a newOwner.
430    * @param newOwner The address to transfer ownership to.
431    */
432   function transferOwnership(address newOwner) onlyOwner public {
433     require(newOwner != address(0));
434     OwnershipTransferred(owner, newOwner);
435     owner = newOwner;
436   }
437 
438 }
439 
440 
441 
442 
443 /**
444  * Define interface for releasing the token transfer after a successful crowdsale.
445  */
446 contract ReleasableToken is ERC20, Ownable {
447 
448   /* The finalizer contract that allows unlift the transfer limits on this token */
449   address public releaseAgent;
450 
451   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
452   bool public released = false;
453 
454   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
455   mapping (address => bool) public transferAgents;
456 
457   /**
458    * Limit token transfer until the crowdsale is over.
459    *
460    */
461   modifier canTransfer(address _sender) {
462 
463     if(!released) {
464         if(!transferAgents[_sender]) {
465             throw;
466         }
467     }
468 
469     _;
470   }
471 
472   /**
473    * Set the contract that can call release and make the token transferable.
474    *
475    * Design choice. Allow reset the release agent to fix fat finger mistakes.
476    */
477   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
478 
479     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
480     releaseAgent = addr;
481   }
482 
483   /**
484    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
485    */
486   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
487     transferAgents[addr] = state;
488   }
489 
490   /**
491    * One way function to release the tokens to the wild.
492    *
493    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
494    */
495   function releaseTokenTransfer() public onlyReleaseAgent {
496     released = true;
497   }
498 
499   /** The function can be called only before or after the tokens have been releasesd */
500   modifier inReleaseState(bool releaseState) {
501     if(releaseState != released) {
502         throw;
503     }
504     _;
505   }
506 
507   /** The function can be called only by a whitelisted release agent. */
508   modifier onlyReleaseAgent() {
509     if(msg.sender != releaseAgent) {
510         throw;
511     }
512     _;
513   }
514 
515   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
516     // Call StandardToken.transfer()
517    return super.transfer(_to, _value);
518   }
519 
520   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
521     // Call StandardToken.transferForm()
522     return super.transferFrom(_from, _to, _value);
523   }
524 
525 }
526 
527 /**
528  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
529  *
530  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
531  */
532 
533 
534 
535 
536 /**
537  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
538  *
539  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
540  */
541 
542 
543 /**
544  * Safe unsigned safe math.
545  *
546  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
547  *
548  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
549  *
550  * Maintained here until merged to mainline zeppelin-solidity.
551  *
552  */
553 library SafeMathLib {
554 
555   function times(uint a, uint b) returns (uint) {
556     uint c = a * b;
557     assert(a == 0 || c / a == b);
558     return c;
559   }
560 
561   function minus(uint a, uint b) returns (uint) {
562     assert(b <= a);
563     return a - b;
564   }
565 
566   function plus(uint a, uint b) returns (uint) {
567     uint c = a + b;
568     assert(c>=a);
569     return c;
570   }
571 
572 }
573 
574 
575 
576 /**
577  * A token that can increase its supply by another contract.
578  *
579  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
580  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
581  *
582  */
583 contract MintableToken is StandardTokenExt, Ownable {
584 
585   using SafeMathLib for uint;
586 
587   bool public mintingFinished = false;
588 
589   /** List of agents that are allowed to create new tokens */
590   mapping (address => bool) public mintAgents;
591 
592   event MintingAgentChanged(address addr, bool state);
593   event Minted(address receiver, uint amount);
594 
595   /**
596    * Create new tokens and allocate them to an address..
597    *
598    * Only callably by a crowdsale contract (mint agent).
599    */
600   function mint(address receiver, uint amount) onlyMintAgent canMint public {
601     totalSupply = totalSupply.plus(amount);
602     balances[receiver] = balances[receiver].plus(amount);
603 
604     // This will make the mint transaction apper in EtherScan.io
605     // We can remove this after there is a standardized minting event
606     Transfer(0, receiver, amount);
607   }
608 
609   /**
610    * Owner can allow a crowdsale contract to mint new tokens.
611    */
612   function setMintAgent(address addr, bool state) onlyOwner canMint public {
613     mintAgents[addr] = state;
614     MintingAgentChanged(addr, state);
615   }
616 
617   modifier onlyMintAgent() {
618     // Only crowdsale contracts are allowed to mint new tokens
619     if(!mintAgents[msg.sender]) {
620         throw;
621     }
622     _;
623   }
624 
625   /** Make sure we are not done yet. */
626   modifier canMint() {
627     if(mintingFinished) throw;
628     _;
629   }
630 }
631 
632 
633 
634 /**
635  * A crowdsaled token.
636  *
637  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
638  *
639  * - The token transfer() is disabled until the crowdsale is over
640  * - The token contract gives an opt-in upgrade path to a new contract
641  * - The same token can be part of several crowdsales through approve() mechanism
642  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
643  *
644  */
645 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
646 
647   /** Name and symbol were updated. */
648   event UpdatedTokenInformation(string newName, string newSymbol);
649 
650   string public name;
651 
652   string public symbol;
653 
654   uint public decimals;
655 
656   /**
657    * Construct the token.
658    *
659    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
660    *
661    * @param _name Token name
662    * @param _symbol Token symbol - should be all caps
663    * @param _initialSupply How many tokens we start with
664    * @param _decimals Number of decimal places
665    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
666    */
667   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
668     UpgradeableToken(msg.sender) {
669 
670     // Create any address, can be transferred
671     // to team multisig via changeOwner(),
672     // also remember to call setUpgradeMaster()
673     owner = msg.sender;
674 
675     name = _name;
676     symbol = _symbol;
677 
678     totalSupply = _initialSupply;
679 
680     decimals = _decimals;
681 
682     // Create initially all balance on the team multisig
683     balances[owner] = totalSupply;
684 
685     if(totalSupply > 0) {
686       Minted(owner, totalSupply);
687     }
688 
689     // No more new supply allowed after the token creation
690     if(!_mintable) {
691       mintingFinished = true;
692       if(totalSupply == 0) {
693         throw; // Cannot create a token without supply and no minting
694       }
695     }
696   }
697 
698   /**
699    * When token is released to be transferable, enforce no new tokens can be created.
700    */
701   function releaseTokenTransfer() public onlyReleaseAgent {
702     mintingFinished = true;
703     super.releaseTokenTransfer();
704   }
705 
706   /**
707    * Allow upgrade agent functionality kick in only if the crowdsale was success.
708    */
709   function canUpgrade() public constant returns(bool) {
710     return released && super.canUpgrade();
711   }
712 
713   /**
714    * Owner can update token information here.
715    *
716    * It is often useful to conceal the actual token association, until
717    * the token operations, like central issuance or reissuance have been completed.
718    *
719    * This function allows the token owner to rename the token after the operations
720    * have been completed and then point the audience to use the token contract.
721    */
722   function setTokenInformation(string _name, string _symbol) onlyOwner {
723     name = _name;
724     symbol = _symbol;
725 
726     UpdatedTokenInformation(name, symbol);
727   }
728 
729 }
730 
731 
732 
733 /**
734  * Hold tokens for a group investor of investors until the unlock date.
735  *
736  * After the unlock date the investor can claim their tokens.
737  *
738  * Steps
739  *
740  * - Prepare a spreadsheet for token allocation
741  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
742  * - Call setInvestor for all investors from the owner account using a local script and CSV input
743  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
744  * - Call lock from the owner account
745  * - Wait until the freeze period is over
746  * - After the freeze time is over investors can call claim() from their address to get their tokens
747  *
748  */
749 contract TokenVault is Ownable {
750 
751   /** How many investors we have now */
752   uint public investorCount;
753 
754   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
755   uint public tokensToBeAllocated;
756 
757   /** How many tokens investors have claimed so far */
758   uint public totalClaimed;
759 
760   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
761   uint public tokensAllocatedTotal;
762 
763   /** How much we have allocated to the investors invested */
764   mapping(address => uint) public balances;
765 
766   /** How many tokens investors have claimed */
767   mapping(address => uint) public claimed;
768 
769   /** When our claim freeze is over (UNIX timestamp) */
770   uint public freezeEndsAt;
771 
772   /** When this vault was locked (UNIX timestamp) */
773   uint public lockedAt;
774 
775   /** We can also define our own token, which will override the ICO one ***/
776   CrowdsaleToken public token;
777 
778   /** What is our current state.
779    *
780    * Loading: Investor data is being loaded and contract not yet locked
781    * Holding: Holding tokens for investors
782    * Distributing: Freeze time is over, investors can claim their tokens
783    */
784   enum State{Unknown, Loading, Holding, Distributing}
785 
786   /** We allocated tokens for investor */
787   event Allocated(address investor, uint value);
788 
789   /** We distributed tokens to an investor */
790   event Distributed(address investors, uint count);
791 
792   event Locked();
793 
794   /**
795    * Create presale contract where lock up period is given days
796    *
797    * @param _owner Who can load investor data and lock
798    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
799    * @param _token Token contract address we are distributing
800    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
801    *
802    */
803   function TokenVault(address _owner, uint _freezeEndsAt, CrowdsaleToken _token, uint _tokensToBeAllocated) {
804 
805     owner = _owner;
806 
807     // Invalid owenr
808     if(owner == 0) {
809       throw;
810     }
811 
812     token = _token;
813 
814     // Check the address looks like a token contract
815     if(!token.isToken()) {
816       throw;
817     }
818 
819     // Give argument
820     if(_freezeEndsAt == 0) {
821       throw;
822     }
823 
824     // Sanity check on _tokensToBeAllocated
825     if(_tokensToBeAllocated == 0) {
826       throw;
827     }
828 
829     freezeEndsAt = _freezeEndsAt;
830     tokensToBeAllocated = _tokensToBeAllocated;
831   }
832 
833   /// @dev Add a presale participating allocation
834   function setInvestor(address investor, uint amount) public onlyOwner {
835 
836     if(lockedAt > 0) {
837       // Cannot add new investors after the vault is locked
838       throw;
839     }
840 
841     if(amount == 0) throw; // No empty buys
842 
843     // Don't allow reset
844     if(balances[investor] > 0) {
845       throw;
846     }
847 
848     balances[investor] = amount;
849 
850     investorCount++;
851 
852     tokensAllocatedTotal += amount;
853 
854     Allocated(investor, amount);
855   }
856 
857   /// @dev Lock the vault
858   ///      - All balances have been loaded in correctly
859   ///      - Tokens are transferred on this vault correctly
860   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
861   function lock() onlyOwner {
862 
863     if(lockedAt > 0) {
864       throw; // Already locked
865     }
866 
867     // Spreadsheet sum does not match to what we have loaded to the investor data
868     if(tokensAllocatedTotal != tokensToBeAllocated) {
869       throw;
870     }
871 
872     // Do not lock the vault if the given tokens are not on this contract
873     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
874       throw;
875     }
876 
877     lockedAt = now;
878 
879     Locked();
880   }
881 
882   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
883   function recoverFailedLock() onlyOwner {
884     if(lockedAt > 0) {
885       throw;
886     }
887 
888     // Transfer all tokens on this contract back to the owner
889     token.transfer(owner, token.balanceOf(address(this)));
890   }
891 
892   /// @dev Get the current balance of tokens in the vault
893   /// @return uint How many tokens there are currently in vault
894   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
895     return token.balanceOf(address(this));
896   }
897 
898   /// @dev Claim N bought tokens to the investor as the msg sender
899   function claim() {
900 
901     address investor = msg.sender;
902 
903     if(lockedAt == 0) {
904       throw; // We were never locked
905     }
906 
907     if(now < freezeEndsAt) {
908       throw; // Trying to claim early
909     }
910 
911     if(balances[investor] == 0) {
912       // Not our investor
913       throw;
914     }
915 
916     if(claimed[investor] > 0) {
917       throw; // Already claimed
918     }
919 
920     uint amount = balances[investor];
921 
922     claimed[investor] = amount;
923 
924     totalClaimed += amount;
925 
926     token.transfer(investor, amount);
927 
928     Distributed(investor, amount);
929   }
930 
931   /// @dev Resolve the contract umambigious state
932   function getState() public constant returns(State) {
933     if(lockedAt == 0) {
934       return State.Loading;
935     } else if(now > freezeEndsAt) {
936       return State.Distributing;
937     } else {
938       return State.Holding;
939     }
940   }
941 
942 }