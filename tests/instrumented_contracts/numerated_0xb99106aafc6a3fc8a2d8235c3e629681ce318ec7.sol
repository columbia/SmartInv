1 /**
2  * This smart contract code is Copyright 2018 TokenMarket Ltd. For more information see https://tokenmarket.net
3  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
4  * NatSpec is used intentionally to cover also other than public functions
5  * Solidity 0.4.18 is intentionally used: it's stable, and our framework is
6  * based on that.
7  */
8 
9 
10 /**
11  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
12  *
13  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
14  */
15 
16 
17 /**
18  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
19  *
20  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
21  */
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
42  * @title ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) public view returns (uint256);
47   function transferFrom(address from, address to, uint256 value) public returns (bool);
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 /**
53  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
54  *
55  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
56  */
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
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75     if (a == 0) {
76       return 0;
77     }
78     uint256 c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   /**
125   * @dev total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     // SafeMath.sub will throw if there is not enough balance.
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     Transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 }
157 
158 
159 
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 /**
257  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
258  *
259  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
260  */
261 
262 
263 
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  */
270 contract Ownable {
271   address public owner;
272 
273 
274   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276 
277   /**
278    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
279    * account.
280    */
281   function Ownable() public {
282     owner = msg.sender;
283   }
284 
285   /**
286    * @dev Throws if called by any account other than the owner.
287    */
288   modifier onlyOwner() {
289     require(msg.sender == owner);
290     _;
291   }
292 
293   /**
294    * @dev Allows the current owner to transfer control of the contract to a newOwner.
295    * @param newOwner The address to transfer ownership to.
296    */
297   function transferOwnership(address newOwner) public onlyOwner {
298     require(newOwner != address(0));
299     OwnershipTransferred(owner, newOwner);
300     owner = newOwner;
301   }
302 
303 }
304 
305 
306 
307 contract Recoverable is Ownable {
308 
309   /// @dev Empty constructor (for now)
310   function Recoverable() {
311   }
312 
313   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
314   /// @param token Token which will we rescue to the owner from the contract
315   function recoverTokens(ERC20Basic token) onlyOwner public {
316     token.transfer(owner, tokensToBeReturned(token));
317   }
318 
319   /// @dev Interface function, can be overwritten by the superclass
320   /// @param token Token which balance we will check and return
321   /// @return The amount of tokens (in smallest denominator) the contract owns
322   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
323     return token.balanceOf(this);
324   }
325 }
326 
327 
328 
329 /**
330  * Standard EIP-20 token with an interface marker.
331  *
332  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
333  *
334  */
335 contract StandardTokenExt is StandardToken, Recoverable {
336 
337   /* Interface declaration */
338   function isToken() public constant returns (bool weAre) {
339     return true;
340   }
341 }
342 
343 /**
344  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
345  *
346  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
347  */
348 
349 
350 /**
351  * Upgrade agent interface inspired by Lunyr.
352  *
353  * Upgrade agent transfers tokens to a new contract.
354  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
355  */
356 contract UpgradeAgent {
357 
358   uint public originalSupply;
359 
360   /** Interface marker */
361   function isUpgradeAgent() public constant returns (bool) {
362     return true;
363   }
364 
365   function upgradeFrom(address _from, uint256 _value) public;
366 
367 }
368 
369 
370 /**
371  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
372  *
373  * First envisioned by Golem and Lunyr projects.
374  */
375 contract UpgradeableToken is StandardTokenExt {
376 
377   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
378   address public upgradeMaster;
379 
380   /** The next contract where the tokens will be migrated. */
381   UpgradeAgent public upgradeAgent;
382 
383   /** How many tokens we have upgraded by now. */
384   uint256 public totalUpgraded;
385 
386   /**
387    * Upgrade states.
388    *
389    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
390    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
391    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
392    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
393    *
394    */
395   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
396 
397   /**
398    * Somebody has upgraded some of his tokens.
399    */
400   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
401 
402   /**
403    * New upgrade agent available.
404    */
405   event UpgradeAgentSet(address agent);
406 
407   /**
408    * Do not allow construction without upgrade master set.
409    */
410   function UpgradeableToken(address _upgradeMaster) {
411     upgradeMaster = _upgradeMaster;
412   }
413 
414   /**
415    * Allow the token holder to upgrade some of their tokens to a new contract.
416    */
417   function upgrade(uint256 value) public {
418 
419       UpgradeState state = getUpgradeState();
420       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
421         // Called in a bad state
422         throw;
423       }
424 
425       // Validate input value.
426       if (value == 0) throw;
427 
428       balances[msg.sender] = balances[msg.sender].sub(value);
429 
430       // Take tokens out from circulation
431       totalSupply_ = totalSupply_.sub(value);
432       totalUpgraded = totalUpgraded.add(value);
433 
434       // Upgrade agent reissues the tokens
435       upgradeAgent.upgradeFrom(msg.sender, value);
436       Upgrade(msg.sender, upgradeAgent, value);
437   }
438 
439   /**
440    * Set an upgrade agent that handles
441    */
442   function setUpgradeAgent(address agent) external {
443 
444       if(!canUpgrade()) {
445         // The token is not yet in a state that we could think upgrading
446         throw;
447       }
448 
449       if (agent == 0x0) throw;
450       // Only a master can designate the next agent
451       if (msg.sender != upgradeMaster) throw;
452       // Upgrade has already begun for an agent
453       if (getUpgradeState() == UpgradeState.Upgrading) throw;
454 
455       upgradeAgent = UpgradeAgent(agent);
456 
457       // Bad interface
458       if(!upgradeAgent.isUpgradeAgent()) throw;
459       // Make sure that token supplies match in source and target
460       if (upgradeAgent.originalSupply() != totalSupply_) throw;
461 
462       UpgradeAgentSet(upgradeAgent);
463   }
464 
465   /**
466    * Get the state of the token upgrade.
467    */
468   function getUpgradeState() public constant returns(UpgradeState) {
469     if(!canUpgrade()) return UpgradeState.NotAllowed;
470     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
471     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
472     else return UpgradeState.Upgrading;
473   }
474 
475   /**
476    * Change the upgrade master.
477    *
478    * This allows us to set a new owner for the upgrade mechanism.
479    */
480   function setUpgradeMaster(address master) public {
481       if (master == 0x0) throw;
482       if (msg.sender != upgradeMaster) throw;
483       upgradeMaster = master;
484   }
485 
486   /**
487    * Child contract can enable to provide the condition when the upgrade can begun.
488    */
489   function canUpgrade() public constant returns(bool) {
490      return true;
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
504 
505 /**
506  * Define interface for releasing the token transfer after a successful crowdsale.
507  */
508 contract ReleasableToken is StandardTokenExt {
509 
510   /* The finalizer contract that allows unlift the transfer limits on this token */
511   address public releaseAgent;
512 
513   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
514   bool public released = false;
515 
516   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
517   mapping (address => bool) public transferAgents;
518 
519   /**
520    * Limit token transfer until the crowdsale is over.
521    *
522    */
523   modifier canTransfer(address _sender) {
524 
525     if(!released) {
526         if(!transferAgents[_sender]) {
527             throw;
528         }
529     }
530 
531     _;
532   }
533 
534   /**
535    * Set the contract that can call release and make the token transferable.
536    *
537    * Design choice. Allow reset the release agent to fix fat finger mistakes.
538    */
539   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
540 
541     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
542     releaseAgent = addr;
543   }
544 
545   /**
546    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
547    */
548   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
549     transferAgents[addr] = state;
550   }
551 
552   /**
553    * One way function to release the tokens to the wild.
554    *
555    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
556    */
557   function releaseTokenTransfer() public onlyReleaseAgent {
558     released = true;
559   }
560 
561   /** The function can be called only before or after the tokens have been releasesd */
562   modifier inReleaseState(bool releaseState) {
563     if(releaseState != released) {
564         throw;
565     }
566     _;
567   }
568 
569   /** The function can be called only by a whitelisted release agent. */
570   modifier onlyReleaseAgent() {
571     if(msg.sender != releaseAgent) {
572         throw;
573     }
574     _;
575   }
576 
577   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
578     // Call StandardToken.transfer()
579    return super.transfer(_to, _value);
580   }
581 
582   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
583     // Call StandardToken.transferForm()
584     return super.transferFrom(_from, _to, _value);
585   }
586 
587 }
588 
589 /**
590  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
591  *
592  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
593  */
594 
595 
596 
597 /**
598  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
599  *
600  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
601  */
602 
603 
604 /**
605  * Safe unsigned safe math.
606  *
607  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
608  *
609  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
610  *
611  * Maintained here until merged to mainline zeppelin-solidity.
612  *
613  */
614 library SafeMathLib {
615 
616   function times(uint a, uint b) returns (uint) {
617     uint c = a * b;
618     assert(a == 0 || c / a == b);
619     return c;
620   }
621 
622   function minus(uint a, uint b) returns (uint) {
623     assert(b <= a);
624     return a - b;
625   }
626 
627   function plus(uint a, uint b) returns (uint) {
628     uint c = a + b;
629     assert(c>=a);
630     return c;
631   }
632 
633 }
634 
635 
636 
637 /**
638  * A token that can increase its supply by another contract.
639  *
640  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
641  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
642  *
643  */
644 contract MintableToken is StandardTokenExt {
645 
646   using SafeMathLib for uint;
647 
648   bool public mintingFinished = false;
649 
650   /** List of agents that are allowed to create new tokens */
651   mapping (address => bool) public mintAgents;
652 
653   event MintingAgentChanged(address addr, bool state);
654   event Minted(address receiver, uint amount);
655 
656   /**
657    * Create new tokens and allocate them to an address..
658    *
659    * Only callably by a crowdsale contract (mint agent).
660    */
661   function mint(address receiver, uint amount) onlyMintAgent canMint public {
662     totalSupply_ = totalSupply_.plus(amount);
663     balances[receiver] = balances[receiver].plus(amount);
664 
665     // This will make the mint transaction apper in EtherScan.io
666     // We can remove this after there is a standardized minting event
667     Transfer(0, receiver, amount);
668   }
669 
670   /**
671    * Owner can allow a crowdsale contract to mint new tokens.
672    */
673   function setMintAgent(address addr, bool state) onlyOwner canMint public {
674     mintAgents[addr] = state;
675     MintingAgentChanged(addr, state);
676   }
677 
678   modifier onlyMintAgent() {
679     // Only crowdsale contracts are allowed to mint new tokens
680     if(!mintAgents[msg.sender]) {
681         throw;
682     }
683     _;
684   }
685 
686   /** Make sure we are not done yet. */
687   modifier canMint() {
688     if(mintingFinished) throw;
689     _;
690   }
691 }
692 
693 
694 
695 /**
696  * A crowdsaled token.
697  *
698  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
699  *
700  * - The token transfer() is disabled until the crowdsale is over
701  * - The token contract gives an opt-in upgrade path to a new contract
702  * - The same token can be part of several crowdsales through approve() mechanism
703  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
704  *
705  */
706 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
707 
708   /** Name and symbol were updated. */
709   event UpdatedTokenInformation(string newName, string newSymbol);
710 
711   string public name;
712 
713   string public symbol;
714 
715   uint public decimals;
716 
717   /**
718    * Construct the token.
719    *
720    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
721    *
722    * @param _name Token name
723    * @param _symbol Token symbol - should be all caps
724    * @param _initialSupply How many tokens we start with
725    * @param _decimals Number of decimal places
726    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
727    */
728   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
729     UpgradeableToken(msg.sender) {
730 
731     // Create any address, can be transferred
732     // to team multisig via changeOwner(),
733     // also remember to call setUpgradeMaster()
734     owner = msg.sender;
735 
736     name = _name;
737     symbol = _symbol;
738 
739     totalSupply_ = _initialSupply;
740 
741     decimals = _decimals;
742 
743     // Create initially all balance on the team multisig
744     balances[owner] = totalSupply_;
745 
746     if(totalSupply_ > 0) {
747       Minted(owner, totalSupply_);
748     }
749 
750     // No more new supply allowed after the token creation
751     if(!_mintable) {
752       mintingFinished = true;
753       if(totalSupply_ == 0) {
754         throw; // Cannot create a token without supply and no minting
755       }
756     }
757   }
758 
759   /**
760    * When token is released to be transferable, enforce no new tokens can be created.
761    */
762   function releaseTokenTransfer() public onlyReleaseAgent {
763     mintingFinished = true;
764     super.releaseTokenTransfer();
765   }
766 
767   /**
768    * Allow upgrade agent functionality kick in only if the crowdsale was success.
769    */
770   function canUpgrade() public constant returns(bool) {
771     return released && super.canUpgrade();
772   }
773 
774   /**
775    * Owner can update token information here.
776    *
777    * It is often useful to conceal the actual token association, until
778    * the token operations, like central issuance or reissuance have been completed.
779    *
780    * This function allows the token owner to rename the token after the operations
781    * have been completed and then point the audience to use the token contract.
782    */
783   function setTokenInformation(string _name, string _symbol) onlyOwner {
784     name = _name;
785     symbol = _symbol;
786 
787     UpdatedTokenInformation(name, symbol);
788   }
789 
790 }
791 
792 
793 /**
794  * This smart contract code is Copyright 2018 TokenMarket Ltd. For more information see https://tokenmarket.net
795  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
796  * NatSpec is used intentionally to cover also other than public functions
797  * Solidity 0.4.18 is intentionally used: it's stable, and our framework is
798  * based on that.
799  */
800 
801 
802 
803 
804 interface SecurityTransferAgent {
805   function verify(address from, address to, uint256 value) public view returns (uint256 newValue);
806 }
807 
808 
809 
810 
811 
812 
813 
814 /**
815  * @title Whitelist
816  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
817  * @dev This simplifies the implementation of "user permissions".
818  */
819 contract Whitelist is Ownable {
820   mapping(address => bool) public whitelist;
821   
822   event WhitelistedAddressAdded(address addr);
823   event WhitelistedAddressRemoved(address addr);
824 
825   /**
826    * @dev Throws if called by any account that's not whitelisted.
827    */
828   modifier onlyWhitelisted() {
829     require(whitelist[msg.sender]);
830     _;
831   }
832 
833   /**
834    * @dev add an address to the whitelist
835    * @param addr address
836    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
837    */
838   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
839     if (!whitelist[addr]) {
840       whitelist[addr] = true;
841       WhitelistedAddressAdded(addr);
842       success = true; 
843     }
844   }
845 
846   /**
847    * @dev add addresses to the whitelist
848    * @param addrs addresses
849    * @return true if at least one address was added to the whitelist, 
850    * false if all addresses were already in the whitelist  
851    */
852   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
853     for (uint256 i = 0; i < addrs.length; i++) {
854       if (addAddressToWhitelist(addrs[i])) {
855         success = true;
856       }
857     }
858   }
859 
860   /**
861    * @dev remove an address from the whitelist
862    * @param addr address
863    * @return true if the address was removed from the whitelist, 
864    * false if the address wasn't in the whitelist in the first place 
865    */
866   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
867     if (whitelist[addr]) {
868       whitelist[addr] = false;
869       WhitelistedAddressRemoved(addr);
870       success = true;
871     }
872   }
873 
874   /**
875    * @dev remove addresses from the whitelist
876    * @param addrs addresses
877    * @return true if at least one address was removed from the whitelist, 
878    * false if all addresses weren't in the whitelist in the first place
879    */
880   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
881     for (uint256 i = 0; i < addrs.length; i++) {
882       if (removeAddressFromWhitelist(addrs[i])) {
883         success = true;
884       }
885     }
886   }
887 
888 }
889 
890 
891 
892 
893 
894 interface ERC677Receiver {
895   function tokenFallback(address from, uint256 amount, bytes data) returns (bool success);
896 }
897 
898 interface ERC677 {
899 
900   // TODO: Have a different event name to make sure that tools with bad APIs do not mix this with ERC-20 Transfer() event that lacks data parameter
901   event ERC677Transfer(address from, address receiver, uint256 amount, bytes data);
902 
903   function transferAndCall(ERC677Receiver receiver, uint amount, bytes data) returns (bool success);
904 }
905 
906 
907 
908 contract ERC677Token is ERC20, ERC677 {
909   function transferAndCall(ERC677Receiver receiver, uint amount, bytes data) returns (bool success) {
910     require(transfer(address(receiver), amount));
911 
912     ERC677Transfer(msg.sender, address(receiver), amount, data);
913 
914     require(receiver.tokenFallback(msg.sender, amount, data));
915   }
916 }
917 
918 
919 /**
920  * @author TokenMarket /  Ville Sundell <ville at tokenmarket.net>
921  */
922 contract CheckpointToken is ERC677Token {
923   using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)
924 
925   /// @dev Name of the token, usually the company and/or series (like "TokenMeerkat Ltd. Series A"):
926   string public name;
927   /// @dev Ticker symbol, usually bases on the "name" above (like "MEER"):
928   string public symbol;
929   /// @dev Decimals are usually set to 18 for EIP-20 tokens:
930   uint256 public decimals;
931   /// @dev If transferVerifier is set, that contract will be queried upon every token transaction:
932   SecurityTransferAgent public transferVerifier;
933 
934   /// @dev Checkpoint is the fundamental unit for our internal accounting
935   ///      (who owns what, and at what moment in time)
936   struct Checkpoint {
937     uint256 blockNumber;
938     uint256 value;
939   }
940   /// @dev This mapping contains checkpoints for every address:
941   mapping (address => Checkpoint[]) public tokenBalances;
942   /// @dev This is a one dimensional Checkpoint mapping of the overall token supply:
943   Checkpoint[] public tokensTotal;
944 
945   /// @dev This mapping keeps account for approve() -> fransferFrom() pattern:
946   mapping (address => mapping (address => uint256)) public allowed;
947 
948   /**
949    * @dev Constructor for CheckpointToken, initializing the token
950    *
951    * Here we define initial values for name, symbol and decimals.
952    *
953    * @param _name Initial name of the token
954    * @param _symbol Initial symbol of the token
955    * @param _decimals Number of decimals for the token, industry standard is 18
956    */
957   function CheckpointToken(string _name, string _symbol, uint256 _decimals) public {
958     name = _name;
959     symbol = _symbol;
960     decimals = _decimals;
961   }
962 
963   /** PUBLIC FUNCTIONS
964    ****************************************/
965 
966   /**
967    * @dev Function to check the amount of tokens that an owner allowed to a spender.
968    * @param owner address The address which owns the funds.
969    * @param spender address The address which will spend the funds.
970    * @return A uint256 specifying the amount of tokens still available for the spender.
971    */
972   function allowance(address owner, address spender) public view returns (uint256) {
973     return allowed[owner][spender];
974   }
975 
976   /**
977    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
978    *
979    * Beware that changing an allowance with this method brings the risk that someone may use both the old
980    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
981    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
982    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
983    * @param spender The address which will spend the funds.
984    * @param value The amount of tokens to be spent.
985    * @return true if the call function was executed successfully
986    */
987   function approve(address spender, uint256 value) public returns (bool) {
988     allowed[msg.sender][spender] = value;
989     Approval(msg.sender, spender, value);
990     return true;
991   }
992 
993   /**
994    * @dev Transfer tokens from one address to another
995    * @param from address The address which you want to send tokens from
996    * @param to address The address which you want to transfer to
997    * @param value uint256 the amount of tokens to be transferred
998    * @return true if the call function was executed successfully
999    */
1000   function transferFrom(address from, address to, uint256 value) public returns (bool) {
1001     require(value <= allowed[from][msg.sender]);
1002 
1003     transferInternal(from, to, value);
1004     Transfer(from, to, value);
1005     return true;
1006   }
1007 
1008   /**
1009    * @dev transfer token for a specified address
1010    * @param to The address to transfer to.
1011    * @param value The amount to be transferred.
1012    * @return true if the call function was executed successfully
1013    */
1014   function transfer(address to, uint256 value) public returns (bool) {
1015     transferInternal(msg.sender, to, value);
1016     Transfer(msg.sender, to, value);
1017     return true;
1018   }
1019 
1020   /**
1021    * @dev total number of tokens in existence
1022    * @return A uint256 specifying the total number of tokens in existence
1023    */
1024   function totalSupply() public view returns (uint256 tokenCount) {
1025     tokenCount = balanceAtBlock(tokensTotal, block.number);
1026   }
1027 
1028   /**
1029    * @dev total number of tokens in existence at the given block
1030    * @param blockNumber The block number we want to query for the total supply
1031    * @return A uint256 specifying the total number of tokens at a given block
1032    */
1033   function totalSupplyAt(uint256 blockNumber) public view returns (uint256 tokenCount) {
1034     tokenCount = balanceAtBlock(tokensTotal, blockNumber);
1035   }
1036 
1037   /**
1038    * @dev Gets the balance of the specified address.
1039    * @param owner The address to query the the balance of.
1040    * @return An uint256 representing the amount owned by the passed address.
1041    */
1042   function balanceOf(address owner) public view returns (uint256 balance) {
1043     balance = balanceAtBlock(tokenBalances[owner], block.number);
1044   }
1045 
1046   /**
1047    * @dev Gets the balance of the specified address.
1048    * @param owner The address to query the the balance of.
1049    * @param blockNumber The block number we want to query for the balance.
1050    * @return An uint256 representing the amount owned by the passed address.
1051    */
1052   function balanceAt(address owner, uint256 blockNumber) public view returns (uint256 balance) {
1053     balance = balanceAtBlock(tokenBalances[owner], blockNumber);
1054   }
1055 
1056   /**
1057    * @dev Increase the amount of tokens that an owner allowed to a spender.
1058    *
1059    * approve should be called when allowed[spender] == 0. To increment
1060    * allowed value is better to use this function to avoid 2 calls (and wait until
1061    * the first transaction is mined)
1062    * From MonolithDAO Token.sol
1063    * @param spender The address which will spend the funds.
1064    * @param addedValue The amount of tokens to increase the allowance by.
1065    */
1066   function increaseApproval(address spender, uint addedValue) public returns (bool) {
1067     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
1068     Approval(msg.sender, spender, allowed[msg.sender][spender]);
1069     return true;
1070   }
1071 
1072   /**
1073    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1074    *
1075    * approve should be called when allowed[spender] == 0. To decrement
1076    * allowed value is better to use this function to avoid 2 calls (and wait until
1077    * the first transaction is mined)
1078    * From MonolithDAO Token.sol
1079    * @param spender The address which will spend the funds.
1080    * @param subtractedValue The amount of tokens to decrease the allowance by.
1081    */
1082   function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
1083     uint oldValue = allowed[msg.sender][spender];
1084     if (subtractedValue > oldValue) {
1085       allowed[msg.sender][spender] = 0;
1086     } else {
1087       allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
1088     }
1089     Approval(msg.sender, spender, allowed[msg.sender][spender]);
1090     return true;
1091   }
1092 
1093   /**
1094    * @dev Addition to StandardToken methods. Increase the amount of tokens that
1095    * an owner allowed to a spender and execute a call with the sent data.
1096    *
1097    * This is originally from OpenZeppelin.
1098    *
1099    * approve should be called when allowed[spender] == 0. To increment
1100    * allowed value is better to use this function to avoid 2 calls (and wait until
1101    * the first transaction is mined)
1102    * From MonolithDAO Token.sol
1103    * @param spender The address which will spend the funds.
1104    * @param addedValue The amount of tokens to increase the allowance by.
1105    * @param data ABI-encoded contract call to call `spender` address.
1106    */
1107   function increaseApproval(address spender, uint addedValue, bytes data) public returns (bool) {
1108     require(spender != address(this));
1109 
1110     increaseApproval(spender, addedValue);
1111 
1112     require(spender.call(data));
1113 
1114     return true;
1115   }
1116 
1117   /**
1118    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
1119    * an owner allowed to a spender and execute a call with the sent data.
1120    *
1121    * This is originally from OpenZeppelin.
1122    *
1123    * approve should be called when allowed[spender] == 0. To decrement
1124    * allowed value is better to use this function to avoid 2 calls (and wait until
1125    * the first transaction is mined)
1126    * From MonolithDAO Token.sol
1127    * @param spender The address which will spend the funds.
1128    * @param subtractedValue The amount of tokens to decrease the allowance by.
1129    * @param data ABI-encoded contract call to call `spender` address.
1130    */
1131   function decreaseApproval(address spender, uint subtractedValue, bytes data) public returns (bool) {
1132     require(spender != address(this));
1133 
1134     decreaseApproval(spender, subtractedValue);
1135 
1136     require(spender.call(data));
1137 
1138     return true;
1139   }
1140 
1141   /** INTERNALS
1142    ****************************************/
1143 
1144   function balanceAtBlock(Checkpoint[] storage checkpoints, uint256 blockNumber) internal returns (uint256 balance) {
1145     uint256 currentBlockNumber;
1146     (currentBlockNumber, balance) = getCheckpoint(checkpoints, blockNumber);
1147   }
1148 
1149   function transferInternal(address from, address to, uint256 value) internal {
1150     uint256 fromBalance = balanceOf(from);
1151     uint256 toBalance = balanceOf(to);
1152 
1153     if (address(transferVerifier) != address(0)) {
1154       value = transferVerifier.verify(from, to, value);
1155       require(value > 0);
1156     }
1157 
1158     setCheckpoint(tokenBalances[from], fromBalance.sub(value));
1159     setCheckpoint(tokenBalances[to], toBalance.add(value));
1160   }
1161 
1162 
1163   /** CORE
1164    ** The Magic happens below:
1165    ***************************************/
1166 
1167   function setCheckpoint(Checkpoint[] storage checkpoints, uint256 newValue) internal {
1168     if ((checkpoints.length == 0) || (checkpoints[checkpoints.length.sub(1)].blockNumber < block.number)) {
1169       checkpoints.push(Checkpoint(block.number, newValue));
1170     } else {
1171        checkpoints[checkpoints.length.sub(1)] = Checkpoint(block.number, newValue);
1172     }
1173   }
1174 
1175   function getCheckpoint(Checkpoint[] storage checkpoints, uint256 blockNumber) internal returns (uint256 blockNumber_, uint256 value) {
1176     if (checkpoints.length == 0) {
1177       return (0, 0);
1178     }
1179 
1180     // Shortcut for the actual value
1181     if (blockNumber >= checkpoints[checkpoints.length.sub(1)].blockNumber) {
1182       return (checkpoints[checkpoints.length.sub(1)].blockNumber, checkpoints[checkpoints.length.sub(1)].value);
1183     }
1184 
1185     if (blockNumber < checkpoints[0].blockNumber) {
1186       return (0, 0);
1187     }
1188 
1189     // Binary search of the value in the array
1190     uint256 min = 0;
1191     uint256 max = checkpoints.length.sub(1);
1192     while (max > min) {
1193       uint256 mid = (max.add(min.add(1))).div(2);
1194       if (checkpoints[mid].blockNumber <= blockNumber) {
1195         min = mid;
1196       } else {
1197         max = mid.sub(1);
1198       }
1199     }
1200 
1201     return (checkpoints[min].blockNumber, checkpoints[min].value);
1202   }
1203 }
1204 
1205 
1206 
1207 
1208 /* Largely copied from https://github.com/OpenZeppelin/openzeppelin-solidity/pull/741/files */
1209 
1210 contract ERC865 is CheckpointToken {
1211   /** @dev This is used to prevent nonce reuse: */
1212   mapping(bytes => bool) signatures;
1213 
1214   event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
1215   event Debug(address from, bytes32 hash);
1216 
1217   /**
1218     * @notice Submit a presigned transfer
1219     * @param _signature bytes The signature, issued by the owner.
1220     * @param _to address The address which you want to transfer to.
1221     * @param _value uint256 The amount of tokens to be transferred.
1222     * @param _fee uint256 The amount of tokens paid to msg.sender, by the person who used to own the tokens.
1223     * @param _nonce uint256 Presigned transaction number
1224     */
1225   function transferPreSigned(
1226     bytes _signature,
1227     address _to,
1228     uint256 _value,
1229     uint256 _fee,
1230     uint256 _nonce
1231   )
1232     public
1233     returns (bool)
1234   {
1235     require(_to != address(0));
1236     require(signatures[_signature] == false);
1237     bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
1238     address from = recover(hashedTx, _signature);
1239     require(from != address(0));
1240 
1241     transferInternal(from, _to, _value);
1242     transferInternal(from, msg.sender, _fee);
1243 
1244     signatures[_signature] = true;
1245     TransferPreSigned(from, _to, msg.sender, _value, _fee);
1246     Transfer(from, _to, _value);
1247     Transfer(from, msg.sender, _fee);
1248     return true;
1249   }
1250 
1251   /**
1252     * @notice Hash (keccak256) of the payload used by transferPreSigned
1253     * @param _token address The address of the token.
1254     * @param _to address The address which you want to transfer to.
1255     * @param _value uint256 The amount of tokens to be transferred.
1256     * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
1257     * @param _nonce uint256 Presigned transaction number.
1258     */
1259   function transferPreSignedHashing(
1260     address _token,
1261     address _to,
1262     uint256 _value,
1263     uint256 _fee,
1264     uint256 _nonce
1265   )
1266     public
1267     pure
1268     returns (bytes32)
1269   {
1270     /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
1271     return keccak256(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce);
1272   }
1273 
1274   /**
1275     * @notice Recover signer address from a message by using his signature.
1276     *         Signature is delivered as a byte array, hence need for this
1277     *         implementation.
1278     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
1279     * @param sig bytes signature, the signature is generated using web3.eth.sign()
1280     */
1281   function recover(bytes32 hash, bytes sig) public pure returns (address) {
1282     bytes32 r;
1283     bytes32 s;
1284     uint8 v;
1285 
1286     /* Check the signature length */
1287     if (sig.length != 65) {
1288       return (address(0));
1289     }
1290 
1291     /* Divide the signature in r, s and v variables */
1292     assembly {
1293       r := mload(add(sig, 32))
1294       s := mload(add(sig, 64))
1295       v := byte(0, mload(add(sig, 96)))
1296     }
1297 
1298     /* Version of signature should be 27 or 28, but 0 and 1 are also possible versions */
1299     if (v < 27) {
1300       v += 27;
1301     }
1302 
1303     /* If the version is correct return the signer address */
1304     if (v != 27 && v != 28) {
1305       return (address(0));
1306     } else {
1307       return ecrecover(hash, v, r, s);
1308     }
1309   }
1310 
1311 }
1312 
1313 
1314 
1315 
1316 
1317 
1318 /**
1319  * @title Roles
1320  * @author Francisco Giordano (@frangio)
1321  * @dev Library for managing addresses assigned to a Role.
1322  *      See RBAC.sol for example usage.
1323  */
1324 library Roles {
1325   struct Role {
1326     mapping (address => bool) bearer;
1327   }
1328 
1329   /**
1330    * @dev give an address access to this role
1331    */
1332   function add(Role storage role, address addr)
1333     internal
1334   {
1335     role.bearer[addr] = true;
1336   }
1337 
1338   /**
1339    * @dev remove an address' access to this role
1340    */
1341   function remove(Role storage role, address addr)
1342     internal
1343   {
1344     role.bearer[addr] = false;
1345   }
1346 
1347   /**
1348    * @dev check if an address has this role
1349    * // reverts
1350    */
1351   function check(Role storage role, address addr)
1352     view
1353     internal
1354   {
1355     require(has(role, addr));
1356   }
1357 
1358   /**
1359    * @dev check if an address has this role
1360    * @return bool
1361    */
1362   function has(Role storage role, address addr)
1363     view
1364     internal
1365     returns (bool)
1366   {
1367     return role.bearer[addr];
1368   }
1369 }
1370 
1371 
1372 
1373 /**
1374  * @title RBAC (Role-Based Access Control)
1375  * @author Matt Condon (@Shrugs)
1376  * @dev Stores and provides setters and getters for roles and addresses.
1377  *      Supports unlimited numbers of roles and addresses.
1378  *      See //contracts/mocks/RBACMock.sol for an example of usage.
1379  * This RBAC method uses strings to key roles. It may be beneficial
1380  *  for you to write your own implementation of this interface using Enums or similar.
1381  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
1382  *  to avoid typos.
1383  */
1384 contract RBAC {
1385   using Roles for Roles.Role;
1386 
1387   mapping (string => Roles.Role) private roles;
1388 
1389   event RoleAdded(address addr, string roleName);
1390   event RoleRemoved(address addr, string roleName);
1391 
1392   /**
1393    * A constant role name for indicating admins.
1394    */
1395   string public constant ROLE_ADMIN = "admin";
1396 
1397   /**
1398    * @dev constructor. Sets msg.sender as admin by default
1399    */
1400   function RBAC()
1401     public
1402   {
1403     addRole(msg.sender, ROLE_ADMIN);
1404   }
1405 
1406   /**
1407    * @dev reverts if addr does not have role
1408    * @param addr address
1409    * @param roleName the name of the role
1410    * // reverts
1411    */
1412   function checkRole(address addr, string roleName)
1413     view
1414     public
1415   {
1416     roles[roleName].check(addr);
1417   }
1418 
1419   /**
1420    * @dev determine if addr has role
1421    * @param addr address
1422    * @param roleName the name of the role
1423    * @return bool
1424    */
1425   function hasRole(address addr, string roleName)
1426     view
1427     public
1428     returns (bool)
1429   {
1430     return roles[roleName].has(addr);
1431   }
1432 
1433   /**
1434    * @dev add a role to an address
1435    * @param addr address
1436    * @param roleName the name of the role
1437    */
1438   function adminAddRole(address addr, string roleName)
1439     onlyAdmin
1440     public
1441   {
1442     addRole(addr, roleName);
1443   }
1444 
1445   /**
1446    * @dev remove a role from an address
1447    * @param addr address
1448    * @param roleName the name of the role
1449    */
1450   function adminRemoveRole(address addr, string roleName)
1451     onlyAdmin
1452     public
1453   {
1454     removeRole(addr, roleName);
1455   }
1456 
1457   /**
1458    * @dev add a role to an address
1459    * @param addr address
1460    * @param roleName the name of the role
1461    */
1462   function addRole(address addr, string roleName)
1463     internal
1464   {
1465     roles[roleName].add(addr);
1466     RoleAdded(addr, roleName);
1467   }
1468 
1469   /**
1470    * @dev remove a role from an address
1471    * @param addr address
1472    * @param roleName the name of the role
1473    */
1474   function removeRole(address addr, string roleName)
1475     internal
1476   {
1477     roles[roleName].remove(addr);
1478     RoleRemoved(addr, roleName);
1479   }
1480 
1481   /**
1482    * @dev modifier to scope access to a single role (uses msg.sender as addr)
1483    * @param roleName the name of the role
1484    * // reverts
1485    */
1486   modifier onlyRole(string roleName)
1487   {
1488     checkRole(msg.sender, roleName);
1489     _;
1490   }
1491 
1492   /**
1493    * @dev modifier to scope access to admins
1494    * // reverts
1495    */
1496   modifier onlyAdmin()
1497   {
1498     checkRole(msg.sender, ROLE_ADMIN);
1499     _;
1500   }
1501 
1502   /**
1503    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
1504    * @param roleNames the names of the roles to scope access to
1505    * // reverts
1506    *
1507    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1508    *  see: https://github.com/ethereum/solidity/issues/2467
1509    */
1510   // modifier onlyRoles(string[] roleNames) {
1511   //     bool hasAnyRole = false;
1512   //     for (uint8 i = 0; i < roleNames.length; i++) {
1513   //         if (hasRole(msg.sender, roleNames[i])) {
1514   //             hasAnyRole = true;
1515   //             break;
1516   //         }
1517   //     }
1518 
1519   //     require(hasAnyRole);
1520 
1521   //     _;
1522   // }
1523 }
1524 
1525 
1526 /**
1527  * @dev Interface for general announcements about the security.
1528  *
1529  * Announcements can be for instance for dividend sharing, voting, or
1530  * just for general announcements.
1531  */
1532 interface Announcement {
1533   function announcementName() public view returns (bytes32);
1534   function announcementURI() public view returns (bytes32);
1535   function announcementType() public view returns (uint256);
1536   function announcementHash() public view returns (uint256);
1537 }
1538 
1539 /**
1540  * @author TokenMarket /  Ville Sundell <ville at tokenmarket.net>
1541  */
1542 contract SecurityToken is CheckpointToken, RBAC, Recoverable, ERC865 {
1543   using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)
1544 
1545   string constant ROLE_ANNOUNCE = "announce()";
1546   string constant ROLE_FORCE = "forceTransfer()";
1547   string constant ROLE_ISSUE = "issueTokens()";
1548   string constant ROLE_BURN = "burnTokens()";
1549   string constant ROLE_INFO = "setTokenInformation()";
1550   string constant ROLE_SETVERIFIER = "setTransactionVerifier()";
1551 
1552   /// @dev Version string telling the token is TM-01, and its version:
1553   string public version = 'TM-01 0.1';
1554 
1555   /// @dev URL where you can get more information about the security
1556   ///      (for example company website or investor interface):
1557   string public url;
1558 
1559   /** SecurityToken specific events **/
1560   /// @dev This is emitted when new tokens are created:
1561   event Issued(address indexed to, uint256 value);
1562   /// @dev This is emitted when tokens are burned from token's own stash:
1563   event Burned(address indexed burner, uint256 value);
1564   /// @dev This is emitted upon forceful transfer of tokens by the Board:
1565   event Forced(address indexed from, address indexed to, uint256 value);
1566   /// @dev This is emitted when new announcements (like dividends, voting, etc.) are issued by the Board:
1567   event Announced(address indexed announcement, uint256 indexed announcementType, bytes32 indexed announcementName, bytes32 announcementURI, uint256 announcementHash);
1568   /// @dev This is emitted when token information is changed:
1569   event UpdatedTokenInformation(string newName, string newSymbol, string newUrl);
1570   /// @dev This is emitted when transaction verifier (the contract which would check KYC, etc.):
1571   event UpdatedTransactionVerifier(address newVerifier);
1572 
1573   /// @dev Address list of Announcements (see "interface Announcement").
1574   ///      Announcements are things like votings, dividends, or any kind of
1575   ///      smart contract:
1576   address[] public announcements;
1577   /// @dev For performance reasons, we also maintain address based mapping of
1578   ///      Announcements:
1579   mapping(address => uint256) public announcementsByAddress;
1580 
1581   /**
1582    * @dev Contructor to create SecurityToken, and subsequent CheckpointToken.
1583    *
1584    * CheckpointToken will be created with hardcoded 18 decimals.
1585    *
1586    * @param _name Initial name of the token
1587    * @param _symbol Initial symbol of the token
1588    */
1589   function SecurityToken(string _name, string _symbol, string _url) CheckpointToken(_name, _symbol, 18) public {
1590     url = _url;
1591 
1592     addRole(msg.sender, ROLE_ANNOUNCE);
1593     addRole(msg.sender, ROLE_FORCE);
1594     addRole(msg.sender, ROLE_ISSUE);
1595     addRole(msg.sender, ROLE_BURN);
1596     addRole(msg.sender, ROLE_INFO);
1597     addRole(msg.sender, ROLE_SETVERIFIER);
1598   }
1599 
1600   /**
1601    * @dev Function to announce Announcements.
1602    *
1603    * Announcements can be for instance for dividend sharing, voting, or
1604    * just for general announcements.
1605    *
1606    * Instead of storing the announcement details, we just broadcast them as an
1607    * event, and store only the address.
1608    *
1609    * @param announcement Address of the Announcement
1610    */
1611   function announce(Announcement announcement) external onlyRole(ROLE_ANNOUNCE) {
1612     announcements.push(announcement);
1613     announcementsByAddress[address(announcement)] = announcements.length;
1614     Announced(address(announcement), announcement.announcementType(), announcement.announcementName(), announcement.announcementURI(), announcement.announcementHash());
1615   }
1616 
1617   /**
1618    * @dev Function to forcefully transfer tokens from A to B by board decission
1619    *
1620    * This must be implemented carefully, since this is a very critical part
1621    * to ensure investor safety.
1622    *
1623    * This is intended to be called by the BAC (The Board), hence the whitelisting.
1624    *
1625    * @param from Address of the account to confisticate the tokens from
1626    * @param to Address to deposit the confisticated token to
1627    * @param value amount of tokens to be confisticated
1628    */
1629   function forceTransfer(address from, address to, uint256 value) external onlyRole(ROLE_FORCE) {
1630     transferInternal(from, to, value);
1631 
1632     Forced(from, to, value);
1633   }
1634 
1635   /**
1636    * @dev Issue new tokens to the board by a board decission
1637    *
1638    * Issue new tokens. This is intended to be called by the BAC (The Board),
1639    * hence the whitelisting.
1640    *
1641    * @param value Token amount to issue
1642    */
1643   function issueTokens(uint256 value) external onlyRole(ROLE_ISSUE) {
1644     address issuer = msg.sender;
1645     uint256 blackHoleBalance = balanceOf(address(0));
1646     uint256 totalSupplyNow = totalSupply();
1647 
1648     setCheckpoint(tokenBalances[address(0)], blackHoleBalance.add(value));
1649     transferInternal(address(0), issuer, value);
1650     setCheckpoint(tokensTotal, totalSupplyNow.add(value));
1651 
1652     Issued(issuer, value);
1653   }
1654 
1655   /**
1656    * @dev Burn tokens from contract's own balance by a board decission
1657    *
1658    * Burn tokens from contract's own balance to prevent accidental burnings.
1659    * This is intended to be called by the BAC (The Board), hence the whitelisting.
1660    *
1661    * @param value Token amount to burn from this contract's balance
1662    */
1663   function burnTokens(uint256 value) external onlyRole(ROLE_BURN) {
1664     address burner = address(this);
1665     uint256 burnerBalance = balanceOf(burner);
1666     uint256 totalSupplyNow = totalSupply();
1667 
1668     transferInternal(burner, address(0), value);
1669     setCheckpoint(tokenBalances[address(0)], burnerBalance.sub(value));
1670     setCheckpoint(tokensTotal, totalSupplyNow.sub(value));
1671 
1672     Burned(burner, value);
1673   }
1674 
1675   /**
1676    * @dev Whitelisted users (The Board, BAC) can update token information here.
1677    *
1678    * It is often useful to conceal the actual token association, until
1679    * the token operations, like central issuance or reissuance have been completed.
1680    *
1681    * This function allows the token owner to rename the token after the operations
1682    * have been completed and then point the audience to use the token contract.
1683    *
1684    * @param _name New name of the token
1685    * @param _symbol New symbol of the token
1686    * @param _url New URL of the token
1687    */
1688   function setTokenInformation(string _name, string _symbol, string _url) external onlyRole(ROLE_INFO) {
1689     name = _name;
1690     symbol = _symbol;
1691     url = _url;
1692 
1693     UpdatedTokenInformation(name, symbol, url);
1694   }
1695 
1696   /**
1697    * @dev Set transaction verifier
1698    *
1699    * This sets a SecurityTransferAgent to be used as a transaction verifier for
1700    * each transfer. This is implemented for possible regulatory requirements.
1701    *
1702    * @param newVerifier Address of the SecurityTransferAgent used as verifier
1703    */
1704   function setTransactionVerifier(SecurityTransferAgent newVerifier) external onlyRole(ROLE_SETVERIFIER) {
1705     transferVerifier = newVerifier;
1706 
1707     UpdatedTransactionVerifier(newVerifier);
1708   }
1709 }
