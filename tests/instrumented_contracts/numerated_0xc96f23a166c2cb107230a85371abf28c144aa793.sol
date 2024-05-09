1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
68 
69 /**
70  * @title Destructible
71  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
72  */
73 contract Destructible is Ownable {
74 
75   constructor() public payable { }
76 
77   /**
78    * @dev Transfers the current balance to the owner and terminates the contract.
79    */
80   function destroy() onlyOwner public {
81     selfdestruct(owner);
82   }
83 
84   function destroyAndSend(address _recipient) onlyOwner public {
85     selfdestruct(_recipient);
86   }
87 }
88 
89 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * See https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 // File: zeppelin-solidity/contracts/math/SafeMath.sol
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110 
111   /**
112   * @dev Multiplies two numbers, throws on overflow.
113   */
114   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
115     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
116     // benefit is lost if 'b' is also tested.
117     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118     if (a == 0) {
119       return 0;
120     }
121 
122     c = a * b;
123     assert(c / a == b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     // uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return a / b;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     assert(b <= a);
142     return a - b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166   uint256 totalSupply_;
167 
168   /**
169   * @dev Total number of tokens in existence
170   */
171   function totalSupply() public view returns (uint256) {
172     return totalSupply_;
173   }
174 
175   /**
176   * @dev Transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[msg.sender]);
183 
184     balances[msg.sender] = balances[msg.sender].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     emit Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
202 
203 /**
204  * @title Burnable Token
205  * @dev Token that can be irreversibly burned (destroyed).
206  */
207 contract BurnableToken is BasicToken {
208 
209   event Burn(address indexed burner, uint256 value);
210 
211   /**
212    * @dev Burns a specific amount of tokens.
213    * @param _value The amount of token to be burned.
214    */
215   function burn(uint256 _value) public {
216     _burn(msg.sender, _value);
217   }
218 
219   function _burn(address _who, uint256 _value) internal {
220     require(_value <= balances[_who]);
221     // no need to require value <= totalSupply, since that would imply the
222     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
223 
224     balances[_who] = balances[_who].sub(_value);
225     totalSupply_ = totalSupply_.sub(_value);
226     emit Burn(_who, _value);
227     emit Transfer(_who, address(0), _value);
228   }
229 }
230 
231 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
232 
233 /**
234  * @title ERC20 interface
235  * @dev see https://github.com/ethereum/EIPs/issues/20
236  */
237 contract ERC20 is ERC20Basic {
238   function allowance(address owner, address spender)
239     public view returns (uint256);
240 
241   function transferFrom(address from, address to, uint256 value)
242     public returns (bool);
243 
244   function approve(address spender, uint256 value) public returns (bool);
245   event Approval(
246     address indexed owner,
247     address indexed spender,
248     uint256 value
249   );
250 }
251 
252 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
253 
254 /**
255  * @title Standard ERC20 token
256  *
257  * @dev Implementation of the basic standard token.
258  * https://github.com/ethereum/EIPs/issues/20
259  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
260  */
261 contract StandardToken is ERC20, BasicToken {
262 
263   mapping (address => mapping (address => uint256)) internal allowed;
264 
265 
266   /**
267    * @dev Transfer tokens from one address to another
268    * @param _from address The address which you want to send tokens from
269    * @param _to address The address which you want to transfer to
270    * @param _value uint256 the amount of tokens to be transferred
271    */
272   function transferFrom(
273     address _from,
274     address _to,
275     uint256 _value
276   )
277     public
278     returns (bool)
279   {
280     require(_to != address(0));
281     require(_value <= balances[_from]);
282     require(_value <= allowed[_from][msg.sender]);
283 
284     balances[_from] = balances[_from].sub(_value);
285     balances[_to] = balances[_to].add(_value);
286     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
287     emit Transfer(_from, _to, _value);
288     return true;
289   }
290 
291   /**
292    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
293    * Beware that changing an allowance with this method brings the risk that someone may use both the old
294    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297    * @param _spender The address which will spend the funds.
298    * @param _value The amount of tokens to be spent.
299    */
300   function approve(address _spender, uint256 _value) public returns (bool) {
301     allowed[msg.sender][_spender] = _value;
302     emit Approval(msg.sender, _spender, _value);
303     return true;
304   }
305 
306   /**
307    * @dev Function to check the amount of tokens that an owner allowed to a spender.
308    * @param _owner address The address which owns the funds.
309    * @param _spender address The address which will spend the funds.
310    * @return A uint256 specifying the amount of tokens still available for the spender.
311    */
312   function allowance(
313     address _owner,
314     address _spender
315    )
316     public
317     view
318     returns (uint256)
319   {
320     return allowed[_owner][_spender];
321   }
322 
323   /**
324    * @dev Increase the amount of tokens that an owner allowed to a spender.
325    * approve should be called when allowed[_spender] == 0. To increment
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _addedValue The amount of tokens to increase the allowance by.
331    */
332   function increaseApproval(
333     address _spender,
334     uint256 _addedValue
335   )
336     public
337     returns (bool)
338   {
339     allowed[msg.sender][_spender] = (
340       allowed[msg.sender][_spender].add(_addedValue));
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345   /**
346    * @dev Decrease the amount of tokens that an owner allowed to a spender.
347    * approve should be called when allowed[_spender] == 0. To decrement
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param _spender The address which will spend the funds.
352    * @param _subtractedValue The amount of tokens to decrease the allowance by.
353    */
354   function decreaseApproval(
355     address _spender,
356     uint256 _subtractedValue
357   )
358     public
359     returns (bool)
360   {
361     uint256 oldValue = allowed[msg.sender][_spender];
362     if (_subtractedValue > oldValue) {
363       allowed[msg.sender][_spender] = 0;
364     } else {
365       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
366     }
367     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
368     return true;
369   }
370 
371 }
372 
373 // File: contracts/token/ERC223/ERC223Basic.sol
374 
375 /**
376  * @title ERC223Basic extends ERC20 interface and supports ERC223
377  */
378 contract ERC223Basic is ERC20Basic {
379   function transfer(address _to, uint256 _value, bytes _data) public returns (bool);
380   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
381 }
382 
383 // File: contracts/token/ERC223/ERC223ReceivingContract.sol
384 
385 /**
386  * @title ERC223ReceivingContract contract that will work with ERC223 tokens.
387  */
388 contract ERC223ReceivingContract {
389   /**
390   * @dev Standard ERC223 function that will handle incoming token transfers.
391   *
392   * @param _from  Token sender address.
393   * @param _value Amount of tokens.
394   * @param _data  Transaction metadata.
395   */
396   function tokenFallback(address _from, uint256 _value, bytes _data) public returns (bool);
397 }
398 
399 // File: contracts/Adminable.sol
400 
401 /**
402  * @title Adminable
403  * @dev The Adminable contract has the simple protection logic, and provides admin based access control
404  */
405 contract Adminable is Ownable {
406 	address public admin;
407 	event AdminDesignated(address indexed previousAdmin, address indexed newAdmin);
408 
409   /**
410     * @dev Throws if called the non admin.
411     */
412 	modifier onlyAdmin() {
413 		require(msg.sender == admin);
414 		_;
415 	}
416 
417   /**
418     * @dev Throws if called the non owner and non admin.
419     */
420   modifier onlyOwnerOrAdmin() {
421 		require(msg.sender == owner || msg.sender == admin);
422 		_;
423 	}
424 
425   /**
426     * @dev Designate new admin for the address
427     * @param _address address The address you want to be a new admin
428     */
429 	function designateAdmin(address _address) public onlyOwner {
430 		require(_address != address(0) && _address != owner);
431 		emit AdminDesignated(admin, _address);
432 		admin = _address;
433 	}
434 }
435 
436 // File: contracts/Lockable.sol
437 
438 /**
439  * @title Lockable
440  * @dev The Lockable contract has an locks address map, and provides lockable control
441  * functions, this simplifies the implementation of "lock transfers".
442  *
443  * The contents of this Smart Contract and all associated code is owned and operated by Rubiix, a Gibraltar company in formation.
444  */
445 contract Lockable is Adminable, ERC20Basic {
446   using SafeMath for uint256;
447   // EPOCH TIMESTAMP OF "Tue Jul 02 2019 00:00:00 GMT+0000"
448   // @see https://www.unixtimestamp.com/index.php
449   uint public globalUnlockTime = 1562025600;
450   uint public constant decimals = 18;
451 
452   event UnLock(address indexed unlocked);
453   event Lock(address indexed locked, uint until, uint256 value, uint count);
454   event UpdateGlobalUnlockTime(uint256 epoch);
455 
456   struct LockMeta {
457     uint256 value;
458     uint until;
459   }
460 
461   mapping(address => LockMeta[]) internal locksMeta;
462   mapping(address => bool) locks;
463 
464   /**
465     * @dev Lock tokens for the address
466     * @param _address address The address you want to lock tokens
467     * @param _days uint The days count you want to lock untill from now
468     * @param _value uint256 the amount of tokens to be locked
469     */
470   function lock(address _address, uint _days, uint256 _value) onlyOwnerOrAdmin public {
471     _value = _value*(10**decimals);
472     require(_value > 0);
473     require(_days > 0);
474     require(_address != owner);
475     require(_address != admin);
476 
477     uint untilTime = block.timestamp + _days * 1 days;
478     locks[_address] = true;
479     // check if we have locks
480     locksMeta[_address].push(LockMeta(_value, untilTime));
481     // fire lock event
482     emit Lock(_address, untilTime, _value, locksMeta[_address].length);
483   }
484 
485   /**
486     * @dev Unlock tokens for the address
487     * @param _address address The address you want to unlock tokens
488     */
489   function unlock(address _address) onlyOwnerOrAdmin public {
490     locks[_address] = false;
491     delete locksMeta[_address];
492     emit UnLock(_address);
493   }
494 
495   /**
496     * @dev Gets the locked balance of the specified address and time
497     * @param _owner The address to query the locked balance of.
498     * @param _time The timestamp seconds to query the locked balance of.
499     * @return An uint256 representing the locked amount owned by the passed address.
500     */
501   function lockedBalanceOf(address _owner, uint _time) public view returns (uint256) {
502     LockMeta[] memory locked = locksMeta[_owner];
503     uint length = locked.length;
504     // if no locks or even not created (takes bdefault) return 0
505     if (length == 0) {
506       return 0;
507     }
508     // sum all available locks
509     uint256 _result = 0;
510     for (uint i = 0; i < length; i++) {
511       if (_time <= locked[i].until) {
512         _result = _result.add(locked[i].value);
513       }
514     }
515     return _result;
516   }
517 
518   /**
519     * @dev Gets the locked balance of the specified address of the current time
520     * @param _owner The address to query the locked balance of.
521     * @return An uint256 representing the locked amount owned by the passed address.
522     */
523   function lockedNowBalanceOf(address _owner) public view returns (uint256) {
524     return this.lockedBalanceOf(_owner, block.timestamp);
525   }
526 
527   /**
528     * @dev Gets the unlocked balance of the specified address and time
529     * @param _owner The address to query the unlocked balance of.
530     * @param _time The timestamp seconds to query the unlocked balance of.
531     * @return An uint256 representing the unlocked amount owned by the passed address.
532     */
533   function unlockedBalanceOf(address _owner, uint _time) public view returns (uint256) {
534     return this.balanceOf(_owner).sub(lockedBalanceOf(_owner, _time));
535   }
536 
537   /**
538     * @dev Gets the unlocked balance of the specified address of the current time
539     * @param _owner The address to query the unlocked balance of.
540     * @return An uint256 representing the unlocked amount owned by the passed address.
541     */
542   function unlockedNowBalanceOf(address _owner) public view returns (uint256) {
543     return this.unlockedBalanceOf(_owner, block.timestamp);
544   }
545 
546   function updateGlobalUnlockTime(uint256 _epoch) public onlyOwnerOrAdmin returns (bool) {
547     require(_epoch >= 0);
548     globalUnlockTime = _epoch;
549     emit UpdateGlobalUnlockTime(_epoch);
550     // Gives owner the ability to update lockup period for all wallets.
551     // Owner can pass an epoch timecode into the function to:
552     // 1. Extend lockup period,
553     // 2. Unlock all wallets by passing '0' into the function
554   }
555 
556   /**
557     * @dev Throws if the value less than the current unlocked balance of.
558     */
559   modifier onlyUnlocked(uint256 _value) {
560     if(block.timestamp > globalUnlockTime) {
561       _;
562     } else {
563       if (locks[msg.sender] == true) {
564         require(this.unlockedNowBalanceOf(msg.sender) >= _value);
565       }
566       _;
567     }
568   }
569 
570   /**
571     * @dev Throws if the value less than the current unlocked balance of the given address.
572     */
573   modifier onlyUnlockedOf(address _address, uint256 _value) {
574     if(block.timestamp > globalUnlockTime) {
575       _;
576     } else {
577       if (locks[_address] == true) {
578         require(this.unlockedNowBalanceOf(_address) >= _value);
579       } else {
580 
581       }
582       _;
583     }
584   }
585 }
586 
587 // File: contracts/StandardLockableToken.sol
588 
589 /**
590  * @title StandardLockableToken
591  *
592  * The contents of this Smart Contract and all associated code is owned and operated by Rubiix, a Gibraltar company in formation.
593  */
594 contract StandardLockableToken is Lockable, /**/ERC223Basic, /*ERC20*/StandardToken {
595 
596   /**
597     * @dev Check address is to be a contract based on extcodesize (must be nonzero to be a contract)
598     * @param _address The address to check.
599     */
600   function isContract(address _address) private constant returns (bool) {
601     uint256 codeLength;
602     assembly {
603       codeLength := extcodesize(_address)
604     }
605     return codeLength > 0;
606   }
607 
608   /**
609     * @dev Transfer token for a specified address
610     * ERC20 support
611     * @param _to The address to transfer to.
612     * @param _value The amount to be transferred.
613     */
614   function transfer(address _to, uint256 _value) onlyUnlocked(_value) public returns (bool) {
615     bytes memory empty;
616     return _transfer(_to, _value, empty);
617   }
618 
619   /**
620     * @dev Transfer token for a specified address
621     * ERC223 support
622     * @param _to The address to transfer to.
623     * @param _value The amount to be transferred.
624     * @param _data The additional data.
625     */
626   function transfer(address _to, uint256 _value, bytes _data) onlyUnlocked(_value) public returns (bool) {
627     return _transfer(_to, _value, _data);
628   }
629 
630   /**
631     * @dev Transfer token for a specified address
632     * ERC223 support
633     * @param _to The address to transfer to.
634     * @param _value The amount to be transferred.
635     * @param _data The additional data.
636     */
637   function _transfer(address _to, uint256 _value, bytes _data) internal returns (bool) {
638     require(_to != address(0));
639     require(_value <= balances[msg.sender]);
640     require(_value > 0);
641     // catch overflow loosing tokens
642     // require(balances[_to] + _value > balances[_to]);
643 
644     // safety update balances
645     balances[msg.sender] = balances[msg.sender].sub(_value);
646     balances[_to] = balances[_to].add(_value);
647 
648     // determine if the contract given
649     if (isContract(_to)) {
650       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
651       receiver.tokenFallback(msg.sender, _value, _data);
652     }
653 
654     // emit ERC20 transfer event
655     emit Transfer(msg.sender, _to, _value);
656     // emit ERC223 transfer event
657     emit Transfer(msg.sender, _to, _value, _data);
658     return true;
659   }
660 
661   /**
662     * @dev Transfer tokens from one address to another
663     * @param _from address The address which you want to send tokens from
664     * @param _to address The address which you want to transfer to
665     * @param _value uint256 the amount of tokens to be transferred
666     */
667   function transferFrom(address _from, address _to, uint256 _value) onlyUnlockedOf(_from, _value) public returns (bool) {
668     require(_to != address(0));
669     require(_value <= balances[_from]);
670     require(_value <= allowed[_from][msg.sender]);
671     require(_value > 0);
672 
673     // make balances manipulations first
674     balances[_from] = balances[_from].sub(_value);
675     balances[_to] = balances[_to].add(_value);
676     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
677 
678     bytes memory empty;
679     if (isContract(_to)) {
680       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
681       receiver.tokenFallback(msg.sender, _value, empty);
682     }
683 
684     // emit ERC20 transfer event
685     emit Transfer(_from, _to, _value);
686     // emit ERC223 transfer event
687     emit Transfer(_from, _to, _value, empty);
688     return true;
689   }
690 }
691 
692 // File: contracts/StandardBurnableLockableToken.sol
693 
694 /**
695  * @title StandardBurnableLockableToken
696  *
697  * The contents of this Smart Contract and all associated code is owned and operated by Rubiix, a Gibraltar company in formation.
698  */
699 contract StandardBurnableLockableToken is StandardLockableToken, BurnableToken {
700   /**
701     * @dev Burns a specific amount of tokens from the target address and decrements allowance
702     * @param _from address The address which you want to send tokens from
703     * @param _value uint256 The amount of token to be burned
704     */
705   function burnFrom(address _from, uint256 _value) onlyOwner onlyUnlockedOf(_from, _value) public {
706     require(_value <= allowed[_from][msg.sender]);
707     require(_value > 0);
708     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
709     // this function needs to emit an event with the updated approval.
710     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
711 
712     _burn(_from, _value);
713 
714     bytes memory empty;
715     // emit ERC223 transfer event also
716     emit Transfer(msg.sender, address(0), _value, empty);
717   }
718 
719   /**
720     * @dev Burns a specific amount of tokens.
721     * @param _value The amount of token to be burned.
722     */
723   function burn(uint256 _value) onlyOwner onlyUnlocked(_value) public {
724     require(_value > 0);
725     _burn(msg.sender, _value);
726 
727     bytes memory empty;
728       // emit ERC223 transfer event also
729     emit Transfer(msg.sender, address(0), _value, empty);
730   }
731 }
732 
733 // File: contracts/RubiixToken.sol
734 
735 /**
736  * @title RubiixToken
737  * @dev The RubiixToken contract is an Standard ERC20 and ERC223 Lockable smart contract
738  * uses as a coin
739  *
740  * The contents of this Smart Contract and all associated code is owned and operated by Rubiix, a Gibraltar company in formation.
741  */
742 contract RubiixToken is StandardBurnableLockableToken, Destructible {
743   string public constant name = "Rubiix Token";
744 	uint public constant decimals = 18;
745 	string public constant symbol = "RBX";
746 
747   /**
748     * @dev Inits an owner, totalSupply and assigns tokens for the reserved addresses.
749     * Owner = 55%
750     * Team = 20%
751     * Company = 23%
752     * Wallet = 2%
753     * Fires ERC20 & ERC223 transfer events
754     */
755   constructor() public {
756     // set the owner
757     owner = msg.sender;
758     admin = 0xfb36E83F6bE7C0E9ba9FF403389001f2312121aF;
759 
760     uint256 INITIAL_SUPPLY = 223684211 * (10**decimals);
761 
762     // init totalSupply
763     totalSupply_ = INITIAL_SUPPLY;
764 
765     // TODO: use info instead of empty. for example: team reserved
766     bytes memory empty;
767 
768     // Owner = 55%
769     uint256 ownerSupply =  12302631605 * (10**(decimals-2));
770     balances[msg.sender] = ownerSupply;
771     emit Transfer(address(0), msg.sender, ownerSupply);
772     emit Transfer(address(0), msg.sender, ownerSupply, empty);
773 
774     // Team = 20%
775     address teamAddress = 0x7B1Af4A3b427C8eED8aA36a9f997b056853d0e36;
776     uint256 teamSupply = 447368422 * (10**(decimals - 1));
777     balances[teamAddress] = teamSupply;
778     emit Transfer(address(0), teamAddress, teamSupply);
779     emit Transfer(address(0), teamAddress, teamSupply, empty);
780 
781     // Company = 23%
782     address companyAddress = 0x3AFb62d009fEe4DD66A405f191B25e77f1d64126;
783     uint256 companySupply = 5144736853 * (10**(decimals-2));
784     balances[companyAddress] = companySupply;
785     emit Transfer(address(0), companyAddress, companySupply);
786     emit Transfer(address(0), companyAddress, companySupply, empty);
787 
788     // Wallet = 2%
789     address walletAddress = 0x4E44743330b950a8c624C457178AaC1355c4f6b2;
790     uint256 walletSupply = 447368422 * (10**(decimals-2));
791     balances[walletAddress] = walletSupply;
792     emit Transfer(address(0), walletAddress, walletSupply);
793     emit Transfer(address(0), walletAddress, walletSupply, empty);
794   }
795 }