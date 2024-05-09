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
253 
254 
255 
256 
257 
258 
259 /**
260    @title ERC827 interface, an extension of ERC20 token standard
261 
262    Interface of a ERC827 token, following the ERC20 standard with extra
263    methods to transfer value and data and execute calls in transfers and
264    approvals.
265  */
266 contract ERC827 is ERC20 {
267 
268   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
269   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
270   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
271 
272 }
273 
274 
275 
276 /**
277    @title ERC827, an extension of ERC20 token standard
278 
279    Implementation the ERC827, following the ERC20 standard with extra
280    methods to transfer value and data and execute calls in transfers and
281    approvals.
282    Uses OpenZeppelin StandardToken.
283  */
284 contract ERC827Token is ERC827, StandardToken {
285 
286   /**
287      @dev Addition to ERC20 token methods. It allows to
288      approve the transfer of value and execute a call with the sent data.
289 
290      Beware that changing an allowance with this method brings the risk that
291      someone may use both the old and the new allowance by unfortunate
292      transaction ordering. One possible solution to mitigate this race condition
293      is to first reduce the spender's allowance to 0 and set the desired value
294      afterwards:
295      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296 
297      @param _spender The address that will spend the funds.
298      @param _value The amount of tokens to be spent.
299      @param _data ABI-encoded contract call to call `_to` address.
300 
301      @return true if the call function was executed successfully
302    */
303   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
304     require(_spender != address(this));
305 
306     super.approve(_spender, _value);
307 
308     require(_spender.call(_data));
309 
310     return true;
311   }
312 
313   /**
314      @dev Addition to ERC20 token methods. Transfer tokens to a specified
315      address and execute a call with the sent data on the same transaction
316 
317      @param _to address The address which you want to transfer to
318      @param _value uint256 the amout of tokens to be transfered
319      @param _data ABI-encoded contract call to call `_to` address.
320 
321      @return true if the call function was executed successfully
322    */
323   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
324     require(_to != address(this));
325 
326     super.transfer(_to, _value);
327 
328     require(_to.call(_data));
329     return true;
330   }
331 
332   /**
333      @dev Addition to ERC20 token methods. Transfer tokens from one address to
334      another and make a contract call on the same transaction
335 
336      @param _from The address which you want to send tokens from
337      @param _to The address which you want to transfer to
338      @param _value The amout of tokens to be transferred
339      @param _data ABI-encoded contract call to call `_to` address.
340 
341      @return true if the call function was executed successfully
342    */
343   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
344     require(_to != address(this));
345 
346     super.transferFrom(_from, _to, _value);
347 
348     require(_to.call(_data));
349     return true;
350   }
351 
352   /**
353    * @dev Addition to StandardToken methods. Increase the amount of tokens that
354    * an owner allowed to a spender and execute a call with the sent data.
355    *
356    * approve should be called when allowed[_spender] == 0. To increment
357    * allowed value is better to use this function to avoid 2 calls (and wait until
358    * the first transaction is mined)
359    * From MonolithDAO Token.sol
360    * @param _spender The address which will spend the funds.
361    * @param _addedValue The amount of tokens to increase the allowance by.
362    * @param _data ABI-encoded contract call to call `_spender` address.
363    */
364   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
365     require(_spender != address(this));
366 
367     super.increaseApproval(_spender, _addedValue);
368 
369     require(_spender.call(_data));
370 
371     return true;
372   }
373 
374   /**
375    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
376    * an owner allowed to a spender and execute a call with the sent data.
377    *
378    * approve should be called when allowed[_spender] == 0. To decrement
379    * allowed value is better to use this function to avoid 2 calls (and wait until
380    * the first transaction is mined)
381    * From MonolithDAO Token.sol
382    * @param _spender The address which will spend the funds.
383    * @param _subtractedValue The amount of tokens to decrease the allowance by.
384    * @param _data ABI-encoded contract call to call `_spender` address.
385    */
386   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
387     require(_spender != address(this));
388 
389     super.decreaseApproval(_spender, _subtractedValue);
390 
391     require(_spender.call(_data));
392 
393     return true;
394   }
395 
396 }
397 
398 /**
399  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
400  *
401  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
402  */
403 
404 
405 
406 
407 /**
408  * @title Ownable
409  * @dev The Ownable contract has an owner address, and provides basic authorization control
410  * functions, this simplifies the implementation of "user permissions".
411  */
412 contract Ownable {
413   address public owner;
414 
415 
416   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
417 
418 
419   /**
420    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
421    * account.
422    */
423   function Ownable() public {
424     owner = msg.sender;
425   }
426 
427   /**
428    * @dev Throws if called by any account other than the owner.
429    */
430   modifier onlyOwner() {
431     require(msg.sender == owner);
432     _;
433   }
434 
435   /**
436    * @dev Allows the current owner to transfer control of the contract to a newOwner.
437    * @param newOwner The address to transfer ownership to.
438    */
439   function transferOwnership(address newOwner) public onlyOwner {
440     require(newOwner != address(0));
441     OwnershipTransferred(owner, newOwner);
442     owner = newOwner;
443   }
444 
445 }
446 
447 
448 
449 contract Recoverable is Ownable {
450 
451   /// @dev Empty constructor (for now)
452   function Recoverable() {
453   }
454 
455   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
456   /// @param token Token which will we rescue to the owner from the contract
457   function recoverTokens(ERC20Basic token) onlyOwner public {
458     token.transfer(owner, tokensToBeReturned(token));
459   }
460 
461   /// @dev Interface function, can be overwritten by the superclass
462   /// @param token Token which balance we will check and return
463   /// @return The amount of tokens (in smallest denominator) the contract owns
464   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
465     return token.balanceOf(this);
466   }
467 }
468 
469 
470 
471 /**
472  * Standard EIP-20 token with an interface marker.
473  *
474  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
475  *
476  */
477 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
478 
479   /* Interface declaration */
480   function isToken() public constant returns (bool weAre) {
481     return true;
482   }
483 }
484 
485 
486 contract BurnableToken is StandardTokenExt {
487 
488   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
489   address public constant BURN_ADDRESS = 0;
490 
491   /** How many tokens we burned */
492   event Burned(address burner, uint burnedAmount);
493 
494   /**
495    * Burn extra tokens from a balance.
496    *
497    */
498   function burn(uint burnAmount) {
499     address burner = msg.sender;
500     balances[burner] = balances[burner].sub(burnAmount);
501     totalSupply_ = totalSupply_.sub(burnAmount);
502     Burned(burner, burnAmount);
503 
504     // Inform the blockchain explores that track the
505     // balances only by a transfer event that the balance in this
506     // address has decreased
507     Transfer(burner, BURN_ADDRESS, burnAmount);
508   }
509 }
510 
511 /**
512  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
513  *
514  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
515  */
516 
517 
518 /**
519  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
520  *
521  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
522  */
523 
524 
525 
526 
527 /**
528  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
529  *
530  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
531  */
532 
533 
534 /**
535  * Upgrade agent interface inspired by Lunyr.
536  *
537  * Upgrade agent transfers tokens to a new contract.
538  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
539  */
540 contract UpgradeAgent {
541 
542   uint public originalSupply;
543 
544   /** Interface marker */
545   function isUpgradeAgent() public constant returns (bool) {
546     return true;
547   }
548 
549   function upgradeFrom(address _from, uint256 _value) public;
550 
551 }
552 
553 
554 /**
555  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
556  *
557  * First envisioned by Golem and Lunyr projects.
558  */
559 contract UpgradeableToken is StandardTokenExt {
560 
561   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
562   address public upgradeMaster;
563 
564   /** The next contract where the tokens will be migrated. */
565   UpgradeAgent public upgradeAgent;
566 
567   /** How many tokens we have upgraded by now. */
568   uint256 public totalUpgraded;
569 
570   /**
571    * Upgrade states.
572    *
573    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
574    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
575    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
576    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
577    *
578    */
579   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
580 
581   /**
582    * Somebody has upgraded some of his tokens.
583    */
584   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
585 
586   /**
587    * New upgrade agent available.
588    */
589   event UpgradeAgentSet(address agent);
590 
591   /**
592    * Do not allow construction without upgrade master set.
593    */
594   function UpgradeableToken(address _upgradeMaster) {
595     upgradeMaster = _upgradeMaster;
596   }
597 
598   /**
599    * Allow the token holder to upgrade some of their tokens to a new contract.
600    */
601   function upgrade(uint256 value) public {
602 
603       UpgradeState state = getUpgradeState();
604       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
605         // Called in a bad state
606         throw;
607       }
608 
609       // Validate input value.
610       if (value == 0) throw;
611 
612       balances[msg.sender] = balances[msg.sender].sub(value);
613 
614       // Take tokens out from circulation
615       totalSupply_ = totalSupply_.sub(value);
616       totalUpgraded = totalUpgraded.add(value);
617 
618       // Upgrade agent reissues the tokens
619       upgradeAgent.upgradeFrom(msg.sender, value);
620       Upgrade(msg.sender, upgradeAgent, value);
621   }
622 
623   /**
624    * Set an upgrade agent that handles
625    */
626   function setUpgradeAgent(address agent) external {
627 
628       if(!canUpgrade()) {
629         // The token is not yet in a state that we could think upgrading
630         throw;
631       }
632 
633       if (agent == 0x0) throw;
634       // Only a master can designate the next agent
635       if (msg.sender != upgradeMaster) throw;
636       // Upgrade has already begun for an agent
637       if (getUpgradeState() == UpgradeState.Upgrading) throw;
638 
639       upgradeAgent = UpgradeAgent(agent);
640 
641       // Bad interface
642       if(!upgradeAgent.isUpgradeAgent()) throw;
643       // Make sure that token supplies match in source and target
644       if (upgradeAgent.originalSupply() != totalSupply_) throw;
645 
646       UpgradeAgentSet(upgradeAgent);
647   }
648 
649   /**
650    * Get the state of the token upgrade.
651    */
652   function getUpgradeState() public constant returns(UpgradeState) {
653     if(!canUpgrade()) return UpgradeState.NotAllowed;
654     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
655     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
656     else return UpgradeState.Upgrading;
657   }
658 
659   /**
660    * Change the upgrade master.
661    *
662    * This allows us to set a new owner for the upgrade mechanism.
663    */
664   function setUpgradeMaster(address master) public {
665       if (master == 0x0) throw;
666       if (msg.sender != upgradeMaster) throw;
667       upgradeMaster = master;
668   }
669 
670   /**
671    * Child contract can enable to provide the condition when the upgrade can begun.
672    */
673   function canUpgrade() public constant returns(bool) {
674      return true;
675   }
676 
677 }
678 
679 /**
680  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
681  *
682  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
683  */
684 
685 
686 
687 
688 
689 /**
690  * Define interface for releasing the token transfer after a successful crowdsale.
691  */
692 contract ReleasableToken is StandardTokenExt {
693 
694   /* The finalizer contract that allows unlift the transfer limits on this token */
695   address public releaseAgent;
696 
697   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
698   bool public released = false;
699 
700   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
701   mapping (address => bool) public transferAgents;
702 
703   /**
704    * Limit token transfer until the crowdsale is over.
705    *
706    */
707   modifier canTransfer(address _sender) {
708 
709     if(!released) {
710         if(!transferAgents[_sender]) {
711             throw;
712         }
713     }
714 
715     _;
716   }
717 
718   /**
719    * Set the contract that can call release and make the token transferable.
720    *
721    * Design choice. Allow reset the release agent to fix fat finger mistakes.
722    */
723   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
724 
725     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
726     releaseAgent = addr;
727   }
728 
729   /**
730    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
731    */
732   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
733     transferAgents[addr] = state;
734   }
735 
736   /**
737    * One way function to release the tokens to the wild.
738    *
739    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
740    */
741   function releaseTokenTransfer() public onlyReleaseAgent {
742     released = true;
743   }
744 
745   /** The function can be called only before or after the tokens have been releasesd */
746   modifier inReleaseState(bool releaseState) {
747     if(releaseState != released) {
748         throw;
749     }
750     _;
751   }
752 
753   /** The function can be called only by a whitelisted release agent. */
754   modifier onlyReleaseAgent() {
755     if(msg.sender != releaseAgent) {
756         throw;
757     }
758     _;
759   }
760 
761   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
762     // Call StandardToken.transfer()
763    return super.transfer(_to, _value);
764   }
765 
766   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
767     // Call StandardToken.transferForm()
768     return super.transferFrom(_from, _to, _value);
769   }
770 
771 }
772 
773 /**
774  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
775  *
776  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
777  */
778 
779 
780 
781 /**
782  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
783  *
784  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
785  */
786 
787 
788 /**
789  * Safe unsigned safe math.
790  *
791  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
792  *
793  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
794  *
795  * Maintained here until merged to mainline zeppelin-solidity.
796  *
797  */
798 library SafeMathLib {
799 
800   function times(uint a, uint b) returns (uint) {
801     uint c = a * b;
802     assert(a == 0 || c / a == b);
803     return c;
804   }
805 
806   function minus(uint a, uint b) returns (uint) {
807     assert(b <= a);
808     return a - b;
809   }
810 
811   function plus(uint a, uint b) returns (uint) {
812     uint c = a + b;
813     assert(c>=a);
814     return c;
815   }
816 
817 }
818 
819 
820 
821 /**
822  * A token that can increase its supply by another contract.
823  *
824  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
825  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
826  *
827  */
828 contract MintableToken is StandardTokenExt {
829 
830   using SafeMathLib for uint;
831 
832   bool public mintingFinished = false;
833 
834   /** List of agents that are allowed to create new tokens */
835   mapping (address => bool) public mintAgents;
836 
837   event MintingAgentChanged(address addr, bool state);
838   event Minted(address receiver, uint amount);
839 
840   /**
841    * Create new tokens and allocate them to an address..
842    *
843    * Only callably by a crowdsale contract (mint agent).
844    */
845   function mint(address receiver, uint amount) onlyMintAgent canMint public {
846     totalSupply_ = totalSupply_.plus(amount);
847     balances[receiver] = balances[receiver].plus(amount);
848 
849     // This will make the mint transaction apper in EtherScan.io
850     // We can remove this after there is a standardized minting event
851     Transfer(0, receiver, amount);
852   }
853 
854   /**
855    * Owner can allow a crowdsale contract to mint new tokens.
856    */
857   function setMintAgent(address addr, bool state) onlyOwner canMint public {
858     mintAgents[addr] = state;
859     MintingAgentChanged(addr, state);
860   }
861 
862   modifier onlyMintAgent() {
863     // Only crowdsale contracts are allowed to mint new tokens
864     if(!mintAgents[msg.sender]) {
865         throw;
866     }
867     _;
868   }
869 
870   /** Make sure we are not done yet. */
871   modifier canMint() {
872     if(mintingFinished) throw;
873     _;
874   }
875 }
876 
877 
878 
879 /**
880  * A crowdsaled token.
881  *
882  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
883  *
884  * - The token transfer() is disabled until the crowdsale is over
885  * - The token contract gives an opt-in upgrade path to a new contract
886  * - The same token can be part of several crowdsales through approve() mechanism
887  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
888  *
889  */
890 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
891 
892   /** Name and symbol were updated. */
893   event UpdatedTokenInformation(string newName, string newSymbol);
894 
895   string public name;
896 
897   string public symbol;
898 
899   uint public decimals;
900 
901   /**
902    * Construct the token.
903    *
904    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
905    *
906    * @param _name Token name
907    * @param _symbol Token symbol - should be all caps
908    * @param _initialSupply How many tokens we start with
909    * @param _decimals Number of decimal places
910    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
911    */
912   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
913     UpgradeableToken(msg.sender) {
914 
915     // Create any address, can be transferred
916     // to team multisig via changeOwner(),
917     // also remember to call setUpgradeMaster()
918     owner = msg.sender;
919 
920     name = _name;
921     symbol = _symbol;
922 
923     totalSupply_ = _initialSupply;
924 
925     decimals = _decimals;
926 
927     // Create initially all balance on the team multisig
928     balances[owner] = totalSupply_;
929 
930     if(totalSupply_ > 0) {
931       Minted(owner, totalSupply_);
932     }
933 
934     // No more new supply allowed after the token creation
935     if(!_mintable) {
936       mintingFinished = true;
937       if(totalSupply_ == 0) {
938         throw; // Cannot create a token without supply and no minting
939       }
940     }
941   }
942 
943   /**
944    * When token is released to be transferable, enforce no new tokens can be created.
945    */
946   function releaseTokenTransfer() public onlyReleaseAgent {
947     mintingFinished = true;
948     super.releaseTokenTransfer();
949   }
950 
951   /**
952    * Allow upgrade agent functionality kick in only if the crowdsale was success.
953    */
954   function canUpgrade() public constant returns(bool) {
955     return released && super.canUpgrade();
956   }
957 
958   /**
959    * Owner can update token information here.
960    *
961    * It is often useful to conceal the actual token association, until
962    * the token operations, like central issuance or reissuance have been completed.
963    *
964    * This function allows the token owner to rename the token after the operations
965    * have been completed and then point the audience to use the token contract.
966    */
967   function setTokenInformation(string _name, string _symbol) onlyOwner {
968     name = _name;
969     symbol = _symbol;
970 
971     UpdatedTokenInformation(name, symbol);
972   }
973 
974 }
975 
976 
977 /**
978  * A crowdsaled token that you can also burn.
979  *
980  */
981 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
982 
983   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
984     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
985 
986   }
987 }
988 
989 
990 
991 /**
992  * The AML Token
993  *
994  * This subset of BurnableCrowdsaleToken gives the Owner a possibility to
995  * reclaim tokens from a participant before the token is released
996  * after a participant has failed a prolonged AML process.
997  *
998  * It is assumed that the anti-money laundering process depends on blockchain data.
999  * The data is not available before the transaction and not for the smart contract.
1000  * Thus, we need to implement logic to handle AML failure cases post payment.
1001  * We give a time window before the token release for the token sale owners to
1002  * complete the AML and claw back all token transactions that were
1003  * caused by rejected purchases.
1004  */
1005 contract AMLToken is BurnableCrowdsaleToken {
1006 
1007   // An event when the owner has reclaimed non-released tokens
1008   event OwnerReclaim(address fromWhom, uint amount);
1009 
1010   function AMLToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) BurnableCrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
1011 
1012   }
1013 
1014   /// @dev Here the owner can reclaim the tokens from a participant if
1015   ///      the token is not released yet. Refund will be handled offband.
1016   /// @param fromWhom address of the participant whose tokens we want to claim
1017   function transferToOwner(address fromWhom) onlyOwner {
1018     if (released) revert();
1019 
1020     uint amount = balanceOf(fromWhom);
1021     balances[fromWhom] = balances[fromWhom].sub(amount);
1022     balances[owner] = balances[owner].add(amount);
1023     Transfer(fromWhom, owner, amount);
1024     OwnerReclaim(fromWhom, amount);
1025   }
1026 }