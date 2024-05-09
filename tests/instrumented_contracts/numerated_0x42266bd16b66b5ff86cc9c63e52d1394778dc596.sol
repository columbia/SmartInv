1 pragma solidity 0.5.11;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  */
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b != 0, errorMessage);
140         return a % b;
141     }
142 }
143 
144 contract Ownable {
145     address public owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149 
150     /**
151      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152      * account.
153      */
154     constructor() public {
155         owner = msg.sender;
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(msg.sender == owner, "Ownable: the caller must be owner");
163         _;
164     }
165 
166     /**
167      * @dev Allows the current owner to transfer control of the contract to a newOwner.
168      * @param _newOwner The address to transfer ownership to.
169      */
170     function transferOwnership(address _newOwner) public onlyOwner {
171         _transferOwnership(_newOwner);
172     }
173 
174     /**
175      * @dev Transfers control of the contract to a newOwner.
176      * @param _newOwner The address to transfer ownership to.
177      */
178     function _transferOwnership(address _newOwner) internal {
179         require(_newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(owner, _newOwner);
181         owner = _newOwner;
182     }
183 }
184 
185 /**
186  * @dev Interface of the ERC20 standard as defined in the EIP.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a `Transfer` event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through `transferFrom`. This is
211      * zero by default.
212      *
213      * This value changes when `approve` or `transferFrom` are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * > Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an `Approval` event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a `Transfer` event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to `approve`. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 /**
260  * @dev Implementation of the `IERC20` interface.
261  *
262  */
263 contract ERC20 is IERC20 {
264     using SafeMath for uint256;
265 
266     mapping (address => uint256) internal _balances;
267 
268     mapping (address => mapping (address => uint256)) internal _allowances;
269 
270     uint256 internal _totalSupply;
271 
272     /**
273      * @dev See `IERC20.totalSupply`.
274      */
275     function totalSupply() public view returns (uint256) {
276         return _totalSupply;
277     }
278 
279     /**
280      * @dev See `IERC20.balanceOf`.
281      */
282     function balanceOf(address account) public view returns (uint256) {
283         return _balances[account];
284     }
285 
286     /**
287      * @dev See `IERC20.transfer`.
288      *
289      * Requirements:
290      *
291      * - `recipient` cannot be the zero address.
292      * - the caller must have a balance of at least `amount`.
293      */
294     function transfer(address recipient, uint256 amount) public returns (bool) {
295         _transfer(msg.sender, recipient, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See `IERC20.allowance`.
301      */
302     function allowance(address owner, address spender) public view returns (uint256) {
303         return _allowances[owner][spender];
304     }
305 
306     /**
307      * @dev See `IERC20.approve`.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function approve(address spender, uint256 value) public returns (bool) {
314         _approve(msg.sender, spender, value);
315         return true;
316     }
317 
318     /**
319      * @dev See `IERC20.transferFrom`.
320      *
321      * Emits an `Approval` event indicating the updated allowance. This is not
322      * required by the EIP. See the note at the beginning of `ERC20`;
323      *
324      * Requirements:
325      * - `sender` and `recipient` cannot be the zero address.
326      * - `sender` must have a balance of at least `value`.
327      * - the caller must have allowance for `sender`'s tokens of at least
328      * `amount`.
329      */
330     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
331         _transfer(sender, recipient, amount);
332         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
333         return true;
334     }
335 
336     /**
337      * @dev Atomically increases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to `approve` that can be used as a mitigation for
340      * problems described in `IERC20.approve`.
341      *
342      * Emits an `Approval` event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
349         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
350         return true;
351     }
352 
353     /**
354      * @dev Atomically decreases the allowance granted to `spender` by the caller.
355      *
356      * This is an alternative to `approve` that can be used as a mitigation for
357      * problems described in `IERC20.approve`.
358      *
359      * Emits an `Approval` event indicating the updated allowance.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      * - `spender` must have allowance for the caller of at least
365      * `subtractedValue`.
366      */
367     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
368         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
369         return true;
370     }
371 
372     /**
373      * @dev Moves tokens `amount` from `sender` to `recipient`.
374      *
375      * This is internal function is equivalent to `transfer`, and can be used to
376      * e.g. implement automatic token fees, slashing mechanisms, etc.
377      *
378      * Emits a `Transfer` event.
379      *
380      * Requirements:
381      *
382      * - `sender` cannot be the zero address.
383      * - `recipient` cannot be the zero address.
384      * - `sender` must have a balance of at least `amount`.
385      */
386     function _transfer(address sender, address recipient, uint256 amount) internal {
387         require(sender != address(0), "ERC20: transfer from the zero address");
388         require(recipient != address(0), "ERC20: transfer to the zero address");
389 
390         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
391         _balances[recipient] = _balances[recipient].add(amount);
392         emit Transfer(sender, recipient, amount);
393     }
394 
395     /**
396      * @dev Destroys `amount` tokens from `account`, reducing the
397      * total supply.
398      *
399      * Emits a {Transfer} event with `to` set to the zero address.
400      *
401      * Requirements
402      *
403      * - `account` cannot be the zero address.
404      * - `account` must have at least `amount` tokens.
405      */
406     function _burn(address account, uint256 value) internal {
407         require(account != address(0), "ERC20: burn from the zero address");
408 
409         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
410         _totalSupply = _totalSupply.sub(value, "ERC20: burn amount exceeds total supply");
411         emit Transfer(account, address(0), value);
412     }
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
415      */
416     function _approve(address owner, address spender, uint256 value) internal {
417         require(owner != address(0), "ERC20: approve from the zero address");
418         require(spender != address(0), "ERC20: approve to the zero address");
419 
420         _allowances[owner][spender] = value;
421         emit Approval(owner, spender, value);
422     }
423 
424     /**
425      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
426      * from the caller's allowance.
427      *
428      * See {_burn} and {_approve}.
429      */
430     function _burnFrom(address account, uint256 amount) internal {
431         _burn(account, amount);
432         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
433     }
434 }
435 
436 /**
437  * @dev Contract module which allows children to implement an emergency stop
438  * mechanism that can be triggered by an authorized account.
439  */
440 contract Pausable is Ownable {
441     /**
442      * @dev Emitted when the pause is triggered by a pauser (`account`).
443      */
444     event Paused(address account);
445 
446     /**
447      * @dev Emitted when the pause is lifted by a pauser (`account`).
448      */
449     event Unpaused(address account);
450 
451     bool private _paused;
452 
453     /**
454      * @dev Initialize the contract in unpaused state. Assigns the Pauser role
455      * to the deployer.
456      */
457     constructor () internal {
458         _paused = false;
459     }
460 
461     /**
462      * @dev Return true if the contract is paused, and false otherwise.
463      */
464     function paused() public view returns (bool) {
465         return _paused;
466     }
467 
468     /**
469      * @dev Modifier to make a function callable only when the contract is not paused.
470      */
471     modifier whenNotPaused() {
472         require(!_paused, "Pausable: paused");
473         _;
474     }
475 
476     /**
477      * @dev Modifier to make a function callable only when the contract is paused.
478      */
479     modifier whenPaused() {
480         require(_paused, "Pausable: not paused");
481         _;
482     }
483 
484     /**
485      * @dev Called by a pauser to pause, triggers stopped state.
486      */
487     function pause() public onlyOwner whenNotPaused {
488         _paused = true;
489         emit Paused(msg.sender);
490     }
491 
492     /**
493      * @dev Called by a pauser to unpause, returns to normal state.
494      */
495     function unpause() public onlyOwner whenPaused {
496         _paused = false;
497         emit Unpaused(msg.sender);
498     }
499 }
500 
501 /**
502  * @dev Extension of {ERC20} that allows token holders to destroy both their own
503  * tokens and those that they have an allowance for, in a way that can be
504  * recognized off-chain (via event analysis).
505  */
506 contract ERC20Burnable is ERC20 {
507     /**
508      * @dev Destroys `amount` tokens from the caller.
509      *
510      * See {ERC20-_burn}.
511      */
512     function burn(uint256 amount) public {
513         _burn(msg.sender, amount);
514     }
515 
516     /**
517      * @dev See {ERC20-_burnFrom}.
518      */
519     function burnFrom(address account, uint256 amount) public {
520         _burnFrom(account, amount);
521     }
522 }
523 
524 /**
525  * @title Pausable token
526  * @dev ERC20 modified with pausable transfers.
527  */
528 contract ERC20Pausable is ERC20Burnable, Pausable {
529     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
530         return super.transfer(to, value);
531     }
532 
533     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
534         return super.transferFrom(from, to, value);
535     }
536 
537     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
538         return super.approve(spender, value);
539     }
540 
541     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
542         return super.increaseAllowance(spender, addedValue);
543     }
544 
545     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
546         return super.decreaseAllowance(spender, subtractedValue);
547     }
548 
549     function burn(uint256 amount) public whenNotPaused {
550         super.burn(amount);
551     }
552 
553     function burnFrom(address account, uint256 amount) public whenNotPaused {
554         super.burnFrom(account, amount);
555     }
556 }
557 
558 contract DPToken is ERC20Pausable {
559     string public constant name = "Dark Pool";
560     string public constant symbol = "DP";
561     uint8 public constant decimals = 8;
562     uint256 internal constant INIT_TOTALSUPPLY = 210000000;
563 
564     mapping( address => uint256) public lockedAmount;
565     mapping (address => LockItem[]) public lockInfo;
566     uint256 private constant DAY_TIMES = 24 * 60 * 60;
567 
568     event SendAndLockToken(address indexed beneficiary, uint256 lockAmount, uint256 lockTime);
569     event ReleaseToken(address indexed beneficiary, uint256 releaseAmount);
570     event LockToken(address indexed targetAddr, uint256 lockAmount);
571     event UnlockToken(address indexed targetAddr, uint256 releaseAmount);
572 
573     struct LockItem {
574         address     lock_address;
575         uint256     lock_amount;
576         uint256     lock_time;
577         uint256     lock_startTime;
578     }
579 
580     /**
581      * @dev Constructor. Initialize token allocation.
582      */
583     constructor() public {
584         _totalSupply = formatDecimals(INIT_TOTALSUPPLY);
585         _balances[msg.sender] = _totalSupply;
586         emit Transfer(address(0), msg.sender, _totalSupply);
587     }
588 
589     /**
590      * @dev Send a specified number of tokens from the owner to a beneficiary and lock the tokens for a certain period of time.
591      * @param beneficiary Address to receive locked token.
592      * @param lockAmount Number of token locked.
593      * @param lockDays Number of days locked.
594      */
595     function sendAndLockToken(address beneficiary, uint256 lockAmount, uint256 lockDays) public onlyOwner {
596         require(beneficiary != address(0), "DPToken: beneficiary is the zero address");
597         require(lockAmount > 0, "DPToken: the amount of lock is 0");
598         require(lockDays > 0, "DPToken: the days of lock is 0");
599         // add lock item
600         uint256 _lockAmount = formatDecimals(lockAmount);
601         uint256 _lockTime = lockDays.mul(DAY_TIMES);
602         lockInfo[beneficiary].push(LockItem(beneficiary, _lockAmount, _lockTime, now));
603         emit SendAndLockToken(beneficiary, _lockAmount, _lockTime);
604         _balances[owner] = _balances[owner].sub(_lockAmount, "DPToken: owner doesn't have enough tokens");
605         emit Transfer(owner, address(0), _lockAmount);
606     }
607 
608     /**
609      * @dev Release the locked token of the specified address.
610      * @param beneficiary A specified address.
611      */
612     function releaseToken(address beneficiary) public returns (bool) {
613         uint256 amount = getReleasableAmount(beneficiary);
614         require(amount > 0, "DPToken: no releasable tokens");
615         for(uint256 i; i < lockInfo[beneficiary].length; i++) {
616             uint256 lockedTime = (now.sub(lockInfo[beneficiary][i].lock_startTime));
617             if (lockedTime >= lockInfo[beneficiary][i].lock_time) {
618                 delete lockInfo[beneficiary][i];
619             }
620         }
621         _balances[beneficiary] = _balances[beneficiary].add(amount);
622         emit Transfer(address(0), beneficiary, amount);
623         emit ReleaseToken(beneficiary, amount);
624         return true;
625     }
626 
627     /**
628      * @dev Get the number of releasable tokens at the specified address.
629      * @param beneficiary A specified address.
630      */
631     function getReleasableAmount(address beneficiary) public view returns (uint256) {
632         require(lockInfo[beneficiary].length != 0, "DPToken: the address has not lock items");
633         uint num = 0;
634         for(uint256 i; i < lockInfo[beneficiary].length; i++) {
635             uint256 lockedTime = (now.sub(lockInfo[beneficiary][i].lock_startTime));
636             if (lockedTime >= lockInfo[beneficiary][i].lock_time) {
637                 num = num.add(lockInfo[beneficiary][i].lock_amount);
638             }
639         }
640         return num;
641     }
642 
643     /**
644      * @dev Lock the specified number of tokens for the target address, this part of the locked token will not be transfered.
645      * @param targetAddr The address of the locked token.
646      * @param lockAmount The amount of the locked token.
647      */
648     function lockToken(address targetAddr, uint256 lockAmount) public onlyOwner {
649         require(targetAddr != address(0), "DPToken: target address is the zero address");
650         require(lockAmount > 0, "DPToken: the amount of lock is 0");
651         uint256 _lockAmount = formatDecimals(lockAmount);
652         lockedAmount[targetAddr] = lockedAmount[targetAddr].add(_lockAmount);
653         emit LockToken(targetAddr, _lockAmount);
654     }
655 
656     /**
657      * @dev Unlock the locked token at the specified address.
658      * @param targetAddr The address of the locked token.
659      * @param lockAmount Number of tokens unlocked.
660      */
661     function unlockToken(address targetAddr, uint256 lockAmount) public onlyOwner {
662         require(targetAddr != address(0), "DPToken: target address is the zero address");
663         require(lockAmount > 0, "DPToken: the amount of lock is 0");
664         uint256 _lockAmount = formatDecimals(lockAmount);
665         if(_lockAmount >= lockedAmount[targetAddr]) {
666             lockedAmount[targetAddr] = 0;
667         } else {
668             lockedAmount[targetAddr] = lockedAmount[targetAddr].sub(_lockAmount);
669         }
670         emit UnlockToken(targetAddr, _lockAmount);
671     }
672 
673     // Rewrite the transfer function to prevent locked tokens from being transferred.
674     function transfer(address recipient, uint256 amount) public returns (bool) {
675         require(_balances[msg.sender].sub(lockedAmount[msg.sender]) >= amount, "DPToken: transfer amount exceeds the vailable balance of msg.sender");
676         return super.transfer(recipient, amount);
677     }
678     // Rewrite the transferFrom function to prevent locked tokens from being transferred.
679     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
680         require(_balances[sender].sub(lockedAmount[sender]) >= amount, "DPToken: transfer amount exceeds the vailable balance of sender");
681         return super.transferFrom(sender, recipient, amount);
682     }
683 
684     // Rewrite the burn function to prevent locked tokens from being destroyed.
685     function burn(uint256 amount) public {
686         require(_balances[msg.sender].sub(lockedAmount[msg.sender]) >= amount, "DPToken: destroy amount exceeds the vailable balance of msg.sender");
687         super.burn(amount);
688     }
689 
690     // Rewrite the burnFrom function to prevent locked tokens from being destroyed.
691     function burnFrom(address account, uint256 amount) public {
692         require(_balances[account].sub(lockedAmount[account]) >= amount, "DPToken: destroy amount exceeds the vailable balance of account");
693         super.burnFrom(account, amount);
694     }
695 
696     /**
697      * @dev Batch transfer of tokens.
698      * @param addrs Array, a group of addresses that receive tokens.
699      * @param amounts Array, the number of transferred tokens.
700      */
701     function batchTransfer(address[] memory addrs, uint256[] memory amounts) public onlyOwner returns(bool) {
702         require(addrs.length == amounts.length, "DPToken: the length of the two arrays is inconsistent");
703         require(addrs.length <= 150, "DPToken: the number of destination addresses cannot exceed 150");
704         for(uint256 i = 0;i < addrs.length;i++) {
705             require(addrs[i] != address(0), "DPToken: target address is the zero address");
706             require(amounts[i] != 0, "DPToken: the number of transfers is 0");
707             transfer(addrs[i], formatDecimals(amounts[i]));
708         }
709         return true;
710     }
711 
712     function formatDecimals(uint256 value) internal pure returns (uint256) {
713         return value.mul(10 ** uint256(decimals));
714     }
715 }