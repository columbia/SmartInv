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
805   function verify(address from, address to, uint256 value) public returns (uint256 newValue);
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
899   event Transfer(address from, address receiver, uint256 amount, bytes data);
900   function transferAndCall(ERC677Receiver receiver, uint amount, bytes data) returns (bool success);
901 }
902 
903 
904 
905 contract ERC677Token is ERC20, ERC677 {
906   function transferAndCall(ERC677Receiver receiver, uint amount, bytes data) returns (bool success) {
907     require(transfer(address(receiver), amount));
908 
909     Transfer(msg.sender, address(receiver), amount, data);
910 
911     require(receiver.tokenFallback(msg.sender, amount, data));
912   }
913 }
914 
915 
916 /**
917  * @author TokenMarket /  Ville Sundell <ville at tokenmarket.net>
918  */
919 contract CheckpointToken is ERC677Token {
920   using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)
921 
922   string public name;
923   string public symbol;
924   uint256 public decimals;
925   SecurityTransferAgent public transferVerifier;
926 
927   struct Checkpoint {
928     uint256 blockNumber;
929     uint256 value;
930   }
931 
932   mapping (address => Checkpoint[]) public tokenBalances;
933   Checkpoint[] public tokensTotal;
934 
935   mapping (address => mapping (address => uint256)) public allowed;
936 
937   /**
938    * @dev Constructor for CheckpointToken, initializing the token
939    *
940    * Here we define initial values for name, symbol and decimals.
941    *
942    * @param _name Initial name of the token
943    * @param _symbol Initial symbol of the token
944    * @param _decimals Number of decimals for the token, industry standard is 18
945    */
946   function CheckpointToken(string _name, string _symbol, uint256 _decimals) public {
947     name = _name;
948     symbol = _symbol;
949     decimals = _decimals;
950   }
951 
952   /** PUBLIC FUNCTIONS
953    ****************************************/
954 
955   /**
956    * @dev Function to check the amount of tokens that an owner allowed to a spender.
957    * @param owner address The address which owns the funds.
958    * @param spender address The address which will spend the funds.
959    * @return A uint256 specifying the amount of tokens still available for the spender.
960    */
961   function allowance(address owner, address spender) public view returns (uint256) {
962     return allowed[owner][spender];
963   }
964 
965   /**
966    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
967    *
968    * Beware that changing an allowance with this method brings the risk that someone may use both the old
969    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
970    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
971    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
972    * @param spender The address which will spend the funds.
973    * @param value The amount of tokens to be spent.
974    * @return true if the call function was executed successfully
975    */
976   function approve(address spender, uint256 value) public returns (bool) {
977     allowed[msg.sender][spender] = value;
978     Approval(msg.sender, spender, value);
979     return true;
980   }
981 
982   /**
983    * @dev Transfer tokens from one address to another
984    * @param from address The address which you want to send tokens from
985    * @param to address The address which you want to transfer to
986    * @param value uint256 the amount of tokens to be transferred
987    * @return true if the call function was executed successfully
988    */
989   function transferFrom(address from, address to, uint256 value) public returns (bool) {
990     require(value <= allowed[from][msg.sender]);
991 
992     transferInternal(from, to, value);
993     Transfer(from, to, value);
994     return true;
995   }
996 
997   /**
998    * @dev transfer token for a specified address
999    * @param to The address to transfer to.
1000    * @param value The amount to be transferred.
1001    * @return true if the call function was executed successfully
1002    */
1003   function transfer(address to, uint256 value) public returns (bool) {
1004     transferInternal(msg.sender, to, value);
1005     Transfer(msg.sender, to, value);
1006     return true;
1007   }
1008 
1009   /**
1010    * @dev total number of tokens in existence
1011    * @return A uint256 specifying the total number of tokens in existence
1012    */
1013   function totalSupply() public view returns (uint256 tokenCount) {
1014     tokenCount = balanceAtBlock(tokensTotal, block.number);
1015   }
1016 
1017   /**
1018    * @dev total number of tokens in existence at the given block
1019    * @param blockNumber The block number we want to query for the total supply
1020    * @return A uint256 specifying the total number of tokens at a given block
1021    */
1022   function totalSupplyAt(uint256 blockNumber) public view returns (uint256 tokenCount) {
1023     tokenCount = balanceAtBlock(tokensTotal, blockNumber);
1024   }
1025 
1026   /**
1027    * @dev Gets the balance of the specified address.
1028    * @param owner The address to query the the balance of.
1029    * @return An uint256 representing the amount owned by the passed address.
1030    */
1031   function balanceOf(address owner) public view returns (uint256 balance) {
1032     balance = balanceAtBlock(tokenBalances[owner], block.number);
1033   }
1034 
1035   /**
1036    * @dev Gets the balance of the specified address.
1037    * @param owner The address to query the the balance of.
1038    * @param blockNumber The block number we want to query for the balance.
1039    * @return An uint256 representing the amount owned by the passed address.
1040    */
1041   function balanceAt(address owner, uint256 blockNumber) public view returns (uint256 balance) {
1042     balance = balanceAtBlock(tokenBalances[owner], blockNumber);
1043   }
1044 
1045   /**
1046    * @dev Increase the amount of tokens that an owner allowed to a spender.
1047    *
1048    * approve should be called when allowed[spender] == 0. To increment
1049    * allowed value is better to use this function to avoid 2 calls (and wait until
1050    * the first transaction is mined)
1051    * From MonolithDAO Token.sol
1052    * @param spender The address which will spend the funds.
1053    * @param addedValue The amount of tokens to increase the allowance by.
1054    */
1055   function increaseApproval(address spender, uint addedValue) public returns (bool) {
1056     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
1057     Approval(msg.sender, spender, allowed[msg.sender][spender]);
1058     return true;
1059   }
1060 
1061   /**
1062    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1063    *
1064    * approve should be called when allowed[spender] == 0. To decrement
1065    * allowed value is better to use this function to avoid 2 calls (and wait until
1066    * the first transaction is mined)
1067    * From MonolithDAO Token.sol
1068    * @param spender The address which will spend the funds.
1069    * @param subtractedValue The amount of tokens to decrease the allowance by.
1070    */
1071   function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
1072     uint oldValue = allowed[msg.sender][spender];
1073     if (subtractedValue > oldValue) {
1074       allowed[msg.sender][spender] = 0;
1075     } else {
1076       allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
1077     }
1078     Approval(msg.sender, spender, allowed[msg.sender][spender]);
1079     return true;
1080   }
1081 
1082   /**
1083    * @dev Addition to StandardToken methods. Increase the amount of tokens that
1084    * an owner allowed to a spender and execute a call with the sent data.
1085    *
1086    * This is originally from OpenZeppelin.
1087    *
1088    * approve should be called when allowed[spender] == 0. To increment
1089    * allowed value is better to use this function to avoid 2 calls (and wait until
1090    * the first transaction is mined)
1091    * From MonolithDAO Token.sol
1092    * @param spender The address which will spend the funds.
1093    * @param addedValue The amount of tokens to increase the allowance by.
1094    * @param data ABI-encoded contract call to call `spender` address.
1095    */
1096   function increaseApproval(address spender, uint addedValue, bytes data) public returns (bool) {
1097     require(spender != address(this));
1098 
1099     increaseApproval(spender, addedValue);
1100 
1101     require(spender.call(data));
1102 
1103     return true;
1104   }
1105 
1106   /**
1107    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
1108    * an owner allowed to a spender and execute a call with the sent data.
1109    *
1110    * This is originally from OpenZeppelin.
1111    *
1112    * approve should be called when allowed[spender] == 0. To decrement
1113    * allowed value is better to use this function to avoid 2 calls (and wait until
1114    * the first transaction is mined)
1115    * From MonolithDAO Token.sol
1116    * @param spender The address which will spend the funds.
1117    * @param subtractedValue The amount of tokens to decrease the allowance by.
1118    * @param data ABI-encoded contract call to call `spender` address.
1119    */
1120   function decreaseApproval(address spender, uint subtractedValue, bytes data) public returns (bool) {
1121     require(spender != address(this));
1122 
1123     decreaseApproval(spender, subtractedValue);
1124 
1125     require(spender.call(data));
1126 
1127     return true;
1128   }
1129 
1130   /** INTERNALS
1131    ****************************************/
1132 
1133   function balanceAtBlock(Checkpoint[] storage checkpoints, uint256 blockNumber) internal returns (uint256 balance) {
1134     uint256 currentBlockNumber;
1135     (currentBlockNumber, balance) = getCheckpoint(checkpoints, blockNumber);
1136   }
1137 
1138   function transferInternal(address from, address to, uint256 value) internal {
1139     if (address(transferVerifier) != address(0)) {
1140       value = transferVerifier.verify(from, to, value);
1141       require(value > 0);
1142     }
1143 
1144     uint256 fromBalance;
1145     uint256 toBalance;
1146 
1147     fromBalance = balanceOf(from);
1148     toBalance = balanceOf(to);
1149 
1150     setCheckpoint(tokenBalances[from], fromBalance.sub(value));
1151     setCheckpoint(tokenBalances[to], toBalance.add(value));
1152   }
1153 
1154 
1155   /** CORE
1156    ** The Magic happens below:
1157    ***************************************/
1158 
1159   function setCheckpoint(Checkpoint[] storage checkpoints, uint256 newValue) internal {
1160     if ((checkpoints.length == 0) || (checkpoints[checkpoints.length.sub(1)].blockNumber < block.number)) {
1161       checkpoints.push(Checkpoint(block.number, newValue));
1162     } else {
1163        checkpoints[checkpoints.length.sub(1)] = Checkpoint(block.number, newValue);
1164     }
1165   }
1166 
1167   function getCheckpoint(Checkpoint[] storage checkpoints, uint256 blockNumber) internal returns (uint256 blockNumber_, uint256 value) {
1168     if (checkpoints.length == 0) {
1169       return (0, 0);
1170     }
1171 
1172     // Shortcut for the actual value
1173     if (blockNumber >= checkpoints[checkpoints.length.sub(1)].blockNumber) {
1174       return (checkpoints[checkpoints.length.sub(1)].blockNumber, checkpoints[checkpoints.length.sub(1)].value);
1175     }
1176 
1177     if (blockNumber < checkpoints[0].blockNumber) {
1178       return (0, 0);
1179     }
1180 
1181     // Binary search of the value in the array
1182     uint256 min = 0;
1183     uint256 max = checkpoints.length.sub(1);
1184     while (max > min) {
1185       uint256 mid = (max.add(min.add(1))).div(2);
1186       if (checkpoints[mid].blockNumber <= blockNumber) {
1187         min = mid;
1188       } else {
1189         max = mid.sub(1);
1190       }
1191     }
1192 
1193     return (checkpoints[min].blockNumber, checkpoints[min].value);
1194   }
1195 }
1196 
1197 
1198 
1199 
1200 /**
1201  * @dev Interface for general announcements about the security.
1202  *
1203  * Announcements can be for instance for dividend sharing, voting, or
1204  * just for general announcements.
1205  */
1206 interface Announcement {
1207   function announcementName() public view returns (bytes32);
1208   function announcementURI() public view returns (bytes32);
1209   function announcementType() public view returns (uint256);
1210   function announcementHash() public view returns (uint256);
1211 }
1212 
1213 /**
1214  * @author TokenMarket /  Ville Sundell <ville at tokenmarket.net>
1215  */
1216 contract SecurityToken is CheckpointToken, Whitelist, Recoverable {
1217   using SafeMath for uint256; // We use only uint256 for safety reasons (no boxing)
1218 
1219   string public version = 'TM01 0.1';
1220 
1221   /** SecurityToken specific events **/
1222   event Issued(address indexed to, uint256 value);
1223   event Burned(address indexed burner, uint256 value);
1224   event Forced(address indexed from, address indexed to, uint256 value);
1225   event Announced(address indexed announcement, uint256 indexed announcementType, bytes32 indexed announcementName, bytes32 announcementURI, uint256 announcementHash);
1226   event UpdatedTokenInformation(string newName, string newSymbol);
1227   event UpdatedTransactionVerifier(address newVerifier);
1228 
1229   address[] public announcements;
1230 
1231   /**
1232    * @dev Contructor to create SecurityToken, and subsequent CheckpointToken.
1233    *
1234    * CheckpointToken will be created with hardcoded 18 decimals.
1235    *
1236    * @param _name Initial name of the token
1237    * @param _symbol Initial symbol of the token
1238    */
1239   function SecurityToken(string _name, string _symbol) CheckpointToken(_name, _symbol, 18) public {
1240 
1241   }
1242 
1243   /**
1244    * @dev Function to announce Announcements.
1245    *
1246    * Announcements can be for instance for dividend sharing, voting, or
1247    * just for general announcements.
1248    *
1249    * Instead of storing the announcement details, we just broadcast them as an
1250    * event, and store only the address.
1251    *
1252    * @param announcement Address of the Announcement
1253    */
1254   function announce(Announcement announcement) external onlyWhitelisted {
1255     announcements.push(announcement);
1256     Announced(address(announcement), announcement.announcementType(), announcement.announcementName(), announcement.announcementURI(), announcement.announcementHash());
1257   }
1258 
1259   /**
1260    * @dev Function to forcefully transfer tokens from A to B by board decission
1261    *
1262    * This must be implemented carefully, since this is a very critical part
1263    * to ensure investor safety.
1264    *
1265    * This is intended to be called by the BAC (The Board), hence the whitelisting.
1266    *
1267    * @param from Address of the account to confisticate the tokens from
1268    * @param to Address to deposit the confisticated token to
1269    * @param value amount of tokens to be confisticated
1270    */
1271   function forceTransfer(address from, address to, uint256 value) external onlyWhitelisted {
1272     transferInternal(from, to, value);
1273 
1274     Forced(from, to, value);
1275   }
1276 
1277   /**
1278    * @dev Issue new tokens to the board by a board decission
1279    *
1280    * Issue new tokens. This is intended to be called by the BAC (The Board),
1281    * hence the whitelisting.
1282    *
1283    * @param value Token amount to issue
1284    */
1285   function issueTokens(uint256 value) external onlyWhitelisted {
1286     address issuer = msg.sender;
1287     uint256 blackHoleBalance = balanceOf(address(0));
1288     uint256 totalSupplyNow = totalSupply();
1289 
1290     setCheckpoint(tokenBalances[address(0)], blackHoleBalance.add(value));
1291     transferInternal(address(0), issuer, value);
1292     setCheckpoint(tokensTotal, totalSupplyNow.add(value));
1293 
1294     Issued(issuer, value);
1295   }
1296 
1297   /**
1298    * @dev Burn tokens from contract's own balance by a board decission
1299    *
1300    * Burn tokens from contract's own balance to prevent accidental burnings.
1301    * This is intended to be called by the BAC (The Board), hence the whitelisting.
1302    *
1303    * @param value Token amount to burn from this contract's balance
1304    */
1305   function burnTokens(uint256 value) external onlyWhitelisted {
1306     address burner = address(this);
1307     uint256 burnerBalance = balanceOf(burner);
1308     uint256 totalSupplyNow = totalSupply();
1309 
1310     transferInternal(burner, address(0), value);
1311     setCheckpoint(tokenBalances[address(0)], burnerBalance.sub(value));
1312     setCheckpoint(tokensTotal, totalSupplyNow.sub(value));
1313 
1314     Burned(burner, value);
1315   }
1316 
1317   /**
1318    * @dev Whitelisted users (The Board, BAC) can update token information here.
1319    *
1320    * It is often useful to conceal the actual token association, until
1321    * the token operations, like central issuance or reissuance have been completed.
1322    *
1323    * This function allows the token owner to rename the token after the operations
1324    * have been completed and then point the audience to use the token contract.
1325    *
1326    * @param _name New name of the token
1327    * @param _symbol New symbol of the token
1328    */
1329   function setTokenInformation(string _name, string _symbol) external onlyWhitelisted {
1330     name = _name;
1331     symbol = _symbol;
1332 
1333     UpdatedTokenInformation(name, symbol);
1334   }
1335 
1336   /**
1337    * @dev Set transaction verifier
1338    *
1339    * This sets a SecurityTransferAgent to be used as a transaction verifier for
1340    * each transfer. This is implemented for possible regulatory requirements.
1341    *
1342    * @param newVerifier Address of the SecurityTransferAgent used as verifier
1343    */
1344   function setTransactionVerifier(SecurityTransferAgent newVerifier) external onlyWhitelisted {
1345     transferVerifier = newVerifier;
1346 
1347     UpdatedTransactionVerifier(newVerifier);
1348   }
1349 }