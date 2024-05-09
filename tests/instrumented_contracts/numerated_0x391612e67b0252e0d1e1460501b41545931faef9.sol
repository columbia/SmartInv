1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-01
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-29
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2019-12-12
11 */
12 
13 pragma solidity ^0.5.0;
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations with added overflow
17  * checks.
18  *
19  * Arithmetic operations in Solidity wrap on overflow. This can easily result
20  * in bugs, because programmers usually assume that an overflow raises an
21  * error, which is the standard behavior in high level programming languages.
22  * `SafeMath` restores this intuition by reverting the transaction when an
23  * operation overflows.
24  *
25  * Using this library instead of the unchecked operations eliminates an entire
26  * class of bugs, so it's recommended to use it always.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, reverting on
31      * overflow.
32      *
33      * Counterpart to Solidity's `+` operator.
34      *
35      * Requirements:
36      * - Addition cannot overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, reverting on
47      * overflow (when the result is negative).
48      *
49      * Counterpart to Solidity's `-` operator.
50      *
51      * Requirements:
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 library Roles {
164     struct Role {
165         mapping (address => bool) bearer;
166     }
167 
168     /**
169      * @dev give an account access to this role
170      */
171     function add(Role storage role, address account) internal {
172         require(account != address(0));
173         require(!has(role, account));
174 
175         role.bearer[account] = true;
176     }
177 
178     /**
179      * @dev remove an account's access to this role
180      */
181     function remove(Role storage role, address account) internal {
182         require(account != address(0));
183         require(has(role, account));
184 
185         role.bearer[account] = false;
186     }
187 
188     /**
189      * @dev check if an account has this role
190      * @return bool
191      */
192     function has(Role storage role, address account) internal view returns (bool) {
193         require(account != address(0));
194         return role.bearer[account];
195     }
196 }
197 
198 contract Ownable {
199     address public owner;
200     address public newOwner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     constructor() public {
205         owner = msg.sender;
206         newOwner = address(0);
207     }
208 
209     modifier onlyOwner() {
210         require(msg.sender == owner);
211         _;
212     }
213     modifier onlyNewOwner() {
214         require(msg.sender != address(0));
215         require(msg.sender == newOwner);
216         _;
217     }
218 
219     function isOwner(address account) public view returns (bool) {
220         if( account == owner ){
221             return true;
222         }
223         else {
224             return false;
225         }
226     }
227 
228     function transferOwnership(address _newOwner) public onlyOwner {
229         require(_newOwner != address(0));
230         newOwner = _newOwner;
231     }
232 
233     function acceptOwnership() public onlyNewOwner returns(bool) {
234         emit OwnershipTransferred(owner, newOwner);
235         owner = newOwner;
236         newOwner = address(0);
237     }
238 }
239 
240 contract PauserRole is Ownable{
241     using Roles for Roles.Role;
242 
243     event PauserAdded(address indexed account);
244     event PauserRemoved(address indexed account);
245 
246     Roles.Role private _pausers;
247 
248     constructor () internal {
249         _addPauser(msg.sender);
250     }
251 
252     modifier onlyPauser() {
253         require(isPauser(msg.sender)|| isOwner(msg.sender));
254         _;
255     }
256 
257     function isPauser(address account) public view returns (bool) {
258         return _pausers.has(account);
259     }
260 
261     function addPauser(address account) public onlyPauser {
262         _addPauser(account);
263     }
264 
265     function removePauser(address account) public onlyOwner {
266         _removePauser(account);
267     }
268 
269     function renouncePauser() public {
270         _removePauser(msg.sender);
271     }
272 
273     function _addPauser(address account) internal {
274         _pausers.add(account);
275         emit PauserAdded(account);
276     }
277 
278     function _removePauser(address account) internal {
279         _pausers.remove(account);
280         emit PauserRemoved(account);
281     }
282 }
283 
284 contract Pausable is PauserRole {
285     event Paused(address account);
286     event Unpaused(address account);
287 
288     bool private _paused;
289 
290     constructor () internal {
291         _paused = false;
292     }
293 
294     /**
295      * @return true if the contract is paused, false otherwise.
296      */
297     function paused() public view returns (bool) {
298         return _paused;
299     }
300 
301     /**
302      * @dev Modifier to make a function callable only when the contract is not paused.
303      */
304     modifier whenNotPaused() {
305         require(!_paused);
306         _;
307     }
308 
309     /**
310      * @dev Modifier to make a function callable only when the contract is paused.
311      */
312     modifier whenPaused() {
313         require(_paused);
314         _;
315     }
316 
317     /**
318      * @dev called by the owner to pause, triggers stopped state
319      */
320     function pause() public onlyPauser whenNotPaused {
321         _paused = true;
322         emit Paused(msg.sender);
323     }
324 
325     /**
326      * @dev called by the owner to unpause, returns to normal state
327      */
328     function unpause() public onlyPauser whenPaused {
329         _paused = false;
330         emit Unpaused(msg.sender);
331     }
332 }
333 
334 interface IERC20 {
335     function transfer(address to, uint256 value) external returns (bool);
336 
337     function approve(address spender, uint256 value) external returns (bool);
338 
339     function transferFrom(address from, address to, uint256 value) external returns (bool);
340 
341     function totalSupply() external view returns (uint256);
342 
343     function balanceOf(address who) external view returns (uint256);
344 
345     function allowance(address owner, address spender) external view returns (uint256);
346 
347     event Transfer(address indexed from, address indexed to, uint256 value);
348 
349     event Approval(address indexed owner, address indexed spender, uint256 value);
350 }
351 
352 contract ERC20 is IERC20 {
353     using SafeMath for uint256;
354 
355     mapping (address => uint256) internal _balances;
356 
357     mapping (address => mapping (address => uint256)) internal _allowed;
358 
359     uint256 private _totalSupply;
360 
361     /**
362     * @dev Total number of tokens in existence
363     */
364     function totalSupply() public view returns (uint256) {
365         return _totalSupply;
366     }
367 
368     /**
369     * @dev Gets the balance of the specified address.
370     * @param owner The address to query the balance of.
371     * @return An uint256 representing the amount owned by the passed address.
372     */
373     function balanceOf(address owner) public view returns (uint256) {
374         return _balances[owner];
375     }
376 
377     /**
378      * @dev Function to check the amount of tokens that an owner allowed to a spender.
379      * @param owner address The address which owns the funds.
380      * @param spender address The address which will spend the funds.
381      * @return A uint256 specifying the amount of tokens still available for the spender.
382      */
383     function allowance(address owner, address spender) public view returns (uint256) {
384         return _allowed[owner][spender];
385     }
386 
387     /**
388      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
389      * Beware that changing an allowance with this method brings the risk that someone may use both the old
390      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
391      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
392      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
393      * @param spender The address which will spend the funds.
394      * @param value The amount of tokens to be spent.
395      */
396     function approve(address spender, uint256 value) public returns (bool) {
397         require(spender != address(0));
398 
399         _allowed[msg.sender][spender] = value;
400         emit Approval(msg.sender, spender, value);
401         return true;
402     }
403 
404     /**
405      * @dev Transfer tokens from one address to another.
406      * Note that while this function emits an Approval event, this is not required as per the specification,
407      * and other compliant implementations may not emit the event.
408      * @param from address The address which you want to send tokens from
409      * @param to address The address which you want to transfer to
410      * @param value uint256 the amount of tokens to be transferred
411      */
412     function transferFrom(address from, address to, uint256 value) public returns (bool) {
413         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
414         _transfer(from, to, value);
415         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
416         return true;
417     }
418 
419     /**
420      * @dev Increase the amount of tokens that an owner allowed to a spender.
421      * approve should be called when allowed_[_spender] == 0. To increment
422      * allowed value is better to use this function to avoid 2 calls (and wait until
423      * the first transaction is mined)
424      * From MonolithDAO Token.sol
425      * Emits an Approval event.
426      * @param spender The address which will spend the funds.
427      * @param addedValue The amount of tokens to increase the allowance by.
428      */
429     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
430         require(spender != address(0));
431 
432         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
433         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
434         return true;
435     }
436 
437     /**
438      * @dev Decrease the amount of tokens that an owner allowed to a spender.
439      * approve should be called when allowed_[_spender] == 0. To decrement
440      * allowed value is better to use this function to avoid 2 calls (and wait until
441      * the first transaction is mined)
442      * From MonolithDAO Token.sol
443      * Emits an Approval event.
444      * @param spender The address which will spend the funds.
445      * @param subtractedValue The amount of tokens to decrease the allowance by.
446      */
447     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
448         require(spender != address(0));
449 
450         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
451         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
452         return true;
453     }
454 
455 
456     /**
457     * @dev Transfer token for a specified address
458     * @param to The address to transfer to.
459     * @param value The amount to be transferred.
460     */
461     function transfer(address to, uint256 value) public returns (bool) {
462         _transfer(msg.sender, to, value);
463         return true;
464     }
465 
466     /**
467     * @dev Transfer token for a specified addresses
468     * @param from The address to transfer from.
469     * @param to The address to transfer to.
470     * @param value The amount to be transferred.
471     */
472     function _transfer(address from, address to, uint256 value) internal {
473         require(to != address(0));
474         require(from != address(0));
475 
476         _balances[from] = _balances[from].sub(value);
477         _balances[to] = _balances[to].add(value);
478         emit Transfer(from, to, value);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from the caller.
483      *
484      * See {ERC20-_burn}.
485      */
486     function burn(uint256 value) public returns (bool) {
487         _burn(msg.sender, value);
488         return true;
489     }
490 
491     /**
492      * @dev Internal function that burns an amount of the token of a given
493      * account.
494      * @param account The account whose tokens will be burnt.
495      * @param value The amount that will be burnt.
496      */
497     function _burn(address account, uint256 value) internal {
498         require(account != address(0));
499 
500         _totalSupply = _totalSupply.sub(value);
501         _balances[account] = _balances[account].sub(value);
502         emit Transfer(account, address(0), value);
503     }
504 
505     /**
506      * @dev Internal function that burns an amount of the token of a given
507      * account, deducting from the sender's allowance for said account. Uses the
508      * internal burn function.
509      * Emits an Approval event (reflecting the reduced allowance).
510      * @param account The account whose tokens will be burnt.
511      * @param value The amount that will be burnt.
512      */
513     function _burnFrom(address account, uint256 value) internal {
514         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
515         _burn(account, value);
516         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
517     }
518 
519     /**
520      * @dev Internal function that mints an amount of the token and assigns it to
521      * an account. This encapsulates the modification of balances such that the
522      * proper events are emitted.
523      * @param account The account that will receive the created tokens.
524      * @param value The amount that will be created.
525      */
526     function _mint(address account, uint256 value) internal {
527         require(account != address(0));
528 
529         _totalSupply = _totalSupply.add(value);
530         _balances[account] = _balances[account].add(value);
531         emit Transfer(address(0), account, value);
532     }
533 }
534 
535 contract ERC20Pausable is ERC20, Pausable {
536     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
537         return super.transfer(to, value);
538     }
539 
540     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
541         return super.transferFrom(from, to, value);
542     }
543 
544     /*
545      * approve/increaseApprove/decreaseApprove can be set when Paused state
546      */
547 
548     /*
549      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
550      *     return super.approve(spender, value);
551      * }
552      *
553      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
554      *     return super.increaseAllowance(spender, addedValue);
555      * }
556      *
557      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
558      *     return super.decreaseAllowance(spender, subtractedValue);
559      * }
560      */
561 }
562 
563 contract ERC20Detailed is IERC20 {
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567 
568     constructor (string memory name, string memory symbol, uint8 decimals) public {
569         _name = name;
570         _symbol = symbol;
571         _decimals = decimals;
572     }
573 
574     /**
575      * @return the name of the token.
576      */
577     function name() public view returns (string memory) {
578         return _name;
579     }
580 
581     /**
582      * @return the symbol of the token.
583      */
584     function symbol() public view returns (string memory) {
585         return _symbol;
586     }
587 
588     /**
589      * @return the number of decimals of the token.
590      */
591     function decimals() public view returns (uint8) {
592         return _decimals;
593     }
594 }
595 
596 contract ERC20Custom is ERC20Detailed, ERC20Pausable {
597 
598     struct LockInfo {
599         uint256 _releaseTime;
600         uint256 _amount;
601     }
602 
603     mapping (address => LockInfo[]) public timelockList;
604     mapping (address => bool) public frozenAccount;
605 
606     event Freeze(address indexed holder);
607     event Unfreeze(address indexed holder);
608     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
609     event Unlock(address indexed holder, uint256 value);
610 
611     modifier notFrozen(address _holder) {
612         require(!frozenAccount[_holder]);
613         _;
614     }
615 
616     constructor() ERC20Detailed("The Bridge", "TBG", 18) public  {
617 
618         _mint(msg.sender, 5000000000 * (10 ** 18));
619     }
620 
621     function timelockListLength(address owner) public view returns (uint256) {
622         return timelockList[owner].length;
623     }
624 
625     function balanceOf(address owner) public view returns (uint256) {
626 
627         uint256 totalBalance = super.balanceOf(owner);
628         if( timelockList[owner].length >0 ){
629             for(uint i=0; i<timelockList[owner].length;i++){
630                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
631             }
632         }
633 
634         return totalBalance;
635     }
636 
637     function balanceOfTimelocked(address owner) public view returns (uint256) {
638 
639         uint256 totalLocked = 0;
640         if( timelockList[owner].length >0 ){
641             for(uint i=0; i<timelockList[owner].length;i++){
642                 totalLocked = totalLocked.add(timelockList[owner][i]._amount);
643             }
644         }
645 
646         return totalLocked;
647     }
648 
649     function balanceOfAvailable(address owner) public view returns (uint256) {
650 
651         uint256 totalBalance = super.balanceOf(owner);
652         return totalBalance;
653     }
654 
655     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
656         if (timelockList[msg.sender].length > 0 ) {
657             _autoUnlock(msg.sender);
658         }
659         return super.transfer(to, value);
660     }
661 
662     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
663         if (timelockList[from].length > 0) {
664             _autoUnlock(from);
665         }
666         return super.transferFrom(from, to, value);
667     }
668 
669     function freezeAccount(address holder) public onlyPauser returns (bool) {
670         require(!frozenAccount[holder]);
671         require(timelockList[holder].length == 0);
672         frozenAccount[holder] = true;
673         emit Freeze(holder);
674         return true;
675     }
676 
677     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
678         require(frozenAccount[holder]);
679         frozenAccount[holder] = false;
680         emit Unfreeze(holder);
681         return true;
682     }
683 
684     function lockByQuantity(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
685         require(!frozenAccount[holder]);
686         _lock(holder,value,releaseTime);
687         return true;
688     }
689 
690     function unlockByQuantity(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
691         //1
692         require(!frozenAccount[holder]);
693         //2
694         require(timelockList[holder].length >0);
695 
696         //3
697         uint256 totalLocked;
698         for(uint idx = 0; idx < timelockList[holder].length ; idx++ ){
699             totalLocked = totalLocked.add(timelockList[holder][idx]._amount);
700         }
701         require(totalLocked >value);
702 
703         //4
704         for(uint idx = 0; idx < timelockList[holder].length ; idx++ ) {
705             if( _unlock(holder, idx) ) {
706                 idx -=1;
707             }
708         }
709 
710         //5
711         _lock(holder,totalLocked.sub(value),releaseTime);
712 
713         return true;
714     }
715 
716     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
717         _transfer(msg.sender, holder, value);
718         _lock(holder,value,releaseTime);
719         return true;
720     }
721 
722     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
723         require( timelockList[holder].length > idx, "AhnLog_There is not lock info.");
724         _unlock(holder,idx);
725         return true;
726     }
727 
728 
729     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns (bool) {
730         _balances[holder] = _balances[holder].sub(value);
731         timelockList[holder].push( LockInfo(releaseTime, value) );
732 
733         emit Lock(holder, value, releaseTime);
734         return true;
735     }
736 
737     function _unlock(address holder, uint256 idx) internal returns(bool) {
738         LockInfo storage lockinfo = timelockList[holder][idx];
739         uint256 releaseAmount = lockinfo._amount;
740 
741         delete timelockList[holder][idx];
742         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
743         timelockList[holder].length -=1;
744 
745         emit Unlock(holder, releaseAmount);
746         _balances[holder] = _balances[holder].add(releaseAmount);
747 
748         return true;
749     }
750 
751     function _autoUnlock(address holder) internal returns (bool) {
752         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
753             if (timelockList[holder][idx]._releaseTime <= now) {
754                 // If lockupinfo was deleted, loop restart at same position.
755                 if( _unlock(holder, idx) ) {
756                     idx -=1;
757                 }
758             }
759         }
760         return true;
761     }
762 
763 }