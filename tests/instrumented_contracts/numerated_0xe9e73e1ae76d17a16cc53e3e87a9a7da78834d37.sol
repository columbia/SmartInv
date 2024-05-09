1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-12-12
7 */
8 
9 pragma solidity ^0.5.0;
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations with added overflow
13  * checks.
14  *
15  * Arithmetic operations in Solidity wrap on overflow. This can easily result
16  * in bugs, because programmers usually assume that an overflow raises an
17  * error, which is the standard behavior in high level programming languages.
18  * `SafeMath` restores this intuition by reverting the transaction when an
19  * operation overflows.
20  *
21  * Using this library instead of the unchecked operations eliminates an entire
22  * class of bugs, so it's recommended to use it always.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, reverting on
27      * overflow.
28      *
29      * Counterpart to Solidity's `+` operator.
30      *
31      * Requirements:
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 library Roles {
160     struct Role {
161         mapping (address => bool) bearer;
162     }
163 
164     /**
165      * @dev give an account access to this role
166      */
167     function add(Role storage role, address account) internal {
168         require(account != address(0));
169         require(!has(role, account));
170 
171         role.bearer[account] = true;
172     }
173 
174     /**
175      * @dev remove an account's access to this role
176      */
177     function remove(Role storage role, address account) internal {
178         require(account != address(0));
179         require(has(role, account));
180 
181         role.bearer[account] = false;
182     }
183 
184     /**
185      * @dev check if an account has this role
186      * @return bool
187      */
188     function has(Role storage role, address account) internal view returns (bool) {
189         require(account != address(0));
190         return role.bearer[account];
191     }
192 }
193 
194 contract Ownable {
195     address public owner;
196     address public newOwner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     constructor() public {
201         owner = msg.sender;
202         newOwner = address(0);
203     }
204 
205     modifier onlyOwner() {
206         require(msg.sender == owner);
207         _;
208     }
209     modifier onlyNewOwner() {
210         require(msg.sender != address(0));
211         require(msg.sender == newOwner);
212         _;
213     }
214 
215     function isOwner(address account) public view returns (bool) {
216         if( account == owner ){
217             return true;
218         }
219         else {
220             return false;
221         }
222     }
223 
224     function transferOwnership(address _newOwner) public onlyOwner {
225         require(_newOwner != address(0));
226         newOwner = _newOwner;
227     }
228 
229     function acceptOwnership() public onlyNewOwner returns(bool) {
230         emit OwnershipTransferred(owner, newOwner);
231         owner = newOwner;
232         newOwner = address(0);
233     }
234 }
235 
236 contract PauserRole is Ownable{
237     using Roles for Roles.Role;
238 
239     event PauserAdded(address indexed account);
240     event PauserRemoved(address indexed account);
241 
242     Roles.Role private _pausers;
243 
244     constructor () internal {
245         _addPauser(msg.sender);
246     }
247 
248     modifier onlyPauser() {
249         require(isPauser(msg.sender)|| isOwner(msg.sender));
250         _;
251     }
252 
253     function isPauser(address account) public view returns (bool) {
254         return _pausers.has(account);
255     }
256 
257     function addPauser(address account) public onlyPauser {
258         _addPauser(account);
259     }
260 
261     function removePauser(address account) public onlyOwner {
262         _removePauser(account);
263     }
264 
265     function renouncePauser() public {
266         _removePauser(msg.sender);
267     }
268 
269     function _addPauser(address account) internal {
270         _pausers.add(account);
271         emit PauserAdded(account);
272     }
273 
274     function _removePauser(address account) internal {
275         _pausers.remove(account);
276         emit PauserRemoved(account);
277     }
278 }
279 
280 contract Pausable is PauserRole {
281     event Paused(address account);
282     event Unpaused(address account);
283 
284     bool private _paused;
285 
286     constructor () internal {
287         _paused = false;
288     }
289 
290     /**
291      * @return true if the contract is paused, false otherwise.
292      */
293     function paused() public view returns (bool) {
294         return _paused;
295     }
296 
297     /**
298      * @dev Modifier to make a function callable only when the contract is not paused.
299      */
300     modifier whenNotPaused() {
301         require(!_paused);
302         _;
303     }
304 
305     /**
306      * @dev Modifier to make a function callable only when the contract is paused.
307      */
308     modifier whenPaused() {
309         require(_paused);
310         _;
311     }
312 
313     /**
314      * @dev called by the owner to pause, triggers stopped state
315      */
316     function pause() public onlyPauser whenNotPaused {
317         _paused = true;
318         emit Paused(msg.sender);
319     }
320 
321     /**
322      * @dev called by the owner to unpause, returns to normal state
323      */
324     function unpause() public onlyPauser whenPaused {
325         _paused = false;
326         emit Unpaused(msg.sender);
327     }
328 }
329 
330 interface IERC20 {
331     function transfer(address to, uint256 value) external returns (bool);
332 
333     function approve(address spender, uint256 value) external returns (bool);
334 
335     function transferFrom(address from, address to, uint256 value) external returns (bool);
336 
337     function totalSupply() external view returns (uint256);
338 
339     function balanceOf(address who) external view returns (uint256);
340 
341     function allowance(address owner, address spender) external view returns (uint256);
342 
343     event Transfer(address indexed from, address indexed to, uint256 value);
344 
345     event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 contract ERC20 is IERC20 {
349     using SafeMath for uint256;
350 
351     mapping (address => uint256) internal _balances;
352 
353     mapping (address => mapping (address => uint256)) internal _allowed;
354 
355     uint256 private _totalSupply;
356 
357     /**
358     * @dev Total number of tokens in existence
359     */
360     function totalSupply() public view returns (uint256) {
361         return _totalSupply;
362     }
363 
364     /**
365     * @dev Gets the balance of the specified address.
366     * @param owner The address to query the balance of.
367     * @return An uint256 representing the amount owned by the passed address.
368     */
369     function balanceOf(address owner) public view returns (uint256) {
370         return _balances[owner];
371     }
372 
373     /**
374      * @dev Function to check the amount of tokens that an owner allowed to a spender.
375      * @param owner address The address which owns the funds.
376      * @param spender address The address which will spend the funds.
377      * @return A uint256 specifying the amount of tokens still available for the spender.
378      */
379     function allowance(address owner, address spender) public view returns (uint256) {
380         return _allowed[owner][spender];
381     }
382 
383     /**
384      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
385      * Beware that changing an allowance with this method brings the risk that someone may use both the old
386      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
387      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
388      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389      * @param spender The address which will spend the funds.
390      * @param value The amount of tokens to be spent.
391      */
392     function approve(address spender, uint256 value) public returns (bool) {
393         require(spender != address(0));
394 
395         _allowed[msg.sender][spender] = value;
396         emit Approval(msg.sender, spender, value);
397         return true;
398     }
399 
400     /**
401      * @dev Transfer tokens from one address to another.
402      * Note that while this function emits an Approval event, this is not required as per the specification,
403      * and other compliant implementations may not emit the event.
404      * @param from address The address which you want to send tokens from
405      * @param to address The address which you want to transfer to
406      * @param value uint256 the amount of tokens to be transferred
407      */
408     function transferFrom(address from, address to, uint256 value) public returns (bool) {
409         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
410         _transfer(from, to, value);
411         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
412         return true;
413     }
414 
415     /**
416      * @dev Increase the amount of tokens that an owner allowed to a spender.
417      * approve should be called when allowed_[_spender] == 0. To increment
418      * allowed value is better to use this function to avoid 2 calls (and wait until
419      * the first transaction is mined)
420      * From MonolithDAO Token.sol
421      * Emits an Approval event.
422      * @param spender The address which will spend the funds.
423      * @param addedValue The amount of tokens to increase the allowance by.
424      */
425     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
426         require(spender != address(0));
427 
428         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
429         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
430         return true;
431     }
432 
433     /**
434      * @dev Decrease the amount of tokens that an owner allowed to a spender.
435      * approve should be called when allowed_[_spender] == 0. To decrement
436      * allowed value is better to use this function to avoid 2 calls (and wait until
437      * the first transaction is mined)
438      * From MonolithDAO Token.sol
439      * Emits an Approval event.
440      * @param spender The address which will spend the funds.
441      * @param subtractedValue The amount of tokens to decrease the allowance by.
442      */
443     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
444         require(spender != address(0));
445 
446         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
447         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
448         return true;
449     }
450 
451 
452     /**
453     * @dev Transfer token for a specified address
454     * @param to The address to transfer to.
455     * @param value The amount to be transferred.
456     */
457     function transfer(address to, uint256 value) public returns (bool) {
458         _transfer(msg.sender, to, value);
459         return true;
460     }
461 
462     /**
463     * @dev Transfer token for a specified addresses
464     * @param from The address to transfer from.
465     * @param to The address to transfer to.
466     * @param value The amount to be transferred.
467     */
468     function _transfer(address from, address to, uint256 value) internal {
469         require(to != address(0));
470         require(from != address(0));
471 
472         _balances[from] = _balances[from].sub(value);
473         _balances[to] = _balances[to].add(value);
474         emit Transfer(from, to, value);
475     }
476 
477     /**
478      * @dev Destroys `amount` tokens from the caller.
479      *
480      * See {ERC20-_burn}.
481      */
482     function burn(uint256 value) public returns (bool) {
483         _burn(msg.sender, value);
484         return true;
485     }
486 
487     /**
488      * @dev Internal function that burns an amount of the token of a given
489      * account.
490      * @param account The account whose tokens will be burnt.
491      * @param value The amount that will be burnt.
492      */
493     function _burn(address account, uint256 value) internal {
494         require(account != address(0));
495 
496         _totalSupply = _totalSupply.sub(value);
497         _balances[account] = _balances[account].sub(value);
498         emit Transfer(account, address(0), value);
499     }
500 
501     /**
502      * @dev Internal function that burns an amount of the token of a given
503      * account, deducting from the sender's allowance for said account. Uses the
504      * internal burn function.
505      * Emits an Approval event (reflecting the reduced allowance).
506      * @param account The account whose tokens will be burnt.
507      * @param value The amount that will be burnt.
508      */
509     function _burnFrom(address account, uint256 value) internal {
510         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
511         _burn(account, value);
512         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
513     }
514 
515     /**
516      * @dev Internal function that mints an amount of the token and assigns it to
517      * an account. This encapsulates the modification of balances such that the
518      * proper events are emitted.
519      * @param account The account that will receive the created tokens.
520      * @param value The amount that will be created.
521      */
522     function _mint(address account, uint256 value) internal {
523         require(account != address(0));
524 
525         _totalSupply = _totalSupply.add(value);
526         _balances[account] = _balances[account].add(value);
527         emit Transfer(address(0), account, value);
528     }
529 }
530 
531 contract ERC20Pausable is ERC20, Pausable {
532     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
533         return super.transfer(to, value);
534     }
535 
536     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
537         return super.transferFrom(from, to, value);
538     }
539 
540     /*
541      * approve/increaseApprove/decreaseApprove can be set when Paused state
542      */
543 
544     /*
545      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
546      *     return super.approve(spender, value);
547      * }
548      *
549      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
550      *     return super.increaseAllowance(spender, addedValue);
551      * }
552      *
553      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
554      *     return super.decreaseAllowance(spender, subtractedValue);
555      * }
556      */
557 }
558 
559 contract ERC20Detailed is IERC20 {
560     string private _name;
561     string private _symbol;
562     uint8 private _decimals;
563 
564     constructor (string memory name, string memory symbol, uint8 decimals) public {
565         _name = name;
566         _symbol = symbol;
567         _decimals = decimals;
568     }
569 
570     /**
571      * @return the name of the token.
572      */
573     function name() public view returns (string memory) {
574         return _name;
575     }
576 
577     /**
578      * @return the symbol of the token.
579      */
580     function symbol() public view returns (string memory) {
581         return _symbol;
582     }
583 
584     /**
585      * @return the number of decimals of the token.
586      */
587     function decimals() public view returns (uint8) {
588         return _decimals;
589     }
590 }
591 
592 contract ERC20Camp is ERC20Detailed, ERC20Pausable {
593 
594     struct LockInfo {
595         uint256 _releaseTime;
596         uint256 _amount;
597     }
598 
599     mapping (address => LockInfo[]) public timelockList;
600     mapping (address => bool) public frozenAccount;
601 
602     event Freeze(address indexed holder);
603     event Unfreeze(address indexed holder);
604     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
605     event Unlock(address indexed holder, uint256 value);
606 
607     modifier notFrozen(address _holder) {
608         require(!frozenAccount[_holder]);
609         _;
610     }
611 
612     constructor() ERC20Detailed("Camp", "CAMP", 18) public  {
613 
614         _mint(msg.sender, 10000000000 * (10 ** 18));
615     }
616 
617     function timelockListLength(address owner) public view returns (uint256) {
618         return timelockList[owner].length;
619     }
620 
621     function balanceOf(address owner) public view returns (uint256) {
622 
623         uint256 totalBalance = super.balanceOf(owner);
624         if( timelockList[owner].length >0 ){
625             for(uint i=0; i<timelockList[owner].length;i++){
626                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
627             }
628         }
629 
630         return totalBalance;
631     }
632 
633     function balanceOfTimelocked(address owner) public view returns (uint256) {
634 
635         uint256 totalLocked = 0;
636         if( timelockList[owner].length >0 ){
637             for(uint i=0; i<timelockList[owner].length;i++){
638                 totalLocked = totalLocked.add(timelockList[owner][i]._amount);
639             }
640         }
641 
642         return totalLocked;
643     }
644 
645     function balanceOfAvailable(address owner) public view returns (uint256) {
646 
647         uint256 totalBalance = super.balanceOf(owner);
648         return totalBalance;
649     }
650 
651     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
652         if (timelockList[msg.sender].length > 0 ) {
653             _autoUnlock(msg.sender);
654         }
655         return super.transfer(to, value);
656     }
657 
658     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
659         if (timelockList[from].length > 0) {
660             _autoUnlock(from);
661         }
662         return super.transferFrom(from, to, value);
663     }
664 
665     function freezeAccount(address holder) public onlyPauser returns (bool) {
666         require(!frozenAccount[holder]);
667         require(timelockList[holder].length == 0);
668         frozenAccount[holder] = true;
669         emit Freeze(holder);
670         return true;
671     }
672 
673     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
674         require(frozenAccount[holder]);
675         frozenAccount[holder] = false;
676         emit Unfreeze(holder);
677         return true;
678     }
679 
680     function lockByQuantity(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
681         require(!frozenAccount[holder]);
682         _lock(holder,value,releaseTime);
683         return true;
684     }
685 
686     function unlockByQuantity(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
687         //1
688         require(!frozenAccount[holder]);
689         //2
690         require(timelockList[holder].length >0);
691 
692         //3
693         uint256 totalLocked;
694         for(uint idx = 0; idx < timelockList[holder].length ; idx++ ){
695             totalLocked = totalLocked.add(timelockList[holder][idx]._amount);
696         }
697         require(totalLocked >value);
698 
699         //4
700         for(uint idx = 0; idx < timelockList[holder].length ; idx++ ) {
701             if( _unlock(holder, idx) ) {
702                 idx -=1;
703             }
704         }
705 
706         //5
707         _lock(holder,totalLocked.sub(value),releaseTime);
708 
709         return true;
710     }
711 
712     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
713         _transfer(msg.sender, holder, value);
714         _lock(holder,value,releaseTime);
715         return true;
716     }
717 
718     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
719         require( timelockList[holder].length > idx, "AhnLog_There is not lock info.");
720         _unlock(holder,idx);
721         return true;
722     }
723 
724 
725     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns (bool) {
726         _balances[holder] = _balances[holder].sub(value);
727         timelockList[holder].push( LockInfo(releaseTime, value) );
728 
729         emit Lock(holder, value, releaseTime);
730         return true;
731     }
732 
733     function _unlock(address holder, uint256 idx) internal returns(bool) {
734         LockInfo storage lockinfo = timelockList[holder][idx];
735         uint256 releaseAmount = lockinfo._amount;
736 
737         delete timelockList[holder][idx];
738         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
739         timelockList[holder].length -=1;
740 
741         emit Unlock(holder, releaseAmount);
742         _balances[holder] = _balances[holder].add(releaseAmount);
743 
744         return true;
745     }
746 
747     function _autoUnlock(address holder) internal returns (bool) {
748         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
749             if (timelockList[holder][idx]._releaseTime <= now) {
750                 // If lockupinfo was deleted, loop restart at same position.
751                 if( _unlock(holder, idx) ) {
752                     idx -=1;
753                 }
754             }
755         }
756         return true;
757     }
758 
759 }