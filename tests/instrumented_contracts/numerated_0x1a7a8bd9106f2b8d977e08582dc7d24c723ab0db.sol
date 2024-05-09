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
22 /**
23  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
24  *
25  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
26  */
27 
28 
29 
30 
31 
32 
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) constant returns (uint256);
43   function transfer(address to, uint256 value) returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal constant returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal constant returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances. 
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) returns (bool) {
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of. 
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) constant returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) constant returns (uint256);
124   function transferFrom(address from, address to, uint256 value) returns (bool);
125   function approve(address spender, uint256 value) returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amout of tokens to be transfered
148    */
149   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
150     var _allowance = allowed[_from][msg.sender];
151 
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // require (_value <= _allowance);
154 
155     balances[_to] = balances[_to].add(_value);
156     balances[_from] = balances[_from].sub(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) returns (bool) {
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifing the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 
193 
194 /**
195  * Standard EIP-20 token with an interface marker.
196  *
197  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
198  *
199  */
200 contract StandardTokenExt is StandardToken {
201 
202   /* Interface declaration */
203   function isToken() public constant returns (bool weAre) {
204     return true;
205   }
206 }
207 
208 
209 contract BurnableToken is StandardTokenExt {
210 
211   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
212   address public constant BURN_ADDRESS = 0;
213 
214   /** How many tokens we burned */
215   event Burned(address burner, uint burnedAmount);
216 
217   /**
218    * Burn extra tokens from a balance.
219    *
220    */
221   function burn(uint burnAmount) {
222     address burner = msg.sender;
223     balances[burner] = balances[burner].sub(burnAmount);
224     totalSupply = totalSupply.sub(burnAmount);
225     Burned(burner, burnAmount);
226 
227     // Inform the blockchain explores that track the
228     // balances only by a transfer event that the balance in this
229     // address has decreased
230     Transfer(burner, BURN_ADDRESS, burnAmount);
231   }
232 }
233 
234 /**
235  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
236  *
237  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
238  */
239 
240 
241 /**
242  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
243  *
244  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
245  */
246 
247 
248 
249 
250 /**
251  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
252  *
253  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
254  */
255 
256 
257 /**
258  * Upgrade agent interface inspired by Lunyr.
259  *
260  * Upgrade agent transfers tokens to a new contract.
261  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
262  */
263 contract UpgradeAgent {
264 
265   uint public originalSupply;
266 
267   /** Interface marker */
268   function isUpgradeAgent() public constant returns (bool) {
269     return true;
270   }
271 
272   function upgradeFrom(address _from, uint256 _value) public;
273 
274 }
275 
276 
277 /**
278  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
279  *
280  * First envisioned by Golem and Lunyr projects.
281  */
282 contract UpgradeableToken is StandardTokenExt {
283 
284   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
285   address public upgradeMaster;
286 
287   /** The next contract where the tokens will be migrated. */
288   UpgradeAgent public upgradeAgent;
289 
290   /** How many tokens we have upgraded by now. */
291   uint256 public totalUpgraded;
292 
293   /**
294    * Upgrade states.
295    *
296    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
297    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
298    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
299    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
300    *
301    */
302   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
303 
304   /**
305    * Somebody has upgraded some of his tokens.
306    */
307   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
308 
309   /**
310    * New upgrade agent available.
311    */
312   event UpgradeAgentSet(address agent);
313 
314   /**
315    * Do not allow construction without upgrade master set.
316    */
317   function UpgradeableToken(address _upgradeMaster) {
318     upgradeMaster = _upgradeMaster;
319   }
320 
321   /**
322    * Allow the token holder to upgrade some of their tokens to a new contract.
323    */
324   function upgrade(uint256 value) public {
325 
326       UpgradeState state = getUpgradeState();
327       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
328         // Called in a bad state
329         throw;
330       }
331 
332       // Validate input value.
333       if (value == 0) throw;
334 
335       balances[msg.sender] = balances[msg.sender].sub(value);
336 
337       // Take tokens out from circulation
338       totalSupply = totalSupply.sub(value);
339       totalUpgraded = totalUpgraded.add(value);
340 
341       // Upgrade agent reissues the tokens
342       upgradeAgent.upgradeFrom(msg.sender, value);
343       Upgrade(msg.sender, upgradeAgent, value);
344   }
345 
346   /**
347    * Set an upgrade agent that handles
348    */
349   function setUpgradeAgent(address agent) external {
350 
351       if(!canUpgrade()) {
352         // The token is not yet in a state that we could think upgrading
353         throw;
354       }
355 
356       if (agent == 0x0) throw;
357       // Only a master can designate the next agent
358       if (msg.sender != upgradeMaster) throw;
359       // Upgrade has already begun for an agent
360       if (getUpgradeState() == UpgradeState.Upgrading) throw;
361 
362       upgradeAgent = UpgradeAgent(agent);
363 
364       // Bad interface
365       if(!upgradeAgent.isUpgradeAgent()) throw;
366       // Make sure that token supplies match in source and target
367       if (upgradeAgent.originalSupply() != totalSupply) throw;
368 
369       UpgradeAgentSet(upgradeAgent);
370   }
371 
372   /**
373    * Get the state of the token upgrade.
374    */
375   function getUpgradeState() public constant returns(UpgradeState) {
376     if(!canUpgrade()) return UpgradeState.NotAllowed;
377     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
378     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
379     else return UpgradeState.Upgrading;
380   }
381 
382   /**
383    * Change the upgrade master.
384    *
385    * This allows us to set a new owner for the upgrade mechanism.
386    */
387   function setUpgradeMaster(address master) public {
388       if (master == 0x0) throw;
389       if (msg.sender != upgradeMaster) throw;
390       upgradeMaster = master;
391   }
392 
393   /**
394    * Child contract can enable to provide the condition when the upgrade can begun.
395    */
396   function canUpgrade() public constant returns(bool) {
397      return true;
398   }
399 
400 }
401 
402 /**
403  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
404  *
405  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
406  */
407 
408 
409 
410 
411 /**
412  * @title Ownable
413  * @dev The Ownable contract has an owner address, and provides basic authorization control
414  * functions, this simplifies the implementation of "user permissions".
415  */
416 contract Ownable {
417   address public owner;
418 
419 
420   /**
421    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
422    * account.
423    */
424   function Ownable() {
425     owner = msg.sender;
426   }
427 
428 
429   /**
430    * @dev Throws if called by any account other than the owner.
431    */
432   modifier onlyOwner() {
433     require(msg.sender == owner);
434     _;
435   }
436 
437 
438   /**
439    * @dev Allows the current owner to transfer control of the contract to a newOwner.
440    * @param newOwner The address to transfer ownership to.
441    */
442   function transferOwnership(address newOwner) onlyOwner {
443     require(newOwner != address(0));      
444     owner = newOwner;
445   }
446 
447 }
448 
449 
450 
451 
452 /**
453  * Define interface for releasing the token transfer after a successful crowdsale.
454  */
455 contract ReleasableToken is ERC20, Ownable {
456 
457   /* The finalizer contract that allows unlift the transfer limits on this token */
458   address public releaseAgent;
459 
460   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
461   bool public released = false;
462 
463   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
464   mapping (address => bool) public transferAgents;
465 
466   /**
467    * Limit token transfer until the crowdsale is over.
468    *
469    */
470   modifier canTransfer(address _sender) {
471 
472     if(!released) {
473         if(!transferAgents[_sender]) {
474             throw;
475         }
476     }
477 
478     _;
479   }
480 
481   /**
482    * Set the contract that can call release and make the token transferable.
483    *
484    * Design choice. Allow reset the release agent to fix fat finger mistakes.
485    */
486   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
487 
488     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
489     releaseAgent = addr;
490   }
491 
492   /**
493    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
494    */
495   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
496     transferAgents[addr] = state;
497   }
498 
499   /**
500    * One way function to release the tokens to the wild.
501    *
502    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
503    */
504   function releaseTokenTransfer() public onlyReleaseAgent {
505     released = true;
506   }
507 
508   /** The function can be called only before or after the tokens have been releasesd */
509   modifier inReleaseState(bool releaseState) {
510     if(releaseState != released) {
511         throw;
512     }
513     _;
514   }
515 
516   /** The function can be called only by a whitelisted release agent. */
517   modifier onlyReleaseAgent() {
518     if(msg.sender != releaseAgent) {
519         throw;
520     }
521     _;
522   }
523 
524   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
525     // Call StandardToken.transfer()
526    return super.transfer(_to, _value);
527   }
528 
529   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
530     // Call StandardToken.transferForm()
531     return super.transferFrom(_from, _to, _value);
532   }
533 
534 }
535 
536 /**
537  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
538  *
539  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
540  */
541 
542 
543 
544 
545 /**
546  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
547  *
548  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
549  */
550 
551 
552 /**
553  * Safe unsigned safe math.
554  *
555  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
556  *
557  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
558  *
559  * Maintained here until merged to mainline zeppelin-solidity.
560  *
561  */
562 library SafeMathLib {
563 
564   function times(uint a, uint b) returns (uint) {
565     uint c = a * b;
566     assert(a == 0 || c / a == b);
567     return c;
568   }
569 
570   function minus(uint a, uint b) returns (uint) {
571     assert(b <= a);
572     return a - b;
573   }
574 
575   function plus(uint a, uint b) returns (uint) {
576     uint c = a + b;
577     assert(c>=a);
578     return c;
579   }
580 
581 }
582 
583 
584 
585 /**
586  * A token that can increase its supply by another contract.
587  *
588  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
589  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
590  *
591  */
592 contract MintableToken is StandardTokenExt, Ownable {
593 
594   using SafeMathLib for uint;
595 
596   bool public mintingFinished = false;
597 
598   /** List of agents that are allowed to create new tokens */
599   mapping (address => bool) public mintAgents;
600 
601   event MintingAgentChanged(address addr, bool state);
602   event Minted(address receiver, uint amount);
603 
604   /**
605    * Create new tokens and allocate them to an address..
606    *
607    * Only callably by a crowdsale contract (mint agent).
608    */
609   function mint(address receiver, uint amount) onlyMintAgent canMint public {
610     totalSupply = totalSupply.plus(amount);
611     balances[receiver] = balances[receiver].plus(amount);
612 
613     // This will make the mint transaction apper in EtherScan.io
614     // We can remove this after there is a standardized minting event
615     Transfer(0, receiver, amount);
616   }
617 
618   /**
619    * Owner can allow a crowdsale contract to mint new tokens.
620    */
621   function setMintAgent(address addr, bool state) onlyOwner canMint public {
622     mintAgents[addr] = state;
623     MintingAgentChanged(addr, state);
624   }
625 
626   modifier onlyMintAgent() {
627     // Only crowdsale contracts are allowed to mint new tokens
628     if(!mintAgents[msg.sender]) {
629         throw;
630     }
631     _;
632   }
633 
634   /** Make sure we are not done yet. */
635   modifier canMint() {
636     if(mintingFinished) throw;
637     _;
638   }
639 }
640 
641 
642 
643 /**
644  * A crowdsaled token.
645  *
646  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
647  *
648  * - The token transfer() is disabled until the crowdsale is over
649  * - The token contract gives an opt-in upgrade path to a new contract
650  * - The same token can be part of several crowdsales through approve() mechanism
651  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
652  *
653  */
654 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
655 
656   /** Name and symbol were updated. */
657   event UpdatedTokenInformation(string newName, string newSymbol);
658 
659   string public name;
660 
661   string public symbol;
662 
663   uint public decimals;
664 
665   /**
666    * Construct the token.
667    *
668    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
669    *
670    * @param _name Token name
671    * @param _symbol Token symbol - should be all caps
672    * @param _initialSupply How many tokens we start with
673    * @param _decimals Number of decimal places
674    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
675    */
676   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
677     UpgradeableToken(msg.sender) {
678 
679     // Create any address, can be transferred
680     // to team multisig via changeOwner(),
681     // also remember to call setUpgradeMaster()
682     owner = msg.sender;
683 
684     name = _name;
685     symbol = _symbol;
686 
687     totalSupply = _initialSupply;
688 
689     decimals = _decimals;
690 
691     // Create initially all balance on the team multisig
692     balances[owner] = totalSupply;
693 
694     if(totalSupply > 0) {
695       Minted(owner, totalSupply);
696     }
697 
698     // No more new supply allowed after the token creation
699     if(!_mintable) {
700       mintingFinished = true;
701       if(totalSupply == 0) {
702         throw; // Cannot create a token without supply and no minting
703       }
704     }
705   }
706 
707   /**
708    * When token is released to be transferable, enforce no new tokens can be created.
709    */
710   function releaseTokenTransfer() public onlyReleaseAgent {
711     mintingFinished = true;
712     super.releaseTokenTransfer();
713   }
714 
715   /**
716    * Allow upgrade agent functionality kick in only if the crowdsale was success.
717    */
718   function canUpgrade() public constant returns(bool) {
719     return released && super.canUpgrade();
720   }
721 
722   /**
723    * Owner can update token information here.
724    *
725    * It is often useful to conceal the actual token association, until
726    * the token operations, like central issuance or reissuance have been completed.
727    *
728    * This function allows the token owner to rename the token after the operations
729    * have been completed and then point the audience to use the token contract.
730    */
731   function setTokenInformation(string _name, string _symbol) onlyOwner {
732     name = _name;
733     symbol = _symbol;
734 
735     UpdatedTokenInformation(name, symbol);
736   }
737 
738 }
739 
740 
741 /**
742  * A crowdsaled token that you can also burn.
743  *
744  */
745 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
746 
747   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
748     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
749 
750   }
751 }
752 
753 
754 
755 /**
756  * The AML Token
757  *
758  * This subset of BurnableCrowdsaleToken gives the Owner a possibility to
759  * reclaim tokens from a participant before the token is released
760  * after a participant has failed a prolonged AML process.
761  *
762  * It is assumed that the anti-money laundering process depends on blockchain data.
763  * The data is not available before the transaction and not for the smart contract.
764  * Thus, we need to implement logic to handle AML failure cases post payment.
765  * We give a time window before the token release for the token sale owners to
766  * complete the AML and claw back all token transactions that were
767  * caused by rejected purchases.
768  */
769 contract AMLToken is BurnableCrowdsaleToken {
770 
771   // An event when the owner has reclaimed non-released tokens
772   event OwnerReclaim(address fromWhom, uint amount);
773 
774   function AMLToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
775 
776   }
777 
778   /// @dev Here the owner can reclaim the tokens from a participant if
779   ///      the token is not released yet. Refund will be handled offband.
780   /// @param fromWhom address of the participant whose tokens we want to claim
781   function transferToOwner(address fromWhom) onlyOwner {
782     if (released) revert();
783 
784     uint amount = balanceOf(fromWhom);
785     balances[fromWhom] = balances[fromWhom].sub(amount);
786     balances[owner] = balances[owner].add(amount);
787     Transfer(fromWhom, owner, amount);
788     OwnerReclaim(fromWhom, amount);
789   }
790 }