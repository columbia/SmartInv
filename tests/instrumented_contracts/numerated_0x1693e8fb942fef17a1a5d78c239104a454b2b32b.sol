1 pragma solidity 0.5.8;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
189 
190 /**
191  * @dev Implementation of the `IERC20` interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using `_mint`.
195  * For a generic mechanism see `ERC20Mintable`.
196  *
197  * *For a detailed writeup see our guide [How to implement supply
198  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
199  *
200  * We have followed general OpenZeppelin guidelines: functions revert instead
201  * of returning `false` on failure. This behavior is nonetheless conventional
202  * and does not conflict with the expectations of ERC20 applications.
203  *
204  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
205  * This allows applications to reconstruct the allowance for all accounts just
206  * by listening to said events. Other implementations of the EIP may not emit
207  * these events, as it isn't required by the specification.
208  *
209  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
210  * functions have been added to mitigate the well-known issues around setting
211  * allowances. See `IERC20.approve`.
212  */
213 contract ERC20 is IERC20 {
214     using SafeMath for uint256;
215 
216     mapping (address => uint256) internal _balances;
217 
218     mapping (address => mapping (address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     /**
223      * @dev See `IERC20.totalSupply`.
224      */
225     function totalSupply() public view returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See `IERC20.balanceOf`.
231      */
232     function balanceOf(address account) public view returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See `IERC20.transfer`.
238      *
239      * Requirements:
240      *
241      * - `recipient` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address recipient, uint256 amount) public returns (bool) {
245         _transfer(msg.sender, recipient, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See `IERC20.allowance`.
251      */
252     function allowance(address owner, address spender) public view returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     /**
257      * @dev See `IERC20.approve`.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function approve(address spender, uint256 value) public returns (bool) {
264         _approve(msg.sender, spender, value);
265         return true;
266     }
267 
268     /**
269      * @dev See `IERC20.transferFrom`.
270      *
271      * Emits an `Approval` event indicating the updated allowance. This is not
272      * required by the EIP. See the note at the beginning of `ERC20`;
273      *
274      * Requirements:
275      * - `sender` and `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `value`.
277      * - the caller must have allowance for `sender`'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
283         return true;
284     }
285 
286     /**
287      * @dev Atomically increases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to `approve` that can be used as a mitigation for
290      * problems described in `IERC20.approve`.
291      *
292      * Emits an `Approval` event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
299         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
300         return true;
301     }
302 
303     /**
304      * @dev Atomically decreases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to `approve` that can be used as a mitigation for
307      * problems described in `IERC20.approve`.
308      *
309      * Emits an `Approval` event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      * - `spender` must have allowance for the caller of at least
315      * `subtractedValue`.
316      */
317     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
318         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
319         return true;
320     }
321 
322     /**
323      * @dev Moves tokens `amount` from `sender` to `recipient`.
324      *
325      * This is internal function is equivalent to `transfer`, and can be used to
326      * e.g. implement automatic token fees, slashing mechanisms, etc.
327      *
328      * Emits a `Transfer` event.
329      *
330      * Requirements:
331      *
332      * - `sender` cannot be the zero address.
333      * - `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      */
336     function _transfer(address sender, address recipient, uint256 amount) internal {
337         require(sender != address(0), "ERC20: transfer from the zero address");
338         require(recipient != address(0), "ERC20: transfer to the zero address");
339 
340         _balances[sender] = _balances[sender].sub(amount);
341         _balances[recipient] = _balances[recipient].add(amount);
342         emit Transfer(sender, recipient, amount);
343     }
344 
345     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
346      * the total supply.
347      *
348      * Emits a `Transfer` event with `from` set to the zero address.
349      *
350      * Requirements
351      *
352      * - `to` cannot be the zero address.
353      */
354     function _mint(address account, uint256 amount) internal {
355         require(account != address(0), "ERC20: mint to the zero address");
356 
357         _totalSupply = _totalSupply.add(amount);
358         _balances[account] = _balances[account].add(amount);
359         emit Transfer(address(0), account, amount);
360     }
361 
362      /**
363      * @dev Destoys `amount` tokens from `account`, reducing the
364      * total supply.
365      *
366      * Emits a `Transfer` event with `to` set to the zero address.
367      *
368      * Requirements
369      *
370      * - `account` cannot be the zero address.
371      * - `account` must have at least `amount` tokens.
372      */
373     function _burn(address account, uint256 value) internal {
374         require(account != address(0), "ERC20: burn from the zero address");
375 
376         _totalSupply = _totalSupply.sub(value);
377         _balances[account] = _balances[account].sub(value);
378         emit Transfer(account, address(0), value);
379     }
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
383      *
384      * This is internal function is equivalent to `approve`, and can be used to
385      * e.g. set automatic allowances for certain subsystems, etc.
386      *
387      * Emits an `Approval` event.
388      *
389      * Requirements:
390      *
391      * - `owner` cannot be the zero address.
392      * - `spender` cannot be the zero address.
393      */
394     function _approve(address owner, address spender, uint256 value) internal {
395         require(owner != address(0), "ERC20: approve from the zero address");
396         require(spender != address(0), "ERC20: approve to the zero address");
397 
398         _allowances[owner][spender] = value;
399         emit Approval(owner, spender, value);
400     }
401 
402     /**
403      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
404      * from the caller's allowance.
405      *
406      * See `_burn` and `_approve`.
407      */
408     function _burnFrom(address account, uint256 amount) internal {
409         _burn(account, amount);
410         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
411     }
412 }
413 
414 // File: contracts\BlobsCoin.sol
415 
416 contract BlobsCoin is ERC20 {
417     string public constant name = "Blobs Coin"; 
418     string public constant symbol = "BLC"; 
419     uint8 public constant decimals = 18; 
420     uint256 public constant initialSupply = 20000000 * (10 ** uint256(decimals));
421     
422     constructor() public {
423         super._mint(msg.sender, initialSupply);
424         owner = msg.sender;
425     }
426 
427     //ownership
428     address public owner;
429 
430     event OwnershipRenounced(address indexed previousOwner);
431     event OwnershipTransferred(
432     address indexed previousOwner,
433     address indexed newOwner
434     );
435 
436     modifier onlyOwner() {
437         require(msg.sender == owner, "Not owner");
438         _;
439     }
440 
441   /**
442    * @dev Allows the current owner to relinquish control of the contract.
443    * @notice Renouncing to ownership will leave the contract without an owner.
444    * It will not be possible to call the functions with the `onlyOwner`
445    * modifier anymore.
446    */
447     function renounceOwnership() public onlyOwner {
448         emit OwnershipRenounced(owner);
449         owner = address(0);
450     }
451 
452   /**
453    * @dev Allows the current owner to transfer control of the contract to a newOwner.
454    * @param _newOwner The address to transfer ownership to.
455    */
456     function transferOwnership(address _newOwner) public onlyOwner {
457         _transferOwnership(_newOwner);
458     }
459 
460   /**
461    * @dev Transfers control of the contract to a newOwner.
462    * @param _newOwner The address to transfer ownership to.
463    */
464     function _transferOwnership(address _newOwner) internal {
465         require(_newOwner != address(0), "Already owner");
466         emit OwnershipTransferred(owner, _newOwner);
467         owner = _newOwner;
468     }
469 
470     //pausable
471     event Pause();
472     event Unpause();
473 
474     bool public paused = false;
475     
476     /**
477     * @dev Modifier to make a function callable only when the contract is not paused.
478     */
479     modifier whenNotPaused() {
480         require(!paused, "Paused by owner");
481         _;
482     }
483 
484     /**
485     * @dev Modifier to make a function callable only when the contract is paused.
486     */
487     modifier whenPaused() {
488         require(paused, "Not paused now");
489         _;
490     }
491 
492     /**
493     * @dev called by the owner to pause, triggers stopped state
494     */
495     function pause() public onlyOwner whenNotPaused {
496         paused = true;
497         emit Pause();
498     }
499 
500     /**
501     * @dev called by the owner to unpause, returns to normal state
502     */
503     function unpause() public onlyOwner whenPaused {
504         paused = false;
505         emit Unpause();
506     }
507 
508     //freezable
509     event Frozen(address target);
510     event Unfrozen(address target);
511 
512     mapping(address => bool) internal freezes;
513 
514     modifier whenNotFrozen() {
515         require(!freezes[msg.sender], "Sender account is locked.");
516         _;
517     }
518 
519     function freeze(address _target) public onlyOwner {
520         freezes[_target] = true;
521         emit Frozen(_target);
522     }
523 
524     function unfreeze(address _target) public onlyOwner {
525         freezes[_target] = false;
526         emit Unfrozen(_target);
527     }
528 
529     function isFrozen(address _target) public view returns (bool) {
530         return freezes[_target];
531     }
532 
533     function transfer(
534         address _to,
535         uint256 _value
536     )
537       public
538       whenNotFrozen
539       whenNotPaused
540       returns (bool)
541     {
542         releaseLock(msg.sender);
543         return super.transfer(_to, _value);
544     }
545 
546     function transferFrom(
547         address _from,
548         address _to,
549         uint256 _value
550     )
551       public
552       whenNotPaused
553       returns (bool)
554     {
555         require(!freezes[_from], "From account is locked.");
556         releaseLock(_from);
557         return super.transferFrom(_from, _to, _value);
558     }
559 
560     //mintable
561     event Mint(address indexed to, uint256 amount);
562 
563     function mint(
564         address _to,
565         uint256 _amount
566     )
567       public
568       onlyOwner
569       returns (bool)
570     {
571         super._mint(_to, _amount);
572         emit Mint(_to, _amount);
573         return true;
574     }
575 
576     //burnable
577     event Burn(address indexed burner, uint256 value);
578 
579     function burn(address _who, uint256 _value) public onlyOwner {
580         require(_value <= super.balanceOf(_who), "Balance is too small.");
581 
582         _burn(_who, _value);
583         emit Burn(_who, _value);
584     }
585 
586     //lockable
587     struct LockInfo {
588         uint256 releaseTime;
589         uint256 balance;
590     }
591     mapping(address => LockInfo[]) internal lockInfo;
592 
593     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
594     event Unlock(address indexed holder, uint256 value);
595 
596     function balanceOf(address _holder) public view returns (uint256 balance) {
597         uint256 lockedBalance = 0;
598         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
599             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
600         }
601         return super.balanceOf(_holder).add(lockedBalance);
602     }
603 
604     function releaseLock(address _holder) internal {
605 
606         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
607             if (lockInfo[_holder][i].releaseTime <= now) {
608                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
609                 emit Unlock(_holder, lockInfo[_holder][i].balance);
610                 lockInfo[_holder][i].balance = 0;
611 
612                 if (i != lockInfo[_holder].length - 1) {
613                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
614                     i--;
615                 }
616                 lockInfo[_holder].length--;
617 
618             }
619         }
620     }
621     function lockCount(address _holder) public view returns (uint256) {
622         return lockInfo[_holder].length;
623     }
624     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
625         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
626     }
627 
628     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
629         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
630         _balances[_holder] = _balances[_holder].sub(_amount);
631         lockInfo[_holder].push(
632             LockInfo(_releaseTime, _amount)
633         );
634         emit Lock(_holder, _amount, _releaseTime);
635     }
636 
637     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
638         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
639         _balances[_holder] = _balances[_holder].sub(_amount);
640         lockInfo[_holder].push(
641             LockInfo(now + _afterTime, _amount)
642         );
643         emit Lock(_holder, _amount, now + _afterTime);
644     }
645 
646     function unlock(address _holder, uint256 i) public onlyOwner {
647         require(i < lockInfo[_holder].length, "No lock information.");
648 
649         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
650         emit Unlock(_holder, lockInfo[_holder][i].balance);
651         lockInfo[_holder][i].balance = 0;
652 
653         if (i != lockInfo[_holder].length - 1) {
654             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
655         }
656         lockInfo[_holder].length--;
657     }
658 
659     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
660         require(_to != address(0), "wrong address");
661         require(_value <= super.balanceOf(owner), "Not enough balance");
662 
663         _balances[owner] = _balances[owner].sub(_value);
664         lockInfo[_to].push(
665             LockInfo(_releaseTime, _value)
666         );
667         emit Transfer(owner, _to, _value);
668         emit Lock(_to, _value, _releaseTime);
669 
670         return true;
671     }
672 
673     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
674         require(_to != address(0), "wrong address");
675         require(_value <= super.balanceOf(owner), "Not enough balance");
676 
677         _balances[owner] = _balances[owner].sub(_value);
678         lockInfo[_to].push(
679             LockInfo(now + _afterTime, _value)
680         );
681         emit Transfer(owner, _to, _value);
682         emit Lock(_to, _value, now + _afterTime);
683 
684         return true;
685     }
686 
687     function currentTime() public view returns (uint256) {
688         return now;
689     }
690 
691     function afterTime(uint256 _value) public view returns (uint256) {
692         return now + _value;
693     }
694 }