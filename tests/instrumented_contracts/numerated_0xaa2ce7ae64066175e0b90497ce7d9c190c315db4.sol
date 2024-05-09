1 pragma solidity 0.5.12;
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
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be aplied to your functions to restrict their use to
117  * the owner.
118  */
119 contract Ownable {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor () internal {
128         _owner = msg.sender;
129         emit OwnershipTransferred(address(0), _owner);
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(isOwner(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Returns true if the caller is the current owner.
149      */
150     function isOwner() public view returns (bool) {
151         return msg.sender == _owner;
152     }
153 
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public onlyOwner {
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      */
166     function _transferOwnership(address newOwner) internal {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 }
172 
173 /**
174  * @title Roles
175  * @dev Library for managing addresses assigned to a Role.
176  */
177 library Roles {
178     struct Role {
179         mapping (address => bool) bearer;
180     }
181 
182     /**
183      * @dev Give an account access to this role.
184      */
185     function add(Role storage role, address account) internal {
186         require(!has(role, account), "Roles: account already has role");
187         role.bearer[account] = true;
188     }
189 
190     /**
191      * @dev Remove an account's access to this role.
192      */
193     function remove(Role storage role, address account) internal {
194         require(has(role, account), "Roles: account does not have role");
195         role.bearer[account] = false;
196     }
197 
198     /**
199      * @dev Check if an account has this role.
200      * @return bool
201      */
202     function has(Role storage role, address account) internal view returns (bool) {
203         require(account != address(0), "Roles: account is the zero address");
204         return role.bearer[account];
205     }
206 }
207 
208 contract PauserRole {
209     using Roles for Roles.Role;
210 
211     event PauserAdded(address indexed account);
212     event PauserRemoved(address indexed account);
213 
214     Roles.Role private _pausers;
215 
216     constructor () internal {
217         _addPauser(msg.sender);
218     }
219 
220     modifier onlyPauser() {
221         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
222         _;
223     }
224 
225     function isPauser(address account) public view returns (bool) {
226         return _pausers.has(account);
227     }
228 
229     function addPauser(address account) public onlyPauser {
230         _addPauser(account);
231     }
232 
233     function renouncePauser() public {
234         _removePauser(msg.sender);
235     }
236 
237     function _addPauser(address account) internal {
238         _pausers.add(account);
239         emit PauserAdded(account);
240     }
241 
242     function _removePauser(address account) internal {
243         _pausers.remove(account);
244         emit PauserRemoved(account);
245     }
246 }
247 
248 /**
249  * @dev Contract module which allows children to implement an emergency stop
250  * mechanism that can be triggered by an authorized account.
251  *
252  * This module is used through inheritance. It will make available the
253  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
254  * the functions of your contract. Note that they will not be pausable by
255  * simply including this module, only once the modifiers are put in place.
256  */
257 contract Pausable is PauserRole {
258     /**
259      * @dev Emitted when the pause is triggered by a pauser (`account`).
260      */
261     event Paused(address account);
262 
263     /**
264      * @dev Emitted when the pause is lifted by a pauser (`account`).
265      */
266     event Unpaused(address account);
267 
268     bool private _paused;
269 
270     /**
271      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
272      * to the deployer.
273      */
274     constructor () internal {
275         _paused = false;
276     }
277 
278     /**
279      * @dev Returns true if the contract is paused, and false otherwise.
280      */
281     function paused() public view returns (bool) {
282         return _paused;
283     }
284 
285     /**
286      * @dev Modifier to make a function callable only when the contract is not paused.
287      */
288     modifier whenNotPaused() {
289         require(!_paused, "Pausable: paused");
290         _;
291     }
292 
293     /**
294      * @dev Modifier to make a function callable only when the contract is paused.
295      */
296     modifier whenPaused() {
297         require(_paused, "Pausable: not paused");
298         _;
299     }
300 
301     /**
302      * @dev Called by a pauser to pause, triggers stopped state.
303      */
304     function pause() public onlyPauser whenNotPaused {
305         _paused = true;
306         emit Paused(msg.sender);
307     }
308 
309     /**
310      * @dev Called by a pauser to unpause, returns to normal state.
311      */
312     function unpause() public onlyPauser whenPaused {
313         _paused = false;
314         emit Unpaused(msg.sender);
315     }
316 }
317 
318 /**
319  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
320  * the optional functions; to access them see `ERC20Detailed`.
321  */
322 interface IERC20 {
323     /**
324      * @dev Returns the amount of tokens in existence.
325      */
326     function totalSupply() external view returns (uint256);
327 
328     /**
329      * @dev Returns the amount of tokens owned by `account`.
330      */
331     function balanceOf(address account) external view returns (uint256);
332 
333     /**
334      * @dev Moves `amount` tokens from the caller's account to `recipient`.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a `Transfer` event.
339      */
340     function transfer(address recipient, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Returns the remaining number of tokens that `spender` will be
344      * allowed to spend on behalf of `owner` through `transferFrom`. This is
345      * zero by default.
346      *
347      * This value changes when `approve` or `transferFrom` are called.
348      */
349     function allowance(address owner, address spender) external view returns (uint256);
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * > Beware that changing an allowance with this method brings the risk
357      * that someone may use both the old and the new allowance by unfortunate
358      * transaction ordering. One possible solution to mitigate this race
359      * condition is to first reduce the spender's allowance to 0 and set the
360      * desired value afterwards:
361      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362      *
363      * Emits an `Approval` event.
364      */
365     function approve(address spender, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Moves `amount` tokens from `sender` to `recipient` using the
369      * allowance mechanism. `amount` is then deducted from the caller's
370      * allowance.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a `Transfer` event.
375      */
376     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Emitted when `value` tokens are moved from one account (`from`) to
380      * another (`to`).
381      *
382      * Note that `value` may be zero.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 value);
385 
386     /**
387      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
388      * a call to `approve`. `value` is the new allowance.
389      */
390     event Approval(address indexed owner, address indexed spender, uint256 value);
391 }
392 
393 
394 /**
395  * @dev Implementation of the `IERC20` interface.
396  *
397  * This implementation is agnostic to the way tokens are created. This means
398  * that a supply mechanism has to be added in a derived contract using `_mint`.
399  * For a generic mechanism see `ERC20Mintable`.
400  *
401  * *For a detailed writeup see our guide [How to implement supply
402  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
403  *
404  * We have followed general OpenZeppelin guidelines: functions revert instead
405  * of returning `false` on failure. This behavior is nonetheless conventional
406  * and does not conflict with the expectations of ERC20 applications.
407  *
408  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
409  * This allows applications to reconstruct the allowance for all accounts just
410  * by listening to said events. Other implementations of the EIP may not emit
411  * these events, as it isn't required by the specification.
412  *
413  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
414  * functions have been added to mitigate the well-known issues around setting
415  * allowances. See `IERC20.approve`.
416  */
417 contract ERC20 is IERC20 {
418     using SafeMath for uint256;
419 
420     mapping (address => uint256) private _balances;
421 
422     mapping (address => mapping (address => uint256)) private _allowances;
423 
424     uint256 private _totalSupply;
425 
426     /**
427      * @dev See `IERC20.totalSupply`.
428      */
429     function totalSupply() public view returns (uint256) {
430         return _totalSupply;
431     }
432 
433     /**
434      * @dev See `IERC20.balanceOf`.
435      */
436     function balanceOf(address account) public view returns (uint256) {
437         return _balances[account];
438     }
439 
440     /**
441      * @dev See `IERC20.transfer`.
442      *
443      * Requirements:
444      *
445      * - `recipient` cannot be the zero address.
446      * - the caller must have a balance of at least `amount`.
447      */
448     function transfer(address recipient, uint256 amount) public returns (bool) {
449         _transfer(msg.sender, recipient, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See `IERC20.allowance`.
455      */
456     function allowance(address owner, address spender) public view returns (uint256) {
457         return _allowances[owner][spender];
458     }
459 
460     /**
461      * @dev See `IERC20.approve`.
462      *
463      * Requirements:
464      *
465      * - `spender` cannot be the zero address.
466      */
467     function approve(address spender, uint256 value) public returns (bool) {
468         _approve(msg.sender, spender, value);
469         return true;
470     }
471 
472     /**
473      * @dev See `IERC20.transferFrom`.
474      *
475      * Emits an `Approval` event indicating the updated allowance. This is not
476      * required by the EIP. See the note at the beginning of `ERC20`;
477      *
478      * Requirements:
479      * - `sender` and `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `value`.
481      * - the caller must have allowance for `sender`'s tokens of at least
482      * `amount`.
483      */
484     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
485         _transfer(sender, recipient, amount);
486         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
487         return true;
488     }
489 
490     /**
491      * @dev Atomically increases the allowance granted to `spender` by the caller.
492      *
493      * This is an alternative to `approve` that can be used as a mitigation for
494      * problems described in `IERC20.approve`.
495      *
496      * Emits an `Approval` event indicating the updated allowance.
497      *
498      * Requirements:
499      *
500      * - `spender` cannot be the zero address.
501      */
502     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
503         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
504         return true;
505     }
506 
507     /**
508      * @dev Atomically decreases the allowance granted to `spender` by the caller.
509      *
510      * This is an alternative to `approve` that can be used as a mitigation for
511      * problems described in `IERC20.approve`.
512      *
513      * Emits an `Approval` event indicating the updated allowance.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      * - `spender` must have allowance for the caller of at least
519      * `subtractedValue`.
520      */
521     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
522         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
523         return true;
524     }
525 
526     /**
527      * @dev Moves tokens `amount` from `sender` to `recipient`.
528      *
529      * This is internal function is equivalent to `transfer`, and can be used to
530      * e.g. implement automatic token fees, slashing mechanisms, etc.
531      *
532      * Emits a `Transfer` event.
533      *
534      * Requirements:
535      *
536      * - `sender` cannot be the zero address.
537      * - `recipient` cannot be the zero address.
538      * - `sender` must have a balance of at least `amount`.
539      */
540     function _transfer(address sender, address recipient, uint256 amount) internal {
541         require(sender != address(0), "ERC20: transfer from the zero address");
542         require(recipient != address(0), "ERC20: transfer to the zero address");
543 
544         _balances[sender] = _balances[sender].sub(amount);
545         _balances[recipient] = _balances[recipient].add(amount);
546         emit Transfer(sender, recipient, amount);
547     }
548 
549     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
550      * the total supply.
551      *
552      * Emits a `Transfer` event with `from` set to the zero address.
553      *
554      * Requirements
555      *
556      * - `to` cannot be the zero address.
557      */
558     function _mint(address account, uint256 amount) internal {
559         require(account != address(0), "ERC20: mint to the zero address");
560 
561         _totalSupply = _totalSupply.add(amount);
562         _balances[account] = _balances[account].add(amount);
563         emit Transfer(address(0), account, amount);
564     }
565 
566 
567     /**
568      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
569      *
570      * This is internal function is equivalent to `approve`, and can be used to
571      * e.g. set automatic allowances for certain subsystems, etc.
572      *
573      * Emits an `Approval` event.
574      *
575      * Requirements:
576      *
577      * - `owner` cannot be the zero address.
578      * - `spender` cannot be the zero address.
579      */
580     function _approve(address owner, address spender, uint256 value) internal {
581         require(owner != address(0), "ERC20: approve from the zero address");
582         require(spender != address(0), "ERC20: approve to the zero address");
583 
584         _allowances[owner][spender] = value;
585         emit Approval(owner, spender, value);
586     }
587 
588 }
589 /**
590  * @title Pausable token
591  * @dev ERC20 modified with pausable transfers.
592  */
593 contract ERC20Pausable is ERC20, Pausable {
594     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
595         return super.transfer(to, value);
596     }
597 
598     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
599         return super.transferFrom(from, to, value);
600     }
601 
602     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
603         return super.approve(spender, value);
604     }
605 
606     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
607         return super.increaseAllowance(spender, addedValue);
608     }
609 
610     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
611         return super.decreaseAllowance(spender, subtractedValue);
612     }
613 }
614 
615 contract Admin is Ownable {
616 
617     event AdminRoleAdded(address indexed account);
618 
619     event AdminRoleRemoved(address indexed account);
620 
621     mapping(address => bool) public AdminRole;
622 
623     constructor () internal {
624         _addAdmin(msg.sender);
625     }
626 
627     modifier onlyAdmin() {
628         require(AdminRole[msg.sender]);
629         _;
630     }
631 
632     function addAdmin(address account) public onlyOwner {
633         _addAdmin(account);
634     }
635 
636     function removeAdmin(address account) public onlyOwner {
637         _removeAdmin(account);
638     }
639 
640     function renounceAdmin() public {
641         _removeAdmin(msg.sender);
642     }
643 
644     function _addAdmin(address account) internal {
645         require(AdminRole[account] == false);
646         AdminRole[account] = true;
647         emit AdminRoleAdded(account);
648     }
649 
650     function _removeAdmin(address account) internal {
651         require(AdminRole[account] == true);
652         AdminRole[account] = false;
653         emit AdminRoleRemoved(account);
654     }
655 }
656 
657 contract Blacklist is Admin {
658 
659     mapping (address => bool) private _blacklist;
660 
661     event BlacklistAdded(address indexed account);
662 
663     event BlacklistRemoved(address indexed account);
664     
665     function isBlacklist(address account) public view returns (bool) {
666         return _blacklist[account];
667     }
668 
669 
670     function addBlacklist(address account) public onlyAdmin {
671         require(_blacklist[account] == false);
672         _blacklist[account] = true;
673         emit BlacklistAdded(account);
674     }
675 
676     function removeBlacklist(address account) public onlyAdmin {
677         require(_blacklist[account] == true);
678         _blacklist[account] = false;
679         emit BlacklistRemoved(account);
680     }
681 }
682 contract SuterusuToken is Blacklist ,ERC20,ERC20Pausable {
683     string  public constant  name  = "Suterusu";
684     string  public constant symbol   = "Suter";
685     uint8 public constant decimals = 18;
686     uint256  private constant _totalSupply = 10000000000 * (10 ** uint256(decimals));
687 
688     constructor()  public {
689         _mint(msg.sender, _totalSupply);
690     }
691 
692 
693     function transfer(address to, uint256 value) public  returns (bool) {
694         require(!isBlacklist(msg.sender), "Token: caller in blacklist can't transfer");
695         require(!isBlacklist(to), "Token: not allow to transfer to recipient address in blacklist");
696         return super.transfer(to, value);
697     }
698 
699     function transferFrom(address from, address to, uint256 value) public  returns (bool) {
700         require(!isBlacklist(msg.sender), "Token: caller in blacklist can't transferFrom");
701         require(!isBlacklist(from), "Token: from in blacklist can't transfer");
702         require(!isBlacklist(to), "Token: not allow to transfer to recipient address in blacklist");
703         return super.transferFrom(from, to, value);
704     }
705 }