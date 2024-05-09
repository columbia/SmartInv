1 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
2 pragma solidity ^0.4.23;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
56 pragma solidity ^0.4.23;
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
72 pragma solidity ^0.4.23;
73 
74 
75 
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender)
83     public view returns (uint256);
84 
85   function transferFrom(address from, address to, uint256 value)
86     public returns (bool);
87 
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(
90     address indexed owner,
91     address indexed spender,
92     uint256 value
93   );
94 }
95 
96 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
97 pragma solidity ^0.4.23;
98 
99 
100 
101 
102 
103 /**
104  * @title SafeERC20
105  * @dev Wrappers around ERC20 operations that throw on failure.
106  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
107  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
108  */
109 library SafeERC20 {
110   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
111     require(token.transfer(to, value));
112   }
113 
114   function safeTransferFrom(
115     ERC20 token,
116     address from,
117     address to,
118     uint256 value
119   )
120     internal
121   {
122     require(token.transferFrom(from, to, value));
123   }
124 
125   function safeApprove(ERC20 token, address spender, uint256 value) internal {
126     require(token.approve(spender, value));
127   }
128 }
129 
130 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
131 pragma solidity ^0.4.23;
132 
133 
134 
135 
136 
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   uint256 totalSupply_;
148 
149   /**
150   * @dev total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return totalSupply_;
154   }
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     emit Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public view returns (uint256) {
177     return balances[_owner];
178   }
179 
180 }
181 
182 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
183 pragma solidity ^0.4.23;
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
207   function transferFrom(
208     address _from,
209     address _to,
210     uint256 _value
211   )
212     public
213     returns (bool)
214   {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     emit Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     emit Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(
249     address _owner,
250     address _spender
251    )
252     public
253     view
254     returns (uint256)
255   {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue > oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
312 pragma solidity ^0.4.23;
313 
314 
315 /**
316  * @title Ownable
317  * @dev The Ownable contract has an owner address, and provides basic authorization control
318  * functions, this simplifies the implementation of "user permissions".
319  */
320 contract Ownable {
321   address public owner;
322 
323 
324   event OwnershipRenounced(address indexed previousOwner);
325   event OwnershipTransferred(
326     address indexed previousOwner,
327     address indexed newOwner
328   );
329 
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   constructor() public {
336     owner = msg.sender;
337   }
338 
339   /**
340    * @dev Throws if called by any account other than the owner.
341    */
342   modifier onlyOwner() {
343     require(msg.sender == owner);
344     _;
345   }
346 
347   /**
348    * @dev Allows the current owner to relinquish control of the contract.
349    */
350   function renounceOwnership() public onlyOwner {
351     emit OwnershipRenounced(owner);
352     owner = address(0);
353   }
354 
355   /**
356    * @dev Allows the current owner to transfer control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function transferOwnership(address _newOwner) public onlyOwner {
360     _transferOwnership(_newOwner);
361   }
362 
363   /**
364    * @dev Transfers control of the contract to a newOwner.
365    * @param _newOwner The address to transfer ownership to.
366    */
367   function _transferOwnership(address _newOwner) internal {
368     require(_newOwner != address(0));
369     emit OwnershipTransferred(owner, _newOwner);
370     owner = _newOwner;
371   }
372 }
373 
374 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
375 pragma solidity ^0.4.23;
376 
377 
378 
379 
380 
381 /**
382  * @title Mintable token
383  * @dev Simple ERC20 Token example, with mintable token creation
384  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
385  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
386  */
387 contract MintableToken is StandardToken, Ownable {
388   event Mint(address indexed to, uint256 amount);
389   event MintFinished();
390 
391   bool public mintingFinished = false;
392 
393 
394   modifier canMint() {
395     require(!mintingFinished);
396     _;
397   }
398 
399   modifier hasMintPermission() {
400     require(msg.sender == owner);
401     _;
402   }
403 
404   /**
405    * @dev Function to mint tokens
406    * @param _to The address that will receive the minted tokens.
407    * @param _amount The amount of tokens to mint.
408    * @return A boolean that indicates if the operation was successful.
409    */
410   function mint(
411     address _to,
412     uint256 _amount
413   )
414     hasMintPermission
415     canMint
416     public
417     returns (bool)
418   {
419     totalSupply_ = totalSupply_.add(_amount);
420     balances[_to] = balances[_to].add(_amount);
421     emit Mint(_to, _amount);
422     emit Transfer(address(0), _to, _amount);
423     return true;
424   }
425 
426   /**
427    * @dev Function to stop minting new tokens.
428    * @return True if the operation was successful.
429    */
430   function finishMinting() onlyOwner canMint public returns (bool) {
431     mintingFinished = true;
432     emit MintFinished();
433     return true;
434   }
435 }
436 
437 //File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
438 pragma solidity ^0.4.23;
439 
440 
441 
442 
443 
444 /**
445  * @title Pausable
446  * @dev Base contract which allows children to implement an emergency stop mechanism.
447  */
448 contract Pausable is Ownable {
449   event Pause();
450   event Unpause();
451 
452   bool public paused = false;
453 
454 
455   /**
456    * @dev Modifier to make a function callable only when the contract is not paused.
457    */
458   modifier whenNotPaused() {
459     require(!paused);
460     _;
461   }
462 
463   /**
464    * @dev Modifier to make a function callable only when the contract is paused.
465    */
466   modifier whenPaused() {
467     require(paused);
468     _;
469   }
470 
471   /**
472    * @dev called by the owner to pause, triggers stopped state
473    */
474   function pause() onlyOwner whenNotPaused public {
475     paused = true;
476     emit Pause();
477   }
478 
479   /**
480    * @dev called by the owner to unpause, returns to normal state
481    */
482   function unpause() onlyOwner whenPaused public {
483     paused = false;
484     emit Unpause();
485   }
486 }
487 
488 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\PausableToken.sol
489 pragma solidity ^0.4.23;
490 
491 
492 
493 
494 
495 /**
496  * @title Pausable token
497  * @dev StandardToken modified with pausable transfers.
498  **/
499 contract PausableToken is StandardToken, Pausable {
500 
501   function transfer(
502     address _to,
503     uint256 _value
504   )
505     public
506     whenNotPaused
507     returns (bool)
508   {
509     return super.transfer(_to, _value);
510   }
511 
512   function transferFrom(
513     address _from,
514     address _to,
515     uint256 _value
516   )
517     public
518     whenNotPaused
519     returns (bool)
520   {
521     return super.transferFrom(_from, _to, _value);
522   }
523 
524   function approve(
525     address _spender,
526     uint256 _value
527   )
528     public
529     whenNotPaused
530     returns (bool)
531   {
532     return super.approve(_spender, _value);
533   }
534 
535   function increaseApproval(
536     address _spender,
537     uint _addedValue
538   )
539     public
540     whenNotPaused
541     returns (bool success)
542   {
543     return super.increaseApproval(_spender, _addedValue);
544   }
545 
546   function decreaseApproval(
547     address _spender,
548     uint _subtractedValue
549   )
550     public
551     whenNotPaused
552     returns (bool success)
553   {
554     return super.decreaseApproval(_spender, _subtractedValue);
555   }
556 }
557 
558 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
559 pragma solidity ^0.4.23;
560 
561 
562 
563 
564 /**
565  * @title Burnable Token
566  * @dev Token that can be irreversibly burned (destroyed).
567  */
568 contract BurnableToken is BasicToken {
569 
570   event Burn(address indexed burner, uint256 value);
571 
572   /**
573    * @dev Burns a specific amount of tokens.
574    * @param _value The amount of token to be burned.
575    */
576   function burn(uint256 _value) public {
577     _burn(msg.sender, _value);
578   }
579 
580   function _burn(address _who, uint256 _value) internal {
581     require(_value <= balances[_who]);
582     // no need to require value <= totalSupply, since that would imply the
583     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
584 
585     balances[_who] = balances[_who].sub(_value);
586     totalSupply_ = totalSupply_.sub(_value);
587     emit Burn(_who, _value);
588     emit Transfer(_who, address(0), _value);
589   }
590 }
591 
592 //File: node_modules\openzeppelin-solidity\contracts\ownership\CanReclaimToken.sol
593 pragma solidity ^0.4.23;
594 
595 
596 
597 
598 
599 
600 /**
601  * @title Contracts that should be able to recover tokens
602  * @author SylTi
603  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
604  * This will prevent any accidental loss of tokens.
605  */
606 contract CanReclaimToken is Ownable {
607   using SafeERC20 for ERC20Basic;
608 
609   /**
610    * @dev Reclaim all ERC20Basic compatible tokens
611    * @param token ERC20Basic The address of the token contract
612    */
613   function reclaimToken(ERC20Basic token) external onlyOwner {
614     uint256 balance = token.balanceOf(this);
615     token.safeTransfer(owner, balance);
616   }
617 
618 }
619 
620 //File: contracts\ico\GotToken.sol
621 /**
622  * @title ParkinGO token
623  *
624  * @version 1.0
625  * @author ParkinGO
626  */
627 pragma solidity ^0.4.24;
628 
629 
630 
631 
632 
633 
634 
635 contract GotToken is CanReclaimToken, MintableToken, PausableToken, BurnableToken {
636     string public constant name = "GOToken";
637     string public constant symbol = "GOT";
638     uint8 public constant decimals = 18;
639 
640     /**
641      * @dev Constructor of GotToken that instantiates a new Mintable Pausable Token
642      */
643     constructor() public {
644         // token should not be transferable until after all tokens have been issued
645         paused = true;
646     }
647 }
648 
649 
650 //File: contracts\ico\PGOMonthlyInternalVault.sol
651 /**
652  * @title PGOMonthlyVault
653  * @dev A token holder contract that allows the release of tokens after a vesting period.
654  *
655  * @version 1.0
656  * @author ParkinGO
657  */
658 
659 pragma solidity ^0.4.24;
660 
661 
662 
663 
664 
665 
666 
667 contract PGOMonthlyInternalVault {
668     using SafeMath for uint256;
669     using SafeERC20 for GotToken;
670 
671     struct Investment {
672         address beneficiary;
673         uint256 totalBalance;
674         uint256 released;
675     }
676 
677     /*** CONSTANTS ***/
678     uint256 public constant VESTING_DIV_RATE = 21;                  // division rate of monthly vesting
679     uint256 public constant VESTING_INTERVAL = 30 days;             // vesting interval
680     uint256 public constant VESTING_CLIFF = 90 days;                // duration until cliff is reached
681     uint256 public constant VESTING_DURATION = 720 days;            // vesting duration
682 
683     GotToken public token;
684     uint256 public start;
685     uint256 public end;
686     uint256 public cliff;
687 
688     //Investment[] public investments;
689 
690     // key: investor address; value: index in investments array.
691     //mapping(address => uint256) public investorLUT;
692 
693     mapping(address => Investment) public investments;
694 
695     /**
696      * @dev Function to be fired by the initPGOMonthlyInternalVault function from the GotCrowdSale contract to set the
697      * InternalVault's state after deployment.
698      * @param beneficiaries Array of the internal investors addresses to whom vested tokens are transferred.
699      * @param balances Array of token amount per beneficiary.
700      * @param startTime Start time at which the first released will be executed, and from which the cliff for second
701      * release is calculated.
702      * @param _token The address of the GOT Token.
703      */
704     function init(address[] beneficiaries, uint256[] balances, uint256 startTime, address _token) public {
705         // makes sure this function is only called once
706         require(token == address(0));
707         require(beneficiaries.length == balances.length);
708 
709         start = startTime;
710         cliff = start.add(VESTING_CLIFF);
711         end = start.add(VESTING_DURATION);
712 
713         token = GotToken(_token);
714 
715         for (uint256 i = 0; i < beneficiaries.length; i = i.add(1)) {
716             investments[beneficiaries[i]] = Investment(beneficiaries[i], balances[i], 0);
717         }
718     }
719 
720     /**
721      * @dev Allows a sender to transfer vested tokens to the beneficiary's address.
722      * @param beneficiary The address that will receive the vested tokens.
723      */
724     function release(address beneficiary) public {
725         uint256 unreleased = releasableAmount(beneficiary);
726         require(unreleased > 0);
727 
728         investments[beneficiary].released = investments[beneficiary].released.add(unreleased);
729         token.safeTransfer(beneficiary, unreleased);
730     }
731 
732     /**
733      * @dev Transfers vested tokens to the sender's address.
734      */
735     function release() public {
736         release(msg.sender);
737     }
738 
739     /**
740      * @dev Allows to check an investment.
741      * @param beneficiary The address of the beneficiary of the investment to check.
742      */
743     function getInvestment(address beneficiary) public view returns(address, uint256, uint256) {
744         return (
745             investments[beneficiary].beneficiary,
746             investments[beneficiary].totalBalance,
747             investments[beneficiary].released
748         );
749     }
750 
751     /**
752      * @dev Calculates the amount that has already vested but hasn't been released yet.
753      * @param beneficiary The address that will receive the vested tokens.
754      */
755     function releasableAmount(address beneficiary) public view returns (uint256) {
756         return vestedAmount(beneficiary).sub(investments[beneficiary].released);
757     }
758 
759     /**
760      * @dev Calculates the amount that has already vested.
761      * @param beneficiary The address that will receive the vested tokens.
762      */
763     function vestedAmount(address beneficiary) public view returns (uint256) {
764         uint256 vested = 0;
765         if (block.timestamp >= cliff && block.timestamp < end) {
766             // after cliff -> 1/21 of totalBalance every month, must skip first 3 months
767             uint256 totalBalance = investments[beneficiary].totalBalance;
768             uint256 monthlyBalance = totalBalance.div(VESTING_DIV_RATE);
769             uint256 time = block.timestamp.sub(cliff);
770             uint256 elapsedOffsets = time.div(VESTING_INTERVAL);
771             uint256 vestedToSum = elapsedOffsets.mul(monthlyBalance);
772             vested = vested.add(vestedToSum);
773         }
774         if (block.timestamp >= end) {
775             // after end -> all vested
776             vested = investments[beneficiary].totalBalance;
777         }
778         return vested;
779     }
780 }
781 
782 
783 //File: contracts\ico\PGOMonthlyPresaleVault.sol
784 /**
785  * @title PGOMonthlyVault
786  * @dev A token holder contract that allows the release of tokens after a vesting period.
787  *
788  * @version 1.0
789  * @author ParkinGO
790  */
791 
792 pragma solidity ^0.4.24;
793 
794 
795 
796 
797 
798 
799 
800 
801 contract PGOMonthlyPresaleVault is PGOMonthlyInternalVault {
802     /**
803      * @dev OVERRIDE vestedAmount from PGOMonthlyInternalVault
804      * Calculates the amount that has already vested, release 1/3 of token immediately.
805      * @param beneficiary The address that will receive the vested tokens.
806      */
807     function vestedAmount(address beneficiary) public view returns (uint256) {
808         uint256 vested = 0;
809 
810         if (block.timestamp >= start) {
811             // after start -> 1/3 released (fixed)
812             vested = investments[beneficiary].totalBalance.div(3);
813         }
814         if (block.timestamp >= cliff && block.timestamp < end) {
815             // after cliff -> 1/27 of totalBalance every month, must skip first 9 month 
816             uint256 unlockedStartBalance = investments[beneficiary].totalBalance.div(3);
817             uint256 totalBalance = investments[beneficiary].totalBalance;
818             uint256 lockedBalance = totalBalance.sub(unlockedStartBalance);
819             uint256 monthlyBalance = lockedBalance.div(VESTING_DIV_RATE);
820             uint256 daysToSkip = 90 days;
821             uint256 time = block.timestamp.sub(start).sub(daysToSkip);
822             uint256 elapsedOffsets = time.div(VESTING_INTERVAL);
823             vested = vested.add(elapsedOffsets.mul(monthlyBalance));
824         }
825         if (block.timestamp >= end) {
826             // after end -> all vested
827             vested = investments[beneficiary].totalBalance;
828         }
829         return vested;
830     }
831 }