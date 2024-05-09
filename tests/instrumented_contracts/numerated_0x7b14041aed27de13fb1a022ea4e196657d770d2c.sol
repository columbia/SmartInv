1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 /**
58  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
59  *
60  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
61  */
62 
63 
64 
65 
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return c;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 /**
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances.
125  */
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   uint256 totalSupply_;
132 
133   /**
134   * @dev total number of tokens in existence
135   */
136   function totalSupply() public view returns (uint256) {
137     return totalSupply_;
138   }
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256 balance) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 
168 
169 
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) public view returns (uint256);
178   function transferFrom(address from, address to, uint256 value) public returns (bool);
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 
185 
186 
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    *
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(address _owner, address _spender) public view returns (uint256) {
242     return allowed[_owner][_spender];
243   }
244 
245   /**
246    * @dev Increase the amount of tokens that an owner allowed to a spender.
247    *
248    * approve should be called when allowed[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
256     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 
285 
286 
287 
288 
289 
290 /**
291    @title ERC827 interface, an extension of ERC20 token standard
292 
293    Interface of a ERC827 token, following the ERC20 standard with extra
294    methods to transfer value and data and execute calls in transfers and
295    approvals.
296  */
297 contract ERC827 is ERC20 {
298 
299   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
300   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
301   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
302 
303 }
304 
305 
306 
307 
308 
309 
310 /**
311    @title ERC827, an extension of ERC20 token standard
312 
313    Implementation the ERC827, following the ERC20 standard with extra
314    methods to transfer value and data and execute calls in transfers and
315    approvals.
316    Uses OpenZeppelin StandardToken.
317  */
318 contract ERC827Token is ERC827, StandardToken {
319 
320   /**
321      @dev Addition to ERC20 token methods. It allows to
322      approve the transfer of value and execute a call with the sent data.
323 
324      Beware that changing an allowance with this method brings the risk that
325      someone may use both the old and the new allowance by unfortunate
326      transaction ordering. One possible solution to mitigate this race condition
327      is to first reduce the spender's allowance to 0 and set the desired value
328      afterwards:
329      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330 
331      @param _spender The address that will spend the funds.
332      @param _value The amount of tokens to be spent.
333      @param _data ABI-encoded contract call to call `_to` address.
334 
335      @return true if the call function was executed successfully
336    */
337   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
338     require(_spender != address(this));
339 
340     super.approve(_spender, _value);
341 
342     require(_spender.call(_data));
343 
344     return true;
345   }
346 
347   /**
348      @dev Addition to ERC20 token methods. Transfer tokens to a specified
349      address and execute a call with the sent data on the same transaction
350 
351      @param _to address The address which you want to transfer to
352      @param _value uint256 the amout of tokens to be transfered
353      @param _data ABI-encoded contract call to call `_to` address.
354 
355      @return true if the call function was executed successfully
356    */
357   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
358     require(_to != address(this));
359 
360     super.transfer(_to, _value);
361 
362     require(_to.call(_data));
363     return true;
364   }
365 
366   /**
367      @dev Addition to ERC20 token methods. Transfer tokens from one address to
368      another and make a contract call on the same transaction
369 
370      @param _from The address which you want to send tokens from
371      @param _to The address which you want to transfer to
372      @param _value The amout of tokens to be transferred
373      @param _data ABI-encoded contract call to call `_to` address.
374 
375      @return true if the call function was executed successfully
376    */
377   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
378     require(_to != address(this));
379 
380     super.transferFrom(_from, _to, _value);
381 
382     require(_to.call(_data));
383     return true;
384   }
385 
386   /**
387    * @dev Addition to StandardToken methods. Increase the amount of tokens that
388    * an owner allowed to a spender and execute a call with the sent data.
389    *
390    * approve should be called when allowed[_spender] == 0. To increment
391    * allowed value is better to use this function to avoid 2 calls (and wait until
392    * the first transaction is mined)
393    * From MonolithDAO Token.sol
394    * @param _spender The address which will spend the funds.
395    * @param _addedValue The amount of tokens to increase the allowance by.
396    * @param _data ABI-encoded contract call to call `_spender` address.
397    */
398   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
399     require(_spender != address(this));
400 
401     super.increaseApproval(_spender, _addedValue);
402 
403     require(_spender.call(_data));
404 
405     return true;
406   }
407 
408   /**
409    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
410    * an owner allowed to a spender and execute a call with the sent data.
411    *
412    * approve should be called when allowed[_spender] == 0. To decrement
413    * allowed value is better to use this function to avoid 2 calls (and wait until
414    * the first transaction is mined)
415    * From MonolithDAO Token.sol
416    * @param _spender The address which will spend the funds.
417    * @param _subtractedValue The amount of tokens to decrease the allowance by.
418    * @param _data ABI-encoded contract call to call `_spender` address.
419    */
420   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
421     require(_spender != address(this));
422 
423     super.decreaseApproval(_spender, _subtractedValue);
424 
425     require(_spender.call(_data));
426 
427     return true;
428   }
429 
430 }
431 
432 
433 /**
434  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
435  *
436  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
437  */
438 
439 
440 
441 
442 
443 
444 contract Recoverable is Ownable {
445 
446   /// @dev Empty constructor (for now)
447   function Recoverable() {
448   }
449 
450   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
451   /// @param token Token which will we rescue to the owner from the contract
452   function recoverTokens(ERC20Basic token) onlyOwner public {
453     token.transfer(owner, tokensToBeReturned(token));
454   }
455 
456   /// @dev Interface function, can be overwritten by the superclass
457   /// @param token Token which balance we will check and return
458   /// @return The amount of tokens (in smallest denominator) the contract owns
459   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
460     return token.balanceOf(this);
461   }
462 }
463 
464 /**
465  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
466  *
467  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
468  */
469 
470 
471 
472 
473 
474 
475 
476 
477 /**
478  * Standard EIP-20 token with an interface marker.
479  *
480  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
481  *
482  */
483 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
484 
485   /* Interface declaration */
486   function isToken() public constant returns (bool weAre) {
487     return true;
488   }
489 }
490 
491 /**
492  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
493  *
494  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
495  */
496 
497 
498 
499 /**
500  * Safe unsigned safe math.
501  *
502  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
503  *
504  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
505  *
506  * Maintained here until merged to mainline zeppelin-solidity.
507  *
508  */
509 library SafeMathLib {
510 
511   function times(uint a, uint b) returns (uint) {
512     uint c = a * b;
513     assert(a == 0 || c / a == b);
514     return c;
515   }
516 
517   function minus(uint a, uint b) returns (uint) {
518     assert(b <= a);
519     return a - b;
520   }
521 
522   function plus(uint a, uint b) returns (uint) {
523     uint c = a + b;
524     assert(c>=a);
525     return c;
526   }
527 
528 }
529 
530 /**
531  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
532  *
533  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
534  */
535 
536 
537 
538 /**
539  * Upgrade agent interface inspired by Lunyr.
540  *
541  * Upgrade agent transfers tokens to a new contract.
542  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
543  */
544 contract UpgradeAgent {
545 
546   uint public originalSupply;
547 
548   /** Interface marker */
549   function isUpgradeAgent() public constant returns (bool) {
550     return true;
551   }
552 
553   function upgradeFrom(address _from, uint256 _value) public;
554 
555 }
556 
557 /**
558  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
559  *
560  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
561  */
562 
563 
564 
565 
566 
567 
568 
569 /**
570  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
571  *
572  * First envisioned by Golem and Lunyr projects.
573  */
574 contract UpgradeableToken is StandardTokenExt {
575 
576   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
577   address public upgradeMaster;
578 
579   /** The next contract where the tokens will be migrated. */
580   UpgradeAgent public upgradeAgent;
581 
582   /** How many tokens we have upgraded by now. */
583   uint256 public totalUpgraded;
584 
585   /**
586    * Upgrade states.
587    *
588    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
589    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
590    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
591    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
592    *
593    */
594   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
595 
596   /**
597    * Somebody has upgraded some of his tokens.
598    */
599   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
600 
601   /**
602    * New upgrade agent available.
603    */
604   event UpgradeAgentSet(address agent);
605 
606   /**
607    * Do not allow construction without upgrade master set.
608    */
609   function UpgradeableToken(address _upgradeMaster) {
610     upgradeMaster = _upgradeMaster;
611   }
612 
613   /**
614    * Allow the token holder to upgrade some of their tokens to a new contract.
615    */
616   function upgrade(uint256 value) public {
617 
618       UpgradeState state = getUpgradeState();
619       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
620         // Called in a bad state
621         throw;
622       }
623 
624       // Validate input value.
625       if (value == 0) throw;
626 
627       balances[msg.sender] = balances[msg.sender].sub(value);
628 
629       // Take tokens out from circulation
630       totalSupply_ = totalSupply_.sub(value);
631       totalUpgraded = totalUpgraded.add(value);
632 
633       // Upgrade agent reissues the tokens
634       upgradeAgent.upgradeFrom(msg.sender, value);
635       Upgrade(msg.sender, upgradeAgent, value);
636   }
637 
638   /**
639    * Set an upgrade agent that handles
640    */
641   function setUpgradeAgent(address agent) external {
642 
643       if(!canUpgrade()) {
644         // The token is not yet in a state that we could think upgrading
645         throw;
646       }
647 
648       if (agent == 0x0) throw;
649       // Only a master can designate the next agent
650       if (msg.sender != upgradeMaster) throw;
651       // Upgrade has already begun for an agent
652       if (getUpgradeState() == UpgradeState.Upgrading) throw;
653 
654       upgradeAgent = UpgradeAgent(agent);
655 
656       // Bad interface
657       if(!upgradeAgent.isUpgradeAgent()) throw;
658       // Make sure that token supplies match in source and target
659       if (upgradeAgent.originalSupply() != totalSupply_) throw;
660 
661       UpgradeAgentSet(upgradeAgent);
662   }
663 
664   /**
665    * Get the state of the token upgrade.
666    */
667   function getUpgradeState() public constant returns(UpgradeState) {
668     if(!canUpgrade()) return UpgradeState.NotAllowed;
669     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
670     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
671     else return UpgradeState.Upgrading;
672   }
673 
674   /**
675    * Change the upgrade master.
676    *
677    * This allows us to set a new owner for the upgrade mechanism.
678    */
679   function setUpgradeMaster(address master) public {
680       if (master == 0x0) throw;
681       if (msg.sender != upgradeMaster) throw;
682       upgradeMaster = master;
683   }
684 
685   /**
686    * Child contract can enable to provide the condition when the upgrade can begun.
687    */
688   function canUpgrade() public constant returns(bool) {
689      return true;
690   }
691 
692 }
693 
694 /**
695  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
696  *
697  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
698  */
699 
700 
701 
702 
703 
704 
705 
706 /**
707  * A token that can increase its supply by another contract.
708  *
709  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
710  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
711  *
712  */
713 contract MintableToken is StandardTokenExt {
714 
715   using SafeMathLib for uint;
716 
717   bool public mintingFinished = false;
718 
719   /** List of agents that are allowed to create new tokens */
720   mapping (address => bool) public mintAgents;
721 
722   event MintingAgentChanged(address addr, bool state);
723   event Minted(address receiver, uint amount);
724 
725   /**
726    * Create new tokens and allocate them to an address..
727    *
728    * Only callably by a crowdsale contract (mint agent).
729    */
730   function mint(address receiver, uint amount) onlyMintAgent canMint public {
731     totalSupply_ = totalSupply_.plus(amount);
732     balances[receiver] = balances[receiver].plus(amount);
733 
734     // This will make the mint transaction apper in EtherScan.io
735     // We can remove this after there is a standardized minting event
736     Transfer(0, receiver, amount);
737   }
738 
739   /**
740    * Owner can allow a crowdsale contract to mint new tokens.
741    */
742   function setMintAgent(address addr, bool state) onlyOwner canMint public {
743     mintAgents[addr] = state;
744     MintingAgentChanged(addr, state);
745   }
746 
747   modifier onlyMintAgent() {
748     // Only crowdsale contracts are allowed to mint new tokens
749     if(!mintAgents[msg.sender]) {
750         throw;
751     }
752     _;
753   }
754 
755   /** Make sure we are not done yet. */
756   modifier canMint() {
757     if(mintingFinished) throw;
758     _;
759   }
760 }
761 
762 contract BurnableToken is StandardTokenExt {
763 
764   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
765   address public constant BURN_ADDRESS = 0;
766 
767   /** How many tokens we burned */
768   event Burned(address burner, uint burnedAmount);
769 
770   /**
771    * Burn extra tokens from a balance.
772    *
773    */
774   function burn(uint burnAmount) {
775     address burner = msg.sender;
776     balances[burner] = balances[burner].sub(burnAmount);
777     totalSupply_ = totalSupply_.sub(burnAmount);
778     Burned(burner, burnAmount);
779 
780     // Inform the blockchain explores that track the
781     // balances only by a transfer event that the balance in this
782     // address has decreased
783     Transfer(burner, BURN_ADDRESS, burnAmount);
784   }
785 }
786 
787 /**
788  * A crowdsaled token.
789  *
790  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
791  *
792  * - The token contract gives an opt-in upgrade path to a new contract
793  * - The same token can be part of several crowdsales through approve() mechanism
794  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
795  *
796  */
797 contract CrowdsaleToken is MintableToken, UpgradeableToken, BurnableToken {
798 
799   /** Name and symbol were updated. */
800   event UpdatedTokenInformation(string newName, string newSymbol);
801 
802   string public name;
803 
804   string public symbol;
805 
806   uint public decimals;
807 
808   /**
809    * Construct the token.
810    *
811    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
812    *
813    * @param _name Token name
814    * @param _symbol Token symbol - should be all caps
815    * @param _initialSupply How many tokens we start with
816    * @param _decimals Number of decimal places
817    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
818    */
819   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
820     UpgradeableToken(msg.sender) {
821 
822     // Create any address, can be transferred
823     // to team multisig via changeOwner(),
824     // also remember to call setUpgradeMaster()
825     owner = msg.sender;
826 
827     name = _name;
828     symbol = _symbol;
829 
830     totalSupply_ = _initialSupply;
831 
832     decimals = _decimals;
833 
834     // Create initially all balance on the team multisig
835     balances[owner] = totalSupply_;
836 
837     if(totalSupply_ > 0) {
838       Minted(owner, totalSupply_);
839     }
840 
841     // No more new supply allowed after the token creation
842     if(!_mintable) {
843       mintingFinished = true;
844       if(totalSupply_ == 0) {
845         throw; // Cannot create a token without supply and no minting
846       }
847     }
848   }
849 
850   /**
851    * Owner can finish token minting.
852    */
853   function finishMinting() public onlyOwner {
854     mintingFinished = true;
855   }
856 
857   /**
858    * Owner can update token information here.
859    *
860    * It is often useful to conceal the actual token association, until
861    * the token operations, like central issuance or reissuance have been completed.
862    *
863    * This function allows the token owner to rename the token after the operations
864    * have been completed and then point the audience to use the token contract.
865    */
866   function setTokenInformation(string _name, string _symbol) onlyOwner {
867     name = _name;
868     symbol = _symbol;
869 
870     UpdatedTokenInformation(name, symbol);
871   }
872 
873 }