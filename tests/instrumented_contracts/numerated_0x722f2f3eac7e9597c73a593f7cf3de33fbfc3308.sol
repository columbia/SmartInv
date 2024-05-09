1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
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
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * See https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address _who) public view returns (uint256);
73   function transfer(address _to, uint256 _value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (_a == 0) {
91       return 0;
92     }
93 
94     c = _a * _b;
95     assert(c / _a == _b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     // assert(_b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = _a / _b;
105     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
106     return _a / _b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     assert(_b <= _a);
114     return _a - _b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
121     c = _a + _b;
122     assert(c >= _a);
123     return c;
124   }
125 }
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) internal balances;
135 
136   uint256 internal totalSupply_;
137 
138   /**
139   * @dev Total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return totalSupply_;
143   }
144 
145   /**
146   * @dev Transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151     require(_value <= balances[msg.sender]);
152     require(_to != address(0));
153 
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 /**
172  * @title Burnable Token
173  * @dev Token that can be irreversibly burned (destroyed).
174  */
175 contract BurnableToken is BasicToken {
176 
177   event Burn(address indexed burner, uint256 value);
178 
179   /**
180    * @dev Burns a specific amount of tokens.
181    * @param _value The amount of token to be burned.
182    */
183   function burn(uint256 _value) public {
184     _burn(msg.sender, _value);
185   }
186 
187   function _burn(address _who, uint256 _value) internal {
188     require(_value <= balances[_who]);
189     // no need to require value <= totalSupply, since that would imply the
190     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
191 
192     balances[_who] = balances[_who].sub(_value);
193     totalSupply_ = totalSupply_.sub(_value);
194     emit Burn(_who, _value);
195     emit Transfer(_who, address(0), _value);
196   }
197 }
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address _owner, address _spender)
205     public view returns (uint256);
206 
207   function transferFrom(address _from, address _to, uint256 _value)
208     public returns (bool);
209 
210   function approve(address _spender, uint256 _value) public returns (bool);
211   event Approval(
212     address indexed owner,
213     address indexed spender,
214     uint256 value
215   );
216 }
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * https://github.com/ethereum/EIPs/issues/20
223  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) internal allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(
237     address _from,
238     address _to,
239     uint256 _value
240   )
241     public
242     returns (bool)
243   {
244     require(_value <= balances[_from]);
245     require(_value <= allowed[_from][msg.sender]);
246     require(_to != address(0));
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
251     emit Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    * Beware that changing an allowance with this method brings the risk that someone may use both the old
258    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261    * @param _spender The address which will spend the funds.
262    * @param _value The amount of tokens to be spent.
263    */
264   function approve(address _spender, uint256 _value) public returns (bool) {
265     allowed[msg.sender][_spender] = _value;
266     emit Approval(msg.sender, _spender, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Function to check the amount of tokens that an owner allowed to a spender.
272    * @param _owner address The address which owns the funds.
273    * @param _spender address The address which will spend the funds.
274    * @return A uint256 specifying the amount of tokens still available for the spender.
275    */
276   function allowance(
277     address _owner,
278     address _spender
279    )
280     public
281     view
282     returns (uint256)
283   {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed[_spender] == 0. To increment
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _addedValue The amount of tokens to increase the allowance by.
295    */
296   function increaseApproval(
297     address _spender,
298     uint256 _addedValue
299   )
300     public
301     returns (bool)
302   {
303     allowed[msg.sender][_spender] = (
304       allowed[msg.sender][_spender].add(_addedValue));
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309   /**
310    * @dev Decrease the amount of tokens that an owner allowed to a spender.
311    * approve should be called when allowed[_spender] == 0. To decrement
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _subtractedValue The amount of tokens to decrease the allowance by.
317    */
318   function decreaseApproval(
319     address _spender,
320     uint256 _subtractedValue
321   )
322     public
323     returns (bool)
324   {
325     uint256 oldValue = allowed[msg.sender][_spender];
326     if (_subtractedValue >= oldValue) {
327       allowed[msg.sender][_spender] = 0;
328     } else {
329       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
330     }
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335 }
336 
337 /**
338  * @title SafeERC20
339  * @dev Wrappers around ERC20 operations that throw on failure.
340  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
341  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
342  */
343 library SafeERC20 {
344   function safeTransfer(
345     ERC20Basic _token,
346     address _to,
347     uint256 _value
348   )
349     internal
350   {
351     require(_token.transfer(_to, _value));
352   }
353 
354   function safeTransferFrom(
355     ERC20 _token,
356     address _from,
357     address _to,
358     uint256 _value
359   )
360     internal
361   {
362     require(_token.transferFrom(_from, _to, _value));
363   }
364 
365   function safeApprove(
366     ERC20 _token,
367     address _spender,
368     uint256 _value
369   )
370     internal
371   {
372     require(_token.approve(_spender, _value));
373   }
374 }
375 
376 /* solium-disable security/no-block-members */
377 
378 pragma solidity ^0.4.24;
379 
380 
381 
382 
383 
384 
385 /**
386  * @title TokenVesting
387  * @dev A token holder contract that can release its token balance gradually like a
388  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
389  * owner.
390  */
391 contract TokenVesting is Ownable {
392   using SafeMath for uint256;
393   using SafeERC20 for ERC20Basic;
394 
395   event Released(uint256 amount);
396   event Revoked();
397 
398   // beneficiary of tokens after they are released
399   address public beneficiary;
400 
401   uint256 public cliff;
402   uint256 public start;
403   uint256 public duration;
404 
405   bool public revocable;
406 
407   mapping (address => uint256) public released;
408   mapping (address => bool) public revoked;
409 
410   /**
411    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
412    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
413    * of the balance will have vested.
414    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
415    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
416    * @param _start the time (as Unix time) at which point vesting starts
417    * @param _duration duration in seconds of the period in which the tokens will vest
418    * @param _revocable whether the vesting is revocable or not
419    */
420   constructor(
421     address _beneficiary,
422     uint256 _start,
423     uint256 _cliff,
424     uint256 _duration,
425     bool _revocable
426   )
427     public
428   {
429     require(_beneficiary != address(0));
430     require(_cliff <= _duration);
431 
432     beneficiary = _beneficiary;
433     revocable = _revocable;
434     duration = _duration;
435     cliff = _start.add(_cliff);
436     start = _start;
437   }
438 
439   /**
440    * @notice Transfers vested tokens to beneficiary.
441    * @param _token ERC20 token which is being vested
442    */
443   function release(ERC20Basic _token) public {
444     uint256 unreleased = releasableAmount(_token);
445 
446     require(unreleased > 0);
447 
448     released[_token] = released[_token].add(unreleased);
449 
450     _token.safeTransfer(beneficiary, unreleased);
451 
452     emit Released(unreleased);
453   }
454 
455   /**
456    * @notice Allows the owner to revoke the vesting. Tokens already vested
457    * remain in the contract, the rest are returned to the owner.
458    * @param _token ERC20 token which is being vested
459    */
460   function revoke(ERC20Basic _token) public onlyOwner {
461     require(revocable);
462     require(!revoked[_token]);
463 
464     uint256 balance = _token.balanceOf(address(this));
465 
466     uint256 unreleased = releasableAmount(_token);
467     uint256 refund = balance.sub(unreleased);
468 
469     revoked[_token] = true;
470 
471     _token.safeTransfer(owner, refund);
472 
473     emit Revoked();
474   }
475 
476   /**
477    * @dev Calculates the amount that has already vested but hasn't been released yet.
478    * @param _token ERC20 token which is being vested
479    */
480   function releasableAmount(ERC20Basic _token) public view returns (uint256) {
481     return vestedAmount(_token).sub(released[_token]);
482   }
483 
484   /**
485    * @dev Calculates the amount that has already vested.
486    * @param _token ERC20 token which is being vested
487    */
488   function vestedAmount(ERC20Basic _token) public view returns (uint256) {
489     uint256 currentBalance = _token.balanceOf(address(this));
490     uint256 totalBalance = currentBalance.add(released[_token]);
491 
492     if (block.timestamp < cliff) {
493       return 0;
494     } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
495       return totalBalance;
496     } else {
497       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
498     }
499   }
500 }
501 
502 /** @title Periodic Token Vesting
503   * @dev A token holder contract that can release its token balance periodically like a
504   * typical vesting scheme. Optionally revocable by the owner.
505   */
506 contract PeriodicTokenVesting is TokenVesting {
507     using SafeMath for uint256;
508 
509     uint256 public releasePeriod;
510     uint256 public releaseCount;
511 
512     mapping (address => uint256) public revokedAmount;
513 
514     constructor(
515         address _beneficiary,
516         uint256 _startInUnixEpochTime,
517         uint256 _releasePeriodInSeconds,
518         uint256 _releaseCount
519     )
520         public
521         TokenVesting(_beneficiary, _startInUnixEpochTime, 0, _releasePeriodInSeconds.mul(_releaseCount), true)
522     {
523         require(_releasePeriodInSeconds.mul(_releaseCount) > 0, "Vesting Duration cannot be 0");
524         require(_startInUnixEpochTime.add(_releasePeriodInSeconds.mul(_releaseCount)) > block.timestamp, "Worthless vesting");
525         releasePeriod = _releasePeriodInSeconds;
526         releaseCount = _releaseCount;
527     }
528 
529     function initialTokenAmountInVesting(ERC20Basic _token) public view returns (uint256) {
530         return _token.balanceOf(address(this)).add(released[_token]).add(revokedAmount[_token]);
531     }
532 
533     function tokenAmountLockedInVesting(ERC20Basic _token) public view returns (uint256) {
534         return _token.balanceOf(address(this)).sub(releasableAmount(_token));
535     }
536 
537     function nextVestingTime(ERC20Basic _token) public view returns (uint256) {
538         if (block.timestamp >= start.add(duration) || revoked[_token]) {
539             return 0;
540         } else {
541             return start.add(((block.timestamp.sub(start)).div(releasePeriod).add(1)).mul(releasePeriod));
542         }
543     }
544 
545     function vestingCompletionTime(ERC20Basic _token) public view returns (uint256) {
546         if (block.timestamp >= start.add(duration) || revoked[_token]) {
547             return 0;
548         } else {
549             return start.add(duration);
550         }
551     }
552 
553     function remainingVestingCount(ERC20Basic _token) public view returns (uint256) {
554         if (block.timestamp >= start.add(duration) || revoked[_token]) {
555             return 0;
556         } else {
557             return releaseCount.sub((block.timestamp.sub(start)).div(releasePeriod));
558         }
559     }
560 
561     /**
562      * @notice Allows the owner to revoke the vesting. Tokens already vested
563      * remain in the contract, the rest are returned to the owner.
564      * @param _token ERC20 token which is being vested
565      */
566     function revoke(ERC20Basic _token) public onlyOwner {
567       require(revocable);
568       require(!revoked[_token]);
569 
570       uint256 balance = _token.balanceOf(address(this));
571 
572       uint256 unreleased = releasableAmount(_token);
573       uint256 refund = balance.sub(unreleased);
574 
575       revoked[_token] = true;
576       revokedAmount[_token] = refund;
577 
578       _token.safeTransfer(owner, refund);
579 
580       emit Revoked();
581     }
582 
583     /**
584      * @dev Calculates the amount that has already vested.
585      * @param _token ERC20 token which is being vested
586      */
587     function vestedAmount(ERC20Basic _token) public view returns (uint256) {
588         uint256 currentBalance = _token.balanceOf(address(this));
589         uint256 totalBalance = currentBalance.add(released[_token]);
590 
591         if (block.timestamp < cliff) {
592             return 0;
593         } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
594             return totalBalance;
595         } else {
596             return totalBalance.mul((block.timestamp.sub(start)).div(releasePeriod)).div(releaseCount);
597         }
598     }
599 }
600 
601 /** @title Cnus Token
602   * An ERC20-compliant token.
603   */
604 contract CnusToken is StandardToken, Ownable, BurnableToken {
605     using SafeMath for uint256;
606 
607     // global token transfer lock
608     bool public globalTokenTransferLock = false;
609     bool public mintingFinished = false;
610     bool public lockingDisabled = false;
611 
612     string public name = "CoinUs";
613     string public symbol = "CNUS";
614     uint256 public decimals = 18;
615 
616     address public mintContractOwner;
617 
618     address[] public vestedAddresses;
619 
620     // mapping that provides address based lock.
621     mapping( address => bool ) public lockedStatusAddress;
622     mapping( address => PeriodicTokenVesting ) private tokenVestingContracts;
623 
624     event LockingDisabled();
625     event GlobalLocked();
626     event GlobalUnlocked();
627     event Locked(address indexed lockedAddress);
628     event Unlocked(address indexed unlockedaddress);
629     event Mint(address indexed to, uint256 amount);
630     event MintFinished();
631     event MintOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
632     event VestingCreated(address indexed beneficiary, uint256 startTime, uint256 period, uint256 releaseCount);
633     event InitialVestingDeposited(address indexed beneficiary, uint256 amount);
634     event AllVestedTokenReleased();
635     event VestedTokenReleased(address indexed beneficiary);
636     event RevokedTokenVesting(address indexed beneficiary);
637 
638     // Check for global lock status to be unlocked
639     modifier checkGlobalTokenTransferLock {
640         if (!lockingDisabled) {
641             require(!globalTokenTransferLock, "Global lock is active");
642         }
643         _;
644     }
645 
646     // Check for address lock to be unlocked
647     modifier checkAddressLock {
648         require(!lockedStatusAddress[msg.sender], "Address is locked");
649         _;
650     }
651 
652     modifier canMint() {
653         require(!mintingFinished, "Minting is finished");
654         _;
655     }
656 
657     modifier hasMintPermission() {
658         require(msg.sender == mintContractOwner, "Minting is not authorized from this account");
659         _;
660     }
661 
662     constructor() public {
663         uint256 initialSupply = 2000000000;
664         initialSupply = initialSupply.mul(10**18);
665         totalSupply_ = initialSupply;
666         balances[msg.sender] = initialSupply;
667         mintContractOwner = msg.sender;
668     }
669 
670     function disableLockingForever() public
671     onlyOwner
672     {
673         lockingDisabled = true;
674         emit LockingDisabled();
675     }
676 
677     function setGlobalTokenTransferLock(bool locked) public
678     onlyOwner
679     {
680         require(!lockingDisabled);
681         require(globalTokenTransferLock != locked);
682         globalTokenTransferLock = locked;
683         if (globalTokenTransferLock) {
684             emit GlobalLocked();
685         } else {
686             emit GlobalUnlocked();
687         }
688     }
689 
690     /**
691       * @dev Allows token issuer to lock token transfer for an address.
692       * @param target Target address to lock token transfer.
693       */
694     function lockAddress(
695         address target
696     )
697         public
698         onlyOwner
699     {
700         require(!lockingDisabled);
701         require(owner != target);
702         require(!lockedStatusAddress[target]);
703         for(uint256 i = 0; i < vestedAddresses.length; i++) {
704             require(tokenVestingContracts[vestedAddresses[i]] != target);
705         }
706         lockedStatusAddress[target] = true;
707         emit Locked(target);
708     }
709 
710     /**
711       * @dev Allows token issuer to unlock token transfer for an address.
712       * @param target Target address to unlock token transfer.
713       */
714     function unlockAddress(
715         address target
716     )
717         public
718         onlyOwner
719     {
720         require(!lockingDisabled);
721         require(lockedStatusAddress[target]);
722         lockedStatusAddress[target] = false;
723         emit Unlocked(target);
724     }
725 
726     /**
727      * @dev Creates a vesting contract that vests its balance of Cnus token to the
728      * _beneficiary, gradually in periodic interval until all of the balance will have
729      * vested by period * release count time.
730      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
731      * @param _startInUnixEpochTime the time (as Unix time) at which point vesting starts
732      * @param _releasePeriodInSeconds period in seconds in which tokens will vest to beneficiary
733      * @param _releaseCount count of period required to have all of the balance vested
734      */
735     function createNewVesting(
736         address _beneficiary,
737         uint256 _startInUnixEpochTime,
738         uint256 _releasePeriodInSeconds,
739         uint256 _releaseCount
740     )
741         public
742         onlyOwner
743     {
744         require(tokenVestingContracts[_beneficiary] == address(0));
745         tokenVestingContracts[_beneficiary] = new PeriodicTokenVesting(
746             _beneficiary, _startInUnixEpochTime, _releasePeriodInSeconds, _releaseCount);
747         vestedAddresses.push(_beneficiary);
748         emit VestingCreated(_beneficiary, _startInUnixEpochTime, _releasePeriodInSeconds, _releaseCount);
749     }
750 
751     /**
752       * @dev Transfers token vesting amount from token issuer to vesting contract created for the
753       * beneficiary. Token Issuer must first approve token spending from owner's account.
754       * @param _beneficiary beneficiary for whom vesting has been created with createNewVesting function.
755       * @param _vestAmount vesting amount for the beneficiary
756       */
757     function transferInitialVestAmountFromOwner(
758         address _beneficiary,
759         uint256 _vestAmount
760     )
761         public
762         onlyOwner
763         returns (bool)
764     {
765         require(tokenVestingContracts[_beneficiary] != address(0));
766         ERC20 cnusToken = ERC20(address(this));
767         require(cnusToken.allowance(owner, address(this)) >= _vestAmount);
768         require(cnusToken.transferFrom(owner, tokenVestingContracts[_beneficiary], _vestAmount));
769         emit InitialVestingDeposited(_beneficiary, cnusToken.balanceOf(tokenVestingContracts[_beneficiary]));
770         return true;
771     }
772 
773     function checkVestedAddressCount()
774         public
775         view
776         returns (uint256)
777     {
778         return vestedAddresses.length;
779     }
780 
781     function checkCurrentTotolVestedAmount()
782         public
783         view
784         returns (uint256)
785     {
786         uint256 vestedAmountSum = 0;
787         for (uint256 i = 0; i < vestedAddresses.length; i++) {
788             vestedAmountSum = vestedAmountSum.add(
789                 tokenVestingContracts[vestedAddresses[i]].vestedAmount(ERC20(address(this))));
790         }
791         return vestedAmountSum;
792     }
793 
794     function checkCurrentTotalReleasableAmount()
795         public
796         view
797         returns (uint256)
798     {
799         uint256 releasableAmountSum = 0;
800         for (uint256 i = 0; i < vestedAddresses.length; i++) {
801             releasableAmountSum = releasableAmountSum.add(
802                 tokenVestingContracts[vestedAddresses[i]].releasableAmount(ERC20(address(this))));
803         }
804         return releasableAmountSum;
805     }
806 
807     function checkCurrentTotalAmountLockedInVesting()
808         public
809         view
810         returns (uint256)
811     {
812         uint256 lockedAmountSum = 0;
813         for (uint256 i = 0; i < vestedAddresses.length; i++) {
814             lockedAmountSum = lockedAmountSum.add(
815                tokenVestingContracts[vestedAddresses[i]].tokenAmountLockedInVesting(ERC20(address(this))));
816         }
817         return lockedAmountSum;
818     }
819 
820     function checkInitialTotalTokenAmountInVesting()
821         public
822         view
823         returns (uint256)
824     {
825         uint256 initialTokenVesting = 0;
826         for (uint256 i = 0; i < vestedAddresses.length; i++) {
827             initialTokenVesting = initialTokenVesting.add(
828                 tokenVestingContracts[vestedAddresses[i]].initialTokenAmountInVesting(ERC20(address(this))));
829         }
830         return initialTokenVesting;
831     }
832 
833     function checkNextVestingTimeForBeneficiary(
834         address _beneficiary
835     )
836         public
837         view
838         returns (uint256)
839     {
840         require(tokenVestingContracts[_beneficiary] != address(0));
841         return tokenVestingContracts[_beneficiary].nextVestingTime(ERC20(address(this)));
842     }
843 
844     function checkVestingCompletionTimeForBeneficiary(
845         address _beneficiary
846     )
847         public
848         view
849         returns (uint256)
850     {
851         require(tokenVestingContracts[_beneficiary] != address(0));
852         return tokenVestingContracts[_beneficiary].vestingCompletionTime(ERC20(address(this)));
853     }
854 
855     function checkRemainingVestingCountForBeneficiary(
856         address _beneficiary
857     )
858         public
859         view
860         returns (uint256)
861     {
862         require(tokenVestingContracts[_beneficiary] != address(0));
863         return tokenVestingContracts[_beneficiary].remainingVestingCount(ERC20(address(this)));
864     }
865 
866     function checkReleasableAmountForBeneficiary(
867         address _beneficiary
868     )
869         public
870         view
871         returns (uint256)
872     {
873         require(tokenVestingContracts[_beneficiary] != address(0));
874         return tokenVestingContracts[_beneficiary].releasableAmount(ERC20(address(this)));
875     }
876 
877     function checkVestedAmountForBeneficiary(
878         address _beneficiary
879     )
880         public
881         view
882         returns (uint256)
883     {
884         require(tokenVestingContracts[_beneficiary] != address(0));
885         return tokenVestingContracts[_beneficiary].vestedAmount(ERC20(address(this)));
886     }
887 
888     function checkTokenAmountLockedInVestingForBeneficiary(
889         address _beneficiary
890     )
891         public
892         view
893         returns (uint256)
894     {
895         require(tokenVestingContracts[_beneficiary] != address(0));
896         return tokenVestingContracts[_beneficiary].tokenAmountLockedInVesting(ERC20(address(this)));
897     }
898 
899     /**
900      * @notice Transfers vested tokens to all beneficiaries.
901      */
902     function releaseAllVestedToken()
903         public
904         checkGlobalTokenTransferLock
905         returns (bool)
906     {
907         emit AllVestedTokenReleased();
908         PeriodicTokenVesting tokenVesting;
909         for(uint256 i = 0; i < vestedAddresses.length; i++) {
910             tokenVesting = tokenVestingContracts[vestedAddresses[i]];
911             if(tokenVesting.releasableAmount(ERC20(address(this))) > 0) {
912                 tokenVesting.release(ERC20(address(this)));
913                 emit VestedTokenReleased(vestedAddresses[i]);
914             }
915         }
916         return true;
917     }
918 
919     /**
920      * @notice Transfers vested tokens to beneficiary.
921      * @param _beneficiary Beneficiary to whom cnus token is being vested
922      */
923     function releaseVestedToken(
924         address _beneficiary
925     )
926         public
927         checkGlobalTokenTransferLock
928         returns (bool)
929     {
930         require(tokenVestingContracts[_beneficiary] != address(0));
931         tokenVestingContracts[_beneficiary].release(ERC20(address(this)));
932         emit VestedTokenReleased(_beneficiary);
933         return true;
934     }
935 
936     /**
937      * @notice Allows the owner to revoke the vesting. Tokens already vested
938      * remain in the contract, the rest are returned to the owner.
939      * @param _beneficiary Beneficiary to whom cnus token is being vested
940      */
941     function revokeTokenVesting(
942         address _beneficiary
943     )
944         public
945         onlyOwner
946         checkGlobalTokenTransferLock
947         returns (bool)
948     {
949         require(tokenVestingContracts[_beneficiary] != address(0));
950         tokenVestingContracts[_beneficiary].revoke(ERC20(address(this)));
951         _transferMisplacedToken(owner, address(this), ERC20(address(this)).balanceOf(address(this)));
952         emit RevokedTokenVesting(_beneficiary);
953         return true;
954     }
955 
956     /** @dev Transfer `_value` token to `_to` from `msg.sender`, on the condition
957       * that global token lock and individual address lock in the `msg.sender`
958       * accountare both released.
959       * @param _to The address of the recipient.
960       * @param _value The amount of token to be transferred.
961       * @return Whether the transfer was successful or not.
962       */
963     function transfer(
964         address _to,
965         uint256 _value
966     )
967         public
968         checkGlobalTokenTransferLock
969         checkAddressLock
970         returns (bool)
971     {
972         return super.transfer(_to, _value);
973     }
974 
975     /**
976      * @dev Transfer tokens from one address to another
977      * @param _from address The address which you want to send tokens from
978      * @param _to address The address which you want to transfer to
979      * @param _value uint256 the amount of tokens to be transferred
980      */
981     function transferFrom(
982         address _from,
983         address _to,
984         uint256 _value
985     )
986         public
987         checkGlobalTokenTransferLock
988         returns (bool)
989     {
990         require(!lockedStatusAddress[_from], "Address is locked.");
991         return super.transferFrom(_from, _to, _value);
992     }
993 
994     /**
995      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
996      * @param _spender address The address which will spend the funds.
997      * @param _value uint256 The amount of tokens to be spent.
998      */
999     function approve(
1000         address _spender,
1001         uint256 _value
1002     )
1003         public
1004         checkGlobalTokenTransferLock
1005         checkAddressLock
1006         returns (bool)
1007     {
1008         return super.approve(_spender, _value);
1009     }
1010 
1011     /**
1012      * @dev Increase the amount of tokens that an owner allowed to a spender.
1013      * approve should be called when allowed[_spender] == 0. To increment
1014      * allowed value is better to use this function to avoid 2 calls (and wait until
1015      * the first transaction is mined)
1016      * From MonolithDAO Token.sol
1017      * @param _spender The address which will spend the funds.
1018      * @param _addedValue The amount of tokens to increase the allowance by.
1019      */
1020     function increaseApproval(
1021         address _spender,
1022         uint _addedValue
1023     )
1024         public
1025         checkGlobalTokenTransferLock
1026         checkAddressLock
1027         returns (bool success)
1028     {
1029         return super.increaseApproval(_spender, _addedValue);
1030     }
1031 
1032     /**
1033      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1034      * approve should be called when allowed[_spender] == 0. To decrement
1035      * allowed value is better to use this function to avoid 2 calls (and wait until
1036      * the first transaction is mined)
1037      * From MonolithDAO Token.sol
1038      * @param _spender The address which will spend the funds.
1039      * @param _subtractedValue The amount of tokens to decrease the allowance by.
1040      */
1041     function decreaseApproval(
1042         address _spender,
1043         uint _subtractedValue
1044     )
1045         public
1046         checkGlobalTokenTransferLock
1047         checkAddressLock
1048         returns (bool success)
1049     {
1050         return super.decreaseApproval(_spender, _subtractedValue);
1051     }
1052 
1053     /**
1054      * @dev Function to transfer mint ownership.
1055      * @param _newOwner The address that will have the mint ownership.
1056      */
1057     function transferMintOwnership(
1058         address _newOwner
1059     )
1060         public
1061         onlyOwner
1062     {
1063         _transferMintOwnership(_newOwner);
1064     }
1065 
1066     /**
1067      * @dev Function to mint tokens
1068      * @param _to The address that will receive the minted tokens.
1069      * @param _amount The amount of tokens to mint.
1070      * @return A boolean that indicates if the operation was successful.
1071      */
1072     function mint(
1073         address _to,
1074         uint256 _amount
1075     )
1076         public
1077         hasMintPermission
1078         canMint
1079         returns (bool)
1080     {
1081         totalSupply_ = totalSupply_.add(_amount);
1082         balances[_to] = balances[_to].add(_amount);
1083         emit Mint(_to, _amount);
1084         emit Transfer(address(0), _to, _amount);
1085         return true;
1086     }
1087 
1088     /**
1089      * @dev Function to stop minting new tokens.
1090      * @return True if the operation was successful.
1091      */
1092     function finishMinting()
1093         public
1094         onlyOwner
1095         canMint
1096         returns (bool)
1097     {
1098         mintingFinished = true;
1099         emit MintFinished();
1100         return true;
1101     }
1102 
1103     function checkMisplacedTokenBalance(
1104         address _tokenAddress
1105     )
1106         public
1107         view
1108         returns (uint256)
1109     {
1110         ERC20 unknownToken = ERC20(_tokenAddress);
1111         return unknownToken.balanceOf(address(this));
1112     }
1113 
1114     // Allow transfer of accidentally sent ERC20 tokens
1115     function refundMisplacedToken(
1116         address _recipient,
1117         address _tokenAddress,
1118         uint256 _value
1119     )
1120         public
1121         onlyOwner
1122     {
1123         _transferMisplacedToken(_recipient, _tokenAddress, _value);
1124     }
1125 
1126     function _transferMintOwnership(
1127         address _newOwner
1128     )
1129         internal
1130     {
1131         require(_newOwner != address(0));
1132         emit MintOwnershipTransferred(mintContractOwner, _newOwner);
1133         mintContractOwner = _newOwner;
1134     }
1135 
1136     function _transferMisplacedToken(
1137         address _recipient,
1138         address _tokenAddress,
1139         uint256 _value
1140     )
1141         internal
1142     {
1143         require(_recipient != address(0));
1144         ERC20 unknownToken = ERC20(_tokenAddress);
1145         require(unknownToken.balanceOf(address(this)) >= _value, "Insufficient token balance.");
1146         require(unknownToken.transfer(_recipient, _value));
1147     }
1148 }