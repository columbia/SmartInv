1 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
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
80 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
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
190 // File: contracts\ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 contract ERC20 is IERC20 {
197     using SafeMath for uint256;
198 
199     mapping (address => uint256) internal _balances;
200 
201     mapping (address => mapping (address => uint256)) private _allowances;
202 
203     uint256 private _totalSupply;
204 
205     /**
206      * @dev See `IERC20.totalSupply`.
207      */
208     function totalSupply() public view returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See `IERC20.balanceOf`.
214      */
215     function balanceOf(address account) public view returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See `IERC20.transfer`.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public returns (bool) {
228         _transfer(msg.sender, recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See `IERC20.allowance`.
234      */
235     function allowance(address owner, address spender) public view returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See `IERC20.approve`.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 value) public returns (bool) {
247         _approve(msg.sender, spender, value);
248         return true;
249     }
250 
251     /**
252      * @dev See `IERC20.transferFrom`.
253      *
254      * Emits an `Approval` event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of `ERC20`;
256      *
257      * Requirements:
258      * - `sender` and `recipient` cannot be the zero address.
259      * - `sender` must have a balance of at least `value`.
260      * - the caller must have allowance for `sender`'s tokens of at least
261      * `amount`.
262      */
263     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
264         _transfer(sender, recipient, amount);
265         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
266         return true;
267     }
268 
269     /**
270      * @dev Atomically increases the allowance granted to `spender` by the caller.
271      *
272      * This is an alternative to `approve` that can be used as a mitigation for
273      * problems described in `IERC20.approve`.
274      *
275      * Emits an `Approval` event indicating the updated allowance.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
282         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
283         return true;
284     }
285 
286     /**
287      * @dev Atomically decreases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to `approve` that can be used as a mitigation for
290      * problems described in `IERC20.approve`.
291      *
292      * Emits an `Approval` event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      * - `spender` must have allowance for the caller of at least
298      * `subtractedValue`.
299      */
300     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
301         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
302         return true;
303     }
304 
305     /**
306      * @dev Moves tokens `amount` from `sender` to `recipient`.
307      *
308      * This is internal function is equivalent to `transfer`, and can be used to
309      * e.g. implement automatic token fees, slashing mechanisms, etc.
310      *
311      * Emits a `Transfer` event.
312      *
313      * Requirements:
314      *
315      * - `sender` cannot be the zero address.
316      * - `recipient` cannot be the zero address.
317      * - `sender` must have a balance of at least `amount`.
318      */
319     function _transfer(address sender, address recipient, uint256 amount) internal {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322 
323         _balances[sender] = _balances[sender].sub(amount);
324         _balances[recipient] = _balances[recipient].add(amount);
325         emit Transfer(sender, recipient, amount);
326     }
327 
328     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
329      * the total supply.
330      *
331      * Emits a `Transfer` event with `from` set to the zero address.
332      *
333      * Requirements
334      *
335      * - `to` cannot be the zero address.
336      */
337     function _mint(address account, uint256 amount) internal {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _totalSupply = _totalSupply.add(amount);
341         _balances[account] = _balances[account].add(amount);
342         emit Transfer(address(0), account, amount);
343     }
344 
345      /**
346      * @dev Destoys `amount` tokens from `account`, reducing the
347      * total supply.
348      *
349      * Emits a `Transfer` event with `to` set to the zero address.
350      *
351      * Requirements
352      *
353      * - `account` cannot be the zero address.
354      * - `account` must have at least `amount` tokens.
355      */
356     function _burn(address account, uint256 value) internal {
357         require(account != address(0), "ERC20: burn from the zero address");
358 
359         _totalSupply = _totalSupply.sub(value);
360         _balances[account] = _balances[account].sub(value);
361         emit Transfer(account, address(0), value);
362     }
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
366      *
367      * This is internal function is equivalent to `approve`, and can be used to
368      * e.g. set automatic allowances for certain subsystems, etc.
369      *
370      * Emits an `Approval` event.
371      *
372      * Requirements:
373      *
374      * - `owner` cannot be the zero address.
375      * - `spender` cannot be the zero address.
376      */
377     function _approve(address owner, address spender, uint256 value) internal {
378         require(owner != address(0), "ERC20: approve from the zero address");
379         require(spender != address(0), "ERC20: approve to the zero address");
380 
381         _allowances[owner][spender] = value;
382         emit Approval(owner, spender, value);
383     }
384 
385     /**
386      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
387      * from the caller's allowance.
388      *
389      * See `_burn` and `_approve`.
390      */
391     function _burnFrom(address account, uint256 amount) internal {
392         _burn(account, amount);
393         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
394     }
395 }
396 
397 // File: ..\node_modules\openzeppelin-solidity\contracts\access\Roles.sol
398 
399 pragma solidity ^0.5.0;
400 
401 /**
402  * @title Roles
403  * @dev Library for managing addresses assigned to a Role.
404  */
405 library Roles {
406     struct Role {
407         mapping (address => bool) bearer;
408     }
409 
410     /**
411      * @dev Give an account access to this role.
412      */
413     function add(Role storage role, address account) internal {
414         require(!has(role, account), "Roles: account already has role");
415         role.bearer[account] = true;
416     }
417 
418     /**
419      * @dev Remove an account's access to this role.
420      */
421     function remove(Role storage role, address account) internal {
422         require(has(role, account), "Roles: account does not have role");
423         role.bearer[account] = false;
424     }
425 
426     /**
427      * @dev Check if an account has this role.
428      * @return bool
429      */
430     function has(Role storage role, address account) internal view returns (bool) {
431         require(account != address(0), "Roles: account is the zero address");
432         return role.bearer[account];
433     }
434 }
435 
436 // File: ..\node_modules\openzeppelin-solidity\contracts\access\roles\PauserRole.sol
437 
438 pragma solidity ^0.5.0;
439 
440 
441 contract PauserRole {
442     using Roles for Roles.Role;
443 
444     event PauserAdded(address indexed account);
445     event PauserRemoved(address indexed account);
446 
447     Roles.Role private _pausers;
448 
449     constructor () internal {
450         _addPauser(msg.sender);
451     }
452 
453     modifier onlyPauser() {
454         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
455         _;
456     }
457 
458     function isPauser(address account) public view returns (bool) {
459         return _pausers.has(account);
460     }
461 
462     function addPauser(address account) public onlyPauser {
463         _addPauser(account);
464     }
465 
466     function renouncePauser() public {
467         _removePauser(msg.sender);
468     }
469 
470     function _addPauser(address account) internal {
471         _pausers.add(account);
472         emit PauserAdded(account);
473     }
474 
475     function _removePauser(address account) internal {
476         _pausers.remove(account);
477         emit PauserRemoved(account);
478     }
479 }
480 
481 // File: openzeppelin-solidity\contracts\lifecycle\Pausable.sol
482 
483 pragma solidity ^0.5.0;
484 
485 
486 /**
487  * @dev Contract module which allows children to implement an emergency stop
488  * mechanism that can be triggered by an authorized account.
489  *
490  * This module is used through inheritance. It will make available the
491  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
492  * the functions of your contract. Note that they will not be pausable by
493  * simply including this module, only once the modifiers are put in place.
494  */
495 contract Pausable is PauserRole {
496     /**
497      * @dev Emitted when the pause is triggered by a pauser (`account`).
498      */
499     event Paused(address account);
500 
501     /**
502      * @dev Emitted when the pause is lifted by a pauser (`account`).
503      */
504     event Unpaused(address account);
505 
506     bool private _paused;
507 
508     /**
509      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
510      * to the deployer.
511      */
512     constructor () internal {
513         _paused = false;
514     }
515 
516     /**
517      * @dev Returns true if the contract is paused, and false otherwise.
518      */
519     function paused() public view returns (bool) {
520         return _paused;
521     }
522 
523     /**
524      * @dev Modifier to make a function callable only when the contract is not paused.
525      */
526     modifier whenNotPaused() {
527         require(!_paused, "Pausable: paused");
528         _;
529     }
530 
531     /**
532      * @dev Modifier to make a function callable only when the contract is paused.
533      */
534     modifier whenPaused() {
535         require(_paused, "Pausable: not paused");
536         _;
537     }
538 
539     /**
540      * @dev Called by a pauser to pause, triggers stopped state.
541      */
542     function pause() public onlyPauser whenNotPaused {
543         _paused = true;
544         emit Paused(msg.sender);
545     }
546 
547     /**
548      * @dev Called by a pauser to unpause, returns to normal state.
549      */
550     function unpause() public onlyPauser whenPaused {
551         _paused = false;
552         emit Unpaused(msg.sender);
553     }
554 }
555 
556 // File: contracts\ERC20Pausable.sol
557 
558 pragma solidity ^0.5.0;
559 
560 
561 
562 /**
563  * @title Pausable token
564  * @dev ERC20 modified with pausable transfers.
565  */
566 contract ERC20Pausable is ERC20, Pausable {
567     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
568         return super.transfer(to, value);
569     }
570 
571     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
572         return super.transferFrom(from, to, value);
573     }
574 
575     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
576         return super.approve(spender, value);
577     }
578 
579     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
580         return super.increaseAllowance(spender, addedValue);
581     }
582 
583     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
584         return super.decreaseAllowance(spender, subtractedValue);
585     }
586 }
587 
588 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
589 
590 pragma solidity ^0.5.0;
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * This module is used through inheritance. It will make available the modifier
598  * `onlyOwner`, which can be aplied to your functions to restrict their use to
599  * the owner.
600  */
601 contract Ownable {
602     address private _owner;
603 
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605 
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor () internal {
610         _owner = msg.sender;
611         emit OwnershipTransferred(address(0), _owner);
612     }
613 
614     /**
615      * @dev Returns the address of the current owner.
616      */
617     function owner() public view returns (address) {
618         return _owner;
619     }
620 
621     /**
622      * @dev Throws if called by any account other than the owner.
623      */
624     modifier onlyOwner() {
625         require(isOwner(), "Ownable: caller is not the owner");
626         _;
627     }
628 
629     /**
630      * @dev Returns true if the caller is the current owner.
631      */
632     function isOwner() public view returns (bool) {
633         return msg.sender == _owner;
634     }
635 
636     /**
637      * @dev Leaves the contract without owner. It will not be possible to call
638      * `onlyOwner` functions anymore. Can only be called by the current owner.
639      *
640      * > Note: Renouncing ownership will leave the contract without an owner,
641      * thereby removing any functionality that is only available to the owner.
642      */
643     function renounceOwnership() public onlyOwner {
644         emit OwnershipTransferred(_owner, address(0));
645         _owner = address(0);
646     }
647 
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      * Can only be called by the current owner.
651      */
652     function transferOwnership(address newOwner) public onlyOwner {
653         _transferOwnership(newOwner);
654     }
655 
656     /**
657      * @dev Transfers ownership of the contract to a new account (`newOwner`).
658      */
659     function _transferOwnership(address newOwner) internal {
660         require(newOwner != address(0), "Ownable: new owner is the zero address");
661         emit OwnershipTransferred(_owner, newOwner);
662         _owner = newOwner;
663     }
664 }
665 
666 // File: contracts\Inty.sol
667 
668 pragma solidity ^0.5.0;
669 
670 
671 
672 
673 contract Inty is ERC20Pausable, Ownable
674 {
675 
676     string public symbol = "ITM";
677     uint8 public decimals = 18;
678     mapping (address => uint256) private _frozenBalances;
679     using SafeMath for uint256;
680     
681 
682     constructor() public
683     {
684         _mint(owner(), 33000000 * 10 ** (uint256)(decimals));
685     }
686 
687     function bulkTransfer(address[] memory recipients, uint256[] memory amounts) public onlyOwner
688     {
689         require(recipients.length == amounts.length, "Addresses and amounts arrays are not equal");
690 
691         for (uint256 i = 0; i < recipients.length; ++i)
692         {
693             require(recipients[i] != address(0), "One of the addresses is null address");
694             _transfer(owner(), recipients[i], amounts[i]);
695         }
696     }
697 
698     function freeze(address token_holder, uint256 amount) public onlyOwner
699     {
700         require(token_holder != address(0), "token_holder is null address");
701         require(amount <= _balances[token_holder], "No enough balance to freeze");
702         _balances[token_holder] = _balances[token_holder].sub(amount);
703         _frozenBalances[token_holder] = _frozenBalances[token_holder].add(amount);
704     }
705 
706     function unfreeze(address token_holder, uint256 amount) public onlyOwner
707     {
708         require(token_holder != address(0), "token_holder is null address");
709         require(amount <= _frozenBalances[token_holder], "No enough frozen balance to unfreeze");
710         _frozenBalances[token_holder] = _frozenBalances[token_holder].sub(amount);
711         _balances[token_holder] = _balances[token_holder].add(amount);
712     }
713 
714     function burn(uint256 amount) public onlyOwner
715     {
716         _burn(msg.sender, amount);
717     }
718 
719     function balanceOfFrozen(address token_holder) public view returns (uint256)
720     {
721         return _frozenBalances[token_holder];
722     }
723 }