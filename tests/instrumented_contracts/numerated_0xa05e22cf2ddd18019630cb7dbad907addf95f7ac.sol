1 pragma solidity ^0.4.24;
2 
3 // File: contracts\openzeppelin-solidity\contracts\ownership\Ownable.sol
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
67 // File: contracts\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 // File: contracts\openzeppelin-solidity\contracts\math\SafeMath.sol
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that throw on error
132  */
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
139     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
140     // benefit is lost if 'b' is also tested.
141     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142     if (_a == 0) {
143       return 0;
144     }
145 
146     c = _a * _b;
147     assert(c / _a == _b);
148     return c;
149   }
150 
151   /**
152   * @dev Integer division of two numbers, truncating the quotient.
153   */
154   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
155     // assert(_b > 0); // Solidity automatically throws when dividing by 0
156     // uint256 c = _a / _b;
157     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
158     return _a / _b;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
163   */
164   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
165     assert(_b <= _a);
166     return _a - _b;
167   }
168 
169   /**
170   * @dev Adds two numbers, throws on overflow.
171   */
172   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
173     c = _a + _b;
174     assert(c >= _a);
175     return c;
176   }
177 }
178 
179 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) internal balances;
189 
190   uint256 internal totalSupply_;
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev Transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_value <= balances[msg.sender]);
206     require(_to != address(0));
207 
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     emit Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) public view returns (uint256) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
226 
227 /**
228  * @title ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20 is ERC20Basic {
232   function allowance(address _owner, address _spender)
233     public view returns (uint256);
234 
235   function transferFrom(address _from, address _to, uint256 _value)
236     public returns (bool);
237 
238   function approve(address _spender, uint256 _value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
247 
248 /**
249  * @title Standard ERC20 token
250  *
251  * @dev Implementation of the basic standard token.
252  * https://github.com/ethereum/EIPs/issues/20
253  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
254  */
255 contract StandardToken is ERC20, BasicToken {
256 
257   mapping (address => mapping (address => uint256)) internal allowed;
258 
259 
260   /**
261    * @dev Transfer tokens from one address to another
262    * @param _from address The address which you want to send tokens from
263    * @param _to address The address which you want to transfer to
264    * @param _value uint256 the amount of tokens to be transferred
265    */
266   function transferFrom(
267     address _from,
268     address _to,
269     uint256 _value
270   )
271     public
272     returns (bool)
273   {
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276     require(_to != address(0));
277 
278     balances[_from] = balances[_from].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     emit Transfer(_from, _to, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     emit Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(
307     address _owner,
308     address _spender
309    )
310     public
311     view
312     returns (uint256)
313   {
314     return allowed[_owner][_spender];
315   }
316 
317   /**
318    * @dev Increase the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(
327     address _spender,
328     uint256 _addedValue
329   )
330     public
331     returns (bool)
332   {
333     allowed[msg.sender][_spender] = (
334       allowed[msg.sender][_spender].add(_addedValue));
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(
349     address _spender,
350     uint256 _subtractedValue
351   )
352     public
353     returns (bool)
354   {
355     uint256 oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue >= oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
368 
369 /**
370  * @title Mintable token
371  * @dev Simple ERC20 Token example, with mintable token creation
372  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
373  */
374 contract MintableToken is StandardToken, Ownable {
375   event Mint(address indexed to, uint256 amount);
376   event MintFinished();
377 
378   bool public mintingFinished = false;
379 
380 
381   modifier canMint() {
382     require(!mintingFinished);
383     _;
384   }
385 
386   modifier hasMintPermission() {
387     require(msg.sender == owner);
388     _;
389   }
390 
391   /**
392    * @dev Function to mint tokens
393    * @param _to The address that will receive the minted tokens.
394    * @param _amount The amount of tokens to mint.
395    * @return A boolean that indicates if the operation was successful.
396    */
397   function mint(
398     address _to,
399     uint256 _amount
400   )
401     public
402     hasMintPermission
403     canMint
404     returns (bool)
405   {
406     totalSupply_ = totalSupply_.add(_amount);
407     balances[_to] = balances[_to].add(_amount);
408     emit Mint(_to, _amount);
409     emit Transfer(address(0), _to, _amount);
410     return true;
411   }
412 
413   /**
414    * @dev Function to stop minting new tokens.
415    * @return True if the operation was successful.
416    */
417   function finishMinting() public onlyOwner canMint returns (bool) {
418     mintingFinished = true;
419     emit MintFinished();
420     return true;
421   }
422 }
423 
424 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
425 
426 /**
427  * @title Burnable Token
428  * @dev Token that can be irreversibly burned (destroyed).
429  */
430 contract BurnableToken is BasicToken {
431 
432   event Burn(address indexed burner, uint256 value);
433 
434   /**
435    * @dev Burns a specific amount of tokens.
436    * @param _value The amount of token to be burned.
437    */
438   function burn(uint256 _value) public {
439     _burn(msg.sender, _value);
440   }
441 
442   function _burn(address _who, uint256 _value) internal {
443     require(_value <= balances[_who]);
444     // no need to require value <= totalSupply, since that would imply the
445     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
446 
447     balances[_who] = balances[_who].sub(_value);
448     totalSupply_ = totalSupply_.sub(_value);
449     emit Burn(_who, _value);
450     emit Transfer(_who, address(0), _value);
451   }
452 }
453 
454 // File: contracts\AccountLockableToken.sol
455 
456 contract AccountLockableToken is Ownable {
457     mapping(address => bool) public lockStates;
458 
459     event LockAccount(address indexed lockAccount);
460     event UnlockAccount(address indexed unlockAccount);
461 
462     /**
463      * @dev Throws if called by locked account
464      */
465     modifier whenNotLocked() {
466         require(!lockStates[msg.sender]);
467         _;
468     }
469 
470     /**
471      * @dev Lock target account
472      * @param _target Target account to lock
473      */
474     function lockAccount(address _target) public onlyOwner returns (bool) {
475         require(_target != owner);
476         require(!lockStates[_target]);
477 
478         lockStates[_target] = true;
479 
480         emit LockAccount(_target);
481 
482         return true;
483     }
484 
485     /**
486      * @dev Unlock target account
487      * @param _target Target account to unlock
488      */
489     function unlockAccount(address _target) public onlyOwner returns (bool) {
490         require(_target != owner);
491         require(lockStates[_target]);
492 
493         lockStates[_target] = false;
494 
495         emit UnlockAccount(_target);
496 
497         return true;
498     }
499 }
500 
501 // File: contracts\WithdrawableToken.sol
502 
503 contract WithdrawableToken is BasicToken, Ownable {
504     using SafeMath for uint256;
505 
506     bool public withdrawingFinished = false;
507 
508     event Withdraw(address _from, address _to, uint256 _value);
509     event WithdrawFinished();
510 
511     modifier canWithdraw() {
512         require(!withdrawingFinished);
513         _;
514     }
515 
516     modifier hasWithdrawPermission() {
517         require(msg.sender == owner);
518         _;
519     }
520 
521     /**
522      * @dev Withdraw the amount of tokens to onwer.
523      * @param _from address The address which owner want to withdraw tokens form.
524      * @param _value uint256 the amount of tokens to be transferred.
525      */
526     function withdraw(address _from, uint256 _value) public
527         hasWithdrawPermission
528         canWithdraw
529         returns (bool)
530     {
531         require(_value <= balances[_from]);
532 
533         balances[_from] = balances[_from].sub(_value);
534         balances[owner] = balances[owner].add(_value);
535 
536         emit Withdraw(_from, owner, _value);
537 
538         return true;
539     }
540 
541     /**
542      * @dev Withdraw the amount of tokens to another.
543      * @param _from address The address which owner want to withdraw tokens from.
544      * @param _to address The address which owner want to transfer to.
545      * @param _value uint256 the amount of tokens to be transferred.
546      */
547     function withdrawFrom(address _from, address _to, uint256 _value) public
548         hasWithdrawPermission
549         canWithdraw
550         returns (bool)
551     {
552         require(_value <= balances[_from]);
553         require(_to != address(0));
554 
555         balances[_from] = balances[_from].sub(_value);
556         balances[_to] = balances[_to].add(_value);
557 
558         emit Withdraw(_from, _to, _value);
559 
560         return true;
561     }
562 
563     /**
564      * @dev Function to stop withdrawing new tokens.
565      * @return True if the operation was successful.
566      */
567     function finishingWithdrawing() public
568         onlyOwner
569         canWithdraw
570         returns (bool)
571     {
572         withdrawingFinished = true;
573 
574         emit WithdrawFinished();
575 
576         return true;
577     }
578 }
579 
580 // File: contracts\openzeppelin-solidity\contracts\math\Math.sol
581 
582 /**
583  * @title Math
584  * @dev Assorted math operations
585  */
586 library Math {
587   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
588     return _a >= _b ? _a : _b;
589   }
590 
591   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
592     return _a < _b ? _a : _b;
593   }
594 
595   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
596     return _a >= _b ? _a : _b;
597   }
598 
599   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
600     return _a < _b ? _a : _b;
601   }
602 }
603 
604 // File: contracts\MilestoneLockToken.sol
605 
606 contract MilestoneLockToken is StandardToken, Ownable {
607     using SafeMath for uint256;
608 
609     struct Policy {
610         uint256 kickOff;
611         uint256[] periods;
612         uint8[] percentages;
613     }
614 
615     struct MilestoneLock {
616         uint8[] policies;
617         uint256[] standardBalances;
618     }
619 
620     uint8 constant MAX_POLICY = 100;
621     uint256 constant MAX_PERCENTAGE = 100;
622 
623     mapping(uint8 => Policy) internal policies;
624     mapping(address => MilestoneLock) internal milestoneLocks;
625 
626     event SetPolicyKickOff(uint8 policy, uint256 kickOff);
627     event PolicyAdded(uint8 policy);
628     event PolicyRemoved(uint8 policy);
629     event PolicyAttributeAdded(uint8 policy, uint256 period, uint8 percentage);
630     event PolicyAttributeRemoved(uint8 policy, uint256 period);
631     event PolicyAttributeModified(uint8 policy, uint256 period, uint8 percentage);
632 
633     /**
634      * @dev Transfer token for a specified address when enough available unlock balance.
635      * @param _to The address to transfer to.
636      * @param _value The amount to be transferred.
637      */
638     function transfer(address _to, uint256 _value) public
639         returns (bool)
640     {
641         require(getAvailableBalance(msg.sender) >= _value);
642 
643         return super.transfer(_to, _value);
644     }
645 
646     /**
647      * @dev Transfer tokens from one address to another when enough available unlock balance.
648      * @param _from address The address which you want to send tokens from.
649      * @param _to address The address which you want to transfer to.
650      * @param _value uint256 the amount of tokens to be transferred.
651      */
652     function transferFrom(address _from, address _to, uint256 _value) public
653         returns (bool)
654     {
655         require(getAvailableBalance(_from) >= _value);
656 
657         return super.transferFrom(_from, _to, _value);
658     }
659 
660     /**
661      * @dev Distribute the amounts of tokens to from owner's balance with the milestone policy to a policy-free user.
662      * @param _to The address to transfer to.
663      * @param _value The amount to be transferred.
664      * @param _policy index of milestone policy to apply.
665      */
666     function distributeWithPolicy(address _to, uint256 _value, uint8 _policy) public
667         onlyOwner
668         returns (bool)
669     {
670         require(_to != address(0));
671         require(_value <= balances[owner]);
672         require(_policy < MAX_POLICY);
673         require(policies[_policy].periods.length > 0);
674 
675         balances[owner] = balances[owner].sub(_value);
676         balances[_to] = balances[_to].add(_value);
677 
678         uint8 policyIndex = _getAppliedPolicyIndex(_to, _policy);
679         if (policyIndex < MAX_POLICY) {
680             milestoneLocks[_to].standardBalances[policyIndex] = 
681                 milestoneLocks[_to].standardBalances[policyIndex].add(_value);
682         } else {
683             milestoneLocks[_to].policies.push(_policy);
684             milestoneLocks[_to].standardBalances.push(_value);
685         }
686 
687         emit Transfer(owner, _to, _value);
688 
689         return true;
690     }
691 
692     /**
693      * @dev add milestone policy.
694      * @param _policy index of the milestone policy you want to add.
695      * @param _periods periods of the milestone you want to add.
696      * @param _percentages unlock percentages of the milestone you want to add.
697      */
698     function addPolicy(uint8 _policy, uint256[] _periods, uint8[] _percentages) public
699         onlyOwner
700         returns (bool)
701     {
702         require(_policy < MAX_POLICY);
703         require(_periods.length > 0);
704         require(_percentages.length > 0);
705         require(_periods.length == _percentages.length);
706         require(policies[_policy].periods.length == 0);
707 
708         policies[_policy].periods = _periods;
709         policies[_policy].percentages = _percentages;
710 
711         emit PolicyAdded(_policy);
712 
713         return true;
714     }
715 
716     /**
717      * @dev remove milestone policy.
718      * @param _policy index of the milestone policy you want to remove.
719      */
720     function removePolicy(uint8 _policy) public
721         onlyOwner
722         returns (bool)
723     {
724         require(_policy < MAX_POLICY);
725 
726         delete policies[_policy];
727 
728         emit PolicyRemoved(_policy);
729 
730         return true;
731     }
732 
733     /**
734      * @dev get milestone policy information.
735      * @param _policy index of milestone policy.
736      */
737     function getPolicy(uint8 _policy) public
738         view
739         returns (uint256, uint256[], uint8[])
740     {
741         require(_policy < MAX_POLICY);
742 
743         return (
744             policies[_policy].kickOff,
745             policies[_policy].periods,
746             policies[_policy].percentages
747         );
748     }
749 
750     /**
751      * @dev set kickoff
752      * @param _policy index of milestone poicy.
753      * @param _time kickoff time of policy.
754      */
755     function setKickOff(uint8 _policy, uint256 _time) public
756         onlyOwner
757         returns (bool)
758     {
759         require(_policy < MAX_POLICY);
760         require(policies[_policy].periods.length > 0);
761 
762         policies[_policy].kickOff = _time;
763 
764         return true;
765     }
766 
767     /**
768      * @dev add attribute to milestone policy.
769      * @param _policy index of milestone policy.
770      * @param _period period of policy.
771      * @param _percentage percentage of unlocking when reaching policy.
772      */
773     function addPolicyAttribute(uint8 _policy, uint256 _period, uint8 _percentage) public
774         onlyOwner
775         returns (bool)
776     {
777         require(_policy < MAX_POLICY);
778 
779         Policy storage policy = policies[_policy];
780 
781         for (uint256 i = 0; i < policy.periods.length; i++) {
782             if (policy.periods[i] == _period) {
783                 revert();
784                 return false;
785             }
786         }
787 
788         policy.periods.push(_period);
789         policy.percentages.push(_percentage);
790 
791         emit PolicyAttributeAdded(_policy, _period, _percentage);
792 
793         return true;
794     }
795 
796     /**
797      * @dev remove attribute from milestone policy.
798      * @param _policy index of milestone policy.
799      * @param _period period of target policy.
800      */
801     function removePolicyAttribute(uint8 _policy, uint256 _period) public
802         onlyOwner
803         returns (bool)
804     {
805         require(_policy < MAX_POLICY);
806 
807         Policy storage policy = policies[_policy];
808         
809         for (uint256 i = 0; i < policy.periods.length; i++) {
810             if (policy.periods[i] == _period) {
811                 _removeElementAt256(policy.periods, i);
812                 _removeElementAt8(policy.percentages, i);
813 
814                 emit PolicyAttributeRemoved(_policy, _period);
815 
816                 return true;
817             }
818         }
819 
820         revert();
821 
822         return false;
823     }
824 
825     /**
826      * @dev modify attribute from milestone policy.
827      * @param _policy index of milestone policy.
828      * @param _period period of target policy.
829      * @param _percentage percentage to modified.
830      */
831     function modifyPolicyAttribute(uint8 _policy, uint256 _period, uint8 _percentage) public
832         onlyOwner
833         returns (bool)
834     {
835         require(_policy < MAX_POLICY);
836 
837         Policy storage policy = policies[_policy];
838         for (uint256 i = 0; i < policy.periods.length; i++) {
839             if (policy.periods[i] == _period) {
840                 policy.percentages[i] = _percentage;
841 
842                 emit PolicyAttributeModified(_policy, _period, _percentage);
843 
844                 return true;
845             }
846         }
847 
848         revert();
849 
850         return false;
851     }
852 
853     /**
854      * @dev get policy's locked percentage of milestone policy from now.
855      * @param _policy index of milestone policy for calculate locked percentage.
856      */
857     function getPolicyLockedPercentage(uint8 _policy) public view
858         returns (uint256)
859     {
860         require(_policy < MAX_POLICY);
861 
862         Policy storage policy = policies[_policy];
863 
864         if (policy.periods.length == 0) {
865             return 0;
866         }
867         
868         if (policy.kickOff == 0 ||
869             policy.kickOff > now) {
870             return MAX_PERCENTAGE;
871         }
872 
873         uint256 unlockedPercentage = 0;
874         for (uint256 i = 0; i < policy.periods.length; ++i) {
875             if (policy.kickOff + policy.periods[i] <= now) {
876                 unlockedPercentage =
877                     unlockedPercentage.add(policy.percentages[i]);
878             }
879         }
880 
881         if (unlockedPercentage > MAX_PERCENTAGE) {
882             return 0;
883         }
884 
885         return MAX_PERCENTAGE - unlockedPercentage;
886     }
887 
888     /**
889      * @dev change account's milestone policy.
890      * @param _to address for milestone policy applyed to.
891      * @param _prevPolicy index of original milestone policy.
892      * @param _newPolicy index of milestone policy to be changed.
893     */
894     function modifyMilestoneTo(address _to, uint8 _prevPolicy, uint8 _newPolicy) public
895         onlyOwner
896         returns (bool)
897     {
898         require(_to != address(0));
899         require(_prevPolicy < MAX_POLICY);
900         require(_newPolicy < MAX_POLICY);
901         require(_prevPolicy != _newPolicy);
902         require(policies[_prevPolicy].periods.length > 0);
903         require(policies[_newPolicy].periods.length > 0);
904 
905         uint256 prevPolicyIndex = _getAppliedPolicyIndex(_to, _prevPolicy);
906         require(prevPolicyIndex < MAX_POLICY);
907 
908         MilestoneLock storage milestoneLock = milestoneLocks[_to];
909 
910         uint256 prevLockedBalance = milestoneLock.standardBalances[prevPolicyIndex];
911 
912         uint256 newPolicyIndex = _getAppliedPolicyIndex(_to, _newPolicy);
913         if (newPolicyIndex < MAX_POLICY) {
914             milestoneLock.standardBalances[newPolicyIndex] =
915                 milestoneLock.standardBalances[newPolicyIndex].add(prevLockedBalance);
916 
917             _removeElementAt8(milestoneLock.policies, prevPolicyIndex);
918             _removeElementAt256(milestoneLock.standardBalances, prevPolicyIndex);
919         } else {
920             milestoneLock.policies.push(_newPolicy);
921             milestoneLock.standardBalances.push(prevLockedBalance);
922         }
923 
924         return true;
925     }
926 
927     /**
928      * @dev remove milestone policy from account.
929      * @param _from address for applied milestone policy removes from.
930      * @param _policy index of milestone policy remove. 
931      */
932     function removeMilestoneFrom(address _from, uint8 _policy) public
933         onlyOwner
934         returns (bool)
935     {
936         require(_from != address(0));
937         require(_policy < MAX_POLICY);
938 
939         uint256 policyIndex = _getAppliedPolicyIndex(_from, _policy);
940         require(policyIndex < MAX_POLICY);
941 
942         _removeElementAt8(milestoneLocks[_from].policies, policyIndex);
943         _removeElementAt256(milestoneLocks[_from].standardBalances, policyIndex);
944 
945         return true;
946     }
947 
948     /**
949      * @dev get accounts milestone policy state information.
950      * @param _account address for milestone policy applied.
951      */
952     function getUserMilestone(address _account) public view
953         returns (uint8[], uint256[])
954     {
955         return (
956             milestoneLocks[_account].policies,
957             milestoneLocks[_account].standardBalances
958         );
959     }
960 
961     /**
962      * @dev available unlock balance.
963      * @param _account address for available unlock balance.
964      */
965     function getAvailableBalance(address _account) public view
966         returns (uint256)
967     {
968         return balances[_account].sub(getTotalLockedBalance(_account));
969     }
970 
971     /**
972      * @dev calcuate locked balance of milestone policy from now.
973      * @param _account address for lock balance.
974      * @param _policy index of applied milestone policy.
975      */
976     function getLockedBalance(address _account, uint8 _policy) public view
977         returns (uint256)
978     {
979         require(_policy < MAX_POLICY);
980 
981         uint256 policyIndex = _getAppliedPolicyIndex(_account, _policy);
982         if (policyIndex >= MAX_POLICY) {
983             return 0;
984         }
985 
986         MilestoneLock storage milestoneLock = milestoneLocks[_account];
987 
988         uint256 lockedPercentage =
989             getPolicyLockedPercentage(milestoneLock.policies[policyIndex]);
990         return milestoneLock.standardBalances[policyIndex].div(MAX_PERCENTAGE).mul(lockedPercentage);
991     }
992 
993     /**
994      * @dev calcuate locked balance of milestone policy from now.
995      * @param _account address for lock balance.
996      */
997     function getTotalLockedBalance(address _account) public view
998         returns (uint256)
999     {
1000         MilestoneLock storage milestoneLock = milestoneLocks[_account];
1001 
1002         uint256 totalLockedBalance = 0;
1003         for (uint256 i = 0; i < milestoneLock.policies.length; i++) {
1004             totalLockedBalance = totalLockedBalance.add(
1005                 getLockedBalance(_account, milestoneLock.policies[i])
1006             );
1007         }
1008 
1009         return totalLockedBalance;
1010     }
1011 
1012     /**
1013      * @dev get milestone policy index applied to user.
1014      * @param _to address The address which you want get to.
1015      * @param _policy index of meilstone policy applied.
1016      */
1017     function _getAppliedPolicyIndex(address _to, uint8 _policy) internal view
1018         returns (uint8)
1019     {
1020         require(_policy < MAX_POLICY);
1021 
1022         MilestoneLock storage milestoneLock = milestoneLocks[_to];
1023         for (uint8 i = 0; i < milestoneLock.policies.length; i++) {
1024             if (milestoneLock.policies[i] == _policy) {
1025                 return i;
1026             }
1027         }
1028 
1029         return MAX_POLICY;
1030     }
1031 
1032     /**
1033      * @dev utility for uint256 array
1034      * @param _array target array
1035      * @param _index array index to remove
1036      */
1037     function _removeElementAt256(uint256[] storage _array, uint256 _index) internal
1038         returns (bool)
1039     {
1040         if (_array.length <= _index) {
1041             return false;
1042         }
1043 
1044         for (uint256 i = _index; i < _array.length - 1; i++) {
1045             _array[i] = _array[i + 1];
1046         }
1047 
1048         delete _array[_array.length - 1];
1049         _array.length--;
1050 
1051         return true;
1052     }
1053 
1054     /**
1055      * @dev utility for uint8 array
1056      * @param _array target array
1057      * @param _index array index to remove
1058      */
1059     function _removeElementAt8(uint8[] storage _array, uint256 _index) internal
1060         returns (bool)
1061     {
1062         if (_array.length <= _index) {
1063             return false;
1064         }
1065 
1066         for (uint256 i = _index; i < _array.length - 1; i++) {
1067             _array[i] = _array[i + 1];
1068         }
1069 
1070         delete _array[_array.length - 1];
1071         _array.length--;
1072 
1073         return true;
1074     }
1075 }
1076 
1077 // File: contracts\dHena.sol
1078 
1079 /**
1080  * @title Hena token
1081  */
1082 contract dHena is
1083     Pausable,
1084     MintableToken,
1085     BurnableToken,
1086     AccountLockableToken,
1087     WithdrawableToken,
1088     MilestoneLockToken
1089 {
1090     uint256 constant MAX_SUFFLY = 1000000000;
1091 
1092     string public name;
1093     string public symbol;
1094     uint8 public decimals;
1095 
1096     constructor() public {
1097         name = "dHena";
1098         symbol = "DHENA";
1099         decimals = 18;
1100         totalSupply_ = MAX_SUFFLY * 10 ** uint(decimals);
1101 
1102         balances[owner] = totalSupply_;
1103 
1104         emit Transfer(address(0), owner, totalSupply_);
1105     }
1106 
1107     /**
1108      * @dev Transfer token for a specified address when if not paused and not locked account
1109      * @param _to The address to transfer to.
1110      * @param _value The amount to be transferred.
1111      */
1112     function transfer(address _to, uint256 _value) public
1113         whenNotPaused
1114         whenNotLocked
1115         returns (bool)
1116     {
1117         return super.transfer(_to, _value);
1118     }
1119 
1120     /**
1121      * @dev Transfer tokens from one address to anther when if not paused and not locked account
1122      * @param _from address The address which you want to send tokens from.
1123      * @param _to address The address which you want to transfer to.
1124      * @param _value uint256 the amount of tokens to be transferred.
1125      */
1126     function transferFrom(address _from, address _to, uint256 _value) public
1127         whenNotPaused
1128         whenNotLocked
1129         returns (bool)
1130     {
1131         require(!lockStates[_from]);
1132 
1133         return super.transferFrom(_from, _to, _value);
1134     }
1135 
1136     /**
1137      * @dev Increase the amount of tokens that an owner allowed to a spender when if not paused and not locked account
1138      * @param _spender address which will spend the funds.
1139      * @param _addedValue amount of tokens to increase the allowance by.
1140      */
1141     function increaseApproval(address _spender, uint256 _addedValue) public
1142         whenNotPaused
1143         whenNotLocked
1144         returns (bool)
1145     {
1146         return super.increaseApproval(_spender, _addedValue);
1147     }
1148 
1149     /**
1150      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1151      * @param _spender address which will spend the funds.
1152      * @param _subtractedValue amount of tokens to decrease the allowance by.
1153      */
1154     function decreaseApproval(address _spender, uint256 _subtractedValue) public
1155         whenNotPaused
1156         whenNotLocked
1157         returns (bool)
1158     {
1159         return super.decreaseApproval(_spender, _subtractedValue);
1160     }
1161 
1162     /**
1163      * @dev Distribute the amount of tokens to owner's balance.
1164      * @param _to The address to transfer to.
1165      * @param _value The amount to be transffered.
1166      */
1167     function distribute(address _to, uint256 _value) public
1168         onlyOwner
1169         returns (bool)
1170     {
1171         require(_to != address(0));
1172         require(_value <= balances[owner]);
1173 
1174         balances[owner] = balances[owner].sub(_value);
1175         balances[_to] = balances[_to].add(_value);
1176 
1177         emit Transfer(owner, _to, _value);
1178 
1179         return true;
1180     }
1181 }