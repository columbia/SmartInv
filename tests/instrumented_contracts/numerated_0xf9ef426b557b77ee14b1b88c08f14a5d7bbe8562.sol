1 // ----------------------------------------------------------------------------
2 // TradingUsdt MiningToken contract
3 // Symbol      : TUM
4 // Name        : TradingUsdt MiningToken
5 // Decimals    : 7
6 // ----------------------------------------------------------------------------
7 
8 pragma solidity 0.5.8;
9 
10 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
14  * the optional functions; to access them see `ERC20Detailed`.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a `Transfer` event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through `transferFrom`. This is
39      * zero by default.
40      *
41      * This value changes when `approve` or `transferFrom` are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * > Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an `Approval` event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a `Transfer` event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to `approve`. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b <= a, "SafeMath: subtraction overflow");
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Solidity only automatically asserts when dividing by 0
171         require(b > 0, "SafeMath: division by zero");
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         require(b != 0, "SafeMath: modulo by zero");
191         return a % b;
192     }
193 }
194 
195 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
196 
197 /**
198  * @dev Implementation of the `IERC20` interface.
199  *
200  * This implementation is agnostic to the way tokens are created. This means
201  * that a supply mechanism has to be added in a derived contract using `_mint`.
202  * For a generic mechanism see `ERC20Mintable`.
203  *
204  * *For a detailed writeup see our guide [How to implement supply
205  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
206  *
207  * We have followed general OpenZeppelin guidelines: functions revert instead
208  * of returning `false` on failure. This behavior is nonetheless conventional
209  * and does not conflict with the expectations of ERC20 applications.
210  *
211  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
212  * This allows applications to reconstruct the allowance for all accounts just
213  * by listening to said events. Other implementations of the EIP may not emit
214  * these events, as it isn't required by the specification.
215  *
216  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
217  * functions have been added to mitigate the well-known issues around setting
218  * allowances. See `IERC20.approve`.
219  */
220 contract ERC20 is IERC20 {
221     using SafeMath for uint256;
222 
223     mapping (address => uint256) internal _balances;
224 
225     mapping (address => mapping (address => uint256)) private _allowances;
226 
227     uint256 private _totalSupply;
228 
229     /**
230      * @dev See `IERC20.totalSupply`.
231      */
232     function totalSupply() public view returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See `IERC20.balanceOf`.
238      */
239     function balanceOf(address account) public view returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See `IERC20.transfer`.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public returns (bool) {
252         _transfer(msg.sender, recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See `IERC20.allowance`.
258      */
259     function allowance(address owner, address spender) public view returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See `IERC20.approve`.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 value) public returns (bool) {
271         _approve(msg.sender, spender, value);
272         return true;
273     }
274 
275     /**
276      * @dev See `IERC20.transferFrom`.
277      *
278      * Emits an `Approval` event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of `ERC20`;
280      *
281      * Requirements:
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `value`.
284      * - the caller must have allowance for `sender`'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
288         _transfer(sender, recipient, amount);
289         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
290         return true;
291     }
292 
293     /**
294      * @dev Atomically increases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to `approve` that can be used as a mitigation for
297      * problems described in `IERC20.approve`.
298      *
299      * Emits an `Approval` event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
306         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
307         return true;
308     }
309 
310     /**
311      * @dev Atomically decreases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to `approve` that can be used as a mitigation for
314      * problems described in `IERC20.approve`.
315      *
316      * Emits an `Approval` event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      * - `spender` must have allowance for the caller of at least
322      * `subtractedValue`.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
325         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
326         return true;
327     }
328 
329     /**
330      * @dev Moves tokens `amount` from `sender` to `recipient`.
331      *
332      * This is internal function is equivalent to `transfer`, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a `Transfer` event.
336      *
337      * Requirements:
338      *
339      * - `sender` cannot be the zero address.
340      * - `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      */
343     function _transfer(address sender, address recipient, uint256 amount) internal {
344         require(sender != address(0), "ERC20: transfer from the zero address");
345         require(recipient != address(0), "ERC20: transfer to the zero address");
346 
347         _balances[sender] = _balances[sender].sub(amount);
348         _balances[recipient] = _balances[recipient].add(amount);
349         emit Transfer(sender, recipient, amount);
350     }
351 
352     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
353      * the total supply.
354      *
355      * Emits a `Transfer` event with `from` set to the zero address.
356      *
357      * Requirements
358      *
359      * - `to` cannot be the zero address.
360      */
361     function _mint(address account, uint256 amount) internal {
362         require(account != address(0), "ERC20: mint to the zero address");
363 
364         _totalSupply = _totalSupply.add(amount);
365         _balances[account] = _balances[account].add(amount);
366         emit Transfer(address(0), account, amount);
367     }
368 
369      /**
370      * @dev Destoys `amount` tokens from `account`, reducing the
371      * total supply.
372      *
373      * Emits a `Transfer` event with `to` set to the zero address.
374      *
375      * Requirements
376      *
377      * - `account` cannot be the zero address.
378      * - `account` must have at least `amount` tokens.
379      */
380     function _burn(address account, uint256 value) internal {
381         require(account != address(0), "ERC20: burn from the zero address");
382 
383         _totalSupply = _totalSupply.sub(value);
384         _balances[account] = _balances[account].sub(value);
385         emit Transfer(account, address(0), value);
386     }
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
390      *
391      * This is internal function is equivalent to `approve`, and can be used to
392      * e.g. set automatic allowances for certain subsystems, etc.
393      *
394      * Emits an `Approval` event.
395      *
396      * Requirements:
397      *
398      * - `owner` cannot be the zero address.
399      * - `spender` cannot be the zero address.
400      */
401     function _approve(address owner, address spender, uint256 value) internal {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = value;
406         emit Approval(owner, spender, value);
407     }
408 
409     /**
410      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
411      * from the caller's allowance.
412      *
413      * See `_burn` and `_approve`.
414      */
415     function _burnFrom(address account, uint256 amount) internal {
416         _burn(account, amount);
417         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
418     }
419 }
420 
421 
422 contract TradingUsdtMiningToken is ERC20 {
423     string public constant name = "TradingUsdt MiningToken"; 
424     string public constant symbol = "TUM"; 
425     uint8 public constant decimals = 7; 
426     uint256 public constant initialSupply = 2000000000 * (10 ** uint256(decimals));
427     
428     constructor() public {
429         super._mint(msg.sender, initialSupply);
430         owner = msg.sender;
431     }
432 
433     //ownership
434     address public owner;
435 
436     event OwnershipRenounced(address indexed previousOwner);
437     event OwnershipTransferred(
438     address indexed previousOwner,
439     address indexed newOwner
440     );
441 
442     modifier onlyOwner() {
443         require(msg.sender == owner, "Not owner");
444         _;
445     }
446 
447   /**
448    * @dev Allows the current owner to relinquish control of the contract.
449    * @notice Renouncing to ownership will leave the contract without an owner.
450    * It will not be possible to call the functions with the `onlyOwner`
451    * modifier anymore.
452    */
453     function renounceOwnership() public onlyOwner {
454         emit OwnershipRenounced(owner);
455         owner = address(0);
456     }
457 
458   /**
459    * @dev Allows the current owner to transfer control of the contract to a newOwner.
460    * @param _newOwner The address to transfer ownership to.
461    */
462     function transferOwnership(address _newOwner) public onlyOwner {
463         _transferOwnership(_newOwner);
464     }
465 
466   /**
467    * @dev Transfers control of the contract to a newOwner.
468    * @param _newOwner The address to transfer ownership to.
469    */
470     function _transferOwnership(address _newOwner) internal {
471         require(_newOwner != address(0), "Already owner");
472         emit OwnershipTransferred(owner, _newOwner);
473         owner = _newOwner;
474     }
475 
476     //pausable
477     event Pause();
478     event Unpause();
479 
480     bool public paused = false;
481     
482     /**
483     * @dev Modifier to make a function callable only when the contract is not paused.
484     */
485     modifier whenNotPaused() {
486         require(!paused, "Paused by owner");
487         _;
488     }
489 
490     /**
491     * @dev Modifier to make a function callable only when the contract is paused.
492     */
493     modifier whenPaused() {
494         require(paused, "Not paused now");
495         _;
496     }
497 
498     /**
499     * @dev called by the owner to pause, triggers stopped state
500     */
501     function pause() public onlyOwner whenNotPaused {
502         paused = true;
503         emit Pause();
504     }
505 
506     /**
507     * @dev called by the owner to unpause, returns to normal state
508     */
509     function unpause() public onlyOwner whenPaused {
510         paused = false;
511         emit Unpause();
512     }
513 
514     //freezable
515     event Frozen(address target);
516     event Unfrozen(address target);
517 
518     mapping(address => bool) internal freezes;
519 
520     modifier whenNotFrozen() {
521         require(!freezes[msg.sender], "Sender account is locked.");
522         _;
523     }
524 
525     function freeze(address _target) public onlyOwner {
526         freezes[_target] = true;
527         emit Frozen(_target);
528     }
529 
530     function unfreeze(address _target) public onlyOwner {
531         freezes[_target] = false;
532         emit Unfrozen(_target);
533     }
534 
535     function isFrozen(address _target) public view returns (bool) {
536         return freezes[_target];
537     }
538 
539     function transfer(
540         address _to,
541         uint256 _value
542     )
543       public
544       whenNotFrozen
545       whenNotPaused
546       returns (bool)
547     {
548         releaseLock(msg.sender);
549         return super.transfer(_to, _value);
550     }
551 
552     function transferFrom(
553         address _from,
554         address _to,
555         uint256 _value
556     )
557       public
558       whenNotPaused
559       returns (bool)
560     {
561         require(!freezes[_from], "From account is locked.");
562         releaseLock(_from);
563         return super.transferFrom(_from, _to, _value);
564     }
565 
566     //mintable
567     event Mint(address indexed to, uint256 amount);
568 
569     function mint(
570         address _to,
571         uint256 _amount
572     )
573       public
574       onlyOwner
575       returns (bool)
576     {
577         super._mint(_to, _amount);
578         emit Mint(_to, _amount);
579         return true;
580     }
581 
582     //burnable
583     event Burn(address indexed burner, uint256 value);
584 
585     function burn(address _who, uint256 _value) public onlyOwner {
586         require(_value <= super.balanceOf(_who), "Balance is too small.");
587 
588         _burn(_who, _value);
589         emit Burn(_who, _value);
590     }
591 
592     //lockable
593     struct LockInfo {
594         uint256 releaseTime;
595         uint256 balance;
596     }
597     mapping(address => LockInfo[]) internal lockInfo;
598 
599     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
600     event Unlock(address indexed holder, uint256 value);
601 
602     function balanceOf(address _holder) public view returns (uint256 balance) {
603         uint256 lockedBalance = 0;
604         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
605             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
606         }
607         return super.balanceOf(_holder).add(lockedBalance);
608     }
609 
610     function releaseLock(address _holder) internal {
611 
612         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
613             if (lockInfo[_holder][i].releaseTime <= now) {
614                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
615                 emit Unlock(_holder, lockInfo[_holder][i].balance);
616                 lockInfo[_holder][i].balance = 0;
617 
618                 if (i != lockInfo[_holder].length - 1) {
619                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
620                     i--;
621                 }
622                 lockInfo[_holder].length--;
623 
624             }
625         }
626     }
627     function lockCount(address _holder) public view returns (uint256) {
628         return lockInfo[_holder].length;
629     }
630     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
631         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
632     }
633 
634     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
635         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
636         _balances[_holder] = _balances[_holder].sub(_amount);
637         lockInfo[_holder].push(
638             LockInfo(_releaseTime, _amount)
639         );
640         emit Lock(_holder, _amount, _releaseTime);
641     }
642 
643     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
644         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
645         _balances[_holder] = _balances[_holder].sub(_amount);
646         lockInfo[_holder].push(
647             LockInfo(now + _afterTime, _amount)
648         );
649         emit Lock(_holder, _amount, now + _afterTime);
650     }
651 
652     function unlock(address _holder, uint256 i) public onlyOwner {
653         require(i < lockInfo[_holder].length, "No lock information.");
654 
655         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
656         emit Unlock(_holder, lockInfo[_holder][i].balance);
657         lockInfo[_holder][i].balance = 0;
658 
659         if (i != lockInfo[_holder].length - 1) {
660             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
661         }
662         lockInfo[_holder].length--;
663     }
664 
665     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
666         require(_to != address(0), "wrong address");
667         require(_value <= super.balanceOf(owner), "Not enough balance");
668 
669         _balances[owner] = _balances[owner].sub(_value);
670         lockInfo[_to].push(
671             LockInfo(_releaseTime, _value)
672         );
673         emit Transfer(owner, _to, _value);
674         emit Lock(_to, _value, _releaseTime);
675 
676         return true;
677     }
678 
679     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
680         require(_to != address(0), "wrong address");
681         require(_value <= super.balanceOf(owner), "Not enough balance");
682 
683         _balances[owner] = _balances[owner].sub(_value);
684         lockInfo[_to].push(
685             LockInfo(now + _afterTime, _value)
686         );
687         emit Transfer(owner, _to, _value);
688         emit Lock(_to, _value, now + _afterTime);
689 
690         return true;
691     }
692 
693     function currentTime() public view returns (uint256) {
694         return now;
695     }
696 
697     function afterTime(uint256 _value) public view returns (uint256) {
698         return now + _value;
699     }
700 
701     //airdrop
702     mapping (address => uint256) public airDropHistory;
703     event AirDrop(address _receiver, uint256 _amount);
704 
705     function dropToken(address[] memory receivers, uint256[] memory values) onlyOwner public {
706     require(receivers.length != 0);
707     require(receivers.length == values.length);
708 
709     for (uint256 i = 0; i < receivers.length; i++) {
710       address receiver = receivers[i];
711       uint256 amount = values[i];
712 
713       transfer(receiver, amount);
714       airDropHistory[receiver] += amount;
715 
716       emit AirDrop(receiver, amount);
717     }
718   }
719 }