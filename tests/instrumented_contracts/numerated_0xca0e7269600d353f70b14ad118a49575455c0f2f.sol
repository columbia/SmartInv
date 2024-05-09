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
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
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
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 
118 
119 
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) public constant returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154 
155     uint256 _allowance = allowed[_from][msg.sender];
156 
157     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
158     // require (_value <= _allowance);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = _allowance.sub(_value);
163     Transfer(_from, _to, _value);
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
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval (address _spender, uint _addedValue)
200     returns (bool success) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue)
207     returns (bool success) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 
221 
222 /**
223  * Standard EIP-20 token with an interface marker.
224  *
225  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
226  *
227  */
228 contract StandardTokenExt is StandardToken {
229 
230   /* Interface declaration */
231   function isToken() public constant returns (bool weAre) {
232     return true;
233   }
234 }
235 
236 
237 contract BurnableToken is StandardTokenExt {
238 
239   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
240   address public constant BURN_ADDRESS = 0;
241 
242   /** How many tokens we burned */
243   event Burned(address burner, uint burnedAmount);
244 
245   /**
246    * Burn extra tokens from a balance.
247    *
248    */
249   function burn(uint burnAmount) {
250     address burner = msg.sender;
251     balances[burner] = balances[burner].sub(burnAmount);
252     totalSupply = totalSupply.sub(burnAmount);
253     Burned(burner, burnAmount);
254 
255     // Inform the blockchain explores that track the
256     // balances only by a transfer event that the balance in this
257     // address has decreased
258     Transfer(burner, BURN_ADDRESS, burnAmount);
259   }
260 }
261 
262 /**
263  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
264  *
265  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
266  */
267 
268 
269 /**
270  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
271  *
272  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
273  */
274 
275 
276 
277 
278 /**
279  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
280  *
281  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
282  */
283 
284 
285 /**
286  * Upgrade agent interface inspired by Lunyr.
287  *
288  * Upgrade agent transfers tokens to a new contract.
289  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
290  */
291 contract UpgradeAgent {
292 
293   uint public originalSupply;
294 
295   /** Interface marker */
296   function isUpgradeAgent() public constant returns (bool) {
297     return true;
298   }
299 
300   function upgradeFrom(address _from, uint256 _value) public;
301 
302 }
303 
304 
305 /**
306  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
307  *
308  * First envisioned by Golem and Lunyr projects.
309  */
310 contract UpgradeableToken is StandardTokenExt {
311 
312   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
313   address public upgradeMaster;
314 
315   /** The next contract where the tokens will be migrated. */
316   UpgradeAgent public upgradeAgent;
317 
318   /** How many tokens we have upgraded by now. */
319   uint256 public totalUpgraded;
320 
321   /**
322    * Upgrade states.
323    *
324    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
325    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
326    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
327    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
328    *
329    */
330   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
331 
332   /**
333    * Somebody has upgraded some of his tokens.
334    */
335   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
336 
337   /**
338    * New upgrade agent available.
339    */
340   event UpgradeAgentSet(address agent);
341 
342   /**
343    * Do not allow construction without upgrade master set.
344    */
345   function UpgradeableToken(address _upgradeMaster) {
346     upgradeMaster = _upgradeMaster;
347   }
348 
349   /**
350    * Allow the token holder to upgrade some of their tokens to a new contract.
351    */
352   function upgrade(uint256 value) public {
353 
354       UpgradeState state = getUpgradeState();
355       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
356         // Called in a bad state
357         throw;
358       }
359 
360       // Validate input value.
361       if (value == 0) throw;
362 
363       balances[msg.sender] = balances[msg.sender].sub(value);
364 
365       // Take tokens out from circulation
366       totalSupply = totalSupply.sub(value);
367       totalUpgraded = totalUpgraded.add(value);
368 
369       // Upgrade agent reissues the tokens
370       upgradeAgent.upgradeFrom(msg.sender, value);
371       Upgrade(msg.sender, upgradeAgent, value);
372   }
373 
374   /**
375    * Set an upgrade agent that handles
376    */
377   function setUpgradeAgent(address agent) external {
378 
379       if(!canUpgrade()) {
380         // The token is not yet in a state that we could think upgrading
381         throw;
382       }
383 
384       if (agent == 0x0) throw;
385       // Only a master can designate the next agent
386       if (msg.sender != upgradeMaster) throw;
387       // Upgrade has already begun for an agent
388       if (getUpgradeState() == UpgradeState.Upgrading) throw;
389 
390       upgradeAgent = UpgradeAgent(agent);
391 
392       // Bad interface
393       if(!upgradeAgent.isUpgradeAgent()) throw;
394       // Make sure that token supplies match in source and target
395       if (upgradeAgent.originalSupply() != totalSupply) throw;
396 
397       UpgradeAgentSet(upgradeAgent);
398   }
399 
400   /**
401    * Get the state of the token upgrade.
402    */
403   function getUpgradeState() public constant returns(UpgradeState) {
404     if(!canUpgrade()) return UpgradeState.NotAllowed;
405     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
406     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
407     else return UpgradeState.Upgrading;
408   }
409 
410   /**
411    * Change the upgrade master.
412    *
413    * This allows us to set a new owner for the upgrade mechanism.
414    */
415   function setUpgradeMaster(address master) public {
416       if (master == 0x0) throw;
417       if (msg.sender != upgradeMaster) throw;
418       upgradeMaster = master;
419   }
420 
421   /**
422    * Child contract can enable to provide the condition when the upgrade can begun.
423    */
424   function canUpgrade() public constant returns(bool) {
425      return true;
426   }
427 
428 }
429 
430 /**
431  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
432  *
433  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
434  */
435 
436 
437 
438 
439 /**
440  * @title Ownable
441  * @dev The Ownable contract has an owner address, and provides basic authorization control
442  * functions, this simplifies the implementation of "user permissions".
443  */
444 contract Ownable {
445   address public owner;
446 
447 
448   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
449 
450 
451   /**
452    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
453    * account.
454    */
455   function Ownable() {
456     owner = msg.sender;
457   }
458 
459 
460   /**
461    * @dev Throws if called by any account other than the owner.
462    */
463   modifier onlyOwner() {
464     require(msg.sender == owner);
465     _;
466   }
467 
468 
469   /**
470    * @dev Allows the current owner to transfer control of the contract to a newOwner.
471    * @param newOwner The address to transfer ownership to.
472    */
473   function transferOwnership(address newOwner) onlyOwner public {
474     require(newOwner != address(0));
475     OwnershipTransferred(owner, newOwner);
476     owner = newOwner;
477   }
478 
479 }
480 
481 
482 
483 
484 /**
485  * Define interface for releasing the token transfer after a successful crowdsale.
486  */
487 contract ReleasableToken is ERC20, Ownable {
488 
489   /* The finalizer contract that allows unlift the transfer limits on this token */
490   address public releaseAgent;
491 
492   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
493   bool public released = false;
494 
495   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
496   mapping (address => bool) public transferAgents;
497 
498   /**
499    * Limit token transfer until the crowdsale is over.
500    *
501    */
502   modifier canTransfer(address _sender) {
503 
504     if(!released) {
505         if(!transferAgents[_sender]) {
506             throw;
507         }
508     }
509 
510     _;
511   }
512 
513   /**
514    * Set the contract that can call release and make the token transferable.
515    *
516    * Design choice. Allow reset the release agent to fix fat finger mistakes.
517    */
518   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
519 
520     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
521     releaseAgent = addr;
522   }
523 
524   /**
525    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
526    */
527   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
528     transferAgents[addr] = state;
529   }
530 
531   /**
532    * One way function to release the tokens to the wild.
533    *
534    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
535    */
536   function releaseTokenTransfer() public onlyReleaseAgent {
537     released = true;
538   }
539 
540   /** The function can be called only before or after the tokens have been releasesd */
541   modifier inReleaseState(bool releaseState) {
542     if(releaseState != released) {
543         throw;
544     }
545     _;
546   }
547 
548   /** The function can be called only by a whitelisted release agent. */
549   modifier onlyReleaseAgent() {
550     if(msg.sender != releaseAgent) {
551         throw;
552     }
553     _;
554   }
555 
556   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
557     // Call StandardToken.transfer()
558    return super.transfer(_to, _value);
559   }
560 
561   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
562     // Call StandardToken.transferForm()
563     return super.transferFrom(_from, _to, _value);
564   }
565 
566 }
567 
568 /**
569  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
570  *
571  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
572  */
573 
574 
575 
576 
577 /**
578  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
579  *
580  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
581  */
582 
583 
584 /**
585  * Safe unsigned safe math.
586  *
587  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
588  *
589  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
590  *
591  * Maintained here until merged to mainline zeppelin-solidity.
592  *
593  */
594 library SafeMathLib {
595 
596   function times(uint a, uint b) returns (uint) {
597     uint c = a * b;
598     assert(a == 0 || c / a == b);
599     return c;
600   }
601 
602   function minus(uint a, uint b) returns (uint) {
603     assert(b <= a);
604     return a - b;
605   }
606 
607   function plus(uint a, uint b) returns (uint) {
608     uint c = a + b;
609     assert(c>=a);
610     return c;
611   }
612 
613 }
614 
615 
616 
617 /**
618  * A token that can increase its supply by another contract.
619  *
620  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
621  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
622  *
623  */
624 contract MintableToken is StandardTokenExt, Ownable {
625 
626   using SafeMathLib for uint;
627 
628   bool public mintingFinished = false;
629 
630   /** List of agents that are allowed to create new tokens */
631   mapping (address => bool) public mintAgents;
632 
633   event MintingAgentChanged(address addr, bool state);
634   event Minted(address receiver, uint amount);
635 
636   /**
637    * Create new tokens and allocate them to an address..
638    *
639    * Only callably by a crowdsale contract (mint agent).
640    */
641   function mint(address receiver, uint amount) onlyMintAgent canMint public {
642     totalSupply = totalSupply.plus(amount);
643     balances[receiver] = balances[receiver].plus(amount);
644 
645     // This will make the mint transaction apper in EtherScan.io
646     // We can remove this after there is a standardized minting event
647     Transfer(0, receiver, amount);
648   }
649 
650   /**
651    * Owner can allow a crowdsale contract to mint new tokens.
652    */
653   function setMintAgent(address addr, bool state) onlyOwner canMint public {
654     mintAgents[addr] = state;
655     MintingAgentChanged(addr, state);
656   }
657 
658   modifier onlyMintAgent() {
659     // Only crowdsale contracts are allowed to mint new tokens
660     if(!mintAgents[msg.sender]) {
661         throw;
662     }
663     _;
664   }
665 
666   /** Make sure we are not done yet. */
667   modifier canMint() {
668     if(mintingFinished) throw;
669     _;
670   }
671 }
672 
673 
674 
675 /**
676  * A crowdsaled token.
677  *
678  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
679  *
680  * - The token transfer() is disabled until the crowdsale is over
681  * - The token contract gives an opt-in upgrade path to a new contract
682  * - The same token can be part of several crowdsales through approve() mechanism
683  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
684  *
685  */
686 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
687 
688   /** Name and symbol were updated. */
689   event UpdatedTokenInformation(string newName, string newSymbol);
690 
691   string public name;
692 
693   string public symbol;
694 
695   uint public decimals;
696 
697   /**
698    * Construct the token.
699    *
700    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
701    *
702    * @param _name Token name
703    * @param _symbol Token symbol - should be all caps
704    * @param _initialSupply How many tokens we start with
705    * @param _decimals Number of decimal places
706    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
707    */
708   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
709     UpgradeableToken(msg.sender) {
710 
711     // Create any address, can be transferred
712     // to team multisig via changeOwner(),
713     // also remember to call setUpgradeMaster()
714     owner = msg.sender;
715 
716     name = _name;
717     symbol = _symbol;
718 
719     totalSupply = _initialSupply;
720 
721     decimals = _decimals;
722 
723     // Create initially all balance on the team multisig
724     balances[owner] = totalSupply;
725 
726     if(totalSupply > 0) {
727       Minted(owner, totalSupply);
728     }
729 
730     // No more new supply allowed after the token creation
731     if(!_mintable) {
732       mintingFinished = true;
733       if(totalSupply == 0) {
734         throw; // Cannot create a token without supply and no minting
735       }
736     }
737   }
738 
739   /**
740    * When token is released to be transferable, enforce no new tokens can be created.
741    */
742   function releaseTokenTransfer() public onlyReleaseAgent {
743     mintingFinished = true;
744     super.releaseTokenTransfer();
745   }
746 
747   /**
748    * Allow upgrade agent functionality kick in only if the crowdsale was success.
749    */
750   function canUpgrade() public constant returns(bool) {
751     return released && super.canUpgrade();
752   }
753 
754   /**
755    * Owner can update token information here.
756    *
757    * It is often useful to conceal the actual token association, until
758    * the token operations, like central issuance or reissuance have been completed.
759    *
760    * This function allows the token owner to rename the token after the operations
761    * have been completed and then point the audience to use the token contract.
762    */
763   function setTokenInformation(string _name, string _symbol) onlyOwner {
764     name = _name;
765     symbol = _symbol;
766 
767     UpdatedTokenInformation(name, symbol);
768   }
769 
770 }
771 
772 
773 /**
774  * A crowdsaled token that you can also burn.
775  *
776  */
777 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
778 
779   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
780     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
781 
782   }
783 }
784 
785 
786 
787 /**
788  * The AML Token
789  *
790  * This subset of BurnableCrowdsaleToken gives the Owner a possibility to
791  * reclaim tokens from a participant before the token is released
792  * after a participant has failed a prolonged AML process.
793  *
794  * It is assumed that the anti-money laundering process depends on blockchain data.
795  * The data is not available before the transaction and not for the smart contract.
796  * Thus, we need to implement logic to handle AML failure cases post payment.
797  * We give a time window before the token release for the token sale owners to
798  * complete the AML and claw back all token transactions that were
799  * caused by rejected purchases.
800  */
801 contract AMLToken is BurnableCrowdsaleToken {
802 
803   // An event when the owner has reclaimed non-released tokens
804   event OwnerReclaim(address fromWhom, uint amount);
805 
806   function AMLToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
807 
808   }
809 
810   /// @dev Here the owner can reclaim the tokens from a participant if
811   ///      the token is not released yet. Refund will be handled offband.
812   /// @param fromWhom address of the participant whose tokens we want to claim
813   function transferToOwner(address fromWhom) onlyOwner {
814     if (released) revert();
815 
816     uint amount = balanceOf(fromWhom);
817     balances[fromWhom] = balances[fromWhom].sub(amount);
818     balances[owner] = balances[owner].add(amount);
819     Transfer(fromWhom, owner, amount);
820     OwnerReclaim(fromWhom, amount);
821   }
822 }