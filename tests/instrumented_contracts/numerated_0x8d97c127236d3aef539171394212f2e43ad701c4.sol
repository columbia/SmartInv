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
456 /**
457  * @title Account Lockable Token
458  */
459 contract AccountLockableToken is Ownable {
460     mapping(address => bool) public lockStates;
461 
462     event LockAccount(address indexed lockAccount);
463     event UnlockAccount(address indexed unlockAccount);
464 
465     /**
466      * @dev Throws if called by locked account
467      */
468     modifier whenNotLocked() {
469         require(!lockStates[msg.sender]);
470         _;
471     }
472 
473     /**
474      * @dev Lock target account
475      * @param _target Target account to lock
476      */
477     function lockAccount(address _target) public
478         onlyOwner
479         returns (bool)
480     {
481         require(_target != owner);
482         require(!lockStates[_target]);
483 
484         lockStates[_target] = true;
485 
486         emit LockAccount(_target);
487 
488         return true;
489     }
490 
491     /**
492      * @dev Unlock target account
493      * @param _target Target account to unlock
494      */
495     function unlockAccount(address _target) public
496         onlyOwner
497         returns (bool)
498     {
499         require(_target != owner);
500         require(lockStates[_target]);
501 
502         lockStates[_target] = false;
503 
504         emit UnlockAccount(_target);
505 
506         return true;
507     }
508 }
509 
510 // File: contracts\WithdrawableToken.sol
511 
512 /**
513  * @title Withdrawable token
514  * @dev Token that can be the withdrawal.
515  */
516 contract WithdrawableToken is BasicToken, Ownable {
517     using SafeMath for uint256;
518 
519     bool public withdrawingFinished = false;
520 
521     event Withdraw(address _from, address _to, uint256 _value);
522     event WithdrawFinished();
523 
524     modifier canWithdraw() {
525         require(!withdrawingFinished);
526         _;
527     }
528 
529     modifier hasWithdrawPermission() {
530         require(msg.sender == owner);
531         _;
532     }
533 
534     /**
535      * @dev Withdraw the amount of tokens to onwer.
536      * @param _from address The address which owner want to withdraw tokens form.
537      * @param _value uint256 the amount of tokens to be transferred.
538      */
539     function withdraw(address _from, uint256 _value) public
540         hasWithdrawPermission
541         canWithdraw
542         returns (bool)
543     {
544         require(_value <= balances[_from]);
545 
546         balances[_from] = balances[_from].sub(_value);
547         balances[owner] = balances[owner].add(_value);
548 
549         emit Transfer(_from, owner, _value);
550         emit Withdraw(_from, owner, _value);
551 
552         return true;
553     }
554 
555     /**
556      * @dev Withdraw the amount of tokens to another.
557      * @param _from address The address which owner want to withdraw tokens from.
558      * @param _to address The address which owner want to transfer to.
559      * @param _value uint256 the amount of tokens to be transferred.
560      */
561     function withdrawFrom(address _from, address _to, uint256 _value) public
562         hasWithdrawPermission
563         canWithdraw
564         returns (bool)
565     {
566         require(_value <= balances[_from]);
567         require(_to != address(0));
568 
569         balances[_from] = balances[_from].sub(_value);
570         balances[_to] = balances[_to].add(_value);
571 
572         emit Transfer(_from, _to, _value);
573         emit Withdraw(_from, _to, _value);
574 
575         return true;
576     }
577 
578     /**
579      * @dev Function to stop withdrawing new tokens.
580      * @return True if the operation was successful.
581      */
582     function finishingWithdrawing() public
583         onlyOwner
584         canWithdraw
585         returns (bool)
586     {
587         withdrawingFinished = true;
588 
589         emit WithdrawFinished();
590 
591         return true;
592     }
593 }
594 
595 // File: contracts\MilestoneLockToken.sol
596 
597 /**
598  * @title Milestone Lock Token
599  * @dev Token lock that can be the milestone policy applied.
600  */
601 contract MilestoneLockToken is StandardToken, Ownable {
602     using SafeMath for uint256;
603 
604     struct Policy {
605         uint256 kickOff;
606         uint256[] periods;
607         uint8[] percentages;
608     }
609 
610     struct MilestoneLock {
611         uint8[] policies;
612         uint256[] standardBalances;
613     }
614 
615     uint8 constant MAX_POLICY = 100;
616     uint256 constant MAX_PERCENTAGE = 100;
617 
618     mapping(uint8 => Policy) internal policies;
619     mapping(address => MilestoneLock) internal milestoneLocks;
620 
621     event SetPolicyKickOff(uint8 policy, uint256 kickOff);
622     event PolicyAdded(uint8 policy);
623     event PolicyRemoved(uint8 policy);
624     event PolicyAttributeAdded(uint8 policy, uint256 period, uint8 percentage);
625     event PolicyAttributeRemoved(uint8 policy, uint256 period);
626     event PolicyAttributeModified(uint8 policy, uint256 period, uint8 percentage);
627 
628     /**
629      * @dev Transfer token for a specified address when enough available unlock balance.
630      * @param _to The address to transfer to.
631      * @param _value The amount to be transferred.
632      */
633     function transfer(address _to, uint256 _value) public
634         returns (bool)
635     {
636         require(getAvailableBalance(msg.sender) >= _value);
637 
638         return super.transfer(_to, _value);
639     }
640 
641     /**
642      * @dev Transfer tokens from one address to another when enough available unlock balance.
643      * @param _from address The address which you want to send tokens from.
644      * @param _to address The address which you want to transfer to.
645      * @param _value uint256 the amount of tokens to be transferred.
646      */
647     function transferFrom(address _from, address _to, uint256 _value) public
648         returns (bool)
649     {
650         require(getAvailableBalance(_from) >= _value);
651 
652         return super.transferFrom(_from, _to, _value);
653     }
654 
655     /**
656      * @dev Distribute the amounts of tokens to from owner's balance with the milestone policy to a policy-free user.
657      * @param _to The address to transfer to.
658      * @param _value The amount to be transferred.
659      * @param _policy index of milestone policy to apply.
660      */
661     function distributeWithPolicy(address _to, uint256 _value, uint8 _policy) public
662         onlyOwner
663         returns (bool)
664     {
665         require(_to != address(0));
666         require(_value <= balances[owner]);
667         require(_policy < MAX_POLICY);
668         require(_checkPolicyEnabled(_policy));
669 
670         balances[owner] = balances[owner].sub(_value);
671         balances[_to] = balances[_to].add(_value);
672 
673         _setMilestoneTo(_to, _value, _policy);
674 
675         emit Transfer(owner, _to, _value);
676 
677         return true;
678     }
679 
680     /**
681      * @dev add milestone policy.
682      * @param _policy index of the milestone policy you want to add.
683      * @param _periods periods of the milestone you want to add.
684      * @param _percentages unlock percentages of the milestone you want to add.
685      */
686     function addPolicy(uint8 _policy, uint256[] _periods, uint8[] _percentages) public
687         onlyOwner
688         returns (bool)
689     {
690         require(_policy < MAX_POLICY);
691         require(!_checkPolicyEnabled(_policy));
692         require(_periods.length > 0);
693         require(_percentages.length > 0);
694         require(_periods.length == _percentages.length);
695 
696         policies[_policy].periods = _periods;
697         policies[_policy].percentages = _percentages;
698 
699         emit PolicyAdded(_policy);
700 
701         return true;
702     }
703 
704     /**
705      * @dev remove milestone policy.
706      * @param _policy index of the milestone policy you want to remove.
707      */
708     function removePolicy(uint8 _policy) public
709         onlyOwner
710         returns (bool)
711     {
712         require(_policy < MAX_POLICY);
713 
714         delete policies[_policy];
715 
716         emit PolicyRemoved(_policy);
717 
718         return true;
719     }
720 
721     /**
722      * @dev get milestone policy information.
723      * @param _policy index of milestone policy.
724      */
725     function getPolicy(uint8 _policy) public
726         view
727         returns (uint256 kickOff, uint256[] periods, uint8[] percentages)
728     {
729         require(_policy < MAX_POLICY);
730 
731         return (
732             policies[_policy].kickOff,
733             policies[_policy].periods,
734             policies[_policy].percentages
735         );
736     }
737 
738     /**
739      * @dev set milestone policy's kickoff time.
740      * @param _policy index of milestone poicy.
741      * @param _time kickoff time of policy.
742      */
743     function setKickOff(uint8 _policy, uint256 _time) public
744         onlyOwner
745         returns (bool)
746     {
747         require(_policy < MAX_POLICY);
748         require(_checkPolicyEnabled(_policy));
749 
750         policies[_policy].kickOff = _time;
751 
752         return true;
753     }
754 
755     /**
756      * @dev add attribute to milestone policy.
757      * @param _policy index of milestone policy.
758      * @param _period period of policy attribute.
759      * @param _percentage percentage of unlocking when reaching policy.
760      */
761     function addPolicyAttribute(uint8 _policy, uint256 _period, uint8 _percentage) public
762         onlyOwner
763         returns (bool)
764     {
765         require(_policy < MAX_POLICY);
766         require(_checkPolicyEnabled(_policy));
767 
768         Policy storage policy = policies[_policy];
769 
770         for (uint256 i = 0; i < policy.periods.length; i++) {
771             if (policy.periods[i] == _period) {
772                 revert();
773                 return false;
774             }
775         }
776 
777         policy.periods.push(_period);
778         policy.percentages.push(_percentage);
779 
780         emit PolicyAttributeAdded(_policy, _period, _percentage);
781 
782         return true;
783     }
784 
785     /**
786      * @dev remove attribute from milestone policy.
787      * @param _policy index of milestone policy attribute.
788      * @param _period period of target policy.
789      */
790     function removePolicyAttribute(uint8 _policy, uint256 _period) public
791         onlyOwner
792         returns (bool)
793     {
794         require(_policy < MAX_POLICY);
795 
796         Policy storage policy = policies[_policy];
797         
798         for (uint256 i = 0; i < policy.periods.length; i++) {
799             if (policy.periods[i] == _period) {
800                 _removeElementAt256(policy.periods, i);
801                 _removeElementAt8(policy.percentages, i);
802 
803                 emit PolicyAttributeRemoved(_policy, _period);
804 
805                 return true;
806             }
807         }
808 
809         revert();
810 
811         return false;
812     }
813 
814     /**
815      * @dev modify attribute from milestone policy.
816      * @param _policy index of milestone policy.
817      * @param _period period of target policy attribute.
818      * @param _percentage percentage to modified.
819      */
820     function modifyPolicyAttribute(uint8 _policy, uint256 _period, uint8 _percentage) public
821         onlyOwner
822         returns (bool)
823     {
824         require(_policy < MAX_POLICY);
825 
826         Policy storage policy = policies[_policy];
827         for (uint256 i = 0; i < policy.periods.length; i++) {
828             if (policy.periods[i] == _period) {
829                 policy.percentages[i] = _percentage;
830 
831                 emit PolicyAttributeModified(_policy, _period, _percentage);
832 
833                 return true;
834             }
835         }
836 
837         revert();
838 
839         return false;
840     }
841 
842     /**
843      * @dev get policy's locked percentage of milestone policy from now.
844      * @param _policy index of milestone policy for calculate locked percentage.
845      */
846     function getPolicyLockedPercentage(uint8 _policy) public view
847         returns (uint256)
848     {
849         require(_policy < MAX_POLICY);
850 
851         Policy storage policy = policies[_policy];
852 
853         if (policy.periods.length == 0) {
854             return 0;
855         }
856         
857         if (policy.kickOff == 0 ||
858             policy.kickOff > now) {
859             return MAX_PERCENTAGE;
860         }
861 
862         uint256 unlockedPercentage = 0;
863         for (uint256 i = 0; i < policy.periods.length; i++) {
864             if (policy.kickOff.add(policy.periods[i]) <= now) {
865                 unlockedPercentage =
866                     unlockedPercentage.add(policy.percentages[i]);
867             }
868         }
869 
870         if (unlockedPercentage > MAX_PERCENTAGE) {
871             return 0;
872         }
873 
874         return MAX_PERCENTAGE.sub(unlockedPercentage);
875     }
876 
877     /**
878      * @dev change account's milestone policy.
879      * @param _from address for milestone policy applyed from.
880      * @param _prevPolicy index of original milestone policy.
881      * @param _newPolicy index of milestone policy to be changed.
882      */
883     function modifyMilestoneFrom(address _from, uint8 _prevPolicy, uint8 _newPolicy) public
884         onlyOwner
885         returns (bool)
886     {
887         require(_from != address(0));
888         require(_prevPolicy != _newPolicy);
889         require(_prevPolicy < MAX_POLICY);
890         require(_checkPolicyEnabled(_prevPolicy));
891         require(_newPolicy < MAX_POLICY);
892         require(_checkPolicyEnabled(_newPolicy));
893 
894         uint256 prevPolicyIndex = _getAppliedPolicyIndex(_from, _prevPolicy);
895         require(prevPolicyIndex < MAX_POLICY);
896 
897         _setMilestoneTo(_from, milestoneLocks[_from].standardBalances[prevPolicyIndex], _newPolicy);
898 
899         milestoneLocks[_from].standardBalances[prevPolicyIndex] = 0;
900 
901         return true;
902     }
903 
904     /**
905      * @dev remove milestone policy from account.
906      * @param _from address for applied milestone policy removes from.
907      * @param _policy index of milestone policy remove. 
908      */
909     function removeMilestoneFrom(address _from, uint8 _policy) public
910         onlyOwner
911         returns (bool)
912     {
913         require(_from != address(0));
914         require(_policy < MAX_POLICY);
915 
916         uint256 policyIndex = _getAppliedPolicyIndex(_from, _policy);
917         require(policyIndex < MAX_POLICY);
918 
919         milestoneLocks[_from].standardBalances[policyIndex] = 0;
920 
921         return true;
922     }
923 
924     /**
925      * @dev get accounts milestone policy state information.
926      * @param _account address for milestone policy applied.
927      */
928     function getUserMilestone(address _account) public
929         view
930         returns (uint8[] accountPolicies, uint256[] standardBalances)
931     {
932         return (
933             milestoneLocks[_account].policies,
934             milestoneLocks[_account].standardBalances
935         );
936     }
937 
938     /**
939      * @dev available unlock balance.
940      * @param _account address for available unlock balance.
941      */
942     function getAvailableBalance(address _account) public
943         view
944         returns (uint256)
945     {
946         return balances[_account].sub(getTotalLockedBalance(_account));
947     }
948 
949     /**
950      * @dev calcuate locked balance of milestone policy from now.
951      * @param _account address for lock balance.
952      * @param _policy index of applied milestone policy.
953      */
954     function getLockedBalance(address _account, uint8 _policy) public
955         view
956         returns (uint256)
957     {
958         require(_policy < MAX_POLICY);
959 
960         uint256 policyIndex = _getAppliedPolicyIndex(_account, _policy);
961         if (policyIndex >= MAX_POLICY) {
962             return 0;
963         }
964 
965         MilestoneLock storage milestoneLock = milestoneLocks[_account];
966         if (milestoneLock.standardBalances[policyIndex] == 0) {
967             return 0;
968         }
969 
970         uint256 lockedPercentage =
971             getPolicyLockedPercentage(milestoneLock.policies[policyIndex]);
972         return milestoneLock.standardBalances[policyIndex].div(MAX_PERCENTAGE).mul(lockedPercentage);
973     }
974 
975     /**
976      * @dev calcuate locked balance of milestone policy from now.
977      * @param _account address for lock balance.
978      */
979     function getTotalLockedBalance(address _account) public
980         view
981         returns (uint256)
982     {
983         MilestoneLock storage milestoneLock = milestoneLocks[_account];
984 
985         uint256 totalLockedBalance = 0;
986         for (uint256 i = 0; i < milestoneLock.policies.length; i++) {
987             totalLockedBalance = totalLockedBalance.add(
988                 getLockedBalance(_account, milestoneLock.policies[i])
989             );
990         }
991 
992         return totalLockedBalance;
993     }
994 
995     /**
996      * @dev check for policy is enabled
997      * @param _policy index of milestone policy.
998      */
999     function _checkPolicyEnabled(uint8 _policy) internal
1000         view
1001         returns (bool)
1002     {
1003         return (policies[_policy].periods.length > 0);
1004     }
1005 
1006     /**
1007      * @dev get milestone policy index applied to a user.
1008      * @param _to address The address which you want get to.
1009      * @param _policy index of milestone policy applied.
1010      */
1011     function _getAppliedPolicyIndex(address _to, uint8 _policy) internal
1012         view
1013         returns (uint8)
1014     {
1015         require(_policy < MAX_POLICY);
1016 
1017         MilestoneLock storage milestoneLock = milestoneLocks[_to];
1018         for (uint8 i = 0; i < milestoneLock.policies.length; i++) {
1019             if (milestoneLock.policies[i] == _policy) {
1020                 return i;
1021             }
1022         }
1023 
1024         return MAX_POLICY;
1025     }
1026 
1027     /**
1028      * @dev set milestone policy applies to a user.
1029      * @param _to address The address which 
1030      * @param _value The amount to apply
1031      * @param _policy index of milestone policy to apply.
1032      */
1033     function _setMilestoneTo(address _to, uint256 _value, uint8 _policy) internal
1034     {
1035         uint8 policyIndex = _getAppliedPolicyIndex(_to, _policy);
1036         if (policyIndex < MAX_POLICY) {
1037             milestoneLocks[_to].standardBalances[policyIndex] = 
1038                 milestoneLocks[_to].standardBalances[policyIndex].add(_value);
1039         } else {
1040             milestoneLocks[_to].policies.push(_policy);
1041             milestoneLocks[_to].standardBalances.push(_value);
1042         }
1043     }
1044 
1045     /**
1046      * @dev utility for uint256 array
1047      * @param _array target array
1048      * @param _index array index to remove
1049      */
1050     function _removeElementAt256(uint256[] storage _array, uint256 _index) internal
1051         returns (bool)
1052     {
1053         if (_array.length <= _index) {
1054             return false;
1055         }
1056 
1057         for (uint256 i = _index; i < _array.length - 1; i++) {
1058             _array[i] = _array[i + 1];
1059         }
1060 
1061         delete _array[_array.length - 1];
1062         _array.length--;
1063 
1064         return true;
1065     }
1066 
1067     /**
1068      * @dev utility for uint8 array
1069      * @param _array target array
1070      * @param _index array index to remove
1071      */
1072     function _removeElementAt8(uint8[] storage _array, uint256 _index) internal
1073         returns (bool)
1074     {
1075         if (_array.length <= _index) {
1076             return false;
1077         }
1078 
1079         for (uint256 i = _index; i < _array.length - 1; i++) {
1080             _array[i] = _array[i + 1];
1081         }
1082 
1083         delete _array[_array.length - 1];
1084         _array.length--;
1085 
1086         return true;
1087     }
1088 }
1089 
1090 // File: contracts\Hena.sol
1091 
1092 /**
1093  * @title Hena token
1094  */
1095 contract Hena is
1096     Pausable,
1097     MintableToken,
1098     BurnableToken,
1099     AccountLockableToken,
1100     WithdrawableToken,
1101     MilestoneLockToken
1102 {
1103     uint256 constant MAX_SUFFLY = 1000000000;
1104 
1105     string public name;
1106     string public symbol;
1107     uint8 public decimals;
1108 
1109     constructor() public
1110     {
1111         name = "Hena";
1112         symbol = "HENA";
1113         decimals = 18;
1114         totalSupply_ = MAX_SUFFLY * (10 ** uint(decimals));
1115 
1116         balances[owner] = totalSupply_;
1117 
1118         emit Transfer(address(0), owner, totalSupply_);
1119     }
1120 
1121     function() public
1122     {
1123         revert();
1124     }
1125 
1126     /**
1127      * @dev Transfer token for a specified address when if not paused and not locked account
1128      * @param _to The address to transfer to.
1129      * @param _value The amount to be transferred.
1130      */
1131     function transfer(address _to, uint256 _value) public
1132         whenNotPaused
1133         whenNotLocked
1134         returns (bool)
1135     {
1136         return super.transfer(_to, _value);
1137     }
1138 
1139     /**
1140      * @dev Transfer tokens from one address to anther when if not paused and not locked account
1141      * @param _from address The address which you want to send tokens from.
1142      * @param _to address The address which you want to transfer to.
1143      * @param _value uint256 the amount of tokens to be transferred.
1144      */
1145     function transferFrom(address _from, address _to, uint256 _value) public
1146         whenNotPaused
1147         whenNotLocked
1148         returns (bool)
1149     {
1150         require(!lockStates[_from]);
1151 
1152         return super.transferFrom(_from, _to, _value);
1153     }
1154 
1155     /**
1156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
1157        when if not paused and not locked account
1158      * @param _spender The address which will spend the funds.
1159      * @param _value The amount of tokens to be spent.
1160      */
1161     function approve(address _spender, uint256 _value) public
1162         whenNotPaused
1163         whenNotLocked
1164         returns (bool)
1165     {
1166         return super.approve(_spender, _value);
1167     }
1168 
1169     /**
1170      * @dev Increase the amount of tokens that an owner allowed to a spender when if not paused and not locked account
1171      * @param _spender address which will spend the funds.
1172      * @param _addedValue amount of tokens to increase the allowance by.
1173      */
1174     function increaseApproval(address _spender, uint256 _addedValue) public
1175         whenNotPaused
1176         whenNotLocked
1177         returns (bool)
1178     {
1179         return super.increaseApproval(_spender, _addedValue);
1180     }
1181 
1182     /**
1183      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1184      * @param _spender address which will spend the funds.
1185      * @param _subtractedValue amount of tokens to decrease the allowance by.
1186      */
1187     function decreaseApproval(address _spender, uint256 _subtractedValue) public
1188         whenNotPaused
1189         whenNotLocked
1190         returns (bool)
1191     {
1192         return super.decreaseApproval(_spender, _subtractedValue);
1193     }
1194 
1195     /**
1196      * @dev Distribute the amount of tokens to owner's balance.
1197      * @param _to The address to transfer to.
1198      * @param _value The amount to be transferred.
1199      */
1200     function distribute(address _to, uint256 _value) public
1201         onlyOwner
1202         returns (bool)
1203     {
1204         require(_to != address(0));
1205         require(_value <= balances[owner]);
1206 
1207         balances[owner] = balances[owner].sub(_value);
1208         balances[_to] = balances[_to].add(_value);
1209 
1210         emit Transfer(owner, _to, _value);
1211 
1212         return true;
1213     }
1214 
1215     /**
1216      * @dev Burns a specific amount of tokens by owner.
1217      * @param _value The amount of token to be burned.
1218      */
1219     function burn(uint256 _value) public
1220         onlyOwner
1221     {
1222         super.burn(_value);
1223     }
1224 
1225     /**
1226      * @dev batch to the policy to account's available balance.
1227      * @param _policy index of milestone policy to apply.
1228      * @param _addresses The addresses to apply.
1229      */
1230     function batchToApplyMilestone(uint8 _policy, address[] _addresses) public
1231         onlyOwner
1232         returns (bool[])
1233     {
1234         require(_policy < MAX_POLICY);
1235         require(_checkPolicyEnabled(_policy));
1236         require(_addresses.length > 0);
1237 
1238         bool[] memory results = new bool[](_addresses.length);
1239         for (uint256 i = 0; i < _addresses.length; i++) {
1240             results[i] = false;
1241             if (_addresses[i] != address(0)) {
1242                 uint256 availableBalance = getAvailableBalance(_addresses[i]);
1243                 results[i] = (availableBalance > 0);
1244                 if (results[i]) {
1245                     _setMilestoneTo(_addresses[i], availableBalance, _policy);
1246                 }
1247             }
1248         }
1249 
1250         return results;
1251     }
1252 }