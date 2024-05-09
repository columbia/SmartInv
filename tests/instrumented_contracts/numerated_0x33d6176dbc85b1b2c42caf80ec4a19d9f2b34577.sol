1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 
184 /**
185  * @dev Implementation of the `IERC20` interface.
186  *
187  * This implementation is agnostic to the way tokens are created. This means
188  * that a supply mechanism has to be added in a derived contract using `_mint`.
189  * For a generic mechanism see `ERC20Mintable`.
190  *
191  * *For a detailed writeup see our guide [How to implement supply
192  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
193  *
194  * We have followed general OpenZeppelin guidelines: functions revert instead
195  * of returning `false` on failure. This behavior is nonetheless conventional
196  * and does not conflict with the expectations of ERC20 applications.
197  *
198  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
199  * This allows applications to reconstruct the allowance for all accounts just
200  * by listening to said events. Other implementations of the EIP may not emit
201  * these events, as it isn't required by the specification.
202  *
203  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
204  * functions have been added to mitigate the well-known issues around setting
205  * allowances. See `IERC20.approve`.
206  */
207 contract ERC20 is IERC20 {
208     using SafeMath for uint256;
209 
210     mapping (address => uint256) private _balances;
211 
212     mapping (address => mapping (address => uint256)) private _allowances;
213 
214     uint256 private _totalSupply;
215 
216     /**
217      * @dev See `IERC20.totalSupply`.
218      */
219     function totalSupply() public view returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See `IERC20.balanceOf`.
225      */
226     function balanceOf(address account) public view returns (uint256) {
227         return _balances[account];
228     }
229 
230     /**
231      * @dev See `IERC20.transfer`.
232      *
233      * Requirements:
234      *
235      * - `recipient` cannot be the zero address.
236      * - the caller must have a balance of at least `amount`.
237      */
238     function transfer(address recipient, uint256 amount) public returns (bool) {
239         _transfer(msg.sender, recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See `IERC20.allowance`.
245      */
246     function allowance(address owner, address spender) public view returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See `IERC20.approve`.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 value) public returns (bool) {
258         _approve(msg.sender, spender, value);
259         return true;
260     }
261 
262     /**
263      * @dev See `IERC20.transferFrom`.
264      *
265      * Emits an `Approval` event indicating the updated allowance. This is not
266      * required by the EIP. See the note at the beginning of `ERC20`;
267      *
268      * Requirements:
269      * - `sender` and `recipient` cannot be the zero address.
270      * - `sender` must have a balance of at least `value`.
271      * - the caller must have allowance for `sender`'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to `approve` that can be used as a mitigation for
284      * problems described in `IERC20.approve`.
285      *
286      * Emits an `Approval` event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
293         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to `approve` that can be used as a mitigation for
301      * problems described in `IERC20.approve`.
302      *
303      * Emits an `Approval` event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
312         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
313         return true;
314     }
315 
316     /**
317      * @dev Moves tokens `amount` from `sender` to `recipient`.
318      *
319      * This is internal function is equivalent to `transfer`, and can be used to
320      * e.g. implement automatic token fees, slashing mechanisms, etc.
321      *
322      * Emits a `Transfer` event.
323      *
324      * Requirements:
325      *
326      * - `sender` cannot be the zero address.
327      * - `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      */
330     function _transfer(address sender, address recipient, uint256 amount) internal {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333 
334         _balances[sender] = _balances[sender].sub(amount);
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337     }
338 
339     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
340      * the total supply.
341      *
342      * Emits a `Transfer` event with `from` set to the zero address.
343      *
344      * Requirements
345      *
346      * - `to` cannot be the zero address.
347      */
348     function _mint(address account, uint256 amount) internal {
349         require(account != address(0), "ERC20: mint to the zero address");
350 
351         _totalSupply = _totalSupply.add(amount);
352         _balances[account] = _balances[account].add(amount);
353         emit Transfer(address(0), account, amount);
354     }
355 
356      /**
357      * @dev Destoys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a `Transfer` event with `to` set to the zero address.
361      *
362      * Requirements
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 value) internal {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _totalSupply = _totalSupply.sub(value);
371         _balances[account] = _balances[account].sub(value);
372         emit Transfer(account, address(0), value);
373     }
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
377      *
378      * This is internal function is equivalent to `approve`, and can be used to
379      * e.g. set automatic allowances for certain subsystems, etc.
380      *
381      * Emits an `Approval` event.
382      *
383      * Requirements:
384      *
385      * - `owner` cannot be the zero address.
386      * - `spender` cannot be the zero address.
387      */
388     function _approve(address owner, address spender, uint256 value) internal {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = value;
393         emit Approval(owner, spender, value);
394     }
395 
396     /**
397      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
398      * from the caller's allowance.
399      *
400      * See `_burn` and `_approve`.
401      */
402     function _burnFrom(address account, uint256 amount) internal {
403         _burn(account, amount);
404         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
405     }
406 }
407 
408 
409 /**
410  * @dev Optional functions from the ERC20 standard.
411  */
412 contract ERC20Detailed is IERC20 {
413     string private _name;
414     string private _symbol;
415     uint8 private _decimals;
416 
417     /**
418      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
419      * these values are immutable: they can only be set once during
420      * construction.
421      */
422     constructor (string memory name, string memory symbol, uint8 decimals) public {
423         _name = name;
424         _symbol = symbol;
425         _decimals = decimals;
426     }
427 
428     /**
429      * @dev Returns the name of the token.
430      */
431     function name() public view returns (string memory) {
432         return _name;
433     }
434 
435     /**
436      * @dev Returns the symbol of the token, usually a shorter version of the
437      * name.
438      */
439     function symbol() public view returns (string memory) {
440         return _symbol;
441     }
442 
443     /**
444      * @dev Returns the number of decimals used to get its user representation.
445      * For example, if `decimals` equals `2`, a balance of `505` tokens should
446      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
447      *
448      * Tokens usually opt for a value of 18, imitating the relationship between
449      * Ether and Wei.
450      *
451      * > Note that this information is only used for _display_ purposes: it in
452      * no way affects any of the arithmetic of the contract, including
453      * `IERC20.balanceOf` and `IERC20.transfer`.
454      */
455     function decimals() public view returns (uint8) {
456         return _decimals;
457     }
458 }
459 
460 /**
461  * @title Roles
462  * @dev Library for managing addresses assigned to a Role.
463  */
464 library Roles {
465     struct Role {
466         mapping (address => bool) bearer;
467     }
468 
469     /**
470      * @dev Give an account access to this role.
471      */
472     function add(Role storage role, address account) internal {
473         require(!has(role, account), "Roles: account already has role");
474         role.bearer[account] = true;
475     }
476 
477     /**
478      * @dev Remove an account's access to this role.
479      */
480     function remove(Role storage role, address account) internal {
481         require(has(role, account), "Roles: account does not have role");
482         role.bearer[account] = false;
483     }
484 
485     /**
486      * @dev Check if an account has this role.
487      * @return bool
488      */
489     function has(Role storage role, address account) internal view returns (bool) {
490         require(account != address(0), "Roles: account is the zero address");
491         return role.bearer[account];
492     }
493 }
494 
495 contract MinterRole {
496     using Roles for Roles.Role;
497 
498     event MinterAdded(address indexed account);
499     event MinterRemoved(address indexed account);
500 
501     Roles.Role private _minters;
502 
503     constructor () internal {
504         _addMinter(msg.sender);
505     }
506 
507     modifier onlyMinter() {
508         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
509         _;
510     }
511 
512     function isMinter(address account) public view returns (bool) {
513         return _minters.has(account);
514     }
515 
516     function addMinter(address account) public onlyMinter {
517         _addMinter(account);
518     }
519 
520     function renounceMinter() public {
521         _removeMinter(msg.sender);
522     }
523 
524     function _addMinter(address account) internal {
525         _minters.add(account);
526         emit MinterAdded(account);
527     }
528 
529     function _removeMinter(address account) internal {
530         _minters.remove(account);
531         emit MinterRemoved(account);
532     }
533 }
534 
535 /**
536  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
537  * which have permission to mint (create) new tokens as they see fit.
538  *
539  * At construction, the deployer of the contract is the only minter.
540  */
541 contract ERC20Mintable is ERC20, MinterRole {
542     /**
543      * @dev See `ERC20._mint`.
544      *
545      * Requirements:
546      *
547      * - the caller must have the `MinterRole`.
548      */
549     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
550         _mint(account, amount);
551         return true;
552     }
553 }
554 
555 /**
556  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
557  */
558 contract ERC20Capped is ERC20Mintable {
559     uint256 private _cap;
560 
561     /**
562      * @dev Sets the value of the `cap`. This value is immutable, it can only be
563      * set once during construction.
564      */
565     constructor (uint256 cap) public {
566         require(cap > 0, "ERC20Capped: cap is 0");
567         _cap = cap;
568     }
569 
570     /**
571      * @dev Returns the cap on the token's total supply.
572      */
573     function cap() public view returns (uint256) {
574         return _cap;
575     }
576 
577     /**
578      * @dev See `ERC20Mintable.mint`.
579      *
580      * Requirements:
581      *
582      * - `value` must not cause the total supply to go over the cap.
583      */
584     function _mint(address account, uint256 value) internal {
585         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
586         super._mint(account, value);
587     }
588 }
589 
590 /**
591  * @title The DARK Token
592  */
593 contract DARK is ERC20Capped(100000000 * (10 ** uint256(18))), ERC20Detailed(
594         "DarkQuery",  // token name
595         "DARK",       // token symbol
596         18            // token decimals
597     ) {
598 
599     /**
600      * @dev Constructor that gives 0x89552A9AF1723bd8F67249d960387B014838D60C all of existing tokens.
601      */
602     constructor () public {
603         _mint(0x89552A9AF1723bd8F67249d960387B014838D60C, 100000000 * (10 ** uint256(decimals())));
604     }
605 }
606 
607 /**
608 0x89552A9AF1723bd8F67249d960387B014838D60C
609 0x89552A9AF1723bd8F67249d960387B014838D60C
610 
611 CHECKSUM OK!
612  */