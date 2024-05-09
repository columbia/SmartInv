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
184 /**
185  * @title Roles
186  * @dev Library for managing addresses assigned to a Role.
187  */
188 library Roles {
189     struct Role {
190         mapping (address => bool) bearer;
191     }
192 
193     /**
194      * @dev Give an account access to this role.
195      */
196     function add(Role storage role, address account) internal {
197         require(!has(role, account), "Roles: account already has role");
198         role.bearer[account] = true;
199     }
200 
201     /**
202      * @dev Remove an account's access to this role.
203      */
204     function remove(Role storage role, address account) internal {
205         require(has(role, account), "Roles: account does not have role");
206         role.bearer[account] = false;
207     }
208 
209     /**
210      * @dev Check if an account has this role.
211      * @return bool
212      */
213     function has(Role storage role, address account) internal view returns (bool) {
214         require(account != address(0), "Roles: account is the zero address");
215         return role.bearer[account];
216     }
217 }
218 
219 contract PauserRole {
220     using Roles for Roles.Role;
221 
222     event PauserAdded(address indexed account);
223     event PauserRemoved(address indexed account);
224 
225     Roles.Role private _pausers;
226 
227     constructor () internal {
228         _addPauser(msg.sender);
229     }
230 
231     modifier onlyPauser() {
232         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
233         _;
234     }
235 
236     function isPauser(address account) public view returns (bool) {
237         return _pausers.has(account);
238     }
239 
240     function addPauser(address account) public onlyPauser {
241         _addPauser(account);
242     }
243 
244     function renouncePauser() public {
245         _removePauser(msg.sender);
246     }
247 
248     function _addPauser(address account) internal {
249         _pausers.add(account);
250         emit PauserAdded(account);
251     }
252 
253     function _removePauser(address account) internal {
254         _pausers.remove(account);
255         emit PauserRemoved(account);
256     }
257 }
258 
259 
260 /**
261  * @dev Contract module which allows children to implement an emergency stop
262  * mechanism that can be triggered by an authorized account.
263  *
264  * This module is used through inheritance. It will make available the
265  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
266  * the functions of your contract. Note that they will not be pausable by
267  * simply including this module, only once the modifiers are put in place.
268  */
269 contract Pausable is PauserRole {
270     /**
271      * @dev Emitted when the pause is triggered by a pauser (`account`).
272      */
273     event Paused(address account);
274 
275     /**
276      * @dev Emitted when the pause is lifted by a pauser (`account`).
277      */
278     event Unpaused(address account);
279 
280     bool private _paused;
281 
282     /**
283      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
284      * to the deployer.
285      */
286     constructor () internal {
287         _paused = false;
288     }
289 
290     /**
291      * @dev Returns true if the contract is paused, and false otherwise.
292      */
293     function paused() public view returns (bool) {
294         return _paused;
295     }
296 
297     /**
298      * @dev Modifier to make a function callable only when the contract is not paused.
299      */
300     modifier whenNotPaused() {
301         require(!_paused, "Pausable: paused");
302         _;
303     }
304 
305     /**
306      * @dev Modifier to make a function callable only when the contract is paused.
307      */
308     modifier whenPaused() {
309         require(_paused, "Pausable: not paused");
310         _;
311     }
312 
313     /**
314      * @dev Called by a pauser to pause, triggers stopped state.
315      */
316     function pause() public onlyPauser whenNotPaused {
317         _paused = true;
318         emit Paused(msg.sender);
319     }
320 
321     /**
322      * @dev Called by a pauser to unpause, returns to normal state.
323      */
324     function unpause() public onlyPauser whenPaused {
325         _paused = false;
326         emit Unpaused(msg.sender);
327     }
328 }
329 
330 /**
331  * @dev Implementation of the `IERC20` interface.
332  *
333  * This implementation is agnostic to the way tokens are created. This means
334  * that a supply mechanism has to be added in a derived contract using `_mint`.
335  * For a generic mechanism see `ERC20Mintable`.
336  *
337  * *For a detailed writeup see our guide [How to implement supply
338  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
339  *
340  * We have followed general OpenZeppelin guidelines: functions revert instead
341  * of returning `false` on failure. This behavior is nonetheless conventional
342  * and does not conflict with the expectations of ERC20 applications.
343  *
344  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
345  * This allows applications to reconstruct the allowance for all accounts just
346  * by listening to said events. Other implementations of the EIP may not emit
347  * these events, as it isn't required by the specification.
348  *
349  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
350  * functions have been added to mitigate the well-known issues around setting
351  * allowances. See `IERC20.approve`.
352  */
353 contract ERC20 is IERC20 {
354     using SafeMath for uint256;
355 
356     mapping (address => uint256) private _balances;
357 
358     mapping (address => mapping (address => uint256)) private _allowances;
359 
360     uint256 private _totalSupply;
361 
362     /**
363      * @dev See `IERC20.totalSupply`.
364      */
365     function totalSupply() public view returns (uint256) {
366         return _totalSupply;
367     }
368 
369     /**
370      * @dev See `IERC20.balanceOf`.
371      */
372     function balanceOf(address account) public view returns (uint256) {
373         return _balances[account];
374     }
375 
376     /**
377      * @dev See `IERC20.transfer`.
378      *
379      * Requirements:
380      *
381      * - `recipient` cannot be the zero address.
382      * - the caller must have a balance of at least `amount`.
383      */
384     function transfer(address recipient, uint256 amount) public returns (bool) {
385         _transfer(msg.sender, recipient, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See `IERC20.allowance`.
391      */
392     function allowance(address owner, address spender) public view returns (uint256) {
393         return _allowances[owner][spender];
394     }
395 
396     /**
397      * @dev See `IERC20.approve`.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function approve(address spender, uint256 value) public returns (bool) {
404         _approve(msg.sender, spender, value);
405         return true;
406     }
407 
408     /**
409      * @dev See `IERC20.transferFrom`.
410      *
411      * Emits an `Approval` event indicating the updated allowance. This is not
412      * required by the EIP. See the note at the beginning of `ERC20`;
413      *
414      * Requirements:
415      * - `sender` and `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `value`.
417      * - the caller must have allowance for `sender`'s tokens of at least
418      * `amount`.
419      */
420     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
421         _transfer(sender, recipient, amount);
422         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
423         return true;
424     }
425 
426     /**
427      * @dev Atomically increases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to `approve` that can be used as a mitigation for
430      * problems described in `IERC20.approve`.
431      *
432      * Emits an `Approval` event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
439         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to `approve` that can be used as a mitigation for
447      * problems described in `IERC20.approve`.
448      *
449      * Emits an `Approval` event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
458         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
459         return true;
460     }
461 
462     /**
463      * @dev Moves tokens `amount` from `sender` to `recipient`.
464      *
465      * This is internal function is equivalent to `transfer`, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a `Transfer` event.
469      *
470      * Requirements:
471      *
472      * - `sender` cannot be the zero address.
473      * - `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      */
476     function _transfer(address sender, address recipient, uint256 amount) internal {
477         require(sender != address(0), "ERC20: transfer from the zero address");
478         require(recipient != address(0), "ERC20: transfer to the zero address");
479 
480         _balances[sender] = _balances[sender].sub(amount);
481         _balances[recipient] = _balances[recipient].add(amount);
482         emit Transfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a `Transfer` event with `from` set to the zero address.
489      *
490      * Requirements
491      *
492      * - `to` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _totalSupply = _totalSupply.add(amount);
498         _balances[account] = _balances[account].add(amount);
499         emit Transfer(address(0), account, amount);
500     }
501 
502      /**
503      * @dev Destoys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a `Transfer` event with `to` set to the zero address.
507      *
508      * Requirements
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 value) internal {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _totalSupply = _totalSupply.sub(value);
517         _balances[account] = _balances[account].sub(value);
518         emit Transfer(account, address(0), value);
519     }
520 
521     /**
522      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
523      *
524      * This is internal function is equivalent to `approve`, and can be used to
525      * e.g. set automatic allowances for certain subsystems, etc.
526      *
527      * Emits an `Approval` event.
528      *
529      * Requirements:
530      *
531      * - `owner` cannot be the zero address.
532      * - `spender` cannot be the zero address.
533      */
534     function _approve(address owner, address spender, uint256 value) internal {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = value;
539         emit Approval(owner, spender, value);
540     }
541 
542     /**
543      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
544      * from the caller's allowance.
545      *
546      * See `_burn` and `_approve`.
547      */
548     function _burnFrom(address account, uint256 amount) internal {
549         _burn(account, amount);
550         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
551     }
552 }
553 
554 contract Register {
555     mapping(address => participant) private _participants;
556 
557     struct participant {
558         string wehereAddr;
559     }
560 
561     event SetMainChainAddrEvent(string MainChainAddr);
562 
563     function setMainChainAddr(string memory mcaddr) public returns(bool){
564         _participants[msg.sender].wehereAddr = mcaddr;
565         emit SetMainChainAddrEvent(mcaddr);
566         return true;
567     }
568 
569     function getMainChainAddr(address queryaddr) public view returns(string memory) {
570         return _participants[queryaddr].wehereAddr;
571     }
572 }
573 
574 /**
575  * @title Pausable token
576  * @dev ERC20 with pausable transfers and allowances.
577  *
578  * Useful if you want to e.g. stop trades until the end of a crowdsale, or have
579  * an emergency switch for freezing all token transfers in the event of a large
580  * bug.
581  */
582 
583 contract ERC20Pausable is ERC20, Pausable, Register {
584 
585     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
586         return super.transfer(to, value);
587     }
588 
589     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
590         return super.transferFrom(from, to, value);
591     }
592 
593     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
594         return super.approve(spender, value);
595     }
596 
597     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
598         return super.increaseAllowance(spender, addedValue);
599     }
600 
601     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
602         return super.decreaseAllowance(spender, subtractedValue);
603     }
604 
605     function setMainChainAddr(string memory mcaddr) public whenNotPaused returns(bool){
606         return super.setMainChainAddr(mcaddr);
607     }
608 }
609 
610 /**
611  * @dev Optional functions from the ERC20 standard.
612  */
613 
614 contract ERC20Detailed is IERC20 {
615     string private _name;
616     string private _symbol;
617     uint8 private _decimals;
618 
619     /**
620      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
621      * these values are immutable: they can only be set once during
622      * construction.
623      */
624     constructor (string memory name, string memory symbol, uint8 decimals) public {
625         _name = name;
626         _symbol = symbol;
627         _decimals = decimals;
628     }
629 
630     /**
631      * @dev Returns the name of the token.
632      */
633     function name() public view returns (string memory) {
634         return _name;
635     }
636 
637     /**
638      * @dev Returns the symbol of the token, usually a shorter version of the
639      * name.
640      */
641     function symbol() public view returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev Returns the number of decimals used to get its user representation.
647      * For example, if `decimals` equals `2`, a balance of `505` tokens should
648      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
649      *
650      * Tokens usually opt for a value of 18, imitating the relationship between
651      * Ether and Wei.
652      *
653      * > Note that this information is only used for _display_ purposes: it in
654      * no way affects any of the arithmetic of the contract, including
655      * `IERC20.balanceOf` and `IERC20.transfer`.
656      */
657     function decimals() public view returns (uint8) {
658         return _decimals;
659     }
660 }
661 
662 /**
663  * @title GECToken
664  * @dev GEC Token contract, where all tokens are pre-assigned to the creator.
665  * Note they can later distribute these tokens as they wish using `transfer` and other
666  * `ERC20` functions.
667  */
668 contract DIDP is ERC20Pausable, ERC20Detailed{
669 
670     /**
671      * @dev Constructor that gives msg.sender all of existing tokens.
672      */
673     constructor () public ERC20Detailed("DIDP", "DIDP", 18) {
674         _mint(msg.sender, 1000000000 * (10 ** uint256(decimals())));
675     }
676 }