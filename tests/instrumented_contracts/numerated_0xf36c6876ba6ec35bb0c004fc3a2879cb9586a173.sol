1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4   /**
5    * @dev Returns the amount of tokens in existence.
6    */
7   function totalSupply() external view returns (uint256);
8 
9   /**
10    * @dev Returns the amount of tokens owned by `account`.
11    */
12   function balanceOf(address account) external view returns (uint256);
13 
14   /**
15    * @dev Moves `amount` tokens from the caller's account to `recipient`.
16    *
17    * Returns a boolean value indicating whether the operation succeeded.
18    *
19    * Emits a `Transfer` event.
20    */
21   function transfer(address recipient, uint256 amount) external returns (bool);
22 
23   /**
24    * @dev Returns the remaining number of tokens that `spender` will be
25    * allowed to spend on behalf of `owner` through `transferFrom`. This is
26    * zero by default.
27    *
28    * This value changes when `approve` or `transferFrom` are called.
29    */
30   function allowance(address owner, address spender) external view returns (uint256);
31 
32   /**
33    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34    *
35    * Returns a boolean value indicating whether the operation succeeded.
36    *
37    * > Beware that changing an allowance with this method brings the risk
38    * that someone may use both the old and the new allowance by unfortunate
39    * transaction ordering. One possible solution to mitigate this race
40    * condition is to first reduce the spender's allowance to 0 and set the
41    * desired value afterwards:
42    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43    *
44    * Emits an `Approval` event.
45    */
46   function approve(address spender, uint256 amount) external returns (bool);
47 
48   /**
49    * @dev Moves `amount` tokens from `sender` to `recipient` using the
50    * allowance mechanism. `amount` is then deducted from the caller's
51    * allowance.
52    *
53    * Returns a boolean value indicating whether the operation succeeded.
54    *
55    * Emits a `Transfer` event.
56    */
57   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59   /**
60    * @dev Emitted when `value` tokens are moved from one account (`from`) to
61    * another (`to`).
62    *
63    * Note that `value` may be zero.
64    */
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 
67   /**
68    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69    * a call to `approve`. `value` is the new allowance.
70    */
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88 library SafeMath {
89   /**
90    * @dev Returns the addition of two unsigned integers, reverting on
91    * overflow.
92    *
93    * Counterpart to Solidity's `+` operator.
94    *
95    * Requirements:
96    * - Addition cannot overflow.
97    */
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     require(c >= a, "SafeMath: addition overflow");
101 
102     return c;
103   }
104 
105   /**
106    * @dev Returns the subtraction of two unsigned integers, reverting on
107    * overflow (when the result is negative).
108    *
109    * Counterpart to Solidity's `-` operator.
110    *
111    * Requirements:
112    * - Subtraction cannot overflow.
113    */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b <= a, "SafeMath: subtraction overflow");
116     uint256 c = a - b;
117 
118     return c;
119   }
120 
121   /**
122    * @dev Returns the multiplication of two unsigned integers, reverting on
123    * overflow.
124    *
125    * Counterpart to Solidity's `*` operator.
126    *
127    * Requirements:
128    * - Multiplication cannot overflow.
129    */
130   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132     // benefit is lost if 'b' is also tested.
133     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
134     if (a == 0) {
135       return 0;
136     }
137 
138     uint256 c = a * b;
139     require(c / a == b, "SafeMath: multiplication overflow");
140 
141     return c;
142   }
143 
144   /**
145    * @dev Returns the integer division of two unsigned integers. Reverts on
146    * division by zero. The result is rounded towards zero.
147    *
148    * Counterpart to Solidity's `/` operator. Note: this function uses a
149    * `revert` opcode (which leaves remaining gas untouched) while Solidity
150    * uses an invalid opcode to revert (consuming all remaining gas).
151    *
152    * Requirements:
153    * - The divisor cannot be zero.
154    */
155   function div(uint256 a, uint256 b) internal pure returns (uint256) {
156     // Solidity only automatically asserts when dividing by 0
157     require(b > 0, "SafeMath: division by zero");
158     uint256 c = a / b;
159     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161     return c;
162   }
163 
164   /**
165    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166    * Reverts when dividing by zero.
167    *
168    * Counterpart to Solidity's `%` operator. This function uses a `revert`
169    * opcode (which leaves remaining gas untouched) while Solidity uses an
170    * invalid opcode to revert (consuming all remaining gas).
171    *
172    * Requirements:
173    * - The divisor cannot be zero.
174    */
175   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176     require(b != 0, "SafeMath: modulo by zero");
177     return a % b;
178   }
179 }
180 
181 
182 /**
183  * @dev Implementation of the `IERC20` interface.
184  *
185  * This implementation is agnostic to the way tokens are created. This means
186  * that a supply mechanism has to be added in a derived contract using `_mint`.
187  * For a generic mechanism see `ERC20Mintable`.
188  *
189  * *For a detailed writeup see our guide [How to implement supply
190  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
191  *
192  * We have followed general OpenZeppelin guidelines: functions revert instead
193  * of returning `false` on failure. This behavior is nonetheless conventional
194  * and does not conflict with the expectations of ERC20 applications.
195  *
196  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
197  * This allows applications to reconstruct the allowance for all accounts just
198  * by listening to said events. Other implementations of the EIP may not emit
199  * these events, as it isn't required by the specification.
200  *
201  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
202  * functions have been added to mitigate the well-known issues around setting
203  * allowances. See `IERC20.approve`.
204  */
205 contract ERC20 is IERC20 {
206   using SafeMath for uint256;
207 
208   mapping (address => uint256) private _balances;
209 
210   mapping (address => mapping (address => uint256)) private _allowances;
211 
212   uint256 private _totalSupply;
213 
214   /**
215    * @dev See `IERC20.totalSupply`.
216    */
217   function totalSupply() public view returns (uint256) {
218     return _totalSupply;
219   }
220 
221   /**
222    * @dev See `IERC20.balanceOf`.
223    */
224   function balanceOf(address account) public view returns (uint256) {
225     return _balances[account];
226   }
227 
228   /**
229    * @dev See `IERC20.transfer`.
230    *
231    * Requirements:
232    *
233    * - `recipient` cannot be the zero address.
234    * - the caller must have a balance of at least `amount`.
235    */
236   function transfer(address recipient, uint256 amount) public returns (bool) {
237     _transfer(msg.sender, recipient, amount);
238     return true;
239   }
240 
241   /**
242    * @dev See `IERC20.allowance`.
243    */
244   function allowance(address owner, address spender) public view returns (uint256) {
245     return _allowances[owner][spender];
246   }
247 
248   /**
249    * @dev See `IERC20.approve`.
250    *
251    * Requirements:
252    *
253    * - `spender` cannot be the zero address.
254    */
255   function approve(address spender, uint256 value) public returns (bool) {
256     _approve(msg.sender, spender, value);
257     return true;
258   }
259 
260   /**
261    * @dev See `IERC20.transferFrom`.
262    *
263    * Emits an `Approval` event indicating the updated allowance. This is not
264    * required by the EIP. See the note at the beginning of `ERC20`;
265    *
266    * Requirements:
267    * - `sender` and `recipient` cannot be the zero address.
268    * - `sender` must have a balance of at least `value`.
269    * - the caller must have allowance for `sender`'s tokens of at least
270    * `amount`.
271    */
272   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
273     _transfer(sender, recipient, amount);
274     _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
275     return true;
276   }
277 
278   /**
279    * @dev Atomically increases the allowance granted to `spender` by the caller.
280    *
281    * This is an alternative to `approve` that can be used as a mitigation for
282    * problems described in `IERC20.approve`.
283    *
284    * Emits an `Approval` event indicating the updated allowance.
285    *
286    * Requirements:
287    *
288    * - `spender` cannot be the zero address.
289    */
290   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
291     _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
292     return true;
293   }
294 
295   /**
296    * @dev Atomically decreases the allowance granted to `spender` by the caller.
297    *
298    * This is an alternative to `approve` that can be used as a mitigation for
299    * problems described in `IERC20.approve`.
300    *
301    * Emits an `Approval` event indicating the updated allowance.
302    *
303    * Requirements:
304    *
305    * - `spender` cannot be the zero address.
306    * - `spender` must have allowance for the caller of at least
307    * `subtractedValue`.
308    */
309   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
310     _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
311     return true;
312   }
313 
314   /**
315    * @dev Moves tokens `amount` from `sender` to `recipient`.
316    *
317    * This is internal function is equivalent to `transfer`, and can be used to
318    * e.g. implement automatic token fees, slashing mechanisms, etc.
319    *
320    * Emits a `Transfer` event.
321    *
322    * Requirements:
323    *
324    * - `sender` cannot be the zero address.
325    * - `recipient` cannot be the zero address.
326    * - `sender` must have a balance of at least `amount`.
327    */
328   function _transfer(address sender, address recipient, uint256 amount) internal {
329     require(sender != address(0), "ERC20: transfer from the zero address");
330     require(recipient != address(0), "ERC20: transfer to the zero address");
331 
332     _balances[sender] = _balances[sender].sub(amount);
333     _balances[recipient] = _balances[recipient].add(amount);
334     emit Transfer(sender, recipient, amount);
335   }
336 
337   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
338    * the total supply.
339    *
340    * Emits a `Transfer` event with `from` set to the zero address.
341    *
342    * Requirements
343    *
344    * - `to` cannot be the zero address.
345    */
346   function _mint(address account, uint256 amount) internal {
347     require(account != address(0), "ERC20: mint to the zero address");
348 
349     _totalSupply = _totalSupply.add(amount);
350     _balances[account] = _balances[account].add(amount);
351     emit Transfer(address(0), account, amount);
352   }
353 
354   /**
355   * @dev Destoys `amount` tokens from `account`, reducing the
356   * total supply.
357   *
358   * Emits a `Transfer` event with `to` set to the zero address.
359   *
360   * Requirements
361   *
362   * - `account` cannot be the zero address.
363   * - `account` must have at least `amount` tokens.
364   */
365   function _burn(address account, uint256 value) internal {
366     require(account != address(0), "ERC20: burn from the zero address");
367 
368     _totalSupply = _totalSupply.sub(value);
369     _balances[account] = _balances[account].sub(value);
370     emit Transfer(account, address(0), value);
371   }
372 
373   /**
374    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
375    *
376    * This is internal function is equivalent to `approve`, and can be used to
377    * e.g. set automatic allowances for certain subsystems, etc.
378    *
379    * Emits an `Approval` event.
380    *
381    * Requirements:
382    *
383    * - `owner` cannot be the zero address.
384    * - `spender` cannot be the zero address.
385    */
386   function _approve(address owner, address spender, uint256 value) internal {
387     require(owner != address(0), "ERC20: approve from the zero address");
388     require(spender != address(0), "ERC20: approve to the zero address");
389 
390     _allowances[owner][spender] = value;
391     emit Approval(owner, spender, value);
392   }
393 
394   /**
395    * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
396    * from the caller's allowance.
397    *
398    * See `_burn` and `_approve`.
399    */
400   function _burnFrom(address account, uint256 amount) internal {
401     _burn(account, amount);
402     _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
403   }
404 }
405 
406 /**
407  * @dev Optional functions from the ERC20 standard.
408  */
409 contract ERC20Detailed is IERC20 {
410   string private _name;
411   string private _symbol;
412   uint8 private _decimals;
413 
414   /**
415    * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
416    * these values are immutable: they can only be set once during
417    * construction.
418    */
419   constructor (string memory name, string memory symbol, uint8 decimals) public {
420     _name = name;
421     _symbol = symbol;
422     _decimals = decimals;
423   }
424 
425   /**
426    * @dev Returns the name of the token.
427    */
428   function name() public view returns (string memory) {
429     return _name;
430   }
431 
432   /**
433    * @dev Returns the symbol of the token, usually a shorter version of the
434    * name.
435    */
436   function symbol() public view returns (string memory) {
437     return _symbol;
438   }
439 
440   /**
441    * @dev Returns the number of decimals used to get its user representation.
442    * For example, if `decimals` equals `2`, a balance of `505` tokens should
443    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
444    *
445    * Tokens usually opt for a value of 18, imitating the relationship between
446    * Ether and Wei.
447    *
448    * > Note that this information is only used for _display_ purposes: it in
449    * no way affects any of the arithmetic of the contract, including
450    * `IERC20.balanceOf` and `IERC20.transfer`.
451    */
452   function decimals() public view returns (uint8) {
453     return _decimals;
454   }
455 }
456 
457 
458 /**
459  * @title Roles
460  * @dev Library for managing addresses assigned to a Role.
461  */
462 library Roles {
463   struct Role {
464     mapping (address => bool) bearer;
465   }
466 
467   /**
468    * @dev Give an account access to this role.
469    */
470   function add(Role storage role, address account) internal {
471     require(!has(role, account), "Roles: account already has role");
472     role.bearer[account] = true;
473   }
474 
475   /**
476    * @dev Remove an account's access to this role.
477    */
478   function remove(Role storage role, address account) internal {
479     require(has(role, account), "Roles: account does not have role");
480     role.bearer[account] = false;
481   }
482 
483   /**
484    * @dev Check if an account has this role.
485    * @return bool
486    */
487   function has(Role storage role, address account) internal view returns (bool) {
488     require(account != address(0), "Roles: account is the zero address");
489     return role.bearer[account];
490   }
491 }
492 
493 
494 contract PauserRole {
495   using Roles for Roles.Role;
496 
497   event PauserAdded(address indexed account);
498   event PauserRemoved(address indexed account);
499 
500   Roles.Role private _pausers;
501 
502   constructor () internal {
503     _addPauser(msg.sender);
504   }
505 
506   modifier onlyPauser() {
507     require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
508     _;
509   }
510 
511   function isPauser(address account) public view returns (bool) {
512     return _pausers.has(account);
513   }
514 
515   function addPauser(address account) public onlyPauser {
516     _addPauser(account);
517   }
518 
519   function renouncePauser() public {
520     _removePauser(msg.sender);
521   }
522 
523   function _addPauser(address account) internal {
524     _pausers.add(account);
525     emit PauserAdded(account);
526   }
527 
528   function _removePauser(address account) internal {
529     _pausers.remove(account);
530     emit PauserRemoved(account);
531   }
532 }
533 
534 
535 /**
536  * @dev Contract module which allows children to implement an emergency stop
537  * mechanism that can be triggered by an authorized account.
538  *
539  * This module is used through inheritance. It will make available the
540  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
541  * the functions of your contract. Note that they will not be pausable by
542  * simply including this module, only once the modifiers are put in place.
543  */
544 contract Pausable is PauserRole {
545   /**
546    * @dev Emitted when the pause is triggered by a pauser (`account`).
547    */
548   event Paused(address account);
549 
550   /**
551    * @dev Emitted when the pause is lifted by a pauser (`account`).
552    */
553   event Unpaused(address account);
554 
555   bool private _paused;
556 
557   /**
558    * @dev Initializes the contract in unpaused state. Assigns the Pauser role
559    * to the deployer.
560    */
561   constructor () internal {
562     _paused = false;
563   }
564 
565   /**
566    * @dev Returns true if the contract is paused, and false otherwise.
567    */
568   function paused() public view returns (bool) {
569     return _paused;
570   }
571 
572   /**
573    * @dev Modifier to make a function callable only when the contract is not paused.
574    */
575   modifier whenNotPaused() {
576     require(!_paused, "Pausable: paused");
577     _;
578   }
579 
580   /**
581    * @dev Modifier to make a function callable only when the contract is paused.
582    */
583   modifier whenPaused() {
584     require(_paused, "Pausable: not paused");
585     _;
586   }
587 
588   /**
589    * @dev Called by a pauser to pause, triggers stopped state.
590    */
591   function pause() public onlyPauser whenNotPaused {
592     _paused = true;
593     emit Paused(msg.sender);
594   }
595 
596   /**
597    * @dev Called by a pauser to unpause, returns to normal state.
598    */
599   function unpause() public onlyPauser whenPaused {
600     _paused = false;
601     emit Unpaused(msg.sender);
602   }
603 }
604 
605 /**
606  * @title Pausable token
607  * @dev ERC20 modified with pausable transfers.
608  */
609 contract ERC20Pausable is ERC20, Pausable {
610   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
611     return super.transfer(to, value);
612   }
613 
614   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
615     return super.transferFrom(from, to, value);
616   }
617 
618   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
619     return super.approve(spender, value);
620   }
621 
622   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
623     return super.increaseAllowance(spender, addedValue);
624   }
625 
626   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
627     return super.decreaseAllowance(spender, subtractedValue);
628   }
629 }
630 
631 
632 /**
633  * @dev Extension of `ERC20` that allows token holders to destroy both their own
634  * tokens and those that they have an allowance for, in a way that can be
635  * recognized off-chain (via event analysis).
636  */
637 contract ERC20Burnable is ERC20 {
638   /**
639    * @dev Destoys `amount` tokens from the caller.
640    *
641    * See `ERC20._burn`.
642    */
643   function burn(uint256 amount) public {
644     _burn(msg.sender, amount);
645   }
646 
647   /**
648    * @dev See `ERC20._burnFrom`.
649    */
650   function burnFrom(address account, uint256 amount) public {
651     _burnFrom(account, amount);
652   }
653 }
654 
655 contract NafenToken is ERC20Pausable, ERC20Detailed, ERC20Burnable {
656   uint private INITIAL_SUPPLY = 8123731e18;
657   constructor () public ERC20Detailed("NafenToken", "NFN", 18) {
658     _mint(msg.sender, INITIAL_SUPPLY);
659   }
660 }