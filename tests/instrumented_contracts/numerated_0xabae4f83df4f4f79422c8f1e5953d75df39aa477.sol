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
24 pragma solidity ^0.4.13;
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
246 
247 
248 
249 
250 
251 
252 /**
253    @title ERC827 interface, an extension of ERC20 token standard
254 
255    Interface of a ERC827 token, following the ERC20 standard with extra
256    methods to transfer value and data and execute calls in transfers and
257    approvals.
258  */
259 contract ERC827 is ERC20 {
260 
261   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
262   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
263   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
264 
265 }
266 
267 
268 
269 /**
270    @title ERC827, an extension of ERC20 token standard
271 
272    Implementation the ERC827, following the ERC20 standard with extra
273    methods to transfer value and data and execute calls in transfers and
274    approvals.
275    Uses OpenZeppelin StandardToken.
276  */
277 contract ERC827Token is ERC827, StandardToken {
278 
279   /**
280      @dev Addition to ERC20 token methods. It allows to
281      approve the transfer of value and execute a call with the sent data.
282 
283      Beware that changing an allowance with this method brings the risk that
284      someone may use both the old and the new allowance by unfortunate
285      transaction ordering. One possible solution to mitigate this race condition
286      is to first reduce the spender's allowance to 0 and set the desired value
287      afterwards:
288      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289 
290      @param _spender The address that will spend the funds.
291      @param _value The amount of tokens to be spent.
292      @param _data ABI-encoded contract call to call `_to` address.
293 
294      @return true if the call function was executed successfully
295    */
296   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
297     require(_spender != address(this));
298 
299     super.approve(_spender, _value);
300 
301     require(_spender.call(_data));
302 
303     return true;
304   }
305 
306   /**
307      @dev Addition to ERC20 token methods. Transfer tokens to a specified
308      address and execute a call with the sent data on the same transaction
309 
310      @param _to address The address which you want to transfer to
311      @param _value uint256 the amout of tokens to be transfered
312      @param _data ABI-encoded contract call to call `_to` address.
313 
314      @return true if the call function was executed successfully
315    */
316   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
317     require(_to != address(this));
318 
319     super.transfer(_to, _value);
320 
321     require(_to.call(_data));
322     return true;
323   }
324 
325   /**
326      @dev Addition to ERC20 token methods. Transfer tokens from one address to
327      another and make a contract call on the same transaction
328 
329      @param _from The address which you want to send tokens from
330      @param _to The address which you want to transfer to
331      @param _value The amout of tokens to be transferred
332      @param _data ABI-encoded contract call to call `_to` address.
333 
334      @return true if the call function was executed successfully
335    */
336   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
337     require(_to != address(this));
338 
339     super.transferFrom(_from, _to, _value);
340 
341     require(_to.call(_data));
342     return true;
343   }
344 
345   /**
346    * @dev Addition to StandardToken methods. Increase the amount of tokens that
347    * an owner allowed to a spender and execute a call with the sent data.
348    *
349    * approve should be called when allowed[_spender] == 0. To increment
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol
353    * @param _spender The address which will spend the funds.
354    * @param _addedValue The amount of tokens to increase the allowance by.
355    * @param _data ABI-encoded contract call to call `_spender` address.
356    */
357   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
358     require(_spender != address(this));
359 
360     super.increaseApproval(_spender, _addedValue);
361 
362     require(_spender.call(_data));
363 
364     return true;
365   }
366 
367   /**
368    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
369    * an owner allowed to a spender and execute a call with the sent data.
370    *
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    * @param _data ABI-encoded contract call to call `_spender` address.
378    */
379   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
380     require(_spender != address(this));
381 
382     super.decreaseApproval(_spender, _subtractedValue);
383 
384     require(_spender.call(_data));
385 
386     return true;
387   }
388 
389 }
390 
391 /**
392  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
393  *
394  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
395  */
396 
397 
398 
399 
400 /**
401  * @title Ownable
402  * @dev The Ownable contract has an owner address, and provides basic authorization control
403  * functions, this simplifies the implementation of "user permissions".
404  */
405 contract Ownable {
406   address public owner;
407 
408 
409   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411 
412   /**
413    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
414    * account.
415    */
416   function Ownable() public {
417     owner = msg.sender;
418   }
419 
420   /**
421    * @dev Throws if called by any account other than the owner.
422    */
423   modifier onlyOwner() {
424     require(msg.sender == owner);
425     _;
426   }
427 
428   /**
429    * @dev Allows the current owner to transfer control of the contract to a newOwner.
430    * @param newOwner The address to transfer ownership to.
431    */
432   function transferOwnership(address newOwner) public onlyOwner {
433     require(newOwner != address(0));
434     OwnershipTransferred(owner, newOwner);
435     owner = newOwner;
436   }
437 
438 }
439 
440 
441 
442 contract Recoverable is Ownable {
443 
444   /// @dev Empty constructor (for now)
445   function Recoverable() {
446   }
447 
448   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
449   /// @param token Token which will we rescue to the owner from the contract
450   function recoverTokens(ERC20Basic token) onlyOwner public {
451     token.transfer(owner, tokensToBeReturned(token));
452   }
453 
454   /// @dev Interface function, can be overwritten by the superclass
455   /// @param token Token which balance we will check and return
456   /// @return The amount of tokens (in smallest denominator) the contract owns
457   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
458     return token.balanceOf(this);
459   }
460 }
461 
462 
463 
464 /**
465  * Standard EIP-20 token with an interface marker.
466  *
467  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
468  *
469  */
470 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
471 
472   /* Interface declaration */
473   function isToken() public constant returns (bool weAre) {
474     return true;
475   }
476 }
477 
478 
479 contract BurnableToken is StandardTokenExt {
480 
481   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
482   address public constant BURN_ADDRESS = 0;
483 
484   /** How many tokens we burned */
485   event Burned(address burner, uint burnedAmount);
486 
487   /**
488    * Burn extra tokens from a balance.
489    *
490    */
491   function burn(uint burnAmount) {
492     address burner = msg.sender;
493     balances[burner] = balances[burner].sub(burnAmount);
494     totalSupply_ = totalSupply_.sub(burnAmount);
495     Burned(burner, burnAmount);
496 
497     // Inform the blockchain explores that track the
498     // balances only by a transfer event that the balance in this
499     // address has decreased
500     Transfer(burner, BURN_ADDRESS, burnAmount);
501   }
502 }
503 
504 /**
505  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
506  *
507  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
508  */
509 
510 
511 /**
512  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
513  *
514  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
515  */
516 
517 
518 
519 
520 /**
521  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
522  *
523  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
524  */
525 
526 
527 /**
528  * Upgrade agent interface inspired by Lunyr.
529  *
530  * Upgrade agent transfers tokens to a new contract.
531  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
532  */
533 contract UpgradeAgent {
534 
535   uint public originalSupply;
536 
537   /** Interface marker */
538   function isUpgradeAgent() public constant returns (bool) {
539     return true;
540   }
541 
542   function upgradeFrom(address _from, uint256 _value) public;
543 
544 }
545 
546 
547 /**
548  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
549  *
550  * First envisioned by Golem and Lunyr projects.
551  */
552 contract UpgradeableToken is StandardTokenExt {
553 
554   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
555   address public upgradeMaster;
556 
557   /** The next contract where the tokens will be migrated. */
558   UpgradeAgent public upgradeAgent;
559 
560   /** How many tokens we have upgraded by now. */
561   uint256 public totalUpgraded;
562 
563   /**
564    * Upgrade states.
565    *
566    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
567    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
568    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
569    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
570    *
571    */
572   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
573 
574   /**
575    * Somebody has upgraded some of his tokens.
576    */
577   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
578 
579   /**
580    * New upgrade agent available.
581    */
582   event UpgradeAgentSet(address agent);
583 
584   /**
585    * Do not allow construction without upgrade master set.
586    */
587   function UpgradeableToken(address _upgradeMaster) {
588     upgradeMaster = _upgradeMaster;
589   }
590 
591   /**
592    * Allow the token holder to upgrade some of their tokens to a new contract.
593    */
594   function upgrade(uint256 value) public {
595 
596       UpgradeState state = getUpgradeState();
597       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
598         // Called in a bad state
599         throw;
600       }
601 
602       // Validate input value.
603       if (value == 0) throw;
604 
605       balances[msg.sender] = balances[msg.sender].sub(value);
606 
607       // Take tokens out from circulation
608       totalSupply_ = totalSupply_.sub(value);
609       totalUpgraded = totalUpgraded.add(value);
610 
611       // Upgrade agent reissues the tokens
612       upgradeAgent.upgradeFrom(msg.sender, value);
613       Upgrade(msg.sender, upgradeAgent, value);
614   }
615 
616   /**
617    * Set an upgrade agent that handles
618    */
619   function setUpgradeAgent(address agent) external {
620 
621       if(!canUpgrade()) {
622         // The token is not yet in a state that we could think upgrading
623         throw;
624       }
625 
626       if (agent == 0x0) throw;
627       // Only a master can designate the next agent
628       if (msg.sender != upgradeMaster) throw;
629       // Upgrade has already begun for an agent
630       if (getUpgradeState() == UpgradeState.Upgrading) throw;
631 
632       upgradeAgent = UpgradeAgent(agent);
633 
634       // Bad interface
635       if(!upgradeAgent.isUpgradeAgent()) throw;
636       // Make sure that token supplies match in source and target
637       if (upgradeAgent.originalSupply() != totalSupply_) throw;
638 
639       UpgradeAgentSet(upgradeAgent);
640   }
641 
642   /**
643    * Get the state of the token upgrade.
644    */
645   function getUpgradeState() public constant returns(UpgradeState) {
646     if(!canUpgrade()) return UpgradeState.NotAllowed;
647     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
648     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
649     else return UpgradeState.Upgrading;
650   }
651 
652   /**
653    * Change the upgrade master.
654    *
655    * This allows us to set a new owner for the upgrade mechanism.
656    */
657   function setUpgradeMaster(address master) public {
658       if (master == 0x0) throw;
659       if (msg.sender != upgradeMaster) throw;
660       upgradeMaster = master;
661   }
662 
663   /**
664    * Child contract can enable to provide the condition when the upgrade can begun.
665    */
666   function canUpgrade() public constant returns(bool) {
667      return true;
668   }
669 
670 }
671 
672 /**
673  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
674  *
675  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
676  */
677 
678 
679 
680 
681 
682 /**
683  * Define interface for releasing the token transfer after a successful crowdsale.
684  */
685 contract ReleasableToken is StandardTokenExt {
686 
687   /* The finalizer contract that allows unlift the transfer limits on this token */
688   address public releaseAgent;
689 
690   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
691   bool public released = false;
692 
693   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
694   mapping (address => bool) public transferAgents;
695 
696   /**
697    * Limit token transfer until the crowdsale is over.
698    *
699    */
700   modifier canTransfer(address _sender) {
701 
702     if(!released) {
703         if(!transferAgents[_sender]) {
704             throw;
705         }
706     }
707 
708     _;
709   }
710 
711   /**
712    * Set the contract that can call release and make the token transferable.
713    *
714    * Design choice. Allow reset the release agent to fix fat finger mistakes.
715    */
716   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
717 
718     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
719     releaseAgent = addr;
720   }
721 
722   /**
723    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
724    */
725   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
726     transferAgents[addr] = state;
727   }
728 
729   /**
730    * One way function to release the tokens to the wild.
731    *
732    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
733    */
734   function releaseTokenTransfer() public onlyReleaseAgent {
735     released = true;
736   }
737 
738   /** The function can be called only before or after the tokens have been releasesd */
739   modifier inReleaseState(bool releaseState) {
740     if(releaseState != released) {
741         throw;
742     }
743     _;
744   }
745 
746   /** The function can be called only by a whitelisted release agent. */
747   modifier onlyReleaseAgent() {
748     if(msg.sender != releaseAgent) {
749         throw;
750     }
751     _;
752   }
753 
754   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
755     // Call StandardToken.transfer()
756    return super.transfer(_to, _value);
757   }
758 
759   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
760     // Call StandardToken.transferForm()
761     return super.transferFrom(_from, _to, _value);
762   }
763 
764 }
765 
766 /**
767  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
768  *
769  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
770  */
771 
772 
773 
774 /**
775  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
776  *
777  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
778  */
779 
780 
781 /**
782  * Safe unsigned safe math.
783  *
784  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
785  *
786  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
787  *
788  * Maintained here until merged to mainline zeppelin-solidity.
789  *
790  */
791 library SafeMathLib {
792 
793   function times(uint a, uint b) returns (uint) {
794     uint c = a * b;
795     assert(a == 0 || c / a == b);
796     return c;
797   }
798 
799   function minus(uint a, uint b) returns (uint) {
800     assert(b <= a);
801     return a - b;
802   }
803 
804   function plus(uint a, uint b) returns (uint) {
805     uint c = a + b;
806     assert(c>=a);
807     return c;
808   }
809 
810 }
811 
812 
813 
814 /**
815  * A token that can increase its supply by another contract.
816  *
817  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
818  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
819  *
820  */
821 contract MintableToken is StandardTokenExt {
822 
823   using SafeMathLib for uint;
824 
825   bool public mintingFinished = false;
826 
827   /** List of agents that are allowed to create new tokens */
828   mapping (address => bool) public mintAgents;
829 
830   event MintingAgentChanged(address addr, bool state);
831   event Minted(address receiver, uint amount);
832 
833   /**
834    * Create new tokens and allocate them to an address..
835    *
836    * Only callably by a crowdsale contract (mint agent).
837    */
838   function mint(address receiver, uint amount) onlyMintAgent canMint public {
839     totalSupply_ = totalSupply_.plus(amount);
840     balances[receiver] = balances[receiver].plus(amount);
841 
842     // This will make the mint transaction apper in EtherScan.io
843     // We can remove this after there is a standardized minting event
844     Transfer(0, receiver, amount);
845   }
846 
847   /**
848    * Owner can allow a crowdsale contract to mint new tokens.
849    */
850   function setMintAgent(address addr, bool state) onlyOwner canMint public {
851     mintAgents[addr] = state;
852     MintingAgentChanged(addr, state);
853   }
854 
855   modifier onlyMintAgent() {
856     // Only crowdsale contracts are allowed to mint new tokens
857     if(!mintAgents[msg.sender]) {
858         throw;
859     }
860     _;
861   }
862 
863   /** Make sure we are not done yet. */
864   modifier canMint() {
865     if(mintingFinished) throw;
866     _;
867   }
868 }
869 
870 
871 
872 /**
873  * A crowdsaled token.
874  *
875  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
876  *
877  * - The token transfer() is disabled until the crowdsale is over
878  * - The token contract gives an opt-in upgrade path to a new contract
879  * - The same token can be part of several crowdsales through approve() mechanism
880  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
881  *
882  */
883 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
884 
885   /** Name and symbol were updated. */
886   event UpdatedTokenInformation(string newName, string newSymbol);
887 
888   string public name;
889 
890   string public symbol;
891 
892   uint public decimals;
893 
894   /**
895    * Construct the token.
896    *
897    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
898    *
899    * @param _name Token name
900    * @param _symbol Token symbol - should be all caps
901    * @param _initialSupply How many tokens we start with
902    * @param _decimals Number of decimal places
903    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
904    */
905   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
906     UpgradeableToken(msg.sender) {
907 
908     // Create any address, can be transferred
909     // to team multisig via changeOwner(),
910     // also remember to call setUpgradeMaster()
911     owner = msg.sender;
912 
913     name = _name;
914     symbol = _symbol;
915 
916     totalSupply_ = _initialSupply;
917 
918     decimals = _decimals;
919 
920     // Create initially all balance on the team multisig
921     balances[owner] = totalSupply_;
922 
923     if(totalSupply_ > 0) {
924       Minted(owner, totalSupply_);
925     }
926 
927     // No more new supply allowed after the token creation
928     if(!_mintable) {
929       mintingFinished = true;
930       if(totalSupply_ == 0) {
931         throw; // Cannot create a token without supply and no minting
932       }
933     }
934   }
935 
936   /**
937    * When token is released to be transferable, enforce no new tokens can be created.
938    */
939   function releaseTokenTransfer() public onlyReleaseAgent {
940     mintingFinished = true;
941     super.releaseTokenTransfer();
942   }
943 
944   /**
945    * Allow upgrade agent functionality kick in only if the crowdsale was success.
946    */
947   function canUpgrade() public constant returns(bool) {
948     return released && super.canUpgrade();
949   }
950 
951   /**
952    * Owner can update token information here.
953    *
954    * It is often useful to conceal the actual token association, until
955    * the token operations, like central issuance or reissuance have been completed.
956    *
957    * This function allows the token owner to rename the token after the operations
958    * have been completed and then point the audience to use the token contract.
959    */
960   function setTokenInformation(string _name, string _symbol) onlyOwner {
961     name = _name;
962     symbol = _symbol;
963 
964     UpdatedTokenInformation(name, symbol);
965   }
966 
967 }
968 
969 
970 /**
971  * A crowdsaled token that you can also burn.
972  *
973  */
974 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
975 
976   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
977     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
978 
979   }
980 }