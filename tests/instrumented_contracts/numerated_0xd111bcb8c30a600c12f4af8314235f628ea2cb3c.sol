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
13 // UPDATE (Apr.2019): version upgraded to 0.4.25 from 0.4.18
14 pragma solidity ^0.4.25;
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address who) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   /**
57   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     emit Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 
233 
234 /**
235  * Standard EIP-20 token with an interface marker.
236  *
237  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
238  *
239  */
240 contract StandardTokenExt is StandardToken {
241 
242   /* Interface declaration */
243   function isToken() public pure returns (bool weAre) {
244     return true;
245   }
246 }
247 
248 
249 contract BurnableToken is StandardTokenExt {
250 
251   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
252   address public constant BURN_ADDRESS = 0;
253 
254   /** How many tokens we burned */
255   event Burned(address burner, uint burnedAmount);
256 
257   /**
258    * Burn extra tokens from a balance.
259    *
260    */
261   function burn(uint burnAmount) public {
262     address burner = msg.sender;
263     balances[burner] = balances[burner].sub(burnAmount);
264     totalSupply_ = totalSupply_.sub(burnAmount);
265     emit Burned(burner, burnAmount);
266 
267     // Inform the blockchain explores that track the
268     // balances only by a transfer event that the balance in this
269     // address has decreased
270     emit Transfer(burner, BURN_ADDRESS, burnAmount);
271   }
272 }
273 
274 /**
275  * Upgrade agent interface inspired by Lunyr.
276  *
277  * Upgrade agent transfers tokens to a new contract.
278  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
279  */
280 contract UpgradeAgent {
281 
282   uint public originalSupply;
283 
284   /** Interface marker */
285   function isUpgradeAgent() public pure returns (bool) {
286     return true;
287   }
288 
289   function upgradeFrom(address _from, uint256 _value) public;
290 
291 }
292 
293 
294 /**
295  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
296  *
297  * First envisioned by Golem and Lunyr projects.
298  */
299 contract UpgradeableToken is StandardTokenExt {
300 
301   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
302   address public upgradeMaster;
303 
304   /** The next contract where the tokens will be migrated. */
305   UpgradeAgent public upgradeAgent;
306 
307   /** How many tokens we have upgraded by now. */
308   uint256 public totalUpgraded;
309 
310   /**
311    * Upgrade states.
312    *
313    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
314    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
315    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
316    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
317    *
318    */
319   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
320 
321   /**
322    * Somebody has upgraded some of his tokens.
323    */
324   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
325 
326   /**
327    * New upgrade agent available.
328    */
329   event UpgradeAgentSet(address agent);
330 
331   /**
332    * Do not allow construction without upgrade master set.
333    */
334   constructor(address _upgradeMaster) public {
335     upgradeMaster = _upgradeMaster;
336   }
337 
338   /**
339    * Allow the token holder to upgrade some of their tokens to a new contract.
340    */
341   function upgrade(uint256 value) public {
342 
343       UpgradeState state = getUpgradeState();
344       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
345         // Called in a bad state
346         revert();
347       }
348 
349       // Validate input value.
350       if (value == 0) revert();
351 
352       balances[msg.sender] = balances[msg.sender].sub(value);
353 
354       // Take tokens out from circulation
355       totalSupply_ = totalSupply_.sub(value);
356       totalUpgraded = totalUpgraded.add(value);
357 
358       // Upgrade agent reissues the tokens
359       upgradeAgent.upgradeFrom(msg.sender, value);
360       emit Upgrade(msg.sender, upgradeAgent, value);
361   }
362 
363   /**
364    * Set an upgrade agent that handles
365    */
366   function setUpgradeAgent(address agent) external {
367 
368       if(!canUpgrade()) {
369         // The token is not yet in a state that we could think upgrading
370         revert();
371       }
372 
373       if (agent == 0x0) revert();
374       // Only a master can designate the next agent
375       if (msg.sender != upgradeMaster) revert();
376       // Upgrade has already begun for an agent
377       if (getUpgradeState() == UpgradeState.Upgrading) revert();
378 
379       upgradeAgent = UpgradeAgent(agent);
380 
381       // Bad interface
382       if(!upgradeAgent.isUpgradeAgent()) revert();
383       // Make sure that token supplies match in source and target
384       if (upgradeAgent.originalSupply() != totalSupply_) revert();
385 
386       emit UpgradeAgentSet(upgradeAgent);
387   }
388 
389   /**
390    * Get the state of the token upgrade.
391    */
392   function getUpgradeState() public view returns(UpgradeState) {
393     if(!canUpgrade()) return UpgradeState.NotAllowed;
394     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
395     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
396     else return UpgradeState.Upgrading;
397   }
398 
399   /**
400    * Change the upgrade master.
401    *
402    * This allows us to set a new owner for the upgrade mechanism.
403    */
404   function setUpgradeMaster(address master) public {
405       if (master == 0x0) revert();
406       if (msg.sender != upgradeMaster) revert();
407       upgradeMaster = master;
408   }
409 
410   /**
411    * Child contract can enable to provide the condition when the upgrade can begun.
412    */
413   function canUpgrade() public view returns(bool);
414 
415 }
416 
417 /**
418  * @title Ownable
419  * @dev The Ownable contract has an owner address, and provides basic authorization control
420  * functions, this simplifies the implementation of "user permissions".
421  */
422 contract Ownable {
423   address public owner;
424 
425 
426   /**
427    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
428    * account.
429    */
430   constructor() public {
431     owner = msg.sender;
432   }
433 
434 
435   /**
436    * @dev Throws if called by any account other than the owner.
437    */
438   modifier onlyOwner() {
439     require(msg.sender == owner);
440     _;
441   }
442 
443 
444   /**
445    * @dev Allows the current owner to transfer control of the contract to a newOwner.
446    * @param newOwner The address to transfer ownership to.
447    */
448   function transferOwnership(address newOwner) public onlyOwner {
449     require(newOwner != address(0));
450     owner = newOwner;
451   }
452 
453 }
454 
455 
456 
457 
458 /**
459  * Define interface for releasing the token transfer after a successful crowdsale.
460  */
461 contract ReleasableToken is ERC20, Ownable {
462 
463   /* The finalizer contract that allows unlift the transfer limits on this token */
464   address public releaseAgent;
465 
466   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
467   bool public released = false;
468 
469   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
470   mapping (address => bool) public transferAgents;
471 
472   /** Map of addresses that are locked to transfer tokens  */
473   mapping (address => bool) public lockAddresses;
474 
475   /**
476    * Limit token transfer until the crowdsale is over.
477    *
478    */
479   modifier canTransfer(address _sender) {
480     if(lockAddresses[_sender]) {
481       revert();
482     }
483     if(!released) {
484         if(!transferAgents[_sender]) {
485             revert();
486         }
487     }
488 
489     _;
490   }
491 
492   /**
493    * Set the contract that can call release and make the token transferable.
494    * Design choice. Allow reset the release agent to fix fat finger mistakes.
495    * UPDATE (Apr.2019): Now owner can permit some account as transfer agent any time.
496    */
497   function setReleaseAgent(address addr) onlyOwner /* inReleaseState(false) */ public {
498 
499     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
500     releaseAgent = addr;
501   }
502 
503   /**
504    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
505    * UPDATE (Apr.2019): Now owner can permit some account as transfer agent any time.
506    */
507   function setTransferAgent(address addr, bool state) onlyOwner /* inReleaseState(false) */ public {
508     transferAgents[addr] = state;
509   }
510 
511   /**
512    * Owner can lock a particular address (a crowdsale contract)
513    * UPDATE (Apr.2019): Now owner can lock specific account in some cases.
514    */
515   function setLockAddress(address addr, bool state) onlyOwner /*inReleaseState(false)*/ public {
516     lockAddresses[addr] = state;
517   }
518 
519   /**
520    * One way function to release the tokens to the wild.
521    *
522    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
523    */
524   function releaseTokenTransfer() public onlyReleaseAgent {
525     released = true;
526   }
527 
528   /**
529    * UPDATE (Apr.2019): Now owner can lock whole transfer in some cases (i.e security accidents)
530    */
531   function lockTokenTransfer() public onlyOwner {
532     released = false;
533   }
534 
535   /** The function can be called only before or after the tokens have been releasesd
536    * UPDATE (Apr.201): Obsolete code, not used any more.
537    */
538     // modifier inReleaseState(bool releaseState) {
539     //   if(releaseState != released) {
540     //       revert();
541     //   }
542     //   _;
543     // }
544 
545   /** The function can be called only by a whitelisted release agent. */
546   modifier onlyReleaseAgent() {
547     if(msg.sender != releaseAgent) {
548         revert();
549     }
550     _;
551   }
552 
553   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
554     // Call StandardToken.transfer()
555    return super.transfer(_to, _value);
556   }
557 
558   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
559     // Call StandardToken.transferForm()
560     return super.transferFrom(_from, _to, _value);
561   }
562 
563 }
564 
565 /**
566  * Safe unsigned safe math.
567  *
568  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
569  *
570  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
571  *
572  * Maintained here until merged to mainline zeppelin-solidity.
573  *
574  */
575 library SafeMathLib {
576 
577   function times(uint a, uint b) internal pure returns (uint) {
578     uint c = a * b;
579     assert(a == 0 || c / a == b);
580     return c;
581   }
582 
583   function minus(uint a, uint b) internal pure returns (uint) {
584     assert(b <= a);
585     return a - b;
586   }
587 
588   function plus(uint a, uint b)  internal pure returns (uint) {
589     uint c = a + b;
590     assert(c>=a);
591     return c;
592   }
593 
594 }
595 
596 
597 
598 /**
599  * A token that can increase its supply by another contract.
600  *
601  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
602  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
603  *
604  */
605 contract MintableToken is StandardTokenExt, Ownable {
606 
607   using SafeMathLib for uint;
608 
609   bool public mintingFinished = false;
610 
611   /** List of agents that are allowed to create new tokens */
612   mapping (address => bool) public mintAgents;
613 
614   event MintingAgentChanged(address addr, bool state);
615   event Minted(address receiver, uint amount);
616 
617   /**
618    * Create new tokens and allocate them to an address..
619    *
620    * Only callably by a crowdsale contract (mint agent).
621    */
622   function mint(address receiver, uint amount) onlyMintAgent canMint public {
623     totalSupply_ = totalSupply_.plus(amount);
624     balances[receiver] = balances[receiver].plus(amount);
625 
626     // This will make the mint transaction apper in EtherScan.io
627     // We can remove this after there is a standardized minting event
628     emit Transfer(0, receiver, amount);
629   }
630 
631   /**
632    * Owner can allow a crowdsale contract to mint new tokens.
633    */
634   function setMintAgent(address addr, bool state) onlyOwner canMint public {
635     mintAgents[addr] = state;
636     emit MintingAgentChanged(addr, state);
637   }
638 
639   modifier onlyMintAgent() {
640     // Only crowdsale contracts are allowed to mint new tokens
641     if(!mintAgents[msg.sender]) {
642         revert();
643     }
644     _;
645   }
646 
647   /** Make sure we are not done yet. */
648   modifier canMint() {
649     if(mintingFinished) revert();
650     _;
651   }
652 }
653 
654 
655 /**
656  * A crowdsaled token.
657  *
658  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
659  *
660  * - The token transfer() is disabled until the crowdsale is over
661  * - The token contract gives an opt-in upgrade path to a new contract
662  * - The same token can be part of several crowdsales through approve() mechanism
663  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
664  *
665  */
666 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
667 
668   /** Name and symbol were updated. */
669   event UpdatedTokenInformation(string newName, string newSymbol);
670 
671   string public name;
672 
673   string public symbol;
674 
675   uint public decimals;
676 
677   /**
678    * Construct the token.
679    *
680    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
681    *
682    * @param _name Token name
683    * @param _symbol Token symbol - should be all caps
684    * @param _initialSupply How many tokens we start with
685    * @param _decimals Number of decimal places
686    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
687    */
688   constructor(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public
689     UpgradeableToken(msg.sender) {
690 
691     // Create any address, can be transferred
692     // to team multisig via changeOwner(),
693     // also remember to call setUpgradeMaster()
694     owner = msg.sender;
695 
696     name = _name;
697     symbol = _symbol;
698 
699     totalSupply_ = _initialSupply;
700 
701     decimals = _decimals;
702 
703     // Create initially all balance on the team multisig
704     balances[owner] = totalSupply_;
705 
706     if(totalSupply_ > 0) {
707       emit Minted(owner, totalSupply_);
708     }
709 
710     // No more new supply allowed after the token creation
711     if(!_mintable) {
712       mintingFinished = true;
713       if(totalSupply_ == 0) {
714         revert(); // Cannot create a token without supply and no minting
715       }
716     }
717   }
718 
719   /**
720    * When token is released to be transferable, enforce no new tokens can be created.
721    */
722   function releaseTokenTransfer() public onlyReleaseAgent {
723     mintingFinished = true;
724     super.releaseTokenTransfer();
725   }
726 
727   /**
728    * Allow upgrade agent functionality kick in only if the crowdsale was success.
729    */
730   function canUpgrade() public view returns(bool) {
731     return released;
732   }
733 
734   /**
735    * Owner can update token information here.
736    *
737    * It is often useful to conceal the actual token association, until
738    * the token operations, like central issuance or reissuance have been completed.
739    *
740    * This function allows the token owner to rename the token after the operations
741    * have been completed and then point the audience to use the token contract.
742    */
743   function setTokenInformation(string _name, string _symbol) public onlyOwner {
744     name = _name;
745     symbol = _symbol;
746 
747     emit UpdatedTokenInformation(name, symbol);
748   }
749 
750 }
751 
752 
753 /**
754  * A crowdsaled token that you can also burn.
755  *
756  */
757 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
758 
759   constructor(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public
760     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
761 
762   }
763 }
764 
765 
766 
767 /**
768  * The AML Token
769  *
770  * This subset of BurnableCrowdsaleToken gives the Owner a possibility to
771  * reclaim tokens from a participant before the token is released
772  * after a participant has failed a prolonged AML process.
773  *
774  * It is assumed that the anti-money laundering process depends on blockchain data.
775  * The data is not available before the transaction and not for the smart contract.
776  * Thus, we need to implement logic to handle AML failure cases post payment.
777  * We give a time window before the token release for the token sale owners to
778  * complete the AML and claw back all token transactions that were
779  * caused by rejected purchases.
780  */
781 contract AMLToken is BurnableCrowdsaleToken {
782 
783   // An event when the owner has reclaimed non-released tokens
784   event OwnerReclaim(address fromWhom, uint amount);
785 
786   constructor(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
787 
788   }
789 
790   /// @dev Here the owner can reclaim the tokens from a participant if
791   ///      the token is not released yet. Refund will be handled offband.
792   /// @param fromWhom address of the participant whose tokens we want to claim
793   function transferToOwner(address fromWhom) public onlyOwner {
794     // UPDATE (Apr.2019): Onwer can reclaim any time in some cases (i.e. security accidents)
795     // if (released) revert();
796 
797     uint amount = balanceOf(fromWhom);
798     balances[fromWhom] = balances[fromWhom].sub(amount);
799     balances[owner] = balances[owner].add(amount);
800     emit Transfer(fromWhom, owner, amount);
801     emit OwnerReclaim(fromWhom, amount);
802   }
803 }