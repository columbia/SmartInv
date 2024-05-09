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
26 
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 
88 
89 /**
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances.
92  */
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   uint256 totalSupply_;
99 
100   /**
101   * @dev total number of tokens in existence
102   */
103   function totalSupply() public view returns (uint256) {
104     return totalSupply_;
105   }
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 
135 
136 
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender) public view returns (uint256);
144   function transferFrom(address from, address to, uint256 value) public returns (bool);
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    *
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(address _owner, address _spender) public view returns (uint256) {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    *
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To decrement
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _subtractedValue The amount of tokens to decrease the allowance by.
232    */
233   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
234     uint oldValue = allowed[msg.sender][_spender];
235     if (_subtractedValue > oldValue) {
236       allowed[msg.sender][_spender] = 0;
237     } else {
238       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239     }
240     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244 }
245 
246 /**
247  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
248  *
249  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
250  */
251 
252 
253 
254 
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address public owner;
262 
263 
264   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266 
267   /**
268    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
269    * account.
270    */
271   function Ownable() public {
272     owner = msg.sender;
273   }
274 
275   /**
276    * @dev Throws if called by any account other than the owner.
277    */
278   modifier onlyOwner() {
279     require(msg.sender == owner);
280     _;
281   }
282 
283   /**
284    * @dev Allows the current owner to transfer control of the contract to a newOwner.
285    * @param newOwner The address to transfer ownership to.
286    */
287   function transferOwnership(address newOwner) public onlyOwner {
288     require(newOwner != address(0));
289     OwnershipTransferred(owner, newOwner);
290     owner = newOwner;
291   }
292 
293 }
294 
295 
296 
297 contract Recoverable is Ownable {
298 
299   /// @dev Empty constructor (for now)
300   function Recoverable() {
301   }
302 
303   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
304   /// @param token Token which will we rescue to the owner from the contract
305   function recoverTokens(ERC20Basic token) onlyOwner public {
306     token.transfer(owner, tokensToBeReturned(token));
307   }
308 
309   /// @dev Interface function, can be overwritten by the superclass
310   /// @param token Token which balance we will check and return
311   /// @return The amount of tokens (in smallest denominator) the contract owns
312   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
313     return token.balanceOf(this);
314   }
315 }
316 
317 
318 
319 /**
320  * Standard EIP-20 token with an interface marker.
321  *
322  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
323  *
324  */
325 contract StandardTokenExt is StandardToken, Recoverable {
326 
327   /* Interface declaration */
328   function isToken() public constant returns (bool weAre) {
329     return true;
330   }
331 }
332 
333 
334 contract BurnableToken is StandardTokenExt {
335 
336   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
337   address public constant BURN_ADDRESS = 0;
338 
339   /** How many tokens we burned */
340   event Burned(address burner, uint burnedAmount);
341 
342   /**
343    * Burn extra tokens from a balance.
344    *
345    */
346   function burn(uint burnAmount) {
347     address burner = msg.sender;
348     balances[burner] = balances[burner].sub(burnAmount);
349     totalSupply_ = totalSupply_.sub(burnAmount);
350     Burned(burner, burnAmount);
351 
352     // Inform the blockchain explores that track the
353     // balances only by a transfer event that the balance in this
354     // address has decreased
355     Transfer(burner, BURN_ADDRESS, burnAmount);
356   }
357 }
358 
359 /**
360  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
361  *
362  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
363  */
364 
365 
366 /**
367  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
368  *
369  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
370  */
371 
372 
373 
374 
375 /**
376  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
377  *
378  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
379  */
380 
381 
382 /**
383  * Upgrade agent interface inspired by Lunyr.
384  *
385  * Upgrade agent transfers tokens to a new contract.
386  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
387  */
388 contract UpgradeAgent {
389 
390   uint public originalSupply;
391 
392   /** Interface marker */
393   function isUpgradeAgent() public constant returns (bool) {
394     return true;
395   }
396 
397   function upgradeFrom(address _from, uint256 _value) public;
398 
399 }
400 
401 
402 /**
403  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
404  *
405  * First envisioned by Golem and Lunyr projects.
406  */
407 contract UpgradeableToken is StandardTokenExt {
408 
409   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
410   address public upgradeMaster;
411 
412   /** The next contract where the tokens will be migrated. */
413   UpgradeAgent public upgradeAgent;
414 
415   /** How many tokens we have upgraded by now. */
416   uint256 public totalUpgraded;
417 
418   /**
419    * Upgrade states.
420    *
421    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
422    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
423    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
424    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
425    *
426    */
427   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
428 
429   /**
430    * Somebody has upgraded some of his tokens.
431    */
432   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
433 
434   /**
435    * New upgrade agent available.
436    */
437   event UpgradeAgentSet(address agent);
438 
439   /**
440    * Do not allow construction without upgrade master set.
441    */
442   function UpgradeableToken(address _upgradeMaster) {
443     upgradeMaster = _upgradeMaster;
444   }
445 
446   /**
447    * Allow the token holder to upgrade some of their tokens to a new contract.
448    */
449   function upgrade(uint256 value) public {
450 
451       UpgradeState state = getUpgradeState();
452       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
453         // Called in a bad state
454         throw;
455       }
456 
457       // Validate input value.
458       if (value == 0) throw;
459 
460       balances[msg.sender] = balances[msg.sender].sub(value);
461 
462       // Take tokens out from circulation
463       totalSupply_ = totalSupply_.sub(value);
464       totalUpgraded = totalUpgraded.add(value);
465 
466       // Upgrade agent reissues the tokens
467       upgradeAgent.upgradeFrom(msg.sender, value);
468       Upgrade(msg.sender, upgradeAgent, value);
469   }
470 
471   /**
472    * Set an upgrade agent that handles
473    */
474   function setUpgradeAgent(address agent) external {
475 
476       if(!canUpgrade()) {
477         // The token is not yet in a state that we could think upgrading
478         throw;
479       }
480 
481       if (agent == 0x0) throw;
482       // Only a master can designate the next agent
483       if (msg.sender != upgradeMaster) throw;
484       // Upgrade has already begun for an agent
485       if (getUpgradeState() == UpgradeState.Upgrading) throw;
486 
487       upgradeAgent = UpgradeAgent(agent);
488 
489       // Bad interface
490       if(!upgradeAgent.isUpgradeAgent()) throw;
491       // Make sure that token supplies match in source and target
492       if (upgradeAgent.originalSupply() != totalSupply_) throw;
493 
494       UpgradeAgentSet(upgradeAgent);
495   }
496 
497   /**
498    * Get the state of the token upgrade.
499    */
500   function getUpgradeState() public constant returns(UpgradeState) {
501     if(!canUpgrade()) return UpgradeState.NotAllowed;
502     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
503     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
504     else return UpgradeState.Upgrading;
505   }
506 
507   /**
508    * Change the upgrade master.
509    *
510    * This allows us to set a new owner for the upgrade mechanism.
511    */
512   function setUpgradeMaster(address master) public {
513       if (master == 0x0) throw;
514       if (msg.sender != upgradeMaster) throw;
515       upgradeMaster = master;
516   }
517 
518   /**
519    * Child contract can enable to provide the condition when the upgrade can begun.
520    */
521   function canUpgrade() public constant returns(bool) {
522      return true;
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
536 
537 /**
538  * Define interface for releasing the token transfer after a successful crowdsale.
539  */
540 contract ReleasableToken is StandardTokenExt {
541 
542   /* The finalizer contract that allows unlift the transfer limits on this token */
543   address public releaseAgent;
544 
545   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
546   bool public released = false;
547 
548   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
549   mapping (address => bool) public transferAgents;
550 
551   /**
552    * Limit token transfer until the crowdsale is over.
553    *
554    */
555   modifier canTransfer(address _sender) {
556 
557     if(!released) {
558         if(!transferAgents[_sender]) {
559             throw;
560         }
561     }
562 
563     _;
564   }
565 
566   /**
567    * Set the contract that can call release and make the token transferable.
568    *
569    * Design choice. Allow reset the release agent to fix fat finger mistakes.
570    */
571   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
572 
573     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
574     releaseAgent = addr;
575   }
576 
577   /**
578    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
579    */
580   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
581     transferAgents[addr] = state;
582   }
583 
584   /**
585    * One way function to release the tokens to the wild.
586    *
587    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
588    */
589   function releaseTokenTransfer() public onlyReleaseAgent {
590     released = true;
591   }
592 
593   /** The function can be called only before or after the tokens have been releasesd */
594   modifier inReleaseState(bool releaseState) {
595     if(releaseState != released) {
596         throw;
597     }
598     _;
599   }
600 
601   /** The function can be called only by a whitelisted release agent. */
602   modifier onlyReleaseAgent() {
603     if(msg.sender != releaseAgent) {
604         throw;
605     }
606     _;
607   }
608 
609   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
610     // Call StandardToken.transfer()
611    return super.transfer(_to, _value);
612   }
613 
614   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
615     // Call StandardToken.transferForm()
616     return super.transferFrom(_from, _to, _value);
617   }
618 
619 }
620 
621 /**
622  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
623  *
624  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
625  */
626 
627 
628 
629 /**
630  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
631  *
632  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
633  */
634 
635 
636 /**
637  * Safe unsigned safe math.
638  *
639  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
640  *
641  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
642  *
643  * Maintained here until merged to mainline zeppelin-solidity.
644  *
645  */
646 library SafeMathLib {
647 
648   function times(uint a, uint b) returns (uint) {
649     uint c = a * b;
650     assert(a == 0 || c / a == b);
651     return c;
652   }
653 
654   function minus(uint a, uint b) returns (uint) {
655     assert(b <= a);
656     return a - b;
657   }
658 
659   function plus(uint a, uint b) returns (uint) {
660     uint c = a + b;
661     assert(c>=a);
662     return c;
663   }
664 
665 }
666 
667 
668 
669 /**
670  * A token that can increase its supply by another contract.
671  *
672  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
673  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
674  *
675  */
676 contract MintableToken is StandardTokenExt {
677 
678   using SafeMathLib for uint;
679 
680   bool public mintingFinished = false;
681 
682   /** List of agents that are allowed to create new tokens */
683   mapping (address => bool) public mintAgents;
684 
685   event MintingAgentChanged(address addr, bool state);
686   event Minted(address receiver, uint amount);
687 
688   /**
689    * Create new tokens and allocate them to an address..
690    *
691    * Only callably by a crowdsale contract (mint agent).
692    */
693   function mint(address receiver, uint amount) onlyMintAgent canMint public {
694     totalSupply_ = totalSupply_.plus(amount);
695     balances[receiver] = balances[receiver].plus(amount);
696 
697     // This will make the mint transaction apper in EtherScan.io
698     // We can remove this after there is a standardized minting event
699     Transfer(0, receiver, amount);
700   }
701 
702   /**
703    * Owner can allow a crowdsale contract to mint new tokens.
704    */
705   function setMintAgent(address addr, bool state) onlyOwner canMint public {
706     mintAgents[addr] = state;
707     MintingAgentChanged(addr, state);
708   }
709 
710   modifier onlyMintAgent() {
711     // Only crowdsale contracts are allowed to mint new tokens
712     if(!mintAgents[msg.sender]) {
713         throw;
714     }
715     _;
716   }
717 
718   /** Make sure we are not done yet. */
719   modifier canMint() {
720     if(mintingFinished) throw;
721     _;
722   }
723 }
724 
725 
726 
727 /**
728  * A crowdsaled token.
729  *
730  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
731  *
732  * - The token transfer() is disabled until the crowdsale is over
733  * - The token contract gives an opt-in upgrade path to a new contract
734  * - The same token can be part of several crowdsales through approve() mechanism
735  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
736  *
737  */
738 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
739 
740   /** Name and symbol were updated. */
741   event UpdatedTokenInformation(string newName, string newSymbol);
742 
743   string public name;
744 
745   string public symbol;
746 
747   uint public decimals;
748 
749   /**
750    * Construct the token.
751    *
752    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
753    *
754    * @param _name Token name
755    * @param _symbol Token symbol - should be all caps
756    * @param _initialSupply How many tokens we start with
757    * @param _decimals Number of decimal places
758    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
759    */
760   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
761     UpgradeableToken(msg.sender) {
762 
763     // Create any address, can be transferred
764     // to team multisig via changeOwner(),
765     // also remember to call setUpgradeMaster()
766     owner = msg.sender;
767 
768     name = _name;
769     symbol = _symbol;
770 
771     totalSupply_ = _initialSupply;
772 
773     decimals = _decimals;
774 
775     // Create initially all balance on the team multisig
776     balances[owner] = totalSupply_;
777 
778     if(totalSupply_ > 0) {
779       Minted(owner, totalSupply_);
780     }
781 
782     // No more new supply allowed after the token creation
783     if(!_mintable) {
784       mintingFinished = true;
785       if(totalSupply_ == 0) {
786         throw; // Cannot create a token without supply and no minting
787       }
788     }
789   }
790 
791   /**
792    * When token is released to be transferable, enforce no new tokens can be created.
793    */
794   function releaseTokenTransfer() public onlyReleaseAgent {
795     mintingFinished = true;
796     super.releaseTokenTransfer();
797   }
798 
799   /**
800    * Allow upgrade agent functionality kick in only if the crowdsale was success.
801    */
802   function canUpgrade() public constant returns(bool) {
803     return released && super.canUpgrade();
804   }
805 
806   /**
807    * Owner can update token information here.
808    *
809    * It is often useful to conceal the actual token association, until
810    * the token operations, like central issuance or reissuance have been completed.
811    *
812    * This function allows the token owner to rename the token after the operations
813    * have been completed and then point the audience to use the token contract.
814    */
815   function setTokenInformation(string _name, string _symbol) onlyOwner {
816     name = _name;
817     symbol = _symbol;
818 
819     UpdatedTokenInformation(name, symbol);
820   }
821 
822 }
823 
824 
825 /**
826  * A crowdsaled token that you can also burn.
827  *
828  */
829 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
830 
831   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
832     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
833 
834   }
835 }