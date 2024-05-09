1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
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
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) internal _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: contracts\MQL.sol
421 
422 pragma solidity 0.5.8;
423 
424 
425 contract MQL is ERC20 {
426     string public constant name = "MiraQle"; 
427     string public constant symbol = "MQL"; 
428     uint8 public constant decimals = 18; 
429     uint256 public constant initialSupply = 2000000000 * (10 ** uint256(decimals));
430     
431     constructor() public {
432         super._mint(msg.sender, initialSupply);
433         owner = msg.sender;
434     }
435 
436     //ownership
437     address public owner;
438 
439     event OwnershipRenounced(address indexed previousOwner);
440     event OwnershipTransferred(
441     address indexed previousOwner,
442     address indexed newOwner
443     );
444 
445     modifier onlyOwner() {
446         require(msg.sender == owner, "Not owner");
447         _;
448     }
449 
450   /**
451    * @dev Allows the current owner to relinquish control of the contract.
452    * @notice Renouncing to ownership will leave the contract without an owner.
453    * It will not be possible to call the functions with the `onlyOwner`
454    * modifier anymore.
455    */
456     function renounceOwnership() public onlyOwner {
457         emit OwnershipRenounced(owner);
458         owner = address(0);
459     }
460 
461   /**
462    * @dev Allows the current owner to transfer control of the contract to a newOwner.
463    * @param _newOwner The address to transfer ownership to.
464    */
465     function transferOwnership(address _newOwner) public onlyOwner {
466         _transferOwnership(_newOwner);
467     }
468 
469   /**
470    * @dev Transfers control of the contract to a newOwner.
471    * @param _newOwner The address to transfer ownership to.
472    */
473     function _transferOwnership(address _newOwner) internal {
474         require(_newOwner != address(0), "Already owner");
475         emit OwnershipTransferred(owner, _newOwner);
476         owner = _newOwner;
477     }
478 
479     //pausable
480     event Pause();
481     event Unpause();
482 
483     bool public paused = false;
484     
485     /**
486     * @dev Modifier to make a function callable only when the contract is not paused.
487     */
488     modifier whenNotPaused() {
489         require(!paused, "Paused by owner");
490         _;
491     }
492 
493     /**
494     * @dev Modifier to make a function callable only when the contract is paused.
495     */
496     modifier whenPaused() {
497         require(paused, "Not paused now");
498         _;
499     }
500 
501     /**
502     * @dev called by the owner to pause, triggers stopped state
503     */
504     function pause() public onlyOwner whenNotPaused {
505         paused = true;
506         emit Pause();
507     }
508 
509     /**
510     * @dev called by the owner to unpause, returns to normal state
511     */
512     function unpause() public onlyOwner whenPaused {
513         paused = false;
514         emit Unpause();
515     }
516 
517     //freezable
518     event Frozen(address target);
519     event Unfrozen(address target);
520 
521     mapping(address => bool) internal freezes;
522 
523     modifier whenNotFrozen() {
524         require(!freezes[msg.sender], "Sender account is locked.");
525         _;
526     }
527 
528     function freeze(address _target) public onlyOwner {
529         freezes[_target] = true;
530         emit Frozen(_target);
531     }
532 
533     function unfreeze(address _target) public onlyOwner {
534         freezes[_target] = false;
535         emit Unfrozen(_target);
536     }
537 
538     function isFrozen(address _target) public view returns (bool) {
539         return freezes[_target];
540     }
541 
542     function transfer(
543         address _to,
544         uint256 _value
545     )
546       public
547       whenNotFrozen
548       whenNotPaused
549       returns (bool)
550     {
551         releaseLock(msg.sender);
552         return super.transfer(_to, _value);
553     }
554 
555     function transferFrom(
556         address _from,
557         address _to,
558         uint256 _value
559     )
560       public
561       whenNotPaused
562       returns (bool)
563     {
564         require(!freezes[_from], "From account is locked.");
565         releaseLock(_from);
566         return super.transferFrom(_from, _to, _value);
567     }
568 
569     //mintable
570     event Mint(address indexed to, uint256 amount);
571 
572     function mint(
573         address _to,
574         uint256 _amount
575     )
576       public
577       onlyOwner
578       returns (bool)
579     {
580         super._mint(_to, _amount);
581         emit Mint(_to, _amount);
582         return true;
583     }
584 
585     //burnable
586     event Burn(address indexed burner, uint256 value);
587 
588     function burn(address _who, uint256 _value) public onlyOwner {
589         require(_value <= super.balanceOf(_who), "Balance is too small.");
590 
591         _burn(_who, _value);
592         emit Burn(_who, _value);
593     }
594 
595     //lockable
596     struct LockInfo {
597         uint256 releaseTime;
598         uint256 balance;
599     }
600     mapping(address => LockInfo[]) internal lockInfo;
601 
602     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
603     event Unlock(address indexed holder, uint256 value);
604 
605     function balanceOf(address _holder) public view returns (uint256 balance) {
606         uint256 lockedBalance = 0;
607         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
608             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
609         }
610         return super.balanceOf(_holder).add(lockedBalance);
611     }
612 
613     function releaseLock(address _holder) internal {
614 
615         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
616             if (lockInfo[_holder][i].releaseTime <= now) {
617                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
618                 emit Unlock(_holder, lockInfo[_holder][i].balance);
619                 lockInfo[_holder][i].balance = 0;
620 
621                 if (i != lockInfo[_holder].length - 1) {
622                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
623                     i--;
624                 }
625                 lockInfo[_holder].length--;
626 
627             }
628         }
629     }
630     function lockCount(address _holder) public view returns (uint256) {
631         return lockInfo[_holder].length;
632     }
633     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
634         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
635     }
636 
637     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
638         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
639         _balances[_holder] = _balances[_holder].sub(_amount);
640         lockInfo[_holder].push(
641             LockInfo(_releaseTime, _amount)
642         );
643         emit Lock(_holder, _amount, _releaseTime);
644     }
645 
646     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
647         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
648         _balances[_holder] = _balances[_holder].sub(_amount);
649         lockInfo[_holder].push(
650             LockInfo(now + _afterTime, _amount)
651         );
652         emit Lock(_holder, _amount, now + _afterTime);
653     }
654 
655     function unlock(address _holder, uint256 i) public onlyOwner {
656         require(i < lockInfo[_holder].length, "No lock information.");
657 
658         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
659         emit Unlock(_holder, lockInfo[_holder][i].balance);
660         lockInfo[_holder][i].balance = 0;
661 
662         if (i != lockInfo[_holder].length - 1) {
663             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
664         }
665         lockInfo[_holder].length--;
666     }
667 
668     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
669         require(_to != address(0), "wrong address");
670         require(_value <= super.balanceOf(owner), "Not enough balance");
671 
672         _balances[owner] = _balances[owner].sub(_value);
673         lockInfo[_to].push(
674             LockInfo(_releaseTime, _value)
675         );
676         emit Transfer(owner, _to, _value);
677         emit Lock(_to, _value, _releaseTime);
678 
679         return true;
680     }
681 
682     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
683         require(_to != address(0), "wrong address");
684         require(_value <= super.balanceOf(owner), "Not enough balance");
685 
686         _balances[owner] = _balances[owner].sub(_value);
687         lockInfo[_to].push(
688             LockInfo(now + _afterTime, _value)
689         );
690         emit Transfer(owner, _to, _value);
691         emit Lock(_to, _value, now + _afterTime);
692 
693         return true;
694     }
695 
696     function currentTime() public view returns (uint256) {
697         return now;
698     }
699 
700     function afterTime(uint256 _value) public view returns (uint256) {
701         return now + _value;
702     }
703 }