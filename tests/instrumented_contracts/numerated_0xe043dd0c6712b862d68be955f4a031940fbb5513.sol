1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() onlyOwner whenNotPaused public {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() onlyOwner whenPaused public {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375   function transfer(
376     address _to,
377     uint256 _value
378   )
379     public
380     whenNotPaused
381     returns (bool)
382   {
383     return super.transfer(_to, _value);
384   }
385 
386   function transferFrom(
387     address _from,
388     address _to,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.transferFrom(_from, _to, _value);
396   }
397 
398   function approve(
399     address _spender,
400     uint256 _value
401   )
402     public
403     whenNotPaused
404     returns (bool)
405   {
406     return super.approve(_spender, _value);
407   }
408 
409   function increaseApproval(
410     address _spender,
411     uint _addedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.increaseApproval(_spender, _addedValue);
418   }
419 
420   function decreaseApproval(
421     address _spender,
422     uint _subtractedValue
423   )
424     public
425     whenNotPaused
426     returns (bool success)
427   {
428     return super.decreaseApproval(_spender, _subtractedValue);
429   }
430 }
431 
432 // File: contracts/interfaces/IRegistry.sol
433 
434 // limited ContractRegistry definition
435 interface IRegistry {
436   function owner()
437     external
438     returns(address);
439 
440   function updateContractAddress(
441     string _name,
442     address _address
443   )
444     external
445     returns (address);
446 
447   function getContractAddress(
448     string _name
449   )
450     external
451     view
452     returns (address);
453 }
454 
455 // File: contracts/interfaces/IBrickblockToken.sol
456 
457 // limited BrickblockToken definition
458 interface IBrickblockToken {
459   function transfer(
460     address _to,
461     uint256 _value
462   )
463     external
464     returns (bool);
465 
466   function transferFrom(
467     address from,
468     address to,
469     uint256 value
470   )
471     external
472     returns (bool);
473 
474   function balanceOf(
475     address _address
476   )
477     external
478     view
479     returns (uint256);
480 
481   function approve(
482     address _spender,
483     uint256 _value
484   )
485     external
486     returns (bool);
487 }
488 
489 // File: contracts/AccessToken.sol
490 
491 /// @title The utility token used for paying fees in the Brickblock ecosystem
492 
493 /** @dev Explanation of terms and patterns:
494     General:
495       * Units of account: All per-token balances are stored in wei (1e18), for the greatest possible accuracy
496       * ERC20 "balances":
497         * "balances" per default is not updated unless a transfer/transferFrom happens
498         * That's why it's set to "internal" because we can't guarantee its accuracy
499 
500     Current Lock Period Balance Sheet:
501       * The balance sheet for tracking ACT balances for the _current_ lock period is 'mintedActFromCurrentLockPeriodPerUser'
502       * Formula:
503         * "totalLockedBBK * (totalMintedActPerLockedBbkToken - mintedActPerUser) / 1e18"
504       * The period in which a BBK token has been locked uninterruptedly
505       * For example, if a token has been locked for 30 days, then unlocked for 13 days, then locked again
506         for 5 days, the current lock period would be 5 days
507       * When a BBK is locked or unlocked, the ACT balance for the respective BBK holder
508         is transferred to a separate balance sheet, called 'mintedActFromPastLockPeriodsPerUser'
509         * Upon migrating this balance to 'mintedActFromPastLockPeriodsPerUser', this balance sheet is essentially
510           zeroed out by setting 'mintedActPerUser' to 'totalMintedActPerLockedBbkToken'
511         * ie. "42 totalLockedBBK * (100 totalMintedActPerLockedBbkToken - 100 mintedActPerUser) === 0"
512       * All newly minted ACT per user are tracked through this until an unlock event occurs
513 
514     Past Lock Periods Balance Sheet:
515       * The balance sheet for tracking ACT balances for the _past_ lock periods is 'mintedActFromPastLockPeriodsPerUser'
516       * Formula:
517         * The sum of all minted ACT from all past lock periods
518       * All periods in which a BBK token has been locked _before_ the current lock period
519       * For example, if a token has been locked for 10 days, then unlocked for 13 days, then locked again for 5 days,
520         then unlocked for 7 days, then locked again for 30 days, the past lock periods would add up to 15 days
521       * So essentially we're summing all locked periods that happened _before_ the current lock period
522       * Needed to track ACT balance per user after a lock or unlock event occurred
523 
524     Transfers Balance Sheet:
525       * The balance sheet for tracking balance changes caused by transfer() and transferFrom()
526       * Needed to accurately track balanceOf after transfers
527       * Formula:
528         * "receivedAct[address] - spentAct[address]"
529       * receivedAct is incremented after an address receives ACT via a transfer() or transferFrom()
530         * increments balanceOf
531       * spentAct is incremented after an address spends ACT via a transfer() or transferFrom()
532         * decrements balanceOf
533 
534     All 3 Above Balance Sheets Combined:
535       * When combining the Current Lock Period Balance, the Past Lock Periods Balance and the Transfers Balance:
536         * We should get the correct total balanceOf for a given address
537         * mintedActFromCurrentLockPeriodPerUser[addr]  // Current Lock Period Balance Sheet
538           + mintedActFromPastLockPeriodsPerUser[addr]  // Past Lock Periods Balance Sheet
539           + receivedAct[addr] - spentAct[addr]     // Transfers Balance Sheet
540 */
541 
542 contract AccessToken is PausableToken {
543   uint8 public constant version = 1;
544 
545   // Instance of registry contract to get contract addresses
546   IRegistry internal registry;
547   string public constant name = "AccessToken";
548   string public constant symbol = "ACT";
549   uint8 public constant decimals = 18;
550 
551   // Total amount of minted ACT that a single locked BBK token is entitled to
552   uint256 internal totalMintedActPerLockedBbkToken;
553 
554   // Total amount of BBK that is currently locked into the ACT contract
555   uint256 public totalLockedBBK;
556 
557   // Amount of locked BBK per user
558   mapping(address => uint256) internal lockedBbkPerUser;
559 
560   /*
561    * Total amount of minted ACT per user
562    * Used to decrement totalMintedActPerLockedBbkToken by amounts that have already been moved to mintedActFromPastLockPeriodsPerUser
563    */
564   mapping(address => uint256) internal mintedActPerUser;
565 
566   // Track minted ACT tokens per user for the current BBK lock period
567   mapping(address => uint256) internal mintedActFromCurrentLockPeriodPerUser;
568 
569   // Track minted ACT tokens per user for past BBK lock periods
570   mapping(address => uint256) internal mintedActFromPastLockPeriodsPerUser;
571 
572   // ERC20 override to keep balances private and use balanceOf instead
573   mapping(address => uint256) internal balances;
574 
575   // Track received ACT via transfer or transferFrom in order to calculate the correct balanceOf
576   mapping(address => uint256) public receivedAct;
577 
578   // Track spent ACT via transfer or transferFrom in order to calculate the correct balanceOf
579   mapping(address => uint256) public spentAct;
580 
581 
582   event Mint(uint256 amount);
583   event Burn(address indexed burner, uint256 value);
584   event BbkLocked(
585     address indexed locker,
586     uint256 lockedAmount,
587     uint256 totalLockedAmount
588   );
589   event BbkUnlocked(
590     address indexed locker,
591     uint256 unlockedAmount,
592     uint256 totalLockedAmount
593   );
594 
595   modifier onlyContract(string _contractName)
596   {
597     require(
598       msg.sender == registry.getContractAddress(_contractName)
599     );
600     _;
601   }
602 
603   constructor (
604     address _registryAddress
605   )
606     public
607   {
608     require(_registryAddress != address(0));
609     registry = IRegistry(_registryAddress);
610   }
611 
612   /// @notice Check an address for amount of currently locked BBK
613   /// works similar to basic ERC20 balanceOf
614   function lockedBbkOf(
615     address _address
616   )
617     external
618     view
619     returns (uint256)
620   {
621     return lockedBbkPerUser[_address];
622   }
623 
624   /** @notice Transfers BBK from an account owning BBK to this contract.
625     1. Uses settleCurrentLockPeriod to transfer funds from the "Current Lock Period"
626        balance sheet to the "Past Lock Periods" balance sheet.
627     2. Keeps a record of BBK transfers via events
628     @param _amount BBK token amount to lock
629   */
630   function lockBBK(
631     uint256 _amount
632   )
633     external
634     returns (bool)
635   {
636     require(_amount > 0);
637     IBrickblockToken _bbk = IBrickblockToken(
638       registry.getContractAddress("BrickblockToken")
639     );
640 
641     require(settleCurrentLockPeriod(msg.sender));
642     lockedBbkPerUser[msg.sender] = lockedBbkPerUser[msg.sender].add(_amount);
643     totalLockedBBK = totalLockedBBK.add(_amount);
644     require(_bbk.transferFrom(msg.sender, this, _amount));
645     emit BbkLocked(msg.sender, _amount, totalLockedBBK);
646     return true;
647   }
648 
649   /** @notice Transfers BBK from this contract to an account
650     1. Uses settleCurrentLockPeriod to transfer funds from the "Current Lock Period"
651        balance sheet to the "Past Lock Periods" balance sheet.
652     2. Keeps a record of BBK transfers via events
653     @param _amount BBK token amount to unlock
654   */
655   function unlockBBK(
656     uint256 _amount
657   )
658     external
659     returns (bool)
660   {
661     require(_amount > 0);
662     IBrickblockToken _bbk = IBrickblockToken(
663       registry.getContractAddress("BrickblockToken")
664     );
665     require(_amount <= lockedBbkPerUser[msg.sender]);
666     require(settleCurrentLockPeriod(msg.sender));
667     lockedBbkPerUser[msg.sender] = lockedBbkPerUser[msg.sender].sub(_amount);
668     totalLockedBBK = totalLockedBBK.sub(_amount);
669     require(_bbk.transfer(msg.sender, _amount));
670     emit BbkUnlocked(msg.sender, _amount, totalLockedBBK);
671     return true;
672   }
673 
674   /**
675     @notice Distribute ACT tokens to all BBK token holders, that have currently locked their BBK tokens into this contract.
676     Adds the tiny delta, caused by integer division remainders, to the owner's mintedActFromPastLockPeriodsPerUser balance.
677     @param _amount Amount of fee to be distributed to ACT holders
678     @dev Accepts calls only from our `FeeManager` contract
679   */
680   function distribute(
681     uint256 _amount
682   )
683     external
684     onlyContract("FeeManager")
685     returns (bool)
686   {
687     totalMintedActPerLockedBbkToken = totalMintedActPerLockedBbkToken
688       .add(
689         _amount
690           .mul(1e18)
691           .div(totalLockedBBK)
692       );
693 
694     uint256 _delta = (_amount.mul(1e18) % totalLockedBBK).div(1e18);
695     mintedActFromPastLockPeriodsPerUser[owner] = mintedActFromPastLockPeriodsPerUser[owner].add(_delta);
696     totalSupply_ = totalSupply_.add(_amount);
697     emit Mint(_amount);
698     return true;
699   }
700 
701   /**
702     @notice Calculates minted ACT from "Current Lock Period" for a given address
703     @param _address ACT holder address
704    */
705   function getMintedActFromCurrentLockPeriod(
706     address _address
707   )
708     private
709     view
710     returns (uint256)
711   {
712     return lockedBbkPerUser[_address]
713       .mul(totalMintedActPerLockedBbkToken.sub(mintedActPerUser[_address]))
714       .div(1e18);
715   }
716 
717   /**
718     @notice Transfers "Current Lock Period" balance sheet to "Past Lock Periods" balance sheet.
719     Ensures that BBK transfers won't affect accrued ACT balances.
720    */
721   function settleCurrentLockPeriod(
722     address _address
723   )
724     private
725     returns (bool)
726   {
727     mintedActFromCurrentLockPeriodPerUser[_address] = getMintedActFromCurrentLockPeriod(_address);
728     mintedActFromPastLockPeriodsPerUser[_address] = mintedActFromPastLockPeriodsPerUser[_address]
729       .add(mintedActFromCurrentLockPeriodPerUser[_address]);
730     mintedActPerUser[_address] = totalMintedActPerLockedBbkToken;
731 
732     return true;
733   }
734 
735   /************************
736   * Start ERC20 overrides *
737   ************************/
738 
739   /** @notice Combines all balance sheets to calculate the correct balance (see explanation on top)
740     @param _address Sender address
741     @return uint256
742   */
743   function balanceOf(
744     address _address
745   )
746     public
747     view
748     returns (uint256)
749   {
750     mintedActFromCurrentLockPeriodPerUser[_address] = getMintedActFromCurrentLockPeriod(_address);
751 
752     return totalMintedActPerLockedBbkToken == 0
753       ? 0
754       : mintedActFromCurrentLockPeriodPerUser[_address]
755       .add(mintedActFromPastLockPeriodsPerUser[_address])
756       .add(receivedAct[_address])
757       .sub(spentAct[_address]);
758   }
759 
760   /**
761     @notice Same as the default ERC20 transfer() with two differences:
762     1. Uses "balanceOf(address)" rather than "balances[address]" to check the balance of msg.sender
763        ("balances" is inaccurate, see above).
764     2. Updates the Transfers Balance Sheet.
765 
766     @param _to Receiver address
767     @param _value Amount
768     @return bool
769   */
770   function transfer(
771     address _to,
772     uint256 _value
773   )
774     public
775     whenNotPaused
776     returns (bool)
777   {
778     require(_to != address(0));
779     require(_value <= balanceOf(msg.sender));
780     spentAct[msg.sender] = spentAct[msg.sender].add(_value);
781     receivedAct[_to] = receivedAct[_to].add(_value);
782     emit Transfer(msg.sender, _to, _value);
783     return true;
784   }
785 
786   /**
787     @notice Same as the default ERC20 transferFrom() with two differences:
788     1. Uses "balanceOf(address)" rather than "balances[address]" to check the balance of msg.sender
789        ("balances" is inaccurate, see above).
790     2. Updates the Transfers Balance Sheet.
791 
792     @param _from Sender Address
793     @param _to Receiver address
794     @param _value Amount
795     @return bool
796   */
797   function transferFrom(
798     address _from,
799     address _to,
800     uint256 _value
801   )
802     public
803     whenNotPaused
804     returns (bool)
805   {
806     require(_to != address(0));
807     require(_value <= balanceOf(_from));
808     require(_value <= allowed[_from][msg.sender]);
809     spentAct[_from] = spentAct[_from].add(_value);
810     receivedAct[_to] = receivedAct[_to].add(_value);
811     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
812     emit Transfer(_from, _to, _value);
813     return true;
814   }
815 
816   /**********************
817   * End ERC20 overrides *
818   ***********************/
819 
820   /**
821     @notice Burns tokens through decrementing "totalSupply" and incrementing "spentAct[address]"
822     @dev Callable only by FeeManager contract
823     @param _address Sender Address
824     @param _value Amount
825     @return bool
826   */
827   function burn(
828     address _address,
829     uint256 _value
830   )
831     external
832     onlyContract("FeeManager")
833     returns (bool)
834   {
835     require(_value <= balanceOf(_address));
836     spentAct[_address] = spentAct[_address].add(_value);
837     totalSupply_ = totalSupply_.sub(_value);
838     emit Burn(_address, _value);
839     return true;
840   }
841 }