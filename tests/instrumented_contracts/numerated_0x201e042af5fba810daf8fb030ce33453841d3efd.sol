1 /**
2  * SETH Token
3  */
4 pragma solidity ^0.4.23;
5 
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint);
54   function balanceOf(address who) public view returns (uint);
55   function transfer(address to, uint value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint value);
57 }
58 
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public constant returns (uint);
66   function transferFrom(address from, address to, uint value) public returns (bool);
67   function approve(address spender, uint value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint value);
69 }
70 
71 
72 
73 /**
74  * Upgrade agent interface inspired by Lunyr.
75  *
76  * Upgrade agent transfers tokens to a new contract.
77  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
78  */
79 contract UpgradeAgent {
80 
81   uint public originalSupply;
82 
83   /** Interface marker */
84   function isUpgradeAgent() public pure returns (bool) {
85     return true;
86   }
87 
88   function upgradeFrom(address _from, uint256 _value) public;
89 
90 }
91 
92 
93 /**
94  * Define interface for releasing the token transfer after a successful crowdsale.
95  */
96 contract ReleasableToken is ERC20, Ownable {
97 
98   /* The finalizer contract that allows unlift the transfer limits on this token */
99   address public releaseAgent;
100 
101   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
102   bool public released = false;
103 
104   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
105   mapping (address => bool) public transferAgents;
106 
107   /**
108    * Limit token transfer until the crowdsale is over.
109    *
110    */
111   modifier canTransfer(address _sender) {
112 
113     if(!released) {
114         if(!transferAgents[_sender]) {
115             revert();
116         }
117     }
118 
119     _;
120   }
121 
122   /**
123    * Set the contract that can call release and make the token transferable.
124    *
125    * Design choice. Allow reset the release agent to fix fat finger mistakes.
126    */
127   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
128 
129     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
130     releaseAgent = addr;
131   }
132 
133   /**
134    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
135    */
136   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
137     transferAgents[addr] = state;
138   }
139 
140   /**
141    * Release the tokens to the wild.
142    *
143    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
144    */
145   function releaseTokenTransfer() public onlyReleaseAgent {
146     released = true;
147   }
148 
149   /**
150    * Unrelease the tokens to the wild.
151    *
152    */
153   function unReleaseTokenTransfer() public onlyReleaseAgent {
154     released = false;
155   }
156 
157   /** The function can be called only before or after the tokens have been releasesd */
158   modifier inReleaseState(bool releaseState) {
159     if(releaseState != released) {
160         revert();
161     }
162     _;
163   }
164 
165   /** The function can be called only by a whitelisted release agent. */
166   modifier onlyReleaseAgent() {
167     if(msg.sender != releaseAgent) {
168         revert();
169     }
170     _;
171   }
172 
173   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
174     // Call StandardToken.transfer()
175    return super.transfer(_to, _value);
176   }
177 
178   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
179     // Call StandardToken.transferForm()
180     return super.transferFrom(_from, _to, _value);
181   }
182 
183 }
184 
185 
186 
187 /**
188  * @title Pausable
189  * @dev Base contract which allows children to implement an emergency stop mechanism.
190  */
191 contract Pausable is Ownable {
192   event Pause();
193   event Unpause();
194 
195   bool public paused = false;
196 
197 
198   /**
199    * @dev Modifier to make a function callable only when the contract is not paused.
200    */
201   modifier whenNotPaused() {
202     require(!paused);
203     _;
204   }
205 
206   /**
207    * @dev Modifier to make a function callable only when the contract is paused.
208    */
209   modifier whenPaused() {
210     require(paused);
211     _;
212   }
213 
214   /**
215    * @dev called by the owner to pause, triggers stopped state
216    */
217   function pause() onlyOwner whenNotPaused public {
218     paused = true;
219     emit Pause();
220   }
221 
222   /**
223    * @dev called by the owner to unpause, returns to normal state
224    */
225   function unpause() onlyOwner whenPaused public {
226     paused = false;
227     emit Unpause();
228   }
229 }
230 
231 
232 /**
233  * @title Basic token
234  * @dev Basic version of StandardToken, with no allowances.
235  */
236 contract BasicToken is ERC20Basic {
237   using SafeMath for uint;
238 
239   mapping(address => uint) balances;
240 
241   uint totalSupply_;
242 
243   /**
244   * @dev total number of tokens in existence
245   */
246   function totalSupply() public view returns (uint) {
247     return totalSupply_;
248   }
249 
250   /**
251   * @dev transfer token for a specified address
252   * @param _to The address to transfer to.
253   * @param _value The amount to be transferred.
254   */
255   function transfer(address _to, uint _value) public returns (bool) {
256     require(_to != address(0));
257     require(_value <= balances[msg.sender]);
258 
259     // SafeMath.sub will throw if there is not enough balance.
260     balances[msg.sender] = balances[msg.sender].sub(_value);
261     balances[_to] = balances[_to].add(_value);
262     emit Transfer(msg.sender, _to, _value);
263     return true;
264   }
265 
266   /**
267   * @dev Gets the balance of the specified address.
268   * @param _owner The address to query the the balance of.
269   * @return An uint representing the amount owned by the passed address.
270   */
271   function balanceOf(address _owner) public view returns (uint balance) {
272     return balances[_owner];
273   }
274 
275 }
276 
277 /**
278  * @title Freezable Token
279  * @dev Token that can be freezed.
280  */
281 
282 contract FreezableToken is BasicToken, Ownable {
283 
284   using SafeMath for uint;
285   uint public unfreezeProcessTime = 3 days;
286   uint public freezeTotal;
287   uint public curId;
288   uint public minFreeze = 100000000;
289 
290   mapping (address => uint) public freezes;
291   mapping (address => uint) public unfreezes;
292   mapping (address => uint) public lastUnfreezeTime;
293   mapping (uint => address) public freezerAddress;
294   mapping (address => uint) public freezerIds;
295   /* This notifies clients about the amount frozen */
296   event Freeze(address indexed from, uint value);
297 
298   /* This notifies clients about the amount unfrozen */
299   event Unfreeze(address indexed from, uint value);
300   event WithdrawUnfreeze(address indexed sender, uint unfreezeAmount);
301   event SettleUnfreeze(address indexed freezer, uint value);
302 
303   function freezeOf(address _tokenOwner) public view returns (uint balance) {
304     return freezes[_tokenOwner];
305   }
306 
307   function unfreezeOf(address _tokenOwner) public view returns (uint balance) {
308     return unfreezes[_tokenOwner];
309   }
310 
311   function freeze(uint _value) public returns (bool success) {
312     if (freezerIds[msg.sender] == 0) {
313       curId = curId.add(1);
314       freezerIds[msg.sender] = curId;
315       freezerAddress[curId] = msg.sender;
316     }
317 
318     require(_value <= balances[msg.sender]);
319     //0 not allowed
320     require (_value >= minFreeze);
321     address sender = msg.sender;
322     balances[sender] = balances[sender].sub(_value);
323     freezeTotal = freezeTotal.add(_value);
324     freezes[sender] = freezes[sender].add(_value);
325     emit Freeze(sender, _value);
326     return true;
327   }
328 
329   function unfreeze(uint _value) public returns (bool success) {
330     require(_value <= freezes[msg.sender]);
331     //0 not allowed
332     require (_value > 0);
333     address sender = msg.sender;
334     freezes[sender] = freezes[sender].sub(_value);
335     lastUnfreezeTime[sender] = block.timestamp;
336     freezeTotal = freezeTotal.sub(_value);
337     unfreezes[sender] = unfreezes[sender].add(_value);
338     emit Unfreeze(sender, _value);
339     return true;
340   }
341 
342   function withdrawUnfreeze() public returns (bool success) {
343     address sender = msg.sender;
344     uint unfreezeAmount = unfreezes[sender];
345     uint unfreezeTime = lastUnfreezeTime[sender].add(unfreezeProcessTime);
346     require(unfreezeAmount > 0);
347     require(block.timestamp > unfreezeTime);
348 
349     unfreezes[sender] = 0;
350     balances[sender] = balances[sender].add(unfreezeAmount);
351     emit WithdrawUnfreeze(sender, unfreezeAmount);
352     return true;
353   }
354 
355   function ownerSettleUnfreeze(address _freezer) onlyOwner public returns (bool success) {
356     uint unfreezeAmount = unfreezes[_freezer];
357     uint unfreezeTime = lastUnfreezeTime[_freezer].add(unfreezeProcessTime);
358     require(unfreezeAmount > 0);
359     require(block.timestamp > unfreezeTime);
360 
361     unfreezes[_freezer] = 0;
362     balances[_freezer] = balances[_freezer].add(unfreezeAmount);
363     emit SettleUnfreeze(_freezer, unfreezeAmount);
364     return true;
365   }
366 
367   function ownerSetProcessTime(uint _newTime) onlyOwner public returns (bool success) {
368     unfreezeProcessTime = _newTime;
369     return true;
370   }
371 
372   function ownerSetMinFreeze(uint _newMinFreeze) public returns (bool success) {
373     minFreeze = _newMinFreeze;
374     return true;
375   }
376 }
377 
378 /**
379  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
380  *
381  * Based on code by FirstBlood:
382  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
383  */
384 contract StandardToken is BasicToken, ERC20 {
385   using SafeMath for uint;
386 
387   /* approve() allowances */
388   mapping (address => mapping (address => uint)) allowed;
389 
390   /* Interface declaration */
391   function isToken() public pure returns (bool weAre) {
392     return true;
393   }
394 
395   /**
396    * @dev Transfer tokens from one address to another
397    * @param _from address The address which you want to send tokens from
398    * @param _to address The address which you want to transfer to
399    * @param _value uint the amount of tokens to be transferred
400    */
401   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
402     require(_to != address(0));
403     require(_value <= balances[_from]);
404     require(_value <= allowed[_from][msg.sender]);
405 
406     uint _allowance = allowed[_from][msg.sender];
407 
408     balances[_to] = balances[_to].add(_value);
409     balances[_from] = balances[_from].sub(_value);
410     allowed[_from][msg.sender] = _allowance.sub(_value);
411     emit Transfer(_from, _to, _value);
412     return true;
413   }
414 
415   /**
416    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
417    *
418    * Beware that changing an allowance with this method brings the risk that someone may use both the old
419    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
420    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
421    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
422    * @param _spender The address which will spend the funds.
423    * @param _value The amount of tokens to be spent.
424    */
425   function approve(address _spender, uint _value) public returns (bool success) {
426 
427     // To change the approve amount you first have to reduce the addresses`
428     //  allowance to zero by calling `approve(_spender, 0)` if it is not
429     //  already 0 to mitigate the race condition described here:
430     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
431     if ((_value != 0) && (allowed[msg.sender][_spender] != 0))
432       revert();
433 
434     allowed[msg.sender][_spender] = _value;
435     emit Approval(msg.sender, _spender, _value);
436     return true;
437   }
438 
439    /**
440    * @dev Function to check the amount of tokens that an owner allowed to a spender.
441    * @param _owner address The address which owns the funds.
442    * @param _spender address The address which will spend the funds.
443    * @return A uint specifying the amount of tokens still available for the spender.
444    */
445   function allowance(address _owner, address _spender) public view returns (uint remaining) {
446     return allowed[_owner][_spender];
447   }
448 
449   /**
450    * @dev Increase the amount of tokens that an owner allowed to a spender.
451    *
452    * approve should be called when allowed[_spender] == 0. To increment
453    * allowed value is better to use this function to avoid 2 calls (and wait until
454    * the first transaction is mined)
455    * From MonolithDAO Token.sol
456    * @param _spender The address which will spend the funds.
457    * @param _addedValue The amount of tokens to increase the allowance by.
458    */
459   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
460     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
461     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
462     return true;
463   }
464 
465   /**
466    * @dev Decrease the amount of tokens that an owner allowed to a spender.
467    *
468    * approve should be called when allowed[_spender] == 0. To decrement
469    * allowed value is better to use this function to avoid 2 calls (and wait until
470    * the first transaction is mined)
471    * From MonolithDAO Token.sol
472    * @param _spender The address which will spend the funds.
473    * @param _subtractedValue The amount of tokens to decrease the allowance by.
474    */
475   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
476     uint oldValue = allowed[msg.sender][_spender];
477     if (_subtractedValue > oldValue) {
478       allowed[msg.sender][_spender] = 0;
479     } else {
480       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
481     }
482     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
483     return true;
484   }
485 
486 }
487 
488 /**
489  * Pausable token
490  *
491  * Simple ERC20 Token example, with pausable token creation
492  **/
493 
494 contract PausableToken is StandardToken, Pausable {
495 
496   function transfer(address _to, uint _value) whenNotPaused public returns (bool) {
497     return super.transfer(_to, _value);
498   }
499 
500   function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {
501     return super.transferFrom(_from, _to, _value);
502   }
503 }
504 
505 /**
506  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
507  *
508  * First envisioned by Golem and Lunyr projects.
509  */
510 contract UpgradeableToken is StandardToken {
511   using SafeMath for uint;
512   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
513   address public upgradeMaster;
514 
515   /** The next contract where the tokens will be migrated. */
516   UpgradeAgent public upgradeAgent;
517 
518   /** How many tokens we have upgraded by now. */
519   uint public totalUpgraded;
520 
521   /**
522    * Upgrade states.
523    *
524    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
525    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
526    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
527    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
528    *
529    */
530   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
531 
532   /**
533    * Somebody has upgraded some of his tokens.
534    */
535   event Upgrade(address indexed _from, address indexed _to, uint _value);
536 
537   /**
538    * New upgrade agent available.
539    */
540   event UpgradeAgentSet(address agent);
541 
542   /**
543    * Do not allow construction without upgrade master set.
544    */
545   constructor(address _upgradeMaster) public {
546     upgradeMaster = _upgradeMaster;
547   }
548   /**
549    * Allow the token holder to upgrade some of their tokens to a new contract.
550    */
551   function upgrade(uint value) public {
552 
553       UpgradeState state = getUpgradeState();
554       if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
555         // Called in a bad state
556         revert();
557       }
558 
559       // Validate input value.
560       if (value == 0) revert();
561 
562       balances[msg.sender] = balances[msg.sender].sub(value);
563 
564       // Take tokens out from circulation
565       totalSupply_ = totalSupply_.sub(value);
566       totalUpgraded = totalUpgraded.add(value);
567 
568       // Upgrade agent reissues the tokens
569       upgradeAgent.upgradeFrom(msg.sender, value);
570       emit Upgrade(msg.sender, upgradeAgent, value);
571   }
572 
573   /**
574    * Set an upgrade agent that handles
575    */
576   function setUpgradeAgent(address agent) external {
577 
578       if(!canUpgrade()) {
579         // The token is not yet in a state that we could think upgrading
580         revert();
581       }
582 
583       if (agent == 0x0) revert();
584       // Only a master can designate the next agent
585       if (msg.sender != upgradeMaster) revert();
586       // Upgrade has already begun for an agent
587       if (getUpgradeState() == UpgradeState.Upgrading) revert();
588 
589       upgradeAgent = UpgradeAgent(agent);
590 
591       // Bad interface
592       if(!upgradeAgent.isUpgradeAgent()) revert();
593       // Make sure that token supplies match in source and target
594       if (upgradeAgent.originalSupply() != totalSupply_) revert();
595 
596       emit UpgradeAgentSet(upgradeAgent);
597   }
598 
599   /**
600    * Get the state of the token upgrade.
601    */
602   function getUpgradeState() public constant returns(UpgradeState) {
603     if(!canUpgrade()) return UpgradeState.NotAllowed;
604     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
605     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
606     else return UpgradeState.Upgrading;
607   }
608 
609   /**
610    * Change the upgrade master.
611    *
612    * This allows us to set a new owner for the upgrade mechanism.
613    */
614   function setUpgradeMaster(address master) public {
615       if (master == 0x0) revert();
616       if (msg.sender != upgradeMaster) revert();
617       upgradeMaster = master;
618   }
619 
620   /**
621    * Child contract can enable to provide the condition when the upgrade can begun.
622    */
623   function canUpgrade() public pure returns(bool) {
624      return true;
625   }
626 
627 }
628 
629 
630 /**
631  * @title Burnable Token
632  * @dev Token that can be irreversibly burned (destroyed).
633  */
634 contract BurnableToken is BasicToken {
635 
636   event Burn(address indexed burner, uint value);
637 
638   /**
639    * @dev Burns a specific amount of tokens.
640    * @param _value The amount of token to be burned.
641    */
642   function burn(uint _value) public {
643     require(_value <= balances[msg.sender]);
644     // no need to require value <= totalSupply, since that would imply the
645     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
646 
647     address burner = msg.sender;
648     balances[burner] = balances[burner].sub(_value);
649     totalSupply_ = totalSupply_.sub(_value);
650     emit Burn(burner, _value);
651     emit Transfer(burner, address(0), _value);
652   }
653 }
654 
655 /**
656  * Blacklist token
657  *
658  * Simple ERC20 Token example, with Blacklist token creation
659  **/
660 
661 contract BlacklistToken is BasicToken, ERC20, Ownable {
662 
663 	event DestroyedBlackFunds(address _blackListedUser, uint _balance);
664 	event AddedBlackList(address _user);
665 	event RemovedBlackList(address _user);
666 
667 	mapping (address => bool) public isBlackListed;
668 
669 	modifier whenNotBlacklisted(address _sender) {
670 		require(!isBlackListed[_sender]);
671 		_;
672 	}
673 
674 	function getBlackListStatus(address _maker) external constant returns (bool) {
675 	    return isBlackListed[_maker];
676 	}
677 
678 	function addBlackList (address _evilUser) public onlyOwner {
679 	    isBlackListed[_evilUser] = true;
680 	    emit AddedBlackList(_evilUser); //event emmiting
681 	}
682 
683 	function removeBlackList (address _clearedUser) public onlyOwner {
684 	    isBlackListed[_clearedUser] = false;
685 	    emit RemovedBlackList(_clearedUser);
686 	}
687 
688 	function destroyBlackFunds (address _blackListedUser) public onlyOwner {
689 	    require(isBlackListed[_blackListedUser]);
690 	    uint dirtyFunds = balanceOf(_blackListedUser);
691 	    balances[_blackListedUser] = 0;
692 	    totalSupply_ -= dirtyFunds;
693 	    emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
694 	}
695 
696 	function transfer(address _to, uint _value) whenNotBlacklisted(msg.sender) public returns (bool) {
697 		return super.transfer(_to, _value);
698 	}
699 
700 	function transferFrom(address _from, address _to, uint _value) whenNotBlacklisted(msg.sender) public returns (bool) {
701 		return super.transferFrom(_from, _to, _value);
702 	}
703 }
704 
705 /**
706  * @title Approvable Token
707  * @dev Token that can be approve and call.
708  */
709 interface tokenRecipient {
710     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
711 }
712 
713 contract ApprovableToken is StandardToken, Ownable {
714 
715   using SafeMath for uint;
716       /**
717      * Set allowance for other address and notify
718      *
719      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
720      *
721      * @param _spender The address authorized to spend
722      * @param _value the max amount they can spend
723      * @param _extraData some extra information to send to the approved contract
724      */
725   function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
726       public
727       returns (bool success) {
728       tokenRecipient spender = tokenRecipient(_spender);
729       if (approve(_spender, _value)) {
730           spender.receiveApproval(msg.sender, _value, address(this), _extraData);
731           return true;
732       }
733   }
734 }
735 
736 
737 /**
738  *
739  * Token supply is created in the token contract creation and allocated to owner.
740  * The owner can then transfer from its supply to crowdsale participants.
741  *
742  */
743 contract SETH is UpgradeableToken, ReleasableToken, PausableToken, BurnableToken, FreezableToken, ApprovableToken, BlacklistToken {
744 
745   string public name;
746   string public symbol;
747   uint8 public decimals;
748 
749   constructor(address _owner)  UpgradeableToken(_owner) public {
750     name = "SUPER ETH";
751     symbol = "SETH";
752     totalSupply_ = 21000000000000;
753     decimals = 6;
754 
755     // Allocate initial balance to the owner
756     balances[_owner] = totalSupply_;
757   }
758 }
759 
760 
761 /**
762  * @title SafeMath
763  * @dev Math operations with safety checks that throw on error
764  */
765 library SafeMath {
766 
767   /**
768   * @dev Multiplies two numbers, throws on overflow.
769   */
770   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
771     if (a == 0) {
772       return 0;
773     }
774     uint256 c = a * b;
775     assert(c / a == b);
776     return c;
777   }
778 
779   /**
780   * @dev Integer division of two numbers, truncating the quotient.
781   */
782   function div(uint256 a, uint256 b) internal pure returns (uint256) {
783     // assert(b > 0); // Solidity automatically throws when dividing by 0
784     uint256 c = a / b;
785     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
786     return c;
787   }
788 
789   /**
790   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
791   */
792   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
793     assert(b <= a);
794     return a - b;
795   }
796 
797   /**
798   * @dev Adds two numbers, throws on overflow.
799   */
800   function add(uint256 a, uint256 b) internal pure returns (uint256) {
801     uint256 c = a + b;
802     assert(c >= a);
803     return c;
804   }
805 }