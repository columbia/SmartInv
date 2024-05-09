1 pragma solidity ^0.5.0;
2 
3 library Roles {
4     struct Role {
5         mapping (address => bool) bearer;
6     }
7 
8     /**
9      * @dev Give an account access to this role.
10      */
11     function add(Role storage role, address account) internal {
12         require(!has(role, account), "Roles: account already has role");
13         role.bearer[account] = true;
14     }
15 
16     /**
17      * @dev Remove an account's access to this role.
18      */
19     function remove(Role storage role, address account) internal {
20         require(has(role, account), "Roles: account does not have role");
21         role.bearer[account] = false;
22     }
23 
24     /**
25      * @dev Check if an account has this role.
26      * @return bool
27      */
28     function has(Role storage role, address account) internal view returns (bool) {
29         require(account != address(0), "Roles: account is the zero address");
30         return role.bearer[account];
31     }
32 }
33 
34 contract MinterRole {
35     using Roles for Roles.Role;
36 
37     event MinterAdded(address indexed account);
38     event MinterRemoved(address indexed account);
39 
40     Roles.Role private _minters;
41 
42     constructor () internal {
43         _addMinter(msg.sender);
44     }
45 
46     modifier onlyMinter() {
47         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
48         _;
49     }
50 
51     function isMinter(address account) public view returns (bool) {
52         return _minters.has(account);
53     }
54 
55     function addMinter(address account) public onlyMinter {
56         _addMinter(account);
57     }
58 
59     function renounceMinter() public {
60         _removeMinter(msg.sender);
61     }
62 
63     function _addMinter(address account) internal {
64         _minters.add(account);
65         emit MinterAdded(account);
66     }
67 
68     function _removeMinter(address account) internal {
69         _minters.remove(account);
70         emit MinterRemoved(account);
71     }
72 }
73 
74 contract PauserRole {
75     using Roles for Roles.Role;
76 
77     event PauserAdded(address indexed account);
78     event PauserRemoved(address indexed account);
79 
80     Roles.Role private _pausers;
81 
82     constructor () internal {
83         _addPauser(msg.sender);
84     }
85 
86     modifier onlyPauser() {
87         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
88         _;
89     }
90 
91     function isPauser(address account) public view returns (bool) {
92         return _pausers.has(account);
93     }
94 
95     function addPauser(address account) public onlyPauser {
96         _addPauser(account);
97     }
98 
99     function renouncePauser() public {
100         _removePauser(msg.sender);
101     }
102 
103     function _addPauser(address account) internal {
104         _pausers.add(account);
105         emit PauserAdded(account);
106     }
107 
108     function _removePauser(address account) internal {
109         _pausers.remove(account);
110         emit PauserRemoved(account);
111     }
112 }
113 
114 
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `recipient`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a `Transfer` event.
132      */
133     function transfer(address recipient, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through `transferFrom`. This is
138      * zero by default.
139      *
140      * This value changes when `approve` or `transferFrom` are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * > Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an `Approval` event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `sender` to `recipient` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a `Transfer` event.
168      */
169     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to `approve`. `value` is the new allowance.
182      */
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 library SafeMath {
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b <= a, "SafeMath: subtraction overflow");
214         uint256 c = a - b;
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      * - Multiplication cannot overflow.
227      */
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
230         // benefit is lost if 'b' is also tested.
231         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
232         if (a == 0) {
233             return 0;
234         }
235 
236         uint256 c = a * b;
237         require(c / a == b, "SafeMath: multiplication overflow");
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers. Reverts on
244      * division by zero. The result is rounded towards zero.
245      *
246      * Counterpart to Solidity's `/` operator. Note: this function uses a
247      * `revert` opcode (which leaves remaining gas untouched) while Solidity
248      * uses an invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      */
253     function div(uint256 a, uint256 b) internal pure returns (uint256) {
254         // Solidity only automatically asserts when dividing by 0
255         require(b > 0, "SafeMath: division by zero");
256         uint256 c = a / b;
257         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         require(b != 0, "SafeMath: modulo by zero");
275         return a % b;
276     }
277 }
278 
279 /**
280  * @dev Implementation of the `IERC20` interface.
281  *
282  * This implementation is agnostic to the way tokens are created. This means
283  * that a supply mechanism has to be added in a derived contract using `_mint`.
284  * For a generic mechanism see `ERC20Mintable`.
285  *
286  * *For a detailed writeup see our guide [How to implement supply
287  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
288  *
289  * We have followed general OpenZeppelin guidelines: functions revert instead
290  * of returning `false` on failure. This behavior is nonetheless conventional
291  * and does not conflict with the expectations of ERC20 applications.
292  *
293  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
294  * This allows applications to reconstruct the allowance for all accounts just
295  * by listening to said events. Other implementations of the EIP may not emit
296  * these events, as it isn't required by the specification.
297  *
298  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
299  * functions have been added to mitigate the well-known issues around setting
300  * allowances. See `IERC20.approve`.
301  */
302 contract ERC20 is IERC20 {
303     using SafeMath for uint256;
304 
305     mapping (address => uint256) private _balances;
306 
307     mapping (address => mapping (address => uint256)) private _allowances;
308 
309     uint256 private _totalSupply;
310 
311     /**
312      * @dev See `IERC20.totalSupply`.
313      */
314     function totalSupply() public view returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See `IERC20.balanceOf`.
320      */
321     function balanceOf(address account) public view returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See `IERC20.transfer`.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public returns (bool) {
334         _transfer(msg.sender, recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See `IERC20.allowance`.
340      */
341     function allowance(address owner, address spender) public view returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See `IERC20.approve`.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 value) public returns (bool) {
353         _approve(msg.sender, spender, value);
354         return true;
355     }
356 
357     /**
358      * @dev See `IERC20.transferFrom`.
359      *
360      * Emits an `Approval` event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of `ERC20`;
362      *
363      * Requirements:
364      * - `sender` and `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `value`.
366      * - the caller must have allowance for `sender`'s tokens of at least
367      * `amount`.
368      */
369     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
370         _transfer(sender, recipient, amount);
371         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to `approve` that can be used as a mitigation for
379      * problems described in `IERC20.approve`.
380      *
381      * Emits an `Approval` event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
388         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to `approve` that can be used as a mitigation for
396      * problems described in `IERC20.approve`.
397      *
398      * Emits an `Approval` event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
407         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
408         return true;
409     }
410 
411     /**
412      * @dev Moves tokens `amount` from `sender` to `recipient`.
413      *
414      * This is internal function is equivalent to `transfer`, and can be used to
415      * e.g. implement automatic token fees, slashing mechanisms, etc.
416      *
417      * Emits a `Transfer` event.
418      *
419      * Requirements:
420      *
421      * - `sender` cannot be the zero address.
422      * - `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      */
425     function _transfer(address sender, address recipient, uint256 amount) internal {
426         require(sender != address(0), "ERC20: transfer from the zero address");
427         require(recipient != address(0), "ERC20: transfer to the zero address");
428 
429         _balances[sender] = _balances[sender].sub(amount);
430         _balances[recipient] = _balances[recipient].add(amount);
431         emit Transfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a `Transfer` event with `from` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `to` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _totalSupply = _totalSupply.add(amount);
447         _balances[account] = _balances[account].add(amount);
448         emit Transfer(address(0), account, amount);
449     }
450 
451      /**
452      * @dev Destoys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a `Transfer` event with `to` set to the zero address.
456      *
457      * Requirements
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 value) internal {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _totalSupply = _totalSupply.sub(value);
466         _balances[account] = _balances[account].sub(value);
467         emit Transfer(account, address(0), value);
468     }
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
472      *
473      * This is internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an `Approval` event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(address owner, address spender, uint256 value) internal {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = value;
488         emit Approval(owner, spender, value);
489     }
490 
491     /**
492      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
493      * from the caller's allowance.
494      *
495      * See `_burn` and `_approve`.
496      */
497     function _burnFrom(address account, uint256 amount) internal {
498         _burn(account, amount);
499         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
500     }
501 }
502 
503 
504 
505 /**
506  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
507  * which have permission to mint (create) new tokens as they see fit.
508  *
509  * At construction, the deployer of the contract is the only minter.
510  */
511 contract ERC20Mintable is ERC20, MinterRole {
512     /**
513      * @dev See `ERC20._mint`.
514      *
515      * Requirements:
516      *
517      * - the caller must have the `MinterRole`.
518      */
519     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
520         _mint(account, amount);
521         return true;
522     }
523 }
524 
525 
526 contract ERC20Capped is ERC20Mintable {
527     uint256 private _cap;
528 
529     /**
530      * @dev Sets the value of the `cap`. This value is immutable, it can only be
531      * set once during construction.
532      */
533     constructor (uint256 cap) public {
534         require(cap > 0, "ERC20Capped: cap is 0");
535         _cap = cap;
536     }
537 
538     /**
539      * @dev Returns the cap on the token's total supply.
540      */
541     function cap() public view returns (uint256) {
542         return _cap;
543     }
544 
545     /**
546      * @dev See `ERC20Mintable.mint`.
547      *
548      * Requirements:
549      *
550      * - `value` must not cause the total supply to go over the cap.
551      */
552     function _mint(address account, uint256 value) internal {
553         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
554         super._mint(account, value);
555     }
556 }
557 
558 contract ERC20Detailed is IERC20 {
559     string private _name;
560     string private _symbol;
561     uint8 private _decimals;
562 
563     /**
564      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
565      * these values are immutable: they can only be set once during
566      * construction.
567      */
568     constructor (string memory name, string memory symbol, uint8 decimals) public {
569         _name = name;
570         _symbol = symbol;
571         _decimals = decimals;
572     }
573 
574     /**
575      * @dev Returns the name of the token.
576      */
577     function name() public view returns (string memory) {
578         return _name;
579     }
580 
581     /**
582      * @dev Returns the symbol of the token, usually a shorter version of the
583      * name.
584      */
585     function symbol() public view returns (string memory) {
586         return _symbol;
587     }
588 
589     /**
590      * @dev Returns the number of decimals used to get its user representation.
591      * For example, if `decimals` equals `2`, a balance of `505` tokens should
592      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
593      *
594      * Tokens usually opt for a value of 18, imitating the relationship between
595      * Ether and Wei.
596      *
597      * > Note that this information is only used for _display_ purposes: it in
598      * no way affects any of the arithmetic of the contract, including
599      * `IERC20.balanceOf` and `IERC20.transfer`.
600      */
601     function decimals() public view returns (uint8) {
602         return _decimals;
603     }
604 }
605 
606 contract Pausable is PauserRole {
607     /**
608      * @dev Emitted when the pause is triggered by a pauser (`account`).
609      */
610     event Paused(address account);
611 
612     /**
613      * @dev Emitted when the pause is lifted by a pauser (`account`).
614      */
615     event Unpaused(address account);
616 
617     bool private _paused;
618 
619     /**
620      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
621      * to the deployer.
622      */
623     constructor () internal {
624         _paused = false;
625     }
626 
627     /**
628      * @dev Returns true if the contract is paused, and false otherwise.
629      */
630     function paused() public view returns (bool) {
631         return _paused;
632     }
633 
634     /**
635      * @dev Modifier to make a function callable only when the contract is not paused.
636      */
637     modifier whenNotPaused() {
638         require(!_paused, "Pausable: paused");
639         _;
640     }
641 
642     /**
643      * @dev Modifier to make a function callable only when the contract is paused.
644      */
645     modifier whenPaused() {
646         require(_paused, "Pausable: not paused");
647         _;
648     }
649 
650     /**
651      * @dev Called by a pauser to pause, triggers stopped state.
652      */
653     function pause() public onlyPauser whenNotPaused {
654         _paused = true;
655         emit Paused(msg.sender);
656     }
657 
658     /**
659      * @dev Called by a pauser to unpause, returns to normal state.
660      */
661     function unpause() public onlyPauser whenPaused {
662         _paused = false;
663         emit Unpaused(msg.sender);
664     }
665 }
666 
667 contract ERC20Pausable is ERC20, Pausable {
668     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
669         return super.transfer(to, value);
670     }
671 
672     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
673         return super.transferFrom(from, to, value);
674     }
675 
676     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
677         return super.approve(spender, value);
678     }
679 
680     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
681         return super.increaseAllowance(spender, addedValue);
682     }
683 
684     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
685         return super.decreaseAllowance(spender, subtractedValue);
686     }
687 }
688 
689 contract SesameChainToken is ERC20, ERC20Detailed, ERC20Capped, ERC20Pausable {
690 
691     constructor(
692     )
693         ERC20Detailed('Sesamechain', 'LSC', 18)
694         ERC20Capped(1*(10**9)*(10**18))
695         ERC20()
696         ERC20Pausable()
697         public
698         payable
699     {}
700 
701 }