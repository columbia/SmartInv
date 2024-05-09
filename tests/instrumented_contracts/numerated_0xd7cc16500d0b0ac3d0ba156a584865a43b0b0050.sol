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
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
111  * the optional functions; to access them see `ERC20Detailed`.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a `Transfer` event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through `transferFrom`. This is
136      * zero by default.
137      *
138      * This value changes when `approve` or `transferFrom` are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * > Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an `Approval` event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a `Transfer` event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to `approve`. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 
185 /**
186  * @dev Implementation of the `IERC20` interface.
187  *
188  * This implementation is agnostic to the way tokens are created. This means
189  * that a supply mechanism has to be added in a derived contract using `_mint`.
190  * For a generic mechanism see `ERC20Mintable`.
191  *
192  * *For a detailed writeup see our guide [How to implement supply
193  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
194  *
195  * We have followed general OpenZeppelin guidelines: functions revert instead
196  * of returning `false` on failure. This behavior is nonetheless conventional
197  * and does not conflict with the expectations of ERC20 applications.
198  *
199  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
200  * This allows applications to reconstruct the allowance for all accounts just
201  * by listening to said events. Other implementations of the EIP may not emit
202  * these events, as it isn't required by the specification.
203  *
204  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
205  * functions have been added to mitigate the well-known issues around setting
206  * allowances. See `IERC20.approve`.
207  */
208 contract ERC20 is IERC20 {
209     using SafeMath for uint256;
210 
211     mapping (address => uint256) private _balances;
212 
213     mapping (address => mapping (address => uint256)) private _allowances;
214 
215     uint256 private _totalSupply;
216 
217     /**
218      * @dev See `IERC20.totalSupply`.
219      */
220     function totalSupply() public view returns (uint256) {
221         return _totalSupply;
222     }
223 
224     /**
225      * @dev See `IERC20.balanceOf`.
226      */
227     function balanceOf(address account) public view returns (uint256) {
228         return _balances[account];
229     }
230 
231     /**
232      * @dev See `IERC20.transfer`.
233      *
234      * Requirements:
235      *
236      * - `recipient` cannot be the zero address.
237      * - the caller must have a balance of at least `amount`.
238      */
239     function transfer(address recipient, uint256 amount) public returns (bool) {
240         _transfer(msg.sender, recipient, amount);
241         return true;
242     }
243 
244     /**
245      * @dev See `IERC20.allowance`.
246      */
247     function allowance(address owner, address spender) public view returns (uint256) {
248         return _allowances[owner][spender];
249     }
250 
251     /**
252      * @dev See `IERC20.approve`.
253      *
254      * Requirements:
255      *
256      * - `spender` cannot be the zero address.
257      */
258     function approve(address spender, uint256 value) public returns (bool) {
259         _approve(msg.sender, spender, value);
260         return true;
261     }
262 
263     /**
264      * @dev See `IERC20.transferFrom`.
265      *
266      * Emits an `Approval` event indicating the updated allowance. This is not
267      * required by the EIP. See the note at the beginning of `ERC20`;
268      *
269      * Requirements:
270      * - `sender` and `recipient` cannot be the zero address.
271      * - `sender` must have a balance of at least `value`.
272      * - the caller must have allowance for `sender`'s tokens of at least
273      * `amount`.
274      */
275     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to `approve` that can be used as a mitigation for
285      * problems described in `IERC20.approve`.
286      *
287      * Emits an `Approval` event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
295         return true;
296     }
297 
298     /**
299      * @dev Atomically decreases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to `approve` that can be used as a mitigation for
302      * problems described in `IERC20.approve`.
303      *
304      * Emits an `Approval` event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      * - `spender` must have allowance for the caller of at least
310      * `subtractedValue`.
311      */
312     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
313         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
314         return true;
315     }
316 
317     /**
318      * @dev Moves tokens `amount` from `sender` to `recipient`.
319      *
320      * This is internal function is equivalent to `transfer`, and can be used to
321      * e.g. implement automatic token fees, slashing mechanisms, etc.
322      *
323      * Emits a `Transfer` event.
324      *
325      * Requirements:
326      *
327      * - `sender` cannot be the zero address.
328      * - `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      */
331     function _transfer(address sender, address recipient, uint256 amount) internal {
332         require(sender != address(0), "ERC20: transfer from the zero address");
333         require(recipient != address(0), "ERC20: transfer to the zero address");
334 
335         _balances[sender] = _balances[sender].sub(amount);
336         _balances[recipient] = _balances[recipient].add(amount);
337         emit Transfer(sender, recipient, amount);
338     }
339 
340     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
341      * the total supply.
342      *
343      * Emits a `Transfer` event with `from` set to the zero address.
344      *
345      * Requirements
346      *
347      * - `to` cannot be the zero address.
348      */
349     function _mint(address account, uint256 amount) internal {
350         require(account != address(0), "ERC20: mint to the zero address");
351 
352         _totalSupply = _totalSupply.add(amount);
353         _balances[account] = _balances[account].add(amount);
354         emit Transfer(address(0), account, amount);
355     }
356 
357      /**
358      * @dev Destoys `amount` tokens from `account`, reducing the
359      * total supply.
360      *
361      * Emits a `Transfer` event with `to` set to the zero address.
362      *
363      * Requirements
364      *
365      * - `account` cannot be the zero address.
366      * - `account` must have at least `amount` tokens.
367      */
368     function _burn(address account, uint256 value) internal {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _totalSupply = _totalSupply.sub(value);
372         _balances[account] = _balances[account].sub(value);
373         emit Transfer(account, address(0), value);
374     }
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
378      *
379      * This is internal function is equivalent to `approve`, and can be used to
380      * e.g. set automatic allowances for certain subsystems, etc.
381      *
382      * Emits an `Approval` event.
383      *
384      * Requirements:
385      *
386      * - `owner` cannot be the zero address.
387      * - `spender` cannot be the zero address.
388      */
389     function _approve(address owner, address spender, uint256 value) internal {
390         require(owner != address(0), "ERC20: approve from the zero address");
391         require(spender != address(0), "ERC20: approve to the zero address");
392 
393         _allowances[owner][spender] = value;
394         emit Approval(owner, spender, value);
395     }
396 
397     /**
398      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
399      * from the caller's allowance.
400      *
401      * See `_burn` and `_approve`.
402      */
403     function _burnFrom(address account, uint256 amount) internal {
404         _burn(account, amount);
405         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
406     }
407 }
408 
409 /**
410  * @title Roles
411  * @dev Library for managing addresses assigned to a Role.
412  */
413 library Roles {
414     struct Role {
415         mapping (address => bool) bearer;
416     }
417 
418     /**
419      * @dev Give an account access to this role.
420      */
421     function add(Role storage role, address account) internal {
422         require(!has(role, account), "Roles: account already has role");
423         role.bearer[account] = true;
424     }
425 
426     /**
427      * @dev Remove an account's access to this role.
428      */
429     function remove(Role storage role, address account) internal {
430         require(has(role, account), "Roles: account does not have role");
431         role.bearer[account] = false;
432     }
433 
434     /**
435      * @dev Check if an account has this role.
436      * @return bool
437      */
438     function has(Role storage role, address account) internal view returns (bool) {
439         require(account != address(0), "Roles: account is the zero address");
440         return role.bearer[account];
441     }
442 }
443 
444 contract PauserRole {
445     using Roles for Roles.Role;
446 
447     event PauserAdded(address indexed account);
448     event PauserRemoved(address indexed account);
449 
450     Roles.Role private _pausers;
451 
452     constructor () internal {
453         _addPauser(msg.sender);
454     }
455 
456     modifier onlyPauser() {
457         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
458         _;
459     }
460 
461     function isPauser(address account) public view returns (bool) {
462         return _pausers.has(account);
463     }
464 
465     function addPauser(address account) public onlyPauser {
466         _addPauser(account);
467     }
468 
469     function renouncePauser() public {
470         _removePauser(msg.sender);
471     }
472 
473     function _addPauser(address account) internal {
474         _pausers.add(account);
475         emit PauserAdded(account);
476     }
477 
478     function _removePauser(address account) internal {
479         _pausers.remove(account);
480         emit PauserRemoved(account);
481     }
482 }
483 
484 /**
485  * @dev Contract module which allows children to implement an emergency stop
486  * mechanism that can be triggered by an authorized account.
487  *
488  * This module is used through inheritance. It will make available the
489  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
490  * the functions of your contract. Note that they will not be pausable by
491  * simply including this module, only once the modifiers are put in place.
492  */
493 contract Pausable is PauserRole {
494     /**
495      * @dev Emitted when the pause is triggered by a pauser (`account`).
496      */
497     event Paused(address account);
498 
499     /**
500      * @dev Emitted when the pause is lifted by a pauser (`account`).
501      */
502     event Unpaused(address account);
503 
504     bool private _paused;
505 
506     /**
507      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
508      * to the deployer.
509      */
510     constructor () internal {
511         _paused = false;
512     }
513 
514     /**
515      * @dev Returns true if the contract is paused, and false otherwise.
516      */
517     function paused() public view returns (bool) {
518         return _paused;
519     }
520 
521     /**
522      * @dev Modifier to make a function callable only when the contract is not paused.
523      */
524     modifier whenNotPaused() {
525         require(!_paused, "Pausable: paused");
526         _;
527     }
528 
529     /**
530      * @dev Modifier to make a function callable only when the contract is paused.
531      */
532     modifier whenPaused() {
533         require(_paused, "Pausable: not paused");
534         _;
535     }
536 
537     /**
538      * @dev Called by a pauser to pause, triggers stopped state.
539      */
540     function pause() public onlyPauser whenNotPaused {
541         _paused = true;
542         emit Paused(msg.sender);
543     }
544 
545     /**
546      * @dev Called by a pauser to unpause, returns to normal state.
547      */
548     function unpause() public onlyPauser whenPaused {
549         _paused = false;
550         emit Unpaused(msg.sender);
551     }
552 }
553 
554 /**
555  * @dev Extension of `ERC20` that allows token holders to destroy both their own
556  * tokens and those that they have an allowance for, in a way that can be
557  * recognized off-chain (via event analysis).
558  */
559 contract ERC20Burnable is ERC20, Pausable {
560     /**
561      * @dev Destoys `amount` tokens from the caller.
562      *
563      * See `ERC20._burn`.
564      */
565     function burn(uint256 amount) public whenNotPaused {
566         _burn(msg.sender, amount);
567     }
568 
569     /**
570      * @dev See `ERC20._burnFrom`.
571      */
572     function burnFrom(address account, uint256 amount) public whenNotPaused {
573         _burnFrom(account, amount);
574     }
575 }
576 
577 /**
578  * @dev Optional functions from the ERC20 standard.
579  */
580 contract ERC20Detailed is IERC20 {
581     string private _name;
582     string private _symbol;
583     uint8 private _decimals;
584 
585     /**
586      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
587      * these values are immutable: they can only be set once during
588      * construction.
589      */
590     constructor (string memory name, string memory symbol, uint8 decimals) public {
591         _name = name;
592         _symbol = symbol;
593         _decimals = decimals;
594     }
595 
596     /**
597      * @dev Returns the name of the token.
598      */
599     function name() public view returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev Returns the symbol of the token, usually a shorter version of the
605      * name.
606      */
607     function symbol() public view returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev Returns the number of decimals used to get its user representation.
613      * For example, if `decimals` equals `2`, a balance of `505` tokens should
614      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
615      *
616      * Tokens usually opt for a value of 18, imitating the relationship between
617      * Ether and Wei.
618      *
619      * > Note that this information is only used for _display_ purposes: it in
620      * no way affects any of the arithmetic of the contract, including
621      * `IERC20.balanceOf` and `IERC20.transfer`.
622      */
623     function decimals() public view returns (uint8) {
624         return _decimals;
625     }
626 }
627 
628 /**
629  * @title Pausable token
630  * @dev ERC20 modified with pausable transfers.
631  */
632 contract ERC20Pausable is ERC20, Pausable {
633     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
634         return super.transfer(to, value);
635     }
636 
637     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
638         return super.transferFrom(from, to, value);
639     }
640 
641     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
642         return super.approve(spender, value);
643     }
644 
645     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
646         return super.increaseAllowance(spender, addedValue);
647     }
648 
649     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
650         return super.decreaseAllowance(spender, subtractedValue);
651     }
652 }
653 
654 contract TEPTokenV2 is ERC20, ERC20Burnable, ERC20Pausable, ERC20Detailed {
655 
656     /**
657      * @dev Constructor that gives msg.sender all of existing tokens.
658      */
659     constructor () public ERC20Detailed("Tepleton", "TEP", 8) {
660         _mint(msg.sender, 900000000 * (10 ** uint256(decimals())));
661     }
662 }