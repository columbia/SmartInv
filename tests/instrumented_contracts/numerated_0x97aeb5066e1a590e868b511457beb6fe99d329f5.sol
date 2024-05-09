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
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   function totalSupply() public view returns (uint256);
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers, truncating the quotient.
68   */
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   /**
77   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   /**
85   * @dev Adds two numbers, throws on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   uint256 totalSupply_;
106 
107   /**
108   * @dev total number of tokens in existence
109   */
110   function totalSupply() public view returns (uint256) {
111     return totalSupply_;
112   }
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 
142 
143 
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 /**
254  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
255  *
256  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
257  */
258 
259 
260 
261 
262 /**
263  * @title Ownable
264  * @dev The Ownable contract has an owner address, and provides basic authorization control
265  * functions, this simplifies the implementation of "user permissions".
266  */
267 contract Ownable {
268   address public owner;
269 
270 
271   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273 
274   /**
275    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
276    * account.
277    */
278   function Ownable() public {
279     owner = msg.sender;
280   }
281 
282   /**
283    * @dev Throws if called by any account other than the owner.
284    */
285   modifier onlyOwner() {
286     require(msg.sender == owner);
287     _;
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address newOwner) public onlyOwner {
295     require(newOwner != address(0));
296     OwnershipTransferred(owner, newOwner);
297     owner = newOwner;
298   }
299 
300 }
301 
302 
303 
304 contract Recoverable is Ownable {
305 
306   /// @dev Empty constructor (for now)
307   function Recoverable() {
308   }
309 
310   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
311   /// @param token Token which will we rescue to the owner from the contract
312   function recoverTokens(ERC20Basic token) onlyOwner public {
313     token.transfer(owner, tokensToBeReturned(token));
314   }
315 
316   /// @dev Interface function, can be overwritten by the superclass
317   /// @param token Token which balance we will check and return
318   /// @return The amount of tokens (in smallest denominator) the contract owns
319   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
320     return token.balanceOf(this);
321   }
322 }
323 
324 
325 
326 /**
327  * Standard EIP-20 token with an interface marker.
328  *
329  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
330  *
331  */
332 contract StandardTokenExt is StandardToken, Recoverable {
333 
334   /* Interface declaration */
335   function isToken() public constant returns (bool weAre) {
336     return true;
337   }
338 }
339 
340 
341 contract BurnableToken is StandardTokenExt {
342 
343   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
344   address public constant BURN_ADDRESS = 0;
345 
346   /** How many tokens we burned */
347   event Burned(address burner, uint burnedAmount);
348 
349   /**
350    * Burn extra tokens from a balance.
351    *
352    */
353   function burn(uint burnAmount) {
354     address burner = msg.sender;
355     balances[burner] = balances[burner].sub(burnAmount);
356     totalSupply_ = totalSupply_.sub(burnAmount);
357     Burned(burner, burnAmount);
358 
359     // Inform the blockchain explores that track the
360     // balances only by a transfer event that the balance in this
361     // address has decreased
362     Transfer(burner, BURN_ADDRESS, burnAmount);
363   }
364 }
365 
366 /**
367  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
368  *
369  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
370  */
371 
372 
373 /**
374  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
375  *
376  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
377  */
378 
379 
380 
381 
382 /**
383  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
384  *
385  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
386  */
387 
388 
389 /**
390  * Upgrade agent interface inspired by Lunyr.
391  *
392  * Upgrade agent transfers tokens to a new contract.
393  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
394  */
395 contract UpgradeAgent {
396 
397   uint public originalSupply;
398 
399   /** Interface marker */
400   function isUpgradeAgent() public constant returns (bool) {
401     return true;
402   }
403 
404   function upgradeFrom(address _from, uint256 _value) public;
405 
406 }
407 
408 
409 /**
410  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
411  *
412  * First envisioned by Golem and Lunyr projects.
413  */
414 contract UpgradeableToken is StandardTokenExt {
415 
416   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
417   address public upgradeMaster;
418 
419   /** The next contract where the tokens will be migrated. */
420   UpgradeAgent public upgradeAgent;
421 
422   /** How many tokens we have upgraded by now. */
423   uint256 public totalUpgraded;
424 
425   /**
426    * Upgrade states.
427    *
428    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
429    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
430    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
431    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
432    *
433    */
434   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
435 
436   /**
437    * Somebody has upgraded some of his tokens.
438    */
439   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
440 
441   /**
442    * New upgrade agent available.
443    */
444   event UpgradeAgentSet(address agent);
445 
446   /**
447    * Do not allow construction without upgrade master set.
448    */
449   function UpgradeableToken(address _upgradeMaster) {
450     upgradeMaster = _upgradeMaster;
451   }
452 
453   /**
454    * Allow the token holder to upgrade some of their tokens to a new contract.
455    */
456   function upgrade(uint256 value) public {
457 
458       UpgradeState state = getUpgradeState();
459       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
460         // Called in a bad state
461         throw;
462       }
463 
464       // Validate input value.
465       if (value == 0) throw;
466 
467       balances[msg.sender] = balances[msg.sender].sub(value);
468 
469       // Take tokens out from circulation
470       totalSupply_ = totalSupply_.sub(value);
471       totalUpgraded = totalUpgraded.add(value);
472 
473       // Upgrade agent reissues the tokens
474       upgradeAgent.upgradeFrom(msg.sender, value);
475       Upgrade(msg.sender, upgradeAgent, value);
476   }
477 
478   /**
479    * Set an upgrade agent that handles
480    */
481   function setUpgradeAgent(address agent) external {
482 
483       if(!canUpgrade()) {
484         // The token is not yet in a state that we could think upgrading
485         throw;
486       }
487 
488       if (agent == 0x0) throw;
489       // Only a master can designate the next agent
490       if (msg.sender != upgradeMaster) throw;
491       // Upgrade has already begun for an agent
492       if (getUpgradeState() == UpgradeState.Upgrading) throw;
493 
494       upgradeAgent = UpgradeAgent(agent);
495 
496       // Bad interface
497       if(!upgradeAgent.isUpgradeAgent()) throw;
498       // Make sure that token supplies match in source and target
499       if (upgradeAgent.originalSupply() != totalSupply_) throw;
500 
501       UpgradeAgentSet(upgradeAgent);
502   }
503 
504   /**
505    * Get the state of the token upgrade.
506    */
507   function getUpgradeState() public constant returns(UpgradeState) {
508     if(!canUpgrade()) return UpgradeState.NotAllowed;
509     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
510     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
511     else return UpgradeState.Upgrading;
512   }
513 
514   /**
515    * Change the upgrade master.
516    *
517    * This allows us to set a new owner for the upgrade mechanism.
518    */
519   function setUpgradeMaster(address master) public {
520       if (master == 0x0) throw;
521       if (msg.sender != upgradeMaster) throw;
522       upgradeMaster = master;
523   }
524 
525   /**
526    * Child contract can enable to provide the condition when the upgrade can begun.
527    */
528   function canUpgrade() public constant returns(bool) {
529      return true;
530   }
531 
532 }
533 
534 /**
535  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
536  *
537  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
538  */
539 
540 
541 
542 
543 
544 /**
545  * Define interface for releasing the token transfer after a successful crowdsale.
546  */
547 contract ReleasableToken is StandardTokenExt {
548 
549   /* The finalizer contract that allows unlift the transfer limits on this token */
550   address public releaseAgent;
551 
552   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
553   bool public released = false;
554 
555   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
556   mapping (address => bool) public transferAgents;
557 
558   /**
559    * Limit token transfer until the crowdsale is over.
560    *
561    */
562   modifier canTransfer(address _sender) {
563 
564     if(!released) {
565         if(!transferAgents[_sender]) {
566             throw;
567         }
568     }
569 
570     _;
571   }
572 
573   /**
574    * Set the contract that can call release and make the token transferable.
575    *
576    * Design choice. Allow reset the release agent to fix fat finger mistakes.
577    */
578   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
579 
580     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
581     releaseAgent = addr;
582   }
583 
584   /**
585    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
586    */
587   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
588     transferAgents[addr] = state;
589   }
590 
591   /**
592    * One way function to release the tokens to the wild.
593    *
594    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
595    */
596   function releaseTokenTransfer() public onlyReleaseAgent {
597     released = true;
598   }
599 
600   /** The function can be called only before or after the tokens have been releasesd */
601   modifier inReleaseState(bool releaseState) {
602     if(releaseState != released) {
603         throw;
604     }
605     _;
606   }
607 
608   /** The function can be called only by a whitelisted release agent. */
609   modifier onlyReleaseAgent() {
610     if(msg.sender != releaseAgent) {
611         throw;
612     }
613     _;
614   }
615 
616   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
617     // Call StandardToken.transfer()
618    return super.transfer(_to, _value);
619   }
620 
621   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
622     // Call StandardToken.transferForm()
623     return super.transferFrom(_from, _to, _value);
624   }
625 
626 }
627 
628 /**
629  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
630  *
631  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
632  */
633 
634 
635 
636 /**
637  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
638  *
639  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
640  */
641 
642 
643 /**
644  * Safe unsigned safe math.
645  *
646  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
647  *
648  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
649  *
650  * Maintained here until merged to mainline zeppelin-solidity.
651  *
652  */
653 library SafeMathLib {
654 
655   function times(uint a, uint b) returns (uint) {
656     uint c = a * b;
657     assert(a == 0 || c / a == b);
658     return c;
659   }
660 
661   function minus(uint a, uint b) returns (uint) {
662     assert(b <= a);
663     return a - b;
664   }
665 
666   function plus(uint a, uint b) returns (uint) {
667     uint c = a + b;
668     assert(c>=a);
669     return c;
670   }
671 
672 }
673 
674 
675 
676 /**
677  * A token that can increase its supply by another contract.
678  *
679  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
680  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
681  *
682  */
683 contract MintableToken is StandardTokenExt {
684 
685   using SafeMathLib for uint;
686 
687   bool public mintingFinished = false;
688 
689   /** List of agents that are allowed to create new tokens */
690   mapping (address => bool) public mintAgents;
691 
692   event MintingAgentChanged(address addr, bool state);
693   event Minted(address receiver, uint amount);
694 
695   /**
696    * Create new tokens and allocate them to an address..
697    *
698    * Only callably by a crowdsale contract (mint agent).
699    */
700   function mint(address receiver, uint amount) onlyMintAgent canMint public {
701     totalSupply_ = totalSupply_.plus(amount);
702     balances[receiver] = balances[receiver].plus(amount);
703 
704     // This will make the mint transaction apper in EtherScan.io
705     // We can remove this after there is a standardized minting event
706     Transfer(0, receiver, amount);
707   }
708 
709   /**
710    * Owner can allow a crowdsale contract to mint new tokens.
711    */
712   function setMintAgent(address addr, bool state) onlyOwner canMint public {
713     mintAgents[addr] = state;
714     MintingAgentChanged(addr, state);
715   }
716 
717   modifier onlyMintAgent() {
718     // Only crowdsale contracts are allowed to mint new tokens
719     if(!mintAgents[msg.sender]) {
720         throw;
721     }
722     _;
723   }
724 
725   /** Make sure we are not done yet. */
726   modifier canMint() {
727     if(mintingFinished) throw;
728     _;
729   }
730 }
731 
732 
733 
734 /**
735  * A crowdsaled token.
736  *
737  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
738  *
739  * - The token transfer() is disabled until the crowdsale is over
740  * - The token contract gives an opt-in upgrade path to a new contract
741  * - The same token can be part of several crowdsales through approve() mechanism
742  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
743  *
744  */
745 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
746 
747   /** Name and symbol were updated. */
748   event UpdatedTokenInformation(string newName, string newSymbol);
749 
750   string public name;
751 
752   string public symbol;
753 
754   uint public decimals;
755 
756   /**
757    * Construct the token.
758    *
759    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
760    *
761    * @param _name Token name
762    * @param _symbol Token symbol - should be all caps
763    * @param _initialSupply How many tokens we start with
764    * @param _decimals Number of decimal places
765    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
766    */
767   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
768     UpgradeableToken(msg.sender) {
769 
770     // Create any address, can be transferred
771     // to team multisig via changeOwner(),
772     // also remember to call setUpgradeMaster()
773     owner = msg.sender;
774 
775     name = _name;
776     symbol = _symbol;
777 
778     totalSupply_ = _initialSupply;
779 
780     decimals = _decimals;
781 
782     // Create initially all balance on the team multisig
783     balances[owner] = totalSupply_;
784 
785     if(totalSupply_ > 0) {
786       Minted(owner, totalSupply_);
787     }
788 
789     // No more new supply allowed after the token creation
790     if(!_mintable) {
791       mintingFinished = true;
792       if(totalSupply_ == 0) {
793         throw; // Cannot create a token without supply and no minting
794       }
795     }
796   }
797 
798   /**
799    * When token is released to be transferable, enforce no new tokens can be created.
800    */
801   function releaseTokenTransfer() public onlyReleaseAgent {
802     mintingFinished = true;
803     super.releaseTokenTransfer();
804   }
805 
806   /**
807    * Allow upgrade agent functionality kick in only if the crowdsale was success.
808    */
809   function canUpgrade() public constant returns(bool) {
810     return released && super.canUpgrade();
811   }
812 
813   /**
814    * Owner can update token information here.
815    *
816    * It is often useful to conceal the actual token association, until
817    * the token operations, like central issuance or reissuance have been completed.
818    *
819    * This function allows the token owner to rename the token after the operations
820    * have been completed and then point the audience to use the token contract.
821    */
822   function setTokenInformation(string _name, string _symbol) onlyOwner {
823     name = _name;
824     symbol = _symbol;
825 
826     UpdatedTokenInformation(name, symbol);
827   }
828 
829 }
830 
831 
832 /**
833  * A crowdsaled token that you can also burn.
834  *
835  */
836 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
837 
838   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
839     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
840 
841   }
842 }
843 
844 
845 
846 /**
847  * The AML Token
848  *
849  * This subset of BurnableCrowdsaleToken gives the Owner a possibility to
850  * reclaim tokens from a participant before the token is released
851  * after a participant has failed a prolonged AML process.
852  *
853  * It is assumed that the anti-money laundering process depends on blockchain data.
854  * The data is not available before the transaction and not for the smart contract.
855  * Thus, we need to implement logic to handle AML failure cases post payment.
856  * We give a time window before the token release for the token sale owners to
857  * complete the AML and claw back all token transactions that were
858  * caused by rejected purchases.
859  */
860 contract AMLToken is BurnableCrowdsaleToken {
861 
862   // An event when the owner has reclaimed non-released tokens
863   event OwnerReclaim(address fromWhom, uint amount);
864 
865   function AMLToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
866 
867   }
868 
869   /// @dev Here the owner can reclaim the tokens from a participant if
870   ///      the token is not released yet. Refund will be handled offband.
871   /// @param fromWhom address of the participant whose tokens we want to claim
872   function transferToOwner(address fromWhom) onlyOwner {
873     if (released) revert();
874 
875     uint amount = balanceOf(fromWhom);
876     balances[fromWhom] = balances[fromWhom].sub(amount);
877     balances[owner] = balances[owner].add(amount);
878     Transfer(fromWhom, owner, amount);
879     OwnerReclaim(fromWhom, amount);
880   }
881 }