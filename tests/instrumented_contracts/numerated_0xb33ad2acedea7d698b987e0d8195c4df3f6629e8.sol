1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
49  *
50  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
51  */
52 
53 
54 /**
55  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
56  *
57  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
58  */
59 
60 
61 
62 
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/179
68  */
69 contract ERC20Basic {
70   function totalSupply() public view returns (uint256);
71   function balanceOf(address who) public view returns (uint256);
72   function transfer(address to, uint256 value) public returns (bool);
73   event Transfer(address indexed from, address indexed to, uint256 value);
74 }
75 
76 
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public view returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
91  *
92  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
93  */
94 
95 
96 
97 
98 
99 
100 
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   uint256 totalSupply_;
113 
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
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
333 /**
334  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
335  *
336  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
337  */
338 
339 
340 /**
341  * Upgrade agent interface inspired by Lunyr.
342  *
343  * Upgrade agent transfers tokens to a new contract.
344  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
345  */
346 contract UpgradeAgent {
347 
348   uint public originalSupply;
349 
350   /** Interface marker */
351   function isUpgradeAgent() public constant returns (bool) {
352     return true;
353   }
354 
355   function upgradeFrom(address _from, uint256 _value) public;
356 
357 }
358 
359 
360 /**
361  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
362  *
363  * First envisioned by Golem and Lunyr projects.
364  */
365 contract UpgradeableToken is StandardTokenExt {
366 
367   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
368   address public upgradeMaster;
369 
370   /** The next contract where the tokens will be migrated. */
371   UpgradeAgent public upgradeAgent;
372 
373   /** How many tokens we have upgraded by now. */
374   uint256 public totalUpgraded;
375 
376   /**
377    * Upgrade states.
378    *
379    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
380    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
381    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
382    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
383    *
384    */
385   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
386 
387   /**
388    * Somebody has upgraded some of his tokens.
389    */
390   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
391 
392   /**
393    * New upgrade agent available.
394    */
395   event UpgradeAgentSet(address agent);
396 
397   /**
398    * Do not allow construction without upgrade master set.
399    */
400   function UpgradeableToken(address _upgradeMaster) {
401     upgradeMaster = _upgradeMaster;
402   }
403 
404   /**
405    * Allow the token holder to upgrade some of their tokens to a new contract.
406    */
407   function upgrade(uint256 value) public {
408 
409       UpgradeState state = getUpgradeState();
410       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
411         // Called in a bad state
412         throw;
413       }
414 
415       // Validate input value.
416       if (value == 0) throw;
417 
418       balances[msg.sender] = balances[msg.sender].sub(value);
419 
420       // Take tokens out from circulation
421       totalSupply_ = totalSupply_.sub(value);
422       totalUpgraded = totalUpgraded.add(value);
423 
424       // Upgrade agent reissues the tokens
425       upgradeAgent.upgradeFrom(msg.sender, value);
426       Upgrade(msg.sender, upgradeAgent, value);
427   }
428 
429   /**
430    * Set an upgrade agent that handles
431    */
432   function setUpgradeAgent(address agent) external {
433 
434       if(!canUpgrade()) {
435         // The token is not yet in a state that we could think upgrading
436         throw;
437       }
438 
439       if (agent == 0x0) throw;
440       // Only a master can designate the next agent
441       if (msg.sender != upgradeMaster) throw;
442       // Upgrade has already begun for an agent
443       if (getUpgradeState() == UpgradeState.Upgrading) throw;
444 
445       upgradeAgent = UpgradeAgent(agent);
446 
447       // Bad interface
448       if(!upgradeAgent.isUpgradeAgent()) throw;
449       // Make sure that token supplies match in source and target
450       if (upgradeAgent.originalSupply() != totalSupply_) throw;
451 
452       UpgradeAgentSet(upgradeAgent);
453   }
454 
455   /**
456    * Get the state of the token upgrade.
457    */
458   function getUpgradeState() public constant returns(UpgradeState) {
459     if(!canUpgrade()) return UpgradeState.NotAllowed;
460     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
461     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
462     else return UpgradeState.Upgrading;
463   }
464 
465   /**
466    * Change the upgrade master.
467    *
468    * This allows us to set a new owner for the upgrade mechanism.
469    */
470   function setUpgradeMaster(address master) public {
471       if (master == 0x0) throw;
472       if (msg.sender != upgradeMaster) throw;
473       upgradeMaster = master;
474   }
475 
476   /**
477    * Child contract can enable to provide the condition when the upgrade can begun.
478    */
479   function canUpgrade() public constant returns(bool) {
480      return true;
481   }
482 
483 }
484 
485 /**
486  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
487  *
488  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
489  */
490 
491 
492 
493 
494 
495 /**
496  * Define interface for releasing the token transfer after a successful crowdsale.
497  */
498 contract ReleasableToken is StandardTokenExt {
499 
500   /* The finalizer contract that allows unlift the transfer limits on this token */
501   address public releaseAgent;
502 
503   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
504   bool public released = false;
505 
506   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
507   mapping (address => bool) public transferAgents;
508 
509   /**
510    * Limit token transfer until the crowdsale is over.
511    *
512    */
513   modifier canTransfer(address _sender) {
514 
515     if(!released) {
516         if(!transferAgents[_sender]) {
517             throw;
518         }
519     }
520 
521     _;
522   }
523 
524   /**
525    * Set the contract that can call release and make the token transferable.
526    *
527    * Design choice. Allow reset the release agent to fix fat finger mistakes.
528    */
529   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
530 
531     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
532     releaseAgent = addr;
533   }
534 
535   /**
536    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
537    */
538   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
539     transferAgents[addr] = state;
540   }
541 
542   /**
543    * One way function to release the tokens to the wild.
544    *
545    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
546    */
547   function releaseTokenTransfer() public onlyReleaseAgent {
548     released = true;
549   }
550 
551   /** The function can be called only before or after the tokens have been releasesd */
552   modifier inReleaseState(bool releaseState) {
553     if(releaseState != released) {
554         throw;
555     }
556     _;
557   }
558 
559   /** The function can be called only by a whitelisted release agent. */
560   modifier onlyReleaseAgent() {
561     if(msg.sender != releaseAgent) {
562         throw;
563     }
564     _;
565   }
566 
567   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
568     // Call StandardToken.transfer()
569    return super.transfer(_to, _value);
570   }
571 
572   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
573     // Call StandardToken.transferForm()
574     return super.transferFrom(_from, _to, _value);
575   }
576 
577 }
578 
579 /**
580  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
581  *
582  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
583  */
584 
585 
586 
587 /**
588  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
589  *
590  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
591  */
592 
593 
594 /**
595  * Safe unsigned safe math.
596  *
597  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
598  *
599  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
600  *
601  * Maintained here until merged to mainline zeppelin-solidity.
602  *
603  */
604 library SafeMathLib {
605 
606   function times(uint a, uint b) returns (uint) {
607     uint c = a * b;
608     assert(a == 0 || c / a == b);
609     return c;
610   }
611 
612   function minus(uint a, uint b) returns (uint) {
613     assert(b <= a);
614     return a - b;
615   }
616 
617   function plus(uint a, uint b) returns (uint) {
618     uint c = a + b;
619     assert(c>=a);
620     return c;
621   }
622 
623 }
624 
625 
626 
627 /**
628  * A token that can increase its supply by another contract.
629  *
630  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
631  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
632  *
633  */
634 contract MintableToken is StandardTokenExt {
635 
636   using SafeMathLib for uint;
637 
638   bool public mintingFinished = false;
639 
640   /** List of agents that are allowed to create new tokens */
641   mapping (address => bool) public mintAgents;
642 
643   event MintingAgentChanged(address addr, bool state);
644   event Minted(address receiver, uint amount);
645 
646   /**
647    * Create new tokens and allocate them to an address..
648    *
649    * Only callably by a crowdsale contract (mint agent).
650    */
651   function mint(address receiver, uint amount) onlyMintAgent canMint public {
652     totalSupply_ = totalSupply_.plus(amount);
653     balances[receiver] = balances[receiver].plus(amount);
654 
655     // This will make the mint transaction apper in EtherScan.io
656     // We can remove this after there is a standardized minting event
657     Transfer(0, receiver, amount);
658   }
659 
660   /**
661    * Owner can allow a crowdsale contract to mint new tokens.
662    */
663   function setMintAgent(address addr, bool state) onlyOwner canMint public {
664     mintAgents[addr] = state;
665     MintingAgentChanged(addr, state);
666   }
667 
668   modifier onlyMintAgent() {
669     // Only crowdsale contracts are allowed to mint new tokens
670     if(!mintAgents[msg.sender]) {
671         throw;
672     }
673     _;
674   }
675 
676   /** Make sure we are not done yet. */
677   modifier canMint() {
678     if(mintingFinished) throw;
679     _;
680   }
681 }
682 
683 
684 
685 /**
686  * A crowdsaled token.
687  *
688  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
689  *
690  * - The token transfer() is disabled until the crowdsale is over
691  * - The token contract gives an opt-in upgrade path to a new contract
692  * - The same token can be part of several crowdsales through approve() mechanism
693  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
694  *
695  */
696 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
697 
698   /** Name and symbol were updated. */
699   event UpdatedTokenInformation(string newName, string newSymbol);
700 
701   string public name;
702 
703   string public symbol;
704 
705   uint public decimals;
706 
707   /**
708    * Construct the token.
709    *
710    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
711    *
712    * @param _name Token name
713    * @param _symbol Token symbol - should be all caps
714    * @param _initialSupply How many tokens we start with
715    * @param _decimals Number of decimal places
716    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
717    */
718   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
719     UpgradeableToken(msg.sender) {
720 
721     // Create any address, can be transferred
722     // to team multisig via changeOwner(),
723     // also remember to call setUpgradeMaster()
724     owner = msg.sender;
725 
726     name = _name;
727     symbol = _symbol;
728 
729     totalSupply_ = _initialSupply;
730 
731     decimals = _decimals;
732 
733     // Create initially all balance on the team multisig
734     balances[owner] = totalSupply_;
735 
736     if(totalSupply_ > 0) {
737       Minted(owner, totalSupply_);
738     }
739 
740     // No more new supply allowed after the token creation
741     if(!_mintable) {
742       mintingFinished = true;
743       if(totalSupply_ == 0) {
744         throw; // Cannot create a token without supply and no minting
745       }
746     }
747   }
748 
749   /**
750    * When token is released to be transferable, enforce no new tokens can be created.
751    */
752   function releaseTokenTransfer() public onlyReleaseAgent {
753     mintingFinished = true;
754     super.releaseTokenTransfer();
755   }
756 
757   /**
758    * Allow upgrade agent functionality kick in only if the crowdsale was success.
759    */
760   function canUpgrade() public constant returns(bool) {
761     return released && super.canUpgrade();
762   }
763 
764   /**
765    * Owner can update token information here.
766    *
767    * It is often useful to conceal the actual token association, until
768    * the token operations, like central issuance or reissuance have been completed.
769    *
770    * This function allows the token owner to rename the token after the operations
771    * have been completed and then point the audience to use the token contract.
772    */
773   function setTokenInformation(string _name, string _symbol) onlyOwner {
774     name = _name;
775     symbol = _symbol;
776 
777     UpdatedTokenInformation(name, symbol);
778   }
779 
780 }
781 
782 
783 /**
784  * Define interface for releasing the token transfer after a successful crowdsale.
785  */
786 contract FCCToken is CrowdsaleToken {
787 
788     using SafeMath for uint;
789 
790     /**
791     * Define spending amount schedule using Period.
792     */
793     struct Period {
794 
795         // UNIX timestamp when this milestone kicks in
796         uint time;
797 
798         // How many percentage of invesetedTokens
799         uint percentage;
800     }
801 
802     // Store periods in a fixed array, so that it can be seen in a blockchain explorer
803     Period[2] public periods;
804 
805     // Get specified period by index
806     function getPeriod(uint n) public view returns (uint, uint) {
807         return (periods[n].time, periods[n].percentage);
808     }
809 
810     // Get transfered token of specified address
811     function transferedTokenOf(address _owner) public view returns (uint256 balance) {
812         return transferedToken[_owner];
813     }
814 
815     // Get purchased token of specified address
816     function investedCrowdsaleTokenOf(address _owner) public view returns (uint256 balance) {
817         return investedCrowdsaleToken[_owner];
818     }
819 
820     // Get received token of specified address
821     function receivedTokenOf(address _owner) public view returns (uint256 balance) {
822         return receivedToken[_owner];
823     }
824 
825     // This contains all crowdedsale addresses, and their transfered token
826     mapping(address => uint256) transferedToken;
827     // This contains all crowdedsale addresses, and their received token
828     mapping(address => uint256) receivedToken;
829 
830     // This contains all crowdedsale addresses, and their token which they bought in crowedsale
831     mapping(address => uint256) investedCrowdsaleToken;
832 
833     /**
834     * Limit amount of token transfer after the crowdsale is over.
835     */
836     modifier fccTokenCanTransfer(address _sender, uint256 _value) {
837         // Verify if sender is not transfer agent
838         if(!transferAgents[_sender]){
839             // Verify if present time is not exceed upper bounds period
840             if(now < periods[1].time){
841 
842                 // Amount of token which sender can transfer
843                 // base on amount of token that they invested in crowdsale and percentage of period
844                 uint256 transferableCrowedSaleToken = 0;
845 
846                 // Verify if present time is not exceed lower bounds period
847                 if(now < periods[0].time){
848                     transferableCrowedSaleToken = (investedCrowdsaleToken[_sender].mul(periods[0].percentage)).div(100);
849                 }else{
850                     transferableCrowedSaleToken = (investedCrowdsaleToken[_sender].mul(periods[1].percentage)).div(100);
851                 }
852 
853                 // Amount of token that sender have
854                 // exclude the token which they invest in crowdsale
855                 uint256 afterCrowedsaleTokenBalance = 0;
856                 if (receivedToken[_sender] > investedCrowdsaleToken[_sender]) {
857                     afterCrowedsaleTokenBalance = receivedToken[_sender].sub(investedCrowdsaleToken[_sender]);
858                 }
859 
860                 // Amount of token that sender can transfer
861                 uint256 totalTransferableBalance = afterCrowedsaleTokenBalance.add(transferableCrowedSaleToken);
862 
863                 // Amount of transfered and intend to transfer token
864                 uint256 totalTransfer = _value.add(transferedToken[_sender]);
865 
866                 require (totalTransferableBalance >= totalTransfer);
867             }
868         }
869 
870         _;
871     }
872 
873     /**
874     * Construct the token.
875     *
876     * @param _name Token name
877     * @param _symbol Token symbol - should be all caps
878     * @param _initialSupply How many tokens we start with
879     * @param _decimals Number of decimal places
880     */
881     function FCCToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) public
882     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable){}
883 
884     // Set _periods Spending amount percentage with time schedule using Period
885     function setPeriod(uint[] _periods) public
886     onlyOwner()
887     {
888         // Check period array length
889         require(_periods.length == 4);
890 
891         // Set Period
892         for(uint i=0; i<_periods.length/2; i++) {
893             periods[i].time = _periods[i*2];
894             periods[i].percentage = _periods[i*2+1];
895         }
896 
897         // Verify if lower bound is greater than upper bound
898         require(periods[0].time <= periods[1].time);
899     }
900 
901     /**
902     * Override method
903     * Return fasle because token does not need upgrade
904     */
905     function canUpgrade() public view returns(bool) {
906         return false;
907     }
908 
909     function transfer(address _to, uint256 _value) public
910     canTransfer(msg.sender)
911     fccTokenCanTransfer(msg.sender, _value)
912     returns (bool success) {
913 
914         // Verify if present time is not exceed release time
915         // and _to is not transfer agent
916         // present time is crowdedsale time
917         if(!released && !transferAgents[_to]) {
918             // Increase _to investedCrowdsaleToken
919             investedCrowdsaleToken[_to] = _value.add(investedCrowdsaleToken[_to]);
920         }
921 
922         // Verify if present time is not exceed upper bound period
923         // and msg.sender is not transfer agent
924         // present time is restricted transfering amount time after crowdedsale
925         if (now < periods[1].time){
926             if (!transferAgents[_to]) {
927                 receivedToken[_to] = _value.add(receivedToken[_to]);
928             }
929             // Increase msg.sender transferedToken
930             if (!transferAgents[msg.sender]) {
931                 transferedToken[msg.sender] = _value.add(transferedToken[msg.sender]);
932             }
933         }
934 
935         // Call CrowdsaleToken.transfer()
936         return super.transfer(_to, _value);
937     }
938 
939     function transferFrom(address _from, address _to, uint256 _value) public
940     canTransfer(_from)
941     fccTokenCanTransfer(_from, _value)
942     returns (bool success) {
943 
944         // Verify if present time is not exceed release time
945         // and _to is not transfer agent
946         // present time is crowdedsale time
947         if(!released && !transferAgents[_to]) {
948             // Increase _to investedCrowdsaleToken
949             investedCrowdsaleToken[_to] = _value.add(investedCrowdsaleToken[_to]);
950         }
951 
952         // Verify if present time is not exceed upper bound period
953         // and _from is not transfer agent
954         // present time is restricted transfering amount time after crowdedsale
955         if (now < periods[1].time){
956             if(!transferAgents[_to]){
957                 receivedToken[_to] = _value.add(receivedToken[_to]);
958             }
959             // Increase msg.sender transferedToken
960             if(!transferAgents[_from]){
961                 transferedToken[_from] = _value.add(transferedToken[_from]);
962             }
963         }
964 
965         // Call CrowdsaleToken.transferForm()
966         return super.transferFrom(_from, _to, _value);
967     }
968 
969 }