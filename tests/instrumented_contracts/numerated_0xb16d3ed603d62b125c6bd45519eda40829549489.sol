1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 
13 pragma solidity ^0.4.18;
14 
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     // SafeMath.sub will throw if there is not enough balance.
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 
120 
121 
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) public view returns (uint256);
129   function transferFrom(address from, address to, uint256 value) public returns (bool);
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public view returns (uint256) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 
232 
233 /**
234  * Standard EIP-20 token with an interface marker.
235  *
236  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
237  *
238  */
239 contract StandardTokenExt is StandardToken {
240 
241   /* Interface declaration */
242   function isToken() public pure returns (bool weAre) {
243     return true;
244   }
245 }
246 
247 
248 contract BurnableToken is StandardTokenExt {
249 
250   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
251   address public constant BURN_ADDRESS = 0;
252 
253   /** How many tokens we burned */
254   event Burned(address burner, uint burnedAmount);
255 
256   /**
257    * Burn extra tokens from a balance.
258    *
259    */
260   function burn(uint burnAmount) public {
261     address burner = msg.sender;
262     balances[burner] = balances[burner].sub(burnAmount);
263     totalSupply_ = totalSupply_.sub(burnAmount);
264     Burned(burner, burnAmount);
265 
266     // Inform the blockchain explores that track the
267     // balances only by a transfer event that the balance in this
268     // address has decreased
269     Transfer(burner, BURN_ADDRESS, burnAmount);
270   }
271 }
272 
273 /**
274  * Upgrade agent interface inspired by Lunyr.
275  *
276  * Upgrade agent transfers tokens to a new contract.
277  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
278  */
279 contract UpgradeAgent {
280 
281   uint public originalSupply;
282 
283   /** Interface marker */
284   function isUpgradeAgent() public pure returns (bool) {
285     return true;
286   }
287 
288   function upgradeFrom(address _from, uint256 _value) public;
289 
290 }
291 
292 
293 /**
294  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
295  *
296  * First envisioned by Golem and Lunyr projects.
297  */
298 contract UpgradeableToken is StandardTokenExt {
299 
300   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
301   address public upgradeMaster;
302 
303   /** The next contract where the tokens will be migrated. */
304   UpgradeAgent public upgradeAgent;
305 
306   /** How many tokens we have upgraded by now. */
307   uint256 public totalUpgraded;
308 
309   /**
310    * Upgrade states.
311    *
312    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
313    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
314    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
315    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
316    *
317    */
318   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
319 
320   /**
321    * Somebody has upgraded some of his tokens.
322    */
323   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
324 
325   /**
326    * New upgrade agent available.
327    */
328   event UpgradeAgentSet(address agent);
329 
330   /**
331    * Do not allow construction without upgrade master set.
332    */
333   function UpgradeableToken(address _upgradeMaster) public {
334     upgradeMaster = _upgradeMaster;
335   }
336 
337   /**
338    * Allow the token holder to upgrade some of their tokens to a new contract.
339    */
340   function upgrade(uint256 value) public {
341 
342       UpgradeState state = getUpgradeState();
343       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
344         // Called in a bad state
345         revert();
346       }
347 
348       // Validate input value.
349       if (value == 0) revert();
350 
351       balances[msg.sender] = balances[msg.sender].sub(value);
352 
353       // Take tokens out from circulation
354       totalSupply_ = totalSupply_.sub(value);
355       totalUpgraded = totalUpgraded.add(value);
356 
357       // Upgrade agent reissues the tokens
358       upgradeAgent.upgradeFrom(msg.sender, value);
359       Upgrade(msg.sender, upgradeAgent, value);
360   }
361 
362   /**
363    * Set an upgrade agent that handles
364    */
365   function setUpgradeAgent(address agent) external {
366 
367       if(!canUpgrade()) {
368         // The token is not yet in a state that we could think upgrading
369         revert();
370       }
371 
372       if (agent == 0x0) revert();
373       // Only a master can designate the next agent
374       if (msg.sender != upgradeMaster) revert();
375       // Upgrade has already begun for an agent
376       if (getUpgradeState() == UpgradeState.Upgrading) revert();
377 
378       upgradeAgent = UpgradeAgent(agent);
379 
380       // Bad interface
381       if(!upgradeAgent.isUpgradeAgent()) revert();
382       // Make sure that token supplies match in source and target
383       if (upgradeAgent.originalSupply() != totalSupply_) revert();
384 
385       UpgradeAgentSet(upgradeAgent);
386   }
387 
388   /**
389    * Get the state of the token upgrade.
390    */
391   function getUpgradeState() public constant returns(UpgradeState) {
392     if(!canUpgrade()) return UpgradeState.NotAllowed;
393     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
394     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
395     else return UpgradeState.Upgrading;
396   }
397 
398   /**
399    * Change the upgrade master.
400    *
401    * This allows us to set a new owner for the upgrade mechanism.
402    */
403   function setUpgradeMaster(address master) public {
404       if (master == 0x0) revert();
405       if (msg.sender != upgradeMaster) revert();
406       upgradeMaster = master;
407   }
408 
409   /**
410    * Child contract can enable to provide the condition when the upgrade can begun.
411    */
412   function canUpgrade() public view returns(bool);
413 
414 }
415 
416 /**
417  * @title Ownable
418  * @dev The Ownable contract has an owner address, and provides basic authorization control
419  * functions, this simplifies the implementation of "user permissions".
420  */
421 contract Ownable {
422   address public owner;
423 
424 
425   /**
426    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
427    * account.
428    */
429   function Ownable() public {
430     owner = msg.sender;
431   }
432 
433 
434   /**
435    * @dev Throws if called by any account other than the owner.
436    */
437   modifier onlyOwner() {
438     require(msg.sender == owner);
439     _;
440   }
441 
442 
443   /**
444    * @dev Allows the current owner to transfer control of the contract to a newOwner.
445    * @param newOwner The address to transfer ownership to.
446    */
447   function transferOwnership(address newOwner) public onlyOwner {
448     require(newOwner != address(0));
449     owner = newOwner;
450   }
451 
452 }
453 
454 
455 
456 
457 /**
458  * Define interface for releasing the token transfer after a successful crowdsale.
459  */
460 contract ReleasableToken is ERC20, Ownable {
461 
462   /* The finalizer contract that allows unlift the transfer limits on this token */
463   address public releaseAgent;
464 
465   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
466   bool public released = false;
467 
468   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
469   mapping (address => bool) public transferAgents;
470 
471   /** Map of addresses that are locked to transfer tokens  */
472   mapping (address => bool) public lockAddresses;
473 
474   /**
475    * Limit token transfer until the crowdsale is over.
476    *
477    */
478   modifier canTransfer(address _sender) {
479     if(lockAddresses[_sender]) {
480       revert();
481     }
482     if(!released) {
483         if(!transferAgents[_sender]) {
484             revert();
485         }
486     }
487 
488     _;
489   }
490 
491   /**
492    * Set the contract that can call release and make the token transferable.
493    *
494    * Design choice. Allow reset the release agent to fix fat finger mistakes.
495    */
496   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
497 
498     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
499     releaseAgent = addr;
500   }
501 
502   /**
503    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
504    */
505   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
506     transferAgents[addr] = state;
507   }
508 
509   /**
510    * Owner can lock a particular address (a crowdsale contract)
511    */
512   function setLockAddress(address addr, bool state) onlyOwner inReleaseState(false) public {
513     lockAddresses[addr] = state;
514   }
515 
516   /**
517    * One way function to release the tokens to the wild.
518    *
519    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
520    */
521   function releaseTokenTransfer() public onlyReleaseAgent {
522     released = true;
523   }
524 
525   /** The function can be called only before or after the tokens have been releasesd */
526   modifier inReleaseState(bool releaseState) {
527     if(releaseState != released) {
528         revert();
529     }
530     _;
531   }
532 
533   /** The function can be called only by a whitelisted release agent. */
534   modifier onlyReleaseAgent() {
535     if(msg.sender != releaseAgent) {
536         revert();
537     }
538     _;
539   }
540 
541   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
542     // Call StandardToken.transfer()
543    return super.transfer(_to, _value);
544   }
545 
546   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
547     // Call StandardToken.transferForm()
548     return super.transferFrom(_from, _to, _value);
549   }
550 
551 }
552 
553 /**
554  * Safe unsigned safe math.
555  *
556  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
557  *
558  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
559  *
560  * Maintained here until merged to mainline zeppelin-solidity.
561  *
562  */
563 library SafeMathLib {
564 
565   function times(uint a, uint b) internal pure returns (uint) {
566     uint c = a * b;
567     assert(a == 0 || c / a == b);
568     return c;
569   }
570 
571   function minus(uint a, uint b) internal pure returns (uint) {
572     assert(b <= a);
573     return a - b;
574   }
575 
576   function plus(uint a, uint b)  internal pure returns (uint) {
577     uint c = a + b;
578     assert(c>=a);
579     return c;
580   }
581 
582 }
583 
584 
585 
586 /**
587  * A token that can increase its supply by another contract.
588  *
589  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
590  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
591  *
592  */
593 contract MintableToken is StandardTokenExt, Ownable {
594 
595   using SafeMathLib for uint;
596 
597   bool public mintingFinished = false;
598 
599   /** List of agents that are allowed to create new tokens */
600   mapping (address => bool) public mintAgents;
601 
602   event MintingAgentChanged(address addr, bool state);
603   event Minted(address receiver, uint amount);
604 
605   /**
606    * Create new tokens and allocate them to an address..
607    *
608    * Only callably by a crowdsale contract (mint agent).
609    */
610   function mint(address receiver, uint amount) onlyMintAgent canMint public {
611     totalSupply_ = totalSupply_.plus(amount);
612     balances[receiver] = balances[receiver].plus(amount);
613 
614     // This will make the mint transaction apper in EtherScan.io
615     // We can remove this after there is a standardized minting event
616     Transfer(0, receiver, amount);
617   }
618 
619   /**
620    * Owner can allow a crowdsale contract to mint new tokens.
621    */
622   function setMintAgent(address addr, bool state) onlyOwner canMint public {
623     mintAgents[addr] = state;
624     MintingAgentChanged(addr, state);
625   }
626 
627   modifier onlyMintAgent() {
628     // Only crowdsale contracts are allowed to mint new tokens
629     if(!mintAgents[msg.sender]) {
630         revert();
631     }
632     _;
633   }
634 
635   /** Make sure we are not done yet. */
636   modifier canMint() {
637     if(mintingFinished) revert();
638     _;
639   }
640 }
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
676   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public
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
687     totalSupply_ = _initialSupply;
688 
689     decimals = _decimals;
690 
691     // Create initially all balance on the team multisig
692     balances[owner] = totalSupply_;
693 
694     if(totalSupply_ > 0) {
695       Minted(owner, totalSupply_);
696     }
697 
698     // No more new supply allowed after the token creation
699     if(!_mintable) {
700       mintingFinished = true;
701       if(totalSupply_ == 0) {
702         revert(); // Cannot create a token without supply and no minting
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
719     return released;
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
731   function setTokenInformation(string _name, string _symbol) public onlyOwner {
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
747   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public
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
774   function AMLToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
775 
776   }
777 
778   /// @dev Here the owner can reclaim the tokens from a participant if
779   ///      the token is not released yet. Refund will be handled offband.
780   /// @param fromWhom address of the participant whose tokens we want to claim
781   function transferToOwner(address fromWhom) public onlyOwner {
782     if (released) revert();
783 
784     uint amount = balanceOf(fromWhom);
785     balances[fromWhom] = balances[fromWhom].sub(amount);
786     balances[owner] = balances[owner].add(amount);
787     Transfer(fromWhom, owner, amount);
788     OwnerReclaim(fromWhom, amount);
789   }
790 }