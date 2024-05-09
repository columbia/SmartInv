1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Pausable is Ownable {
107   event Pause();
108   event Unpause();
109 
110   bool public paused = false;
111 
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyOwner whenPaused {
141     paused = false;
142     emit Unpause();
143   }
144 }
145 
146 contract TokenDestructible is Ownable {
147 
148   constructor() public payable { }
149 
150   /**
151    * @notice Terminate contract and refund to owner
152    * @param _tokens List of addresses of ERC20 or ERC20Basic token contracts to
153    refund.
154    * @notice The called token contracts could try to re-enter this contract. Only
155    supply token contracts you trust.
156    */
157   function destroy(address[] _tokens) public onlyOwner {
158 
159     // Transfer tokens to owner
160     for (uint256 i = 0; i < _tokens.length; i++) {
161       ERC20Basic token = ERC20Basic(_tokens[i]);
162       uint256 balance = token.balanceOf(this);
163       token.transfer(owner, balance);
164     }
165 
166     // Transfer Eth to owner and terminate contract
167     selfdestruct(owner);
168   }
169 }
170 
171 contract ERC20Basic {
172   function totalSupply() public view returns (uint256);
173   function balanceOf(address _who) public view returns (uint256);
174   function transfer(address _to, uint256 _value) public returns (bool);
175   event Transfer(address indexed from, address indexed to, uint256 value);
176 }
177 
178 contract BasicToken is ERC20Basic {
179   using SafeMath for uint256;
180 
181   mapping(address => uint256) internal balances;
182 
183   uint256 internal totalSupply_;
184 
185   /**
186   * @dev Total number of tokens in existence
187   */
188   function totalSupply() public view returns (uint256) {
189     return totalSupply_;
190   }
191 
192   /**
193   * @dev Transfer token for a specified address
194   * @param _to The address to transfer to.
195   * @param _value The amount to be transferred.
196   */
197   function transfer(address _to, uint256 _value) public returns (bool) {
198     require(_value <= balances[msg.sender]);
199     require(_to != address(0));
200 
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     emit Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) public view returns (uint256) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 contract ERC20 is ERC20Basic {
219   function allowance(address _owner, address _spender)
220     public view returns (uint256);
221 
222   function transferFrom(address _from, address _to, uint256 _value)
223     public returns (bool);
224 
225   function approve(address _spender, uint256 _value) public returns (bool);
226   event Approval(
227     address indexed owner,
228     address indexed spender,
229     uint256 value
230   );
231 }
232 
233 contract StandardToken is ERC20, BasicToken {
234 
235   mapping (address => mapping (address => uint256)) internal allowed;
236 
237 
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param _from address The address which you want to send tokens from
241    * @param _to address The address which you want to transfer to
242    * @param _value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(
245     address _from,
246     address _to,
247     uint256 _value
248   )
249     public
250     returns (bool)
251   {
252     require(_value <= balances[_from]);
253     require(_value <= allowed[_from][msg.sender]);
254     require(_to != address(0));
255 
256     balances[_from] = balances[_from].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259     emit Transfer(_from, _to, _value);
260     return true;
261   }
262 
263   /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param _spender The address which will spend the funds.
270    * @param _value The amount of tokens to be spent.
271    */
272   function approve(address _spender, uint256 _value) public returns (bool) {
273     allowed[msg.sender][_spender] = _value;
274     emit Approval(msg.sender, _spender, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Function to check the amount of tokens that an owner allowed to a spender.
280    * @param _owner address The address which owns the funds.
281    * @param _spender address The address which will spend the funds.
282    * @return A uint256 specifying the amount of tokens still available for the spender.
283    */
284   function allowance(
285     address _owner,
286     address _spender
287    )
288     public
289     view
290     returns (uint256)
291   {
292     return allowed[_owner][_spender];
293   }
294 
295   /**
296    * @dev Increase the amount of tokens that an owner allowed to a spender.
297    * approve should be called when allowed[_spender] == 0. To increment
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _addedValue The amount of tokens to increase the allowance by.
303    */
304   function increaseApproval(
305     address _spender,
306     uint256 _addedValue
307   )
308     public
309     returns (bool)
310   {
311     allowed[msg.sender][_spender] = (
312       allowed[msg.sender][_spender].add(_addedValue));
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317   /**
318    * @dev Decrease the amount of tokens that an owner allowed to a spender.
319    * approve should be called when allowed[_spender] == 0. To decrement
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _subtractedValue The amount of tokens to decrease the allowance by.
325    */
326   function decreaseApproval(
327     address _spender,
328     uint256 _subtractedValue
329   )
330     public
331     returns (bool)
332   {
333     uint256 oldValue = allowed[msg.sender][_spender];
334     if (_subtractedValue >= oldValue) {
335       allowed[msg.sender][_spender] = 0;
336     } else {
337       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338     }
339     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 
343 }
344 
345 contract PausableToken is StandardToken, Pausable {
346 
347   function transfer(
348     address _to,
349     uint256 _value
350   )
351     public
352     whenNotPaused
353     returns (bool)
354   {
355     return super.transfer(_to, _value);
356   }
357 
358   function transferFrom(
359     address _from,
360     address _to,
361     uint256 _value
362   )
363     public
364     whenNotPaused
365     returns (bool)
366   {
367     return super.transferFrom(_from, _to, _value);
368   }
369 
370   function approve(
371     address _spender,
372     uint256 _value
373   )
374     public
375     whenNotPaused
376     returns (bool)
377   {
378     return super.approve(_spender, _value);
379   }
380 
381   function increaseApproval(
382     address _spender,
383     uint _addedValue
384   )
385     public
386     whenNotPaused
387     returns (bool success)
388   {
389     return super.increaseApproval(_spender, _addedValue);
390   }
391 
392   function decreaseApproval(
393     address _spender,
394     uint _subtractedValue
395   )
396     public
397     whenNotPaused
398     returns (bool success)
399   {
400     return super.decreaseApproval(_spender, _subtractedValue);
401   }
402 }
403 
404 contract IndividualLockableToken is PausableToken{
405 
406   using SafeMath for uint256;
407 
408 
409 
410   event LockTimeSetted(address indexed holder, uint256 old_release_time, uint256 new_release_time);
411 
412   event Locked(address indexed holder, uint256 locked_balance_change, uint256 total_locked_balance, uint256 release_time);
413 
414 
415 
416   struct lockState {
417 
418     uint256 locked_balance;
419 
420     uint256 release_time;
421 
422   }
423 
424 
425 
426   // default lock period
427 
428   uint256 public lock_period = 24 weeks;
429 
430 
431 
432   mapping(address => lockState) internal userLock;
433 
434 
435 
436   // Specify the time that a particular person's lock will be released
437 
438   function setReleaseTime(address _holder, uint256 _release_time)
439 
440     public
441 
442     onlyOwner
443 
444     returns (bool)
445 
446   {
447 
448     require(_holder != address(0));
449 
450 	require(_release_time >= block.timestamp);
451 
452 
453 
454 	uint256 old_release_time = userLock[_holder].release_time;
455 
456 
457 
458 	userLock[_holder].release_time = _release_time;
459 
460 	emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
461 
462 	return true;
463 
464   }
465 
466   
467 
468   // Returns the point at which token holder's lock is released
469 
470   function getReleaseTime(address _holder)
471 
472     public
473 
474     view
475 
476     returns (uint256)
477 
478   {
479 
480     require(_holder != address(0));
481 
482 
483 
484 	return userLock[_holder].release_time;
485 
486   }
487 
488 
489 
490   // Unlock a specific person. Free trading even with a lock balance
491 
492   function clearReleaseTime(address _holder)
493 
494     public
495 
496     onlyOwner
497 
498     returns (bool)
499 
500   {
501 
502     require(_holder != address(0));
503 
504     require(userLock[_holder].release_time > 0);
505 
506 
507 
508 	uint256 old_release_time = userLock[_holder].release_time;
509 
510 
511 
512 	userLock[_holder].release_time = 0;
513 
514 	emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
515 
516 	return true;
517 
518   }
519 
520 
521 
522   // Increase the lock balance of a specific person.
523 
524   // If you only want to increase the balance, the release_time must be specified in advance.
525 
526   function increaseLockBalance(address _holder, uint256 _value)
527 
528     public
529 
530     onlyOwner
531 
532     returns (bool)
533 
534   {
535 
536 	require(_holder != address(0));
537 
538 	require(_value > 0);
539 
540 	require(balances[_holder] >= _value);
541 
542 	
543 
544 	if (userLock[_holder].release_time == 0) {
545 
546 		userLock[_holder].release_time = block.timestamp + lock_period;
547 
548 	}
549 
550 	
551 
552 	userLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);
553 
554 	emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
555 
556 	return true;
557 
558   }
559 
560 
561 
562   // Decrease the lock balance of a specific person.
563 
564   function decreaseLockBalance(address _holder, uint256 _value)
565 
566     public
567 
568     onlyOwner
569 
570     returns (bool)
571 
572   {
573 
574 	require(_holder != address(0));
575 
576 	require(_value > 0);
577 
578 	require(userLock[_holder].locked_balance >= _value);
579 
580 
581 
582 	userLock[_holder].locked_balance = (userLock[_holder].locked_balance).sub(_value);
583 
584 	emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
585 
586 	return true;
587 
588   }
589 
590 
591 
592   // Clear the lock.
593 
594   function clearLock(address _holder)
595 
596     public
597 
598     onlyOwner
599 
600     returns (bool)
601 
602   {
603 
604 	require(_holder != address(0));
605 
606 	require(userLock[_holder].release_time > 0);
607 
608 
609 
610 	userLock[_holder].locked_balance = 0;
611 
612 	userLock[_holder].release_time = 0;
613 
614 	emit Locked(_holder, 0, userLock[_holder].locked_balance, userLock[_holder].release_time);
615 
616 	return true;
617 
618   }
619 
620 
621 
622   // Check the amount of the lock
623 
624   function getLockedBalance(address _holder)
625 
626     public
627 
628     view
629 
630     returns (uint256)
631 
632   {
633 
634     if(block.timestamp >= userLock[_holder].release_time) return uint256(0);
635 
636     return userLock[_holder].locked_balance;
637 
638   }
639 
640 
641 
642   // Check your remaining balance
643 
644   function getFreeBalance(address _holder)
645 
646     public
647 
648     view
649 
650     returns (uint256)
651 
652   {
653 
654     if(block.timestamp >= userLock[_holder].release_time) return balances[_holder];
655 
656     return balances[_holder].sub(userLock[_holder].locked_balance);
657 
658   }
659 
660 
661 
662   // transfer overrride
663 
664   function transfer(
665 
666     address _to,
667 
668     uint256 _value
669 
670   )
671 
672     public
673 
674     returns (bool)
675 
676   {
677 
678     require(getFreeBalance(msg.sender) >= _value);
679 
680     return super.transfer(_to, _value);
681 
682   }
683 
684 
685 
686   // transferFrom overrride
687 
688   function transferFrom(
689 
690     address _from,
691 
692     address _to,
693 
694     uint256 _value
695 
696   )
697 
698     public
699 
700     returns (bool)
701 
702   {
703 
704     require(getFreeBalance(_from) >= _value);
705 
706     return super.transferFrom(_from, _to, _value);
707 
708   }
709 
710 
711 
712   // approve overrride
713 
714   function approve(
715 
716     address _spender,
717 
718     uint256 _value
719 
720   )
721 
722     public
723 
724     returns (bool)
725 
726   {
727 
728     require(getFreeBalance(msg.sender) >= _value);
729 
730     return super.approve(_spender, _value);
731 
732   }
733 
734 
735 
736   // increaseApproval overrride
737 
738   function increaseApproval(
739 
740     address _spender,
741 
742     uint _addedValue
743 
744   )
745 
746     public
747 
748     returns (bool success)
749 
750   {
751 
752     require(getFreeBalance(msg.sender) >= allowed[msg.sender][_spender].add(_addedValue));
753 
754     return super.increaseApproval(_spender, _addedValue);
755 
756   }
757 
758   
759 
760   // decreaseApproval overrride
761 
762   function decreaseApproval(
763 
764     address _spender,
765 
766     uint _subtractedValue
767 
768   )
769 
770     public
771 
772     returns (bool success)
773 
774   {
775 
776 	uint256 oldValue = allowed[msg.sender][_spender];
777 
778 	
779 
780     if (_subtractedValue < oldValue) {
781 
782       require(getFreeBalance(msg.sender) >= oldValue.sub(_subtractedValue));	  
783 
784     }    
785 
786     return super.decreaseApproval(_spender, _subtractedValue);
787 
788   }
789 
790 }
791 
792 contract EthereumRed is IndividualLockableToken, TokenDestructible {
793 
794   using SafeMath for uint256;
795 
796 
797 
798   string public constant name = "Ethereum Red";
799 
800   string public constant symbol = "ERED";
801 
802   uint8  public constant decimals = 18;
803 
804 
805 
806   // 24,000,000,000 YRE
807 
808   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
809 
810 
811 
812   constructor()
813 
814     public
815 
816   {
817 
818     totalSupply_ = INITIAL_SUPPLY;
819 
820     balances[msg.sender] = totalSupply_;
821 
822   }
823 
824 }