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
33   function balanceOf(address who) constant returns (uint256);
34   function transfer(address to, uint256 value) returns (bool);
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
45   function allowance(address owner, address spender) constant returns (uint256);
46   function transferFrom(address from, address to, uint256 value) returns (bool);
47   function approve(address spender, uint256 value) returns (bool);
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
111   function transfer(address _to, uint256 _value) returns (bool) {
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of. 
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) constant returns (uint256 balance) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 
130 
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amout of tokens to be transfered
149    */
150   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
151     var _allowance = allowed[_from][msg.sender];
152 
153     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
154     // require (_value <= _allowance);
155 
156     balances[_to] = balances[_to].add(_value);
157     balances[_from] = balances[_from].sub(_value);
158     allowed[_from][msg.sender] = _allowance.sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) returns (bool) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifing the amount of tokens still available for the spender.
186    */
187   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191 }
192 
193 
194 
195 /**
196  * Standard EIP-20 token with an interface marker.
197  *
198  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
199  *
200  */
201 contract StandardTokenExt is StandardToken {
202 
203   /* Interface declaration */
204   function isToken() public constant returns (bool weAre) {
205     return true;
206   }
207 }
208 
209 /**
210  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
211  *
212  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
213  */
214 
215 
216 /**
217  * Upgrade agent interface inspired by Lunyr.
218  *
219  * Upgrade agent transfers tokens to a new contract.
220  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
221  */
222 contract UpgradeAgent {
223 
224   uint public originalSupply;
225 
226   /** Interface marker */
227   function isUpgradeAgent() public constant returns (bool) {
228     return true;
229   }
230 
231   function upgradeFrom(address _from, uint256 _value) public;
232 
233 }
234 
235 
236 /**
237  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
238  *
239  * First envisioned by Golem and Lunyr projects.
240  */
241 contract UpgradeableToken is StandardTokenExt {
242 
243   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
244   address public upgradeMaster;
245 
246   /** The next contract where the tokens will be migrated. */
247   UpgradeAgent public upgradeAgent;
248 
249   /** How many tokens we have upgraded by now. */
250   uint256 public totalUpgraded;
251 
252   /**
253    * Upgrade states.
254    *
255    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
256    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
257    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
258    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
259    *
260    */
261   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
262 
263   /**
264    * Somebody has upgraded some of his tokens.
265    */
266   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
267 
268   /**
269    * New upgrade agent available.
270    */
271   event UpgradeAgentSet(address agent);
272 
273   /**
274    * Do not allow construction without upgrade master set.
275    */
276   function UpgradeableToken(address _upgradeMaster) {
277     upgradeMaster = _upgradeMaster;
278   }
279 
280   /**
281    * Allow the token holder to upgrade some of their tokens to a new contract.
282    */
283   function upgrade(uint256 value) public {
284 
285       UpgradeState state = getUpgradeState();
286       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
287         // Called in a bad state
288         throw;
289       }
290 
291       // Validate input value.
292       if (value == 0) throw;
293 
294       balances[msg.sender] = balances[msg.sender].sub(value);
295 
296       // Take tokens out from circulation
297       totalSupply = totalSupply.sub(value);
298       totalUpgraded = totalUpgraded.add(value);
299 
300       // Upgrade agent reissues the tokens
301       upgradeAgent.upgradeFrom(msg.sender, value);
302       Upgrade(msg.sender, upgradeAgent, value);
303   }
304 
305   /**
306    * Set an upgrade agent that handles
307    */
308   function setUpgradeAgent(address agent) external {
309 
310       if(!canUpgrade()) {
311         // The token is not yet in a state that we could think upgrading
312         throw;
313       }
314 
315       if (agent == 0x0) throw;
316       // Only a master can designate the next agent
317       if (msg.sender != upgradeMaster) throw;
318       // Upgrade has already begun for an agent
319       if (getUpgradeState() == UpgradeState.Upgrading) throw;
320 
321       upgradeAgent = UpgradeAgent(agent);
322 
323       // Bad interface
324       if(!upgradeAgent.isUpgradeAgent()) throw;
325       // Make sure that token supplies match in source and target
326       if (upgradeAgent.originalSupply() != totalSupply) throw;
327 
328       UpgradeAgentSet(upgradeAgent);
329   }
330 
331   /**
332    * Get the state of the token upgrade.
333    */
334   function getUpgradeState() public constant returns(UpgradeState) {
335     if(!canUpgrade()) return UpgradeState.NotAllowed;
336     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
337     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
338     else return UpgradeState.Upgrading;
339   }
340 
341   /**
342    * Change the upgrade master.
343    *
344    * This allows us to set a new owner for the upgrade mechanism.
345    */
346   function setUpgradeMaster(address master) public {
347       if (master == 0x0) throw;
348       if (msg.sender != upgradeMaster) throw;
349       upgradeMaster = master;
350   }
351 
352   /**
353    * Child contract can enable to provide the condition when the upgrade can begun.
354    */
355   function canUpgrade() public constant returns(bool) {
356      return true;
357   }
358 
359 }
360 
361 /**
362  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
363  *
364  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
365  */
366 
367 
368 
369 
370 /**
371  * @title Ownable
372  * @dev The Ownable contract has an owner address, and provides basic authorization control
373  * functions, this simplifies the implementation of "user permissions".
374  */
375 contract Ownable {
376   address public owner;
377 
378 
379   /**
380    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
381    * account.
382    */
383   function Ownable() {
384     owner = msg.sender;
385   }
386 
387 
388   /**
389    * @dev Throws if called by any account other than the owner.
390    */
391   modifier onlyOwner() {
392     require(msg.sender == owner);
393     _;
394   }
395 
396 
397   /**
398    * @dev Allows the current owner to transfer control of the contract to a newOwner.
399    * @param newOwner The address to transfer ownership to.
400    */
401   function transferOwnership(address newOwner) onlyOwner {
402     require(newOwner != address(0));      
403     owner = newOwner;
404   }
405 
406 }
407 
408 
409 
410 
411 /**
412  * Define interface for releasing the token transfer after a successful crowdsale.
413  */
414 contract ReleasableToken is ERC20, Ownable {
415 
416   /* The finalizer contract that allows unlift the transfer limits on this token */
417   address public releaseAgent;
418 
419   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
420   bool public released = false;
421 
422   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
423   mapping (address => bool) public transferAgents;
424 
425   /**
426    * Limit token transfer until the crowdsale is over.
427    *
428    */
429   modifier canTransfer(address _sender) {
430 
431     if(!released) {
432         if(!transferAgents[_sender]) {
433             throw;
434         }
435     }
436 
437     _;
438   }
439 
440   /**
441    * Set the contract that can call release and make the token transferable.
442    *
443    * Design choice. Allow reset the release agent to fix fat finger mistakes.
444    */
445   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
446 
447     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
448     releaseAgent = addr;
449   }
450 
451   /**
452    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
453    */
454   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
455     transferAgents[addr] = state;
456   }
457 
458   /**
459    * One way function to release the tokens to the wild.
460    *
461    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
462    */
463   function releaseTokenTransfer() public onlyReleaseAgent {
464     released = true;
465   }
466 
467   /** The function can be called only before or after the tokens have been releasesd */
468   modifier inReleaseState(bool releaseState) {
469     if(releaseState != released) {
470         throw;
471     }
472     _;
473   }
474 
475   /** The function can be called only by a whitelisted release agent. */
476   modifier onlyReleaseAgent() {
477     if(msg.sender != releaseAgent) {
478         throw;
479     }
480     _;
481   }
482 
483   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
484     // Call StandardToken.transfer()
485    return super.transfer(_to, _value);
486   }
487 
488   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
489     // Call StandardToken.transferForm()
490     return super.transferFrom(_from, _to, _value);
491   }
492 
493 }
494 
495 /**
496  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
497  *
498  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
499  */
500 
501 
502 
503 
504 /**
505  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
506  *
507  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
508  */
509 
510 
511 /**
512  * Safe unsigned safe math.
513  *
514  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
515  *
516  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
517  *
518  * Maintained here until merged to mainline zeppelin-solidity.
519  *
520  */
521 library SafeMathLib {
522 
523   function times(uint a, uint b) returns (uint) {
524     uint c = a * b;
525     assert(a == 0 || c / a == b);
526     return c;
527   }
528 
529   function minus(uint a, uint b) returns (uint) {
530     assert(b <= a);
531     return a - b;
532   }
533 
534   function plus(uint a, uint b) returns (uint) {
535     uint c = a + b;
536     assert(c>=a);
537     return c;
538   }
539 
540 }
541 
542 
543 
544 /**
545  * A token that can increase its supply by another contract.
546  *
547  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
548  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
549  *
550  */
551 contract MintableToken is StandardTokenExt, Ownable {
552 
553   using SafeMathLib for uint;
554 
555   bool public mintingFinished = false;
556 
557   /** List of agents that are allowed to create new tokens */
558   mapping (address => bool) public mintAgents;
559 
560   event MintingAgentChanged(address addr, bool state);
561   event Minted(address receiver, uint amount);
562 
563   /**
564    * Create new tokens and allocate them to an address..
565    *
566    * Only callably by a crowdsale contract (mint agent).
567    */
568   function mint(address receiver, uint amount) onlyMintAgent canMint public {
569     totalSupply = totalSupply.plus(amount);
570     balances[receiver] = balances[receiver].plus(amount);
571 
572     // This will make the mint transaction apper in EtherScan.io
573     // We can remove this after there is a standardized minting event
574     Transfer(0, receiver, amount);
575   }
576 
577   /**
578    * Owner can allow a crowdsale contract to mint new tokens.
579    */
580   function setMintAgent(address addr, bool state) onlyOwner canMint public {
581     mintAgents[addr] = state;
582     MintingAgentChanged(addr, state);
583   }
584 
585   modifier onlyMintAgent() {
586     // Only crowdsale contracts are allowed to mint new tokens
587     if(!mintAgents[msg.sender]) {
588         throw;
589     }
590     _;
591   }
592 
593   /** Make sure we are not done yet. */
594   modifier canMint() {
595     if(mintingFinished) throw;
596     _;
597   }
598 }
599 
600 
601 
602 /**
603  * A crowdsaled token.
604  *
605  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
606  *
607  * - The token transfer() is disabled until the crowdsale is over
608  * - The token contract gives an opt-in upgrade path to a new contract
609  * - The same token can be part of several crowdsales through approve() mechanism
610  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
611  *
612  */
613 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
614 
615   /** Name and symbol were updated. */
616   event UpdatedTokenInformation(string newName, string newSymbol);
617 
618   string public name;
619 
620   string public symbol;
621 
622   uint public decimals;
623 
624   /**
625    * Construct the token.
626    *
627    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
628    *
629    * @param _name Token name
630    * @param _symbol Token symbol - should be all caps
631    * @param _initialSupply How many tokens we start with
632    * @param _decimals Number of decimal places
633    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
634    */
635   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
636     UpgradeableToken(msg.sender) {
637 
638     // Create any address, can be transferred
639     // to team multisig via changeOwner(),
640     // also remember to call setUpgradeMaster()
641     owner = msg.sender;
642 
643     name = _name;
644     symbol = _symbol;
645 
646     totalSupply = _initialSupply;
647 
648     decimals = _decimals;
649 
650     // Create initially all balance on the team multisig
651     balances[owner] = totalSupply;
652 
653     if(totalSupply > 0) {
654       Minted(owner, totalSupply);
655     }
656 
657     // No more new supply allowed after the token creation
658     if(!_mintable) {
659       mintingFinished = true;
660       if(totalSupply == 0) {
661         throw; // Cannot create a token without supply and no minting
662       }
663     }
664   }
665 
666   /**
667    * When token is released to be transferable, enforce no new tokens can be created.
668    */
669   function releaseTokenTransfer() public onlyReleaseAgent {
670     mintingFinished = true;
671     super.releaseTokenTransfer();
672   }
673 
674   /**
675    * Allow upgrade agent functionality kick in only if the crowdsale was success.
676    */
677   function canUpgrade() public constant returns(bool) {
678     return released && super.canUpgrade();
679   }
680 
681   /**
682    * Owner can update token information here.
683    *
684    * It is often useful to conceal the actual token association, until
685    * the token operations, like central issuance or reissuance have been completed.
686    *
687    * This function allows the token owner to rename the token after the operations
688    * have been completed and then point the audience to use the token contract.
689    */
690   function setTokenInformation(string _name, string _symbol) onlyOwner {
691     name = _name;
692     symbol = _symbol;
693 
694     UpdatedTokenInformation(name, symbol);
695   }
696 
697 }
698 
699 
700 
701 /**
702  * Hold tokens for a group investor of investors until the unlock date.
703  *
704  * After the unlock date the investor can claim their tokens.
705  *
706  * Steps
707  *
708  * - Prepare a spreadsheet for token allocation
709  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
710  * - Call setInvestor for all investors from the owner account using a local script and CSV input
711  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
712  * - Call lock from the owner account
713  * - Wait until the freeze period is over
714  * - After the freeze time is over investors can call claim() from their address to get their tokens
715  *
716  */
717 contract TokenVault is Ownable {
718 
719   /** How many investors we have now */
720   uint public investorCount;
721 
722   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
723   uint public tokensToBeAllocated;
724 
725   /** How many tokens investors have claimed so far */
726   uint public totalClaimed;
727 
728   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
729   uint public tokensAllocatedTotal;
730 
731   /** How much we have allocated to the investors invested */
732   mapping(address => uint) public balances;
733 
734   /** How many tokens investors have claimed */
735   mapping(address => uint) public claimed;
736 
737   /** When our claim freeze is over (UNIX timestamp) */
738   uint public freezeEndsAt;
739 
740   /** When this vault was locked (UNIX timestamp) */
741   uint public lockedAt;
742 
743   /** We can also define our own token, which will override the ICO one ***/
744   CrowdsaleToken public token;
745 
746   /** What is our current state.
747    *
748    * Loading: Investor data is being loaded and contract not yet locked
749    * Holding: Holding tokens for investors
750    * Distributing: Freeze time is over, investors can claim their tokens
751    */
752   enum State{Unknown, Loading, Holding, Distributing}
753 
754   /** We allocated tokens for investor */
755   event Allocated(address investor, uint value);
756 
757   /** We distributed tokens to an investor */
758   event Distributed(address investors, uint count);
759 
760   event Locked();
761 
762   /**
763    * Create presale contract where lock up period is given days
764    *
765    * @param _owner Who can load investor data and lock
766    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
767    * @param _token Token contract address we are distributing
768    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
769    *
770    */
771   function TokenVault(address _owner, uint _freezeEndsAt, CrowdsaleToken _token, uint _tokensToBeAllocated) {
772 
773     owner = _owner;
774 
775     // Invalid owenr
776     if(owner == 0) {
777       throw;
778     }
779 
780     token = _token;
781 
782     // Check the address looks like a token contract
783     if(!token.isToken()) {
784       throw;
785     }
786 
787     // Give argument
788     if(_freezeEndsAt == 0) {
789       throw;
790     }
791 
792     // Sanity check on _tokensToBeAllocated
793     if(_tokensToBeAllocated == 0) {
794       throw;
795     }
796 
797     freezeEndsAt = _freezeEndsAt;
798     tokensToBeAllocated = _tokensToBeAllocated;
799   }
800 
801   /// @dev Add a presale participating allocation
802   function setInvestor(address investor, uint amount) public onlyOwner {
803 
804     if(lockedAt > 0) {
805       // Cannot add new investors after the vault is locked
806       throw;
807     }
808 
809     if(amount == 0) throw; // No empty buys
810 
811     // Don't allow reset
812     if(balances[investor] > 0) {
813       throw;
814     }
815 
816     balances[investor] = amount;
817 
818     investorCount++;
819 
820     tokensAllocatedTotal += amount;
821 
822     Allocated(investor, amount);
823   }
824 
825   /// @dev Lock the vault
826   ///      - All balances have been loaded in correctly
827   ///      - Tokens are transferred on this vault correctly
828   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
829   function lock() onlyOwner {
830 
831     if(lockedAt > 0) {
832       throw; // Already locked
833     }
834 
835     // Spreadsheet sum does not match to what we have loaded to the investor data
836     if(tokensAllocatedTotal != tokensToBeAllocated) {
837       throw;
838     }
839 
840     // Do not lock the vault if the given tokens are not on this contract
841     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
842       throw;
843     }
844 
845     lockedAt = now;
846 
847     Locked();
848   }
849 
850   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
851   function recoverFailedLock() onlyOwner {
852     if(lockedAt > 0) {
853       throw;
854     }
855 
856     // Transfer all tokens on this contract back to the owner
857     token.transfer(owner, token.balanceOf(address(this)));
858   }
859 
860   /// @dev Get the current balance of tokens in the vault
861   /// @return uint How many tokens there are currently in vault
862   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
863     return token.balanceOf(address(this));
864   }
865 
866   /// @dev Claim N bought tokens to the investor as the msg sender
867   function claim() {
868 
869     address investor = msg.sender;
870 
871     if(lockedAt == 0) {
872       throw; // We were never locked
873     }
874 
875     if(now < freezeEndsAt) {
876       throw; // Trying to claim early
877     }
878 
879     if(balances[investor] == 0) {
880       // Not our investor
881       throw;
882     }
883 
884     if(claimed[investor] > 0) {
885       throw; // Already claimed
886     }
887 
888     uint amount = balances[investor];
889 
890     claimed[investor] = amount;
891 
892     totalClaimed += amount;
893 
894     token.transfer(investor, amount);
895 
896     Distributed(investor, amount);
897   }
898 
899   /// @dev Resolve the contract umambigious state
900   function getState() public constant returns(State) {
901     if(lockedAt == 0) {
902       return State.Loading;
903     } else if(now > freezeEndsAt) {
904       return State.Distributing;
905     } else {
906       return State.Holding;
907     }
908   }
909 
910 }