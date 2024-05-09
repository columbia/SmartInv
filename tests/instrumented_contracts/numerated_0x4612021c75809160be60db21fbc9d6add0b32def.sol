1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
121      * Reverts when dividing by zero.
122      *
123      * Counterpart to Solidity's `%` operator. This function uses a `revert`
124      * opcode (which leaves remaining gas untouched) while Solidity uses an
125      * invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return mod(a, b, "SafeMath: modulo by zero");
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts with custom message when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b != 0, errorMessage);
147         return a % b;
148     }
149 }
150 
151 library Roles {
152     struct Role {
153         mapping (address => bool) bearer;
154     }
155 
156     /**
157      * @dev give an account access to this role
158      */
159     function add(Role storage role, address account) internal {
160         require(account != address(0));
161         require(!has(role, account));
162 
163         role.bearer[account] = true;
164     }
165 
166     /**
167      * @dev remove an account's access to this role
168      */
169     function remove(Role storage role, address account) internal {
170         require(account != address(0));
171         require(has(role, account));
172 
173         role.bearer[account] = false;
174     }
175 
176     /**
177      * @dev check if an account has this role
178      * @return bool
179      */
180     function has(Role storage role, address account) internal view returns (bool) {
181         require(account != address(0));
182         return role.bearer[account];
183     }
184 }
185 
186 contract Ownable {
187     address public owner;
188     address public newOwner;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     constructor() public {
193         owner = msg.sender;
194         newOwner = address(0);
195     }
196 
197     modifier onlyOwner() {
198         require(msg.sender == owner);
199         _;
200     }
201     modifier onlyNewOwner() {
202         require(msg.sender != address(0));
203         require(msg.sender == newOwner);
204         _;
205     }
206 
207     function isOwner(address account) public view returns (bool) {
208         if( account == owner ){
209             return true;
210         }
211         else {
212             return false;
213         }
214     }
215 
216     function transferOwnership(address _newOwner) public onlyOwner {
217         require(_newOwner != address(0));
218         newOwner = _newOwner;
219     }
220 
221     function acceptOwnership() public onlyNewOwner returns(bool) {
222         emit OwnershipTransferred(owner, newOwner);
223         owner = newOwner;
224         newOwner = address(0);
225     }
226 }
227 
228 contract PauserRole is Ownable{
229     using Roles for Roles.Role;
230 
231     event PauserAdded(address indexed account);
232     event PauserRemoved(address indexed account);
233 
234     Roles.Role private _pausers;
235 
236     constructor () internal {
237         _addPauser(msg.sender);
238     }
239 
240     modifier onlyPauser() {
241         require(isPauser(msg.sender)|| isOwner(msg.sender));
242         _;
243     }
244 
245     function isPauser(address account) public view returns (bool) {
246         return _pausers.has(account);
247     }
248 
249     function addPauser(address account) public onlyPauser {
250         _addPauser(account);
251     }
252 
253     function removePauser(address account) public onlyOwner {
254         _removePauser(account);
255     }
256 
257     function renouncePauser() public {
258         _removePauser(msg.sender);
259     }
260 
261     function _addPauser(address account) internal {
262         _pausers.add(account);
263         emit PauserAdded(account);
264     }
265 
266     function _removePauser(address account) internal {
267         _pausers.remove(account);
268         emit PauserRemoved(account);
269     }
270 }
271 
272 contract Pausable is PauserRole {
273     event Paused(address account);
274     event Unpaused(address account);
275 
276     bool private _paused;
277 
278     constructor () internal {
279         _paused = false;
280     }
281 
282     /**
283      * @return true if the contract is paused, false otherwise.
284      */
285     function paused() public view returns (bool) {
286         return _paused;
287     }
288 
289     /**
290      * @dev Modifier to make a function callable only when the contract is not paused.
291      */
292     modifier whenNotPaused() {
293         require(!_paused);
294         _;
295     }
296 
297     /**
298      * @dev Modifier to make a function callable only when the contract is paused.
299      */
300     modifier whenPaused() {
301         require(_paused);
302         _;
303     }
304 
305     /**
306      * @dev called by the owner to pause, triggers stopped state
307      */
308     function pause() public onlyPauser whenNotPaused {
309         _paused = true;
310         emit Paused(msg.sender);
311     }
312 
313     /**
314      * @dev called by the owner to unpause, returns to normal state
315      */
316     function unpause() public onlyPauser whenPaused {
317         _paused = false;
318         emit Unpaused(msg.sender);
319     }
320 }
321 
322 interface IERC20 {
323     function transfer(address to, uint256 value) external returns (bool);
324 
325     function approve(address spender, uint256 value) external returns (bool);
326 
327     function transferFrom(address from, address to, uint256 value) external returns (bool);
328 
329     function totalSupply() external view returns (uint256);
330 
331     function balanceOf(address who) external view returns (uint256);
332 
333     function allowance(address owner, address spender) external view returns (uint256);
334 
335     event Transfer(address indexed from, address indexed to, uint256 value);
336 
337     event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 contract ERC20 is IERC20 {
341     using SafeMath for uint256;
342 
343     mapping (address => uint256) internal _balances;
344 
345     mapping (address => mapping (address => uint256)) internal _allowed;
346 
347     uint256 private _totalSupply;
348 
349     /**
350     * @dev Total number of tokens in existence
351     */
352     function totalSupply() public view returns (uint256) {
353         return _totalSupply;
354     }
355 
356     /**
357     * @dev Gets the balance of the specified address.
358     * @param owner The address to query the balance of.
359     * @return An uint256 representing the amount owned by the passed address.
360     */
361     function balanceOf(address owner) public view returns (uint256) {
362         return _balances[owner];
363     }
364 
365     /**
366      * @dev Function to check the amount of tokens that an owner allowed to a spender.
367      * @param owner address The address which owns the funds.
368      * @param spender address The address which will spend the funds.
369      * @return A uint256 specifying the amount of tokens still available for the spender.
370      */
371     function allowance(address owner, address spender) public view returns (uint256) {
372         return _allowed[owner][spender];
373     }
374 
375     /**
376      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
377      * Beware that changing an allowance with this method brings the risk that someone may use both the old
378      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
379      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
380      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381      * @param spender The address which will spend the funds.
382      * @param value The amount of tokens to be spent.
383      */
384     function approve(address spender, uint256 value) public returns (bool) {
385         require(spender != address(0));
386 
387         _allowed[msg.sender][spender] = value;
388         emit Approval(msg.sender, spender, value);
389         return true;
390     }
391 
392     /**
393      * @dev Transfer tokens from one address to another.
394      * Note that while this function emits an Approval event, this is not required as per the specification,
395      * and other compliant implementations may not emit the event.
396      * @param from address The address which you want to send tokens from
397      * @param to address The address which you want to transfer to
398      * @param value uint256 the amount of tokens to be transferred
399      */
400     function transferFrom(address from, address to, uint256 value) public returns (bool) {
401         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
402         _transfer(from, to, value);
403         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
404         return true;
405     }
406 
407     /**
408      * @dev Increase the amount of tokens that an owner allowed to a spender.
409      * approve should be called when allowed_[_spender] == 0. To increment
410      * allowed value is better to use this function to avoid 2 calls (and wait until
411      * the first transaction is mined)
412      * From MonolithDAO Token.sol
413      * Emits an Approval event.
414      * @param spender The address which will spend the funds.
415      * @param addedValue The amount of tokens to increase the allowance by.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
418         require(spender != address(0));
419 
420         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
421         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
422         return true;
423     }
424 
425     /**
426      * @dev Decrease the amount of tokens that an owner allowed to a spender.
427      * approve should be called when allowed_[_spender] == 0. To decrement
428      * allowed value is better to use this function to avoid 2 calls (and wait until
429      * the first transaction is mined)
430      * From MonolithDAO Token.sol
431      * Emits an Approval event.
432      * @param spender The address which will spend the funds.
433      * @param subtractedValue The amount of tokens to decrease the allowance by.
434      */
435     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
436         require(spender != address(0));
437 
438         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
439         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
440         return true;
441     }
442 
443 
444     /**
445     * @dev Transfer token for a specified address
446     * @param to The address to transfer to.
447     * @param value The amount to be transferred.
448     */
449     function transfer(address to, uint256 value) public returns (bool) {
450         _transfer(msg.sender, to, value);
451         return true;
452     }
453 
454     /**
455     * @dev Transfer token for a specified addresses
456     * @param from The address to transfer from.
457     * @param to The address to transfer to.
458     * @param value The amount to be transferred.
459     */
460     function _transfer(address from, address to, uint256 value) internal {
461         require(to != address(0));
462         require(from != address(0));
463 
464         _balances[from] = _balances[from].sub(value);
465         _balances[to] = _balances[to].add(value);
466         emit Transfer(from, to, value);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from the caller.
471      *
472      * See {ERC20-_burn}.
473      */
474     function burn(uint256 value) public returns (bool) {
475         _burn(msg.sender, value);
476         return true;
477     }
478 
479     /**
480      * @dev Internal function that burns an amount of the token of a given
481      * account.
482      * @param account The account whose tokens will be burnt.
483      * @param value The amount that will be burnt.
484      */
485     function _burn(address account, uint256 value) internal {
486         require(account != address(0));
487 
488         _totalSupply = _totalSupply.sub(value);
489         _balances[account] = _balances[account].sub(value);
490         emit Transfer(account, address(0), value);
491     }
492 
493     /**
494      * @dev Internal function that burns an amount of the token of a given
495      * account, deducting from the sender's allowance for said account. Uses the
496      * internal burn function.
497      * Emits an Approval event (reflecting the reduced allowance).
498      * @param account The account whose tokens will be burnt.
499      * @param value The amount that will be burnt.
500      */
501     function _burnFrom(address account, uint256 value) internal {
502         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
503         _burn(account, value);
504         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
505     }
506 
507     /**
508      * @dev Internal function that mints an amount of the token and assigns it to
509      * an account. This encapsulates the modification of balances such that the
510      * proper events are emitted.
511      * @param account The account that will receive the created tokens.
512      * @param value The amount that will be created.
513      */
514     function _mint(address account, uint256 value) internal {
515         require(account != address(0));
516 
517         _totalSupply = _totalSupply.add(value);
518         _balances[account] = _balances[account].add(value);
519         emit Transfer(address(0), account, value);
520     }
521 }
522 
523 contract ERC20Pausable is ERC20, Pausable {
524     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
525         return super.transfer(to, value);
526     }
527 
528     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
529         return super.transferFrom(from, to, value);
530     }
531 
532     /*
533      * approve/increaseApprove/decreaseApprove can be set when Paused state
534      */
535 
536     /*
537      * function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
538      *     return super.approve(spender, value);
539      * }
540      *
541      * function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
542      *     return super.increaseAllowance(spender, addedValue);
543      * }
544      *
545      * function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
546      *     return super.decreaseAllowance(spender, subtractedValue);
547      * }
548      */
549 }
550 
551 contract ERC20Detailed is IERC20 {
552     string private _name;
553     string private _symbol;
554     uint8 private _decimals;
555 
556     constructor (string memory name, string memory symbol, uint8 decimals) public {
557         _name = name;
558         _symbol = symbol;
559         _decimals = decimals;
560     }
561 
562     /**
563      * @return the name of the token.
564      */
565     function name() public view returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @return the symbol of the token.
571      */
572     function symbol() public view returns (string memory) {
573         return _symbol;
574     }
575 
576     /**
577      * @return the number of decimals of the token.
578      */
579     function decimals() public view returns (uint8) {
580         return _decimals;
581     }
582 }
583 
584 contract ERC20ext is ERC20Detailed, ERC20Pausable {
585 
586     struct LockInfo {
587         uint256 _releaseTime;
588         uint256 _amount;
589     }
590 
591     mapping (address => LockInfo[]) public timelockList;
592     mapping (address => bool) public frozenAccount;
593 
594     event Freeze(address indexed holder);
595     event Unfreeze(address indexed holder);
596     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
597     event Unlock(address indexed holder, uint256 value);
598 
599     modifier notFrozen(address _holder) {
600         require(!frozenAccount[_holder]);
601         _;
602     }
603 
604     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20Detailed(name, symbol, decimals) public  {
605         _mint(msg.sender, amount * 10 ** uint256(decimals));
606     }
607 
608     function timelockListLength(address owner) public view returns (uint256) {
609         return timelockList[owner].length;
610     }
611 
612     function balanceOf(address owner) public view returns (uint256) {
613 
614         uint256 totalBalance = super.balanceOf(owner);
615         if( timelockList[owner].length >0 ){
616             for(uint i=0; i<timelockList[owner].length;i++){
617                 totalBalance = totalBalance.add(timelockList[owner][i]._amount);
618             }
619         }
620 
621         return totalBalance;
622     }
623 
624     function balanceOfTimelocked(address owner) public view returns (uint256) {
625 
626         uint256 totalLocked = 0;
627         if( timelockList[owner].length >0 ){
628             for(uint i=0; i<timelockList[owner].length;i++){
629                 totalLocked = totalLocked.add(timelockList[owner][i]._amount);
630             }
631         }
632 
633         return totalLocked;
634     }
635 
636     function balanceOfAvailable(address owner) public view returns (uint256) {
637 
638         uint256 totalBalance = super.balanceOf(owner);
639         return totalBalance;
640     }
641 
642     function transfer(address to, uint256 value) public notFrozen(msg.sender) returns (bool) {
643         if (timelockList[msg.sender].length > 0 ) {
644             _autoUnlock(msg.sender);
645         }
646         return super.transfer(to, value);
647     }
648 
649     function transferFrom(address from, address to, uint256 value) public notFrozen(from) returns (bool) {
650         if (timelockList[from].length > 0) {
651             _autoUnlock(from);
652         }
653         return super.transferFrom(from, to, value);
654     }
655 
656     function freezeAccount(address holder) public onlyPauser returns (bool) {
657         require(!frozenAccount[holder]);
658         require(timelockList[holder].length == 0);
659         frozenAccount[holder] = true;
660         emit Freeze(holder);
661         return true;
662     }
663 
664     function unfreezeAccount(address holder) public onlyPauser returns (bool) {
665         require(frozenAccount[holder]);
666         frozenAccount[holder] = false;
667         emit Unfreeze(holder);
668         return true;
669     }
670 
671     function lockByQuantity(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
672         require(!frozenAccount[holder]);
673         _lock(holder,value,releaseTime);
674         return true;
675     }
676 
677     function unlockByQuantity(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
678         //1
679         require(!frozenAccount[holder]);
680         //2
681         require(timelockList[holder].length >0);
682 
683         //3
684         uint256 totalLocked;
685         for(uint idx = 0; idx < timelockList[holder].length ; idx++ ){
686             totalLocked = totalLocked.add(timelockList[holder][idx]._amount);
687         }
688         require(totalLocked >value);
689 
690         //4
691         for(uint idx = 0; idx < timelockList[holder].length ; idx++ ) {
692             if( _unlock(holder, idx) ) {
693                 idx -=1;
694             }
695         }
696 
697         //5
698         _lock(holder,totalLocked.sub(value),releaseTime);
699 
700         return true;
701     }
702 
703     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlyPauser returns (bool) {
704         _transfer(msg.sender, holder, value);
705         _lock(holder,value,releaseTime);
706         return true;
707     }
708 
709     function unlock(address holder, uint256 idx) public onlyPauser returns (bool) {
710         require( timelockList[holder].length > idx, "AhnLog_There is not lock info.");
711         _unlock(holder,idx);
712         return true;
713     }
714 
715 
716     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns (bool) {
717         _balances[holder] = _balances[holder].sub(value);
718         timelockList[holder].push( LockInfo(releaseTime, value) );
719 
720         emit Lock(holder, value, releaseTime);
721         return true;
722     }
723 
724     function _unlock(address holder, uint256 idx) internal returns(bool) {
725         LockInfo storage lockinfo = timelockList[holder][idx];
726         uint256 releaseAmount = lockinfo._amount;
727 
728         delete timelockList[holder][idx];
729         timelockList[holder][idx] = timelockList[holder][timelockList[holder].length.sub(1)];
730         timelockList[holder].length -=1;
731 
732         emit Unlock(holder, releaseAmount);
733         _balances[holder] = _balances[holder].add(releaseAmount);
734 
735         return true;
736     }
737 
738     function _autoUnlock(address holder) internal returns (bool) {
739         for(uint256 idx =0; idx < timelockList[holder].length ; idx++ ) {
740             if (timelockList[holder][idx]._releaseTime <= now) {
741                 // If lockupinfo was deleted, loop restart at same position.
742                 if( _unlock(holder, idx) ) {
743                     idx -=1;
744                 }
745             }
746         }
747         return true;
748     }
749 
750 }