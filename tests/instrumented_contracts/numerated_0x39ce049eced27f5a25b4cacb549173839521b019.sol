1 // File: contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/token/ERC20/IERC20.sol
77 
78 pragma solidity ^0.4.24;
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 interface IERC20 {
85     function totalSupply() external view returns (uint256);
86 
87     function balanceOf(address who) external view returns (uint256);
88 
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     function transfer(address to, uint256 value) external returns (bool);
92 
93     function approve(address spender, uint256 value) external returns (bool);
94 
95     function transferFrom(address from, address to, uint256 value) external returns (bool);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: contracts/math/SafeMath.sol
103 
104 pragma solidity ^0.4.24;
105 
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that revert on error
109  */
110 library SafeMath {
111     /**
112     * @dev Multiplies two numbers, reverts on overflow.
113     */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
130     */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // Solidity only automatically asserts when dividing by 0
133         require(b > 0);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
142     */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         require(b <= a);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151     * @dev Adds two numbers, reverts on overflow.
152     */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a);
156 
157         return c;
158     }
159 
160     /**
161     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
162     * reverts when dividing by zero.
163     */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         require(b != 0);
166         return a % b;
167     }
168 }
169 
170 // File: contracts/token/ERC20/ERC20.sol
171 
172 pragma solidity ^0.4.24;
173 
174 
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
181  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  *
183  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
184  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
185  * compliant implementations may not do it.
186  */
187 contract ERC20 is IERC20 {
188     using SafeMath for uint256;
189 
190     mapping (address => uint256) private _balances;
191 
192     mapping (address => mapping (address => uint256)) private _allowed;
193 
194     uint256 private _totalSupply;
195 
196     /**
197     * @dev Total number of tokens in existence
198     */
199     function totalSupply() public view returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204     * @dev Gets the balance of the specified address.
205     * @param owner The address to query the balance of.
206     * @return An uint256 representing the amount owned by the passed address.
207     */
208     function balanceOf(address owner) public view returns (uint256) {
209         return _balances[owner];
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param owner address The address which owns the funds.
215      * @param spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address owner, address spender) public view returns (uint256) {
219         return _allowed[owner][spender];
220     }
221 
222     /**
223     * @dev Transfer token for a specified address
224     * @param to The address to transfer to.
225     * @param value The amount to be transferred.
226     */
227     function transfer(address to, uint256 value) public returns (bool) {
228         _transfer(msg.sender, to, value);
229         return true;
230     }
231 
232     /**
233      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234      * Beware that changing an allowance with this method brings the risk that someone may use both the old
235      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      * @param spender The address which will spend the funds.
239      * @param value The amount of tokens to be spent.
240      */
241     function approve(address spender, uint256 value) public returns (bool) {
242         require(spender != address(0));
243 
244         _allowed[msg.sender][spender] = value;
245         emit Approval(msg.sender, spender, value);
246         return true;
247     }
248 
249     /**
250      * @dev Transfer tokens from one address to another.
251      * Note that while this function emits an Approval event, this is not required as per the specification,
252      * and other compliant implementations may not emit the event.
253      * @param from address The address which you want to send tokens from
254      * @param to address The address which you want to transfer to
255      * @param value uint256 the amount of tokens to be transferred
256      */
257     function transferFrom(address from, address to, uint256 value) public returns (bool) {
258         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
259         _transfer(from, to, value);
260         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
261         return true;
262     }
263 
264     /**
265      * @dev Increase the amount of tokens that an owner allowed to a spender.
266      * approve should be called when allowed_[_spender] == 0. To increment
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * Emits an Approval event.
271      * @param spender The address which will spend the funds.
272      * @param addedValue The amount of tokens to increase the allowance by.
273      */
274     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
275         require(spender != address(0));
276 
277         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
278         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
279         return true;
280     }
281 
282     /**
283      * @dev Decrease the amount of tokens that an owner allowed to a spender.
284      * approve should be called when allowed_[_spender] == 0. To decrement
285      * allowed value is better to use this function to avoid 2 calls (and wait until
286      * the first transaction is mined)
287      * From MonolithDAO Token.sol
288      * Emits an Approval event.
289      * @param spender The address which will spend the funds.
290      * @param subtractedValue The amount of tokens to decrease the allowance by.
291      */
292     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
293         require(spender != address(0));
294 
295         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
296         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
297         return true;
298     }
299 
300     /**
301     * @dev Transfer token for a specified addresses
302     * @param from The address to transfer from.
303     * @param to The address to transfer to.
304     * @param value The amount to be transferred.
305     */
306     function _transfer(address from, address to, uint256 value) internal {
307         require(to != address(0));
308 
309         _balances[from] = _balances[from].sub(value);
310         _balances[to] = _balances[to].add(value);
311         emit Transfer(from, to, value);
312     }
313 
314     /**
315      * @dev Internal function that mints an amount of the token and assigns it to
316      * an account. This encapsulates the modification of balances such that the
317      * proper events are emitted.
318      * @param account The account that will receive the created tokens.
319      * @param value The amount that will be created.
320      */
321     function _mint(address account, uint256 value) internal {
322         require(account != address(0));
323 
324         _totalSupply = _totalSupply.add(value);
325         _balances[account] = _balances[account].add(value);
326         emit Transfer(address(0), account, value);
327     }
328 
329     /**
330      * @dev Internal function that burns an amount of the token of a given
331      * account.
332      * @param account The account whose tokens will be burnt.
333      * @param value The amount that will be burnt.
334      */
335     function _burn(address account, uint256 value) internal {
336         require(account != address(0));
337 
338         _totalSupply = _totalSupply.sub(value);
339         _balances[account] = _balances[account].sub(value);
340         emit Transfer(account, address(0), value);
341     }
342 
343     /**
344      * @dev Internal function that burns an amount of the token of a given
345      * account, deducting from the sender's allowance for said account. Uses the
346      * internal burn function.
347      * Emits an Approval event (reflecting the reduced allowance).
348      * @param account The account whose tokens will be burnt.
349      * @param value The amount that will be burnt.
350      */
351     function _burnFrom(address account, uint256 value) internal {
352         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
353         _burn(account, value);
354         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
355     }
356 }
357 
358 // File: contracts/token/ERC20/ERC20Detailed.sol
359 
360 pragma solidity ^0.4.24;
361 
362 
363 /**
364  * @title ERC20Detailed token
365  * @dev The decimals are only for visualization purposes.
366  * All the operations are done using the smallest and indivisible token unit,
367  * just as on Ethereum all the operations are done in wei.
368  */
369 contract ERC20Detailed is IERC20 {
370     string private _name;
371     string private _symbol;
372     uint8 private _decimals;
373 
374     constructor (string name, string symbol, uint8 decimals) public {
375         _name = name;
376         _symbol = symbol;
377         _decimals = decimals;
378     }
379 
380     /**
381      * @return the name of the token.
382      */
383     function name() public view returns (string) {
384         return _name;
385     }
386 
387     /**
388      * @return the symbol of the token.
389      */
390     function symbol() public view returns (string) {
391         return _symbol;
392     }
393 
394     /**
395      * @return the number of decimals of the token.
396      */
397     function decimals() public view returns (uint8) {
398         return _decimals;
399     }
400 }
401 
402 // File: contracts/access/Roles.sol
403 
404 pragma solidity ^0.4.24;
405 
406 /**
407  * @title Roles
408  * @dev Library for managing addresses assigned to a Role.
409  */
410 library Roles {
411     struct Role {
412         mapping (address => bool) bearer;
413     }
414 
415     /**
416      * @dev give an account access to this role
417      */
418     function add(Role storage role, address account) internal {
419         require(account != address(0));
420         require(!has(role, account));
421 
422         role.bearer[account] = true;
423     }
424 
425     /**
426      * @dev remove an account's access to this role
427      */
428     function remove(Role storage role, address account) internal {
429         require(account != address(0));
430         require(has(role, account));
431 
432         role.bearer[account] = false;
433     }
434 
435     /**
436      * @dev check if an account has this role
437      * @return bool
438      */
439     function has(Role storage role, address account) internal view returns (bool) {
440         require(account != address(0));
441         return role.bearer[account];
442     }
443 }
444 
445 // File: contracts/access/roles/PauserRole.sol
446 
447 pragma solidity ^0.4.24;
448 
449 
450 contract PauserRole {
451     using Roles for Roles.Role;
452 
453     event PauserAdded(address indexed account);
454     event PauserRemoved(address indexed account);
455 
456     Roles.Role private _pausers;
457 
458     constructor () internal {
459         _addPauser(msg.sender);
460     }
461 
462     modifier onlyPauser() {
463         require(isPauser(msg.sender));
464         _;
465     }
466 
467     function isPauser(address account) public view returns (bool) {
468         return _pausers.has(account);
469     }
470 
471     function addPauser(address account) public onlyPauser {
472         _addPauser(account);
473     }
474 
475     function renouncePauser() public {
476         _removePauser(msg.sender);
477     }
478 
479     function _addPauser(address account) internal {
480         _pausers.add(account);
481         emit PauserAdded(account);
482     }
483 
484     function _removePauser(address account) internal {
485         _pausers.remove(account);
486         emit PauserRemoved(account);
487     }
488 }
489 
490 // File: contracts/lifecycle/Pausable.sol
491 
492 pragma solidity ^0.4.24;
493 
494 
495 /**
496  * @title Pausable
497  * @dev Base contract which allows children to implement an emergency stop mechanism.
498  */
499 contract Pausable is PauserRole {
500     event Paused(address account);
501     event Unpaused(address account);
502 
503     bool private _paused;
504 
505     constructor () internal {
506         _paused = false;
507     }
508 
509     /**
510      * @return true if the contract is paused, false otherwise.
511      */
512     function paused() public view returns (bool) {
513         return _paused;
514     }
515 
516     /**
517      * @dev Modifier to make a function callable only when the contract is not paused.
518      */
519     modifier whenNotPaused() {
520         require(!_paused);
521         _;
522     }
523 
524     /**
525      * @dev Modifier to make a function callable only when the contract is paused.
526      */
527     modifier whenPaused() {
528         require(_paused);
529         _;
530     }
531 
532     /**
533      * @dev called by the owner to pause, triggers stopped state
534      */
535     function pause() public onlyPauser whenNotPaused {
536         _paused = true;
537         emit Paused(msg.sender);
538     }
539 
540     /**
541      * @dev called by the owner to unpause, returns to normal state
542      */
543     function unpause() public onlyPauser whenPaused {
544         _paused = false;
545         emit Unpaused(msg.sender);
546     }
547 }
548 
549 // File: contracts/token/ERC20/ERC20Pausable.sol
550 
551 pragma solidity ^0.4.24;
552 
553 
554 
555 /**
556  * @title Pausable token
557  * @dev ERC20 modified with pausable transfers.
558  **/
559 contract ERC20Pausable is ERC20, Pausable {
560     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
561         return super.transfer(to, value);
562     }
563 
564     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
565         return super.transferFrom(from, to, value);
566     }
567 
568     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
569         return super.approve(spender, value);
570     }
571 
572     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
573         return super.increaseAllowance(spender, addedValue);
574     }
575 
576     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
577         return super.decreaseAllowance(spender, subtractedValue);
578     }
579 }
580 
581 // File: contracts/mocks/PauserRoleMock.sol
582 
583 pragma solidity ^0.4.24;
584 
585 
586 contract PauserRoleMock is PauserRole {
587     function removePauser(address account) public {
588         _removePauser(account);
589     }
590 
591     function onlyPauserMock() public view onlyPauser {
592     }
593 
594     // Causes a compilation error if super._removePauser is not internal
595     function _removePauser(address account) internal {
596         super._removePauser(account);
597     }
598 }
599 
600 // File: contracts/ABEToken.sol
601 
602 pragma solidity ^0.4.24;
603 
604 // OpenZeppelin - Token Blueprint
605 
606 
607 
608 
609 
610 
611 contract ABEToken is ERC20Detailed, ERC20Pausable, PauserRoleMock, Ownable {
612 
613     modifier validDestination(address to) {
614         require(to != address(this));
615         _;
616     }
617 
618     // checks if the address can transfer certain amount of tokens
619     modifier canTransfer(address _sender, uint256 _value) {
620         require(_sender != address(0));
621 
622         uint256 remaining = balanceOf(_sender).sub(_value);
623         uint256 totalLockAmt = 0;
624 
625         if (investors_locked[_sender] > 0) {
626             totalLockAmt = totalLockAmt.add(getLockedAmount_investors(_sender));
627         }
628 
629         require(remaining >= totalLockAmt);
630 
631         _;
632     }
633 
634     constructor(address initialAddress, uint256 initialTokenSupply) 
635         public 
636         ERC20Detailed("Abelian", "ABE", 18) 
637     {
638         _mint(initialAddress, initialTokenSupply);
639     }
640 
641     mapping(address => uint256) public investors_locked;
642     mapping(address => uint256) public investors_deliveryDate;
643 
644 	bool private frozen = false;
645 
646 	// ============================ INVESTOR LOCKING =================================
647     event UpdatedLockingState(address indexed to, uint256 value, uint256 date);
648 
649     // get investors' locked amount of token
650     // this lockup will be released in 4 batches: 
651     // 1. on delievery date
652     // 2. three months after the delivery date
653     // 3. six months after the delivery date
654     // 4. nine months after the delivery date
655     function getLockedAmount_investors(address _investor)
656         public
657 		view
658 		returns (uint256)
659 	{
660         require(_investor != address(0));
661 
662         uint256 delieveryDate = investors_deliveryDate[_investor];
663         uint256 lockedAmt = investors_locked[_investor];
664 
665         if (now <= delieveryDate) {
666             return lockedAmt;
667         }
668         if (now <= delieveryDate + 90 days) {
669             return lockedAmt.mul(3).div(4);
670         }
671         if (now <= delieveryDate + 180 days) {
672             return lockedAmt.mul(2).div(4);
673 
674         }
675         if (now <= delieveryDate + 270 days) {
676             return  lockedAmt.mul(1).div(4);
677         }
678 	
679         return 0;
680     }
681 
682     // set lockup for investor
683     function setLockup_investors(address _investor, uint256 _value, uint256 _delieveryDate)
684         public
685         onlyOwner
686     {
687         require(_investor != address(0));
688 
689         investors_locked[_investor] = _value;
690         investors_deliveryDate[_investor] = _delieveryDate;
691         emit UpdatedLockingState(_investor, _value, _delieveryDate);
692     }
693 
694     // show investor details
695     function showLockupDetails_investors(address _investor) 
696         public 
697         view 
698         returns (uint256, uint256) 
699     {
700         require(_investor != address(0));
701 
702         uint256 _value = investors_locked[_investor];
703         uint256 _spendingDate = investors_deliveryDate[_investor];
704 
705         return (_spendingDate, _value);
706     }
707 
708 	// ============================ FREEZING =================================
709 	function freeze()
710 		public
711 		onlyOwner
712 	{
713 		frozen = true;
714 	}
715 
716 	function isFrozen() public view returns(bool) {
717 		return frozen;
718 	}
719 
720     modifier whenNotPaused() {
721         require(!paused());
722 		require(!frozen);
723         _;
724     }
725 
726 	// ============================ BASE =================================
727     function transferFrom(address _from, address _to, uint256 _value) 
728         public 
729         validDestination(_to)
730 	    canTransfer(_from, _value)
731         returns (bool) 
732     {
733         return super.transferFrom(_from, _to, _value);
734     }
735 
736     function transfer(address _to, uint256 _value) 
737         public
738         validDestination(_to)
739 	    canTransfer(msg.sender, _value) 
740         returns (bool)
741     {
742         return super.transfer(_to, _value);
743     }
744 
745 }