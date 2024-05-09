1 pragma solidity 0.5.11;
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
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts with custom message when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 contract Ownable {
153     address public owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157 
158     /**
159      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160      * account.
161      */
162     constructor() public {
163         owner = msg.sender;
164     }
165 
166     /**
167      * @dev Throws if called by any account other than the owner.
168      */
169     modifier onlyOwner() {
170         require(msg.sender == owner, "Ownable: the caller must be owner");
171         _;
172     }
173 
174     /**
175      * @dev Allows the current owner to transfer control of the contract to a newOwner.
176      * @param _newOwner The address to transfer ownership to.
177      */
178     function transferOwnership(address _newOwner) public onlyOwner {
179         _transferOwnership(_newOwner);
180     }
181 
182     /**
183      * @dev Transfers control of the contract to a newOwner.
184      * @param _newOwner The address to transfer ownership to.
185      */
186     function _transferOwnership(address _newOwner) internal {
187         require(_newOwner != address(0), "Ownable: new owner is the zero address");
188         emit OwnershipTransferred(owner, _newOwner);
189         owner = _newOwner;
190     }
191 }
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP.
195  */
196 interface IERC20 {
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `recipient`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a `Transfer` event.
213      */
214     function transfer(address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through `transferFrom`. This is
219      * zero by default.
220      *
221      * This value changes when `approve` or `transferFrom` are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * > Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an `Approval` event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a `Transfer` event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to `approve`. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 /**
268  * @dev Implementation of the `IERC20` interface.
269  *
270  */
271 contract ERC20 is IERC20 {
272     using SafeMath for uint256;
273 
274     mapping (address => uint256) internal _balances;
275 
276     mapping (address => mapping (address => uint256)) internal _allowances;
277 
278     uint256 internal _totalSupply;
279 
280     /**
281      * @dev See `IERC20.totalSupply`.
282      */
283     function totalSupply() public view returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See `IERC20.balanceOf`.
289      */
290     function balanceOf(address account) public view returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See `IERC20.transfer`.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public returns (bool) {
303         _transfer(msg.sender, recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See `IERC20.allowance`.
309      */
310     function allowance(address owner, address spender) public view returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See `IERC20.approve`.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 value) public returns (bool) {
322         _approve(msg.sender, spender, value);
323         return true;
324     }
325 
326     /**
327      * @dev See `IERC20.transferFrom`.
328      *
329      * Emits an `Approval` event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of `ERC20`;
331      *
332      * Requirements:
333      * - `sender` and `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `value`.
335      * - the caller must have allowance for `sender`'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
339         _transfer(sender, recipient, amount);
340         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
341         return true;
342     }
343 
344     /**
345      * @dev Atomically increases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to `approve` that can be used as a mitigation for
348      * problems described in `IERC20.approve`.
349      *
350      * Emits an `Approval` event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
357         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
358         return true;
359     }
360 
361     /**
362      * @dev Atomically decreases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to `approve` that can be used as a mitigation for
365      * problems described in `IERC20.approve`.
366      *
367      * Emits an `Approval` event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      * - `spender` must have allowance for the caller of at least
373      * `subtractedValue`.
374      */
375     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
376         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
377         return true;
378     }
379 
380     /**
381      * @dev Moves tokens `amount` from `sender` to `recipient`.
382      *
383      * This is internal function is equivalent to `transfer`, and can be used to
384      * e.g. implement automatic token fees, slashing mechanisms, etc.
385      *
386      * Emits a `Transfer` event.
387      *
388      * Requirements:
389      *
390      * - `sender` cannot be the zero address.
391      * - `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      */
394     function _transfer(address sender, address recipient, uint256 amount) internal {
395         require(sender != address(0), "ERC20: transfer from the zero address");
396         require(recipient != address(0), "ERC20: transfer to the zero address");
397 
398         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
399         _balances[recipient] = _balances[recipient].add(amount);
400         emit Transfer(sender, recipient, amount);
401     }
402 
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 value) internal {
415         require(account != address(0), "ERC20: burn from the zero address");
416 
417         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
418         _totalSupply = _totalSupply.sub(value, "ERC20: burn amount exceeds total supply");
419         emit Transfer(account, address(0), value);
420     }
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
423      */
424     function _approve(address owner, address spender, uint256 value) internal {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = value;
429         emit Approval(owner, spender, value);
430     }
431 
432     /**
433      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
434      * from the caller's allowance.
435      *
436      * See {_burn} and {_approve}.
437      */
438     function _burnFrom(address account, uint256 amount) internal {
439         _burn(account, amount);
440         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
441     }
442 }
443 
444 /**
445  * @dev Contract module which allows children to implement an emergency stop
446  * mechanism that can be triggered by an authorized account.
447  */
448 contract Pausable is Ownable {
449     /**
450      * @dev Emitted when the pause is triggered by a pauser (`account`).
451      */
452     event Paused(address account);
453 
454     /**
455      * @dev Emitted when the pause is lifted by a pauser (`account`).
456      */
457     event Unpaused(address account);
458 
459     bool private _paused;
460 
461     /**
462      * @dev Initialize the contract in unpaused state. Assigns the Pauser role
463      * to the deployer.
464      */
465     constructor () internal {
466         _paused = false;
467     }
468 
469     /**
470      * @dev Return true if the contract is paused, and false otherwise.
471      */
472     function paused() public view returns (bool) {
473         return _paused;
474     }
475 
476     /**
477      * @dev Modifier to make a function callable only when the contract is not paused.
478      */
479     modifier whenNotPaused() {
480         require(!_paused, "Pausable: paused");
481         _;
482     }
483 
484     /**
485      * @dev Modifier to make a function callable only when the contract is paused.
486      */
487     modifier whenPaused() {
488         require(_paused, "Pausable: not paused");
489         _;
490     }
491 
492     /**
493      * @dev Called by a pauser to pause, triggers stopped state.
494      */
495     function pause() public onlyOwner whenNotPaused {
496         _paused = true;
497         emit Paused(msg.sender);
498     }
499 
500     /**
501      * @dev Called by a pauser to unpause, returns to normal state.
502      */
503     function unpause() public onlyOwner whenPaused {
504         _paused = false;
505         emit Unpaused(msg.sender);
506     }
507 }
508 
509 /**
510  * @dev Extension of {ERC20} that allows token holders to destroy both their own
511  * tokens and those that they have an allowance for, in a way that can be
512  * recognized off-chain (via event analysis).
513  */
514 contract ERC20Burnable is ERC20 {
515     /**
516      * @dev Destroys `amount` tokens from the caller.
517      *
518      * See {ERC20-_burn}.
519      */
520     function burn(uint256 amount) public {
521         _burn(msg.sender, amount);
522     }
523 
524     /**
525      * @dev See {ERC20-_burnFrom}.
526      */
527     function burnFrom(address account, uint256 amount) public {
528         _burnFrom(account, amount);
529     }
530 }
531 
532 /**
533  * @title Pausable token
534  * @dev ERC20 modified with pausable transfers.
535  */
536 contract ERC20Pausable is ERC20Burnable, Pausable {
537     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
538         return super.transfer(to, value);
539     }
540 
541     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
542         return super.transferFrom(from, to, value);
543     }
544 
545     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
546         return super.approve(spender, value);
547     }
548 
549     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
550         return super.increaseAllowance(spender, addedValue);
551     }
552 
553     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
554         return super.decreaseAllowance(spender, subtractedValue);
555     }
556 
557     function burn(uint256 amount) public whenNotPaused {
558         super.burn(amount);
559     }
560 
561     function burnFrom(address account, uint256 amount) public whenNotPaused {
562         super.burnFrom(account, amount);
563     }
564 }
565 
566 contract BITSGToken is ERC20Pausable {
567     string public constant name = "BitSG Token";
568     string public constant symbol = "BITSG";
569     uint8 public constant decimals = 8;
570     uint256 internal constant INIT_TOTALSUPPLY = 1200000000;
571 
572     mapping( address => uint256) public lockedAmount;
573     mapping (address => LockItem[]) public lockInfo;
574     uint256 private constant DAY_TIMES = 24 * 60 * 60;
575 
576     event SendAndLockToken(address indexed beneficiary, uint256 lockAmount, uint256 lockTime);
577     event ReleaseToken(address indexed beneficiary, uint256 releaseAmount);
578     event LockToken(address indexed targetAddr, uint256 lockAmount);
579     event UnlockToken(address indexed targetAddr, uint256 releaseAmount);
580 
581     struct LockItem {
582         address     lock_address;
583         uint256     lock_amount;
584         uint256     lock_time;
585         uint256     lock_startTime;
586     }
587 
588     /**
589      * @dev Constructor. Initialize token allocation.
590      */
591     constructor() public {
592         _totalSupply = formatDecimals(INIT_TOTALSUPPLY);
593         _balances[msg.sender] = _totalSupply;
594         emit Transfer(address(0), msg.sender, _totalSupply);
595     }
596 
597     /**
598      * @dev Send a specified number of tokens from the owner to a beneficiary and lock the tokens for a certain period of time.
599      * @param beneficiary Address to receive locked token.
600      * @param lockAmount Number of token locked.
601      * @param lockDays Number of days locked.
602      */
603     function sendAndLockToken(address beneficiary, uint256 lockAmount, uint256 lockDays) public onlyOwner {
604         require(beneficiary != address(0), "BITSGToken: beneficiary is the zero address");
605         require(lockAmount > 0, "BITSGToken: the amount of lock is 0");
606         require(lockDays > 0, "BITSGToken: the days of lock is 0");
607         // add lock item
608         uint256 _lockAmount = formatDecimals(lockAmount);
609         uint256 _lockTime = lockDays.mul(DAY_TIMES);
610         lockInfo[beneficiary].push(LockItem(beneficiary, _lockAmount, _lockTime, now));
611         emit SendAndLockToken(beneficiary, _lockAmount, _lockTime);
612         _balances[owner] = _balances[owner].sub(_lockAmount, "BITSGToken: owner doesn't have enough tokens");
613         emit Transfer(owner, address(0), _lockAmount);
614     }
615 
616     /**
617      * @dev Release the locked token of the specified address.
618      * @param beneficiary A specified address.
619      */
620     function releaseToken(address beneficiary) public returns (bool) {
621         uint256 amount = getReleasableAmount(beneficiary);
622         require(amount > 0, "BITSGToken: no releasable tokens");
623         for(uint256 i; i < lockInfo[beneficiary].length; i++) {
624             uint256 lockedTime = (now.sub(lockInfo[beneficiary][i].lock_startTime));
625             if (lockedTime >= lockInfo[beneficiary][i].lock_time) {
626                 delete lockInfo[beneficiary][i];
627             }
628         }
629         _balances[beneficiary] = _balances[beneficiary].add(amount);
630         emit Transfer(address(0), beneficiary, amount);
631         emit ReleaseToken(beneficiary, amount);
632         return true;
633     }
634 
635     /**
636      * @dev Get the number of releasable tokens at the specified address.
637      * @param beneficiary A specified address.
638      */
639     function getReleasableAmount(address beneficiary) public view returns (uint256) {
640         require(lockInfo[beneficiary].length != 0, "BITSGToken: the address has not lock items");
641         uint num = 0;
642         for(uint256 i; i < lockInfo[beneficiary].length; i++) {
643             uint256 lockedTime = (now.sub(lockInfo[beneficiary][i].lock_startTime));
644             if (lockedTime >= lockInfo[beneficiary][i].lock_time) {
645                 num = num.add(lockInfo[beneficiary][i].lock_amount);
646             }
647         }
648         return num;
649     }
650 
651     /**
652      * @dev Lock the specified number of tokens for the target address, this part of the locked token will not be transfered.
653      * @param targetAddr The address of the locked token.
654      * @param lockAmount The amount of the locked token.
655      */
656     function lockToken(address targetAddr, uint256 lockAmount) public onlyOwner {
657         require(targetAddr != address(0), "BITSGToken: target address is the zero address");
658         require(lockAmount > 0, "BITSGToken: the amount of lock is 0");
659         uint256 _lockAmount = formatDecimals(lockAmount);
660         lockedAmount[targetAddr] = lockedAmount[targetAddr].add(_lockAmount);
661         emit LockToken(targetAddr, _lockAmount);
662     }
663 
664     /**
665      * @dev Unlock the locked token at the specified address.
666      * @param targetAddr The address of the locked token.
667      * @param lockAmount Number of tokens unlocked.
668      */
669     function unlockToken(address targetAddr, uint256 lockAmount) public onlyOwner {
670         require(targetAddr != address(0), "BITSGToken: target address is the zero address");
671         require(lockAmount > 0, "BITSGToken: the amount of lock is 0");
672         uint256 _lockAmount = formatDecimals(lockAmount);
673         if(_lockAmount >= lockedAmount[targetAddr]) {
674             lockedAmount[targetAddr] = 0;
675         } else {
676             lockedAmount[targetAddr] = lockedAmount[targetAddr].sub(_lockAmount);
677         }
678         emit UnlockToken(targetAddr, _lockAmount);
679     }
680 
681     // Rewrite the transfer function to prevent locked tokens from being transferred.
682     function transfer(address recipient, uint256 amount) public returns (bool) {
683         require(_balances[msg.sender].sub(lockedAmount[msg.sender]) >= amount, "BITSGToken: transfer amount exceeds the vailable balance of msg.sender");
684         return super.transfer(recipient, amount);
685     }
686     // Rewrite the transferFrom function to prevent locked tokens from being transferred.
687     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
688         require(_balances[sender].sub(lockedAmount[sender]) >= amount, "BITSGToken: transfer amount exceeds the vailable balance of sender");
689         return super.transferFrom(sender, recipient, amount);
690     }
691 
692     // Rewrite the burn function to prevent locked tokens from being destroyed.
693     function burn(uint256 amount) public {
694         require(_balances[msg.sender].sub(lockedAmount[msg.sender]) >= amount, "BITSGToken: destroy amount exceeds the vailable balance of msg.sender");
695         super.burn(amount);
696     }
697 
698     // Rewrite the burnFrom function to prevent locked tokens from being destroyed.
699     function burnFrom(address account, uint256 amount) public {
700         require(_balances[account].sub(lockedAmount[account]) >= amount, "BITSGToken: destroy amount exceeds the vailable balance of account");
701         super.burnFrom(account, amount);
702     }
703 
704     /**
705      * @dev Batch transfer of tokens.
706      * @param addrs Array, a group of addresses that receive tokens.
707      * @param amounts Array, the number of transferred tokens.
708      */
709     function batchTransfer(address[] memory addrs, uint256[] memory amounts) public onlyOwner returns(bool) {
710         require(addrs.length == amounts.length, "BITSGToken: the length of the two arrays is inconsistent");
711         require(addrs.length <= 150, "BITSGToken: the number of destination addresses cannot exceed 150");
712         for(uint256 i = 0;i < addrs.length;i++) {
713             require(addrs[i] != address(0), "BITSGToken: target address is the zero address");
714             require(amounts[i] != 0, "BITSGToken: the number of transfers is 0");
715             transfer(addrs[i], formatDecimals(amounts[i]));
716         }
717         return true;
718     }
719 
720     function formatDecimals(uint256 value) internal pure returns (uint256) {
721         return value.mul(10 ** uint256(decimals));
722     }
723 }