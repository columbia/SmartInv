1 pragma solidity ^0.5.8;
2 
3 
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
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a, "SafeMath: subtraction overflow");
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0, "SafeMath: division by zero");
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b != 0, "SafeMath: modulo by zero");
182         return a % b;
183     }
184 }
185 
186 /**
187  * @dev Implementation of the `IERC20` interface.
188  *
189  * This implementation is agnostic to the way tokens are created. This means
190  * that a supply mechanism has to be added in a derived contract using `_mint`.
191  * For a generic mechanism see `ERC20Mintable`.
192  *
193  * *For a detailed writeup see our guide [How to implement supply
194  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
195  *
196  * We have followed general OpenZeppelin guidelines: functions revert instead
197  * of returning `false` on failure. This behavior is nonetheless conventional
198  * and does not conflict with the expectations of ERC20 applications.
199  *
200  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
201  * This allows applications to reconstruct the allowance for all accounts just
202  * by listening to said events. Other implementations of the EIP may not emit
203  * these events, as it isn't required by the specification.
204  *
205  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
206  * functions have been added to mitigate the well-known issues around setting
207  * allowances. See `IERC20.approve`.
208  */
209 contract ERC20 is IERC20 {
210     using SafeMath for uint256;
211 
212     mapping (address => uint256) private _balances;
213 
214     mapping (address => mapping (address => uint256)) private _allowances;
215 
216     uint256 private _totalSupply;
217 
218     /**
219      * @dev See `IERC20.totalSupply`.
220      */
221     function totalSupply() public view returns (uint256) {
222         return _totalSupply;
223     }
224 
225     /**
226      * @dev See `IERC20.balanceOf`.
227      */
228     function balanceOf(address account) public view returns (uint256) {
229         return _balances[account];
230     }
231 
232     /**
233      * @dev See `IERC20.transfer`.
234      *
235      * Requirements:
236      *
237      * - `recipient` cannot be the zero address.
238      * - the caller must have a balance of at least `amount`.
239      */
240     function transfer(address recipient, uint256 amount) public returns (bool) {
241         _transfer(msg.sender, recipient, amount);
242         return true;
243     }
244 
245     /**
246      * @dev See `IERC20.allowance`.
247      */
248     function allowance(address owner, address spender) public view returns (uint256) {
249         return _allowances[owner][spender];
250     }
251 
252     /**
253      * @dev See `IERC20.approve`.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function approve(address spender, uint256 value) public returns (bool) {
260         _approve(msg.sender, spender, value);
261         return true;
262     }
263 
264     /**
265      * @dev See `IERC20.transferFrom`.
266      *
267      * Emits an `Approval` event indicating the updated allowance. This is not
268      * required by the EIP. See the note at the beginning of `ERC20`;
269      *
270      * Requirements:
271      * - `sender` and `recipient` cannot be the zero address.
272      * - `sender` must have a balance of at least `value`.
273      * - the caller must have allowance for `sender`'s tokens of at least
274      * `amount`.
275      */
276     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
279         return true;
280     }
281 
282     /**
283      * @dev Atomically increases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to `approve` that can be used as a mitigation for
286      * problems described in `IERC20.approve`.
287      *
288      * Emits an `Approval` event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
295         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
296         return true;
297     }
298 
299     /**
300      * @dev Atomically decreases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to `approve` that can be used as a mitigation for
303      * problems described in `IERC20.approve`.
304      *
305      * Emits an `Approval` event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      * - `spender` must have allowance for the caller of at least
311      * `subtractedValue`.
312      */
313     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
314         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
315         return true;
316     }
317 
318     /**
319      * @dev Moves tokens `amount` from `sender` to `recipient`.
320      *
321      * This is internal function is equivalent to `transfer`, and can be used to
322      * e.g. implement automatic token fees, slashing mechanisms, etc.
323      *
324      * Emits a `Transfer` event.
325      *
326      * Requirements:
327      *
328      * - `sender` cannot be the zero address.
329      * - `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      */
332     function _transfer(address sender, address recipient, uint256 amount) internal {
333         require(sender != address(0), "ERC20: transfer from the zero address");
334         require(recipient != address(0), "ERC20: transfer to the zero address");
335 
336         _balances[sender] = _balances[sender].sub(amount);
337         _balances[recipient] = _balances[recipient].add(amount);
338         emit Transfer(sender, recipient, amount);
339     }
340 
341     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
342      * the total supply.
343      *
344      * Emits a `Transfer` event with `from` set to the zero address.
345      *
346      * Requirements
347      *
348      * - `to` cannot be the zero address.
349      */
350     function _mint(address account, uint256 amount) internal {
351         require(account != address(0), "ERC20: mint to the zero address");
352 
353         _totalSupply = _totalSupply.add(amount);
354         _balances[account] = _balances[account].add(amount);
355         emit Transfer(address(0), account, amount);
356     }
357 
358      /**
359      * @dev Destoys `amount` tokens from `account`, reducing the
360      * total supply.
361      *
362      * Emits a `Transfer` event with `to` set to the zero address.
363      *
364      * Requirements
365      *
366      * - `account` cannot be the zero address.
367      * - `account` must have at least `amount` tokens.
368      */
369     function _burn(address account, uint256 value) internal {
370         require(account != address(0), "ERC20: burn from the zero address");
371 
372         _totalSupply = _totalSupply.sub(value);
373         _balances[account] = _balances[account].sub(value);
374         emit Transfer(account, address(0), value);
375     }
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
379      *
380      * This is internal function is equivalent to `approve`, and can be used to
381      * e.g. set automatic allowances for certain subsystems, etc.
382      *
383      * Emits an `Approval` event.
384      *
385      * Requirements:
386      *
387      * - `owner` cannot be the zero address.
388      * - `spender` cannot be the zero address.
389      */
390     function _approve(address owner, address spender, uint256 value) internal {
391         require(owner != address(0), "ERC20: approve from the zero address");
392         require(spender != address(0), "ERC20: approve to the zero address");
393 
394         _allowances[owner][spender] = value;
395         emit Approval(owner, spender, value);
396     }
397 
398     /**
399      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
400      * from the caller's allowance.
401      *
402      * See `_burn` and `_approve`.
403      */
404     function _burnFrom(address account, uint256 amount) internal {
405         _burn(account, amount);
406         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
407     }
408 }
409 
410 
411 /**
412  * @dev Optional functions from the ERC20 standard.
413  */
414 contract ERC20Detailed is IERC20 {
415     string private _name;
416     string private _symbol;
417     uint8 private _decimals;
418 
419     /**
420      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
421      * these values are immutable: they can only be set once during
422      * construction.
423      */
424     constructor (string memory name, string memory symbol, uint8 decimals) public {
425         _name = name;
426         _symbol = symbol;
427         _decimals = decimals;
428     }
429 
430     /**
431      * @dev Returns the name of the token.
432      */
433     function name() public view returns (string memory) {
434         return _name;
435     }
436 
437     /**
438      * @dev Returns the symbol of the token, usually a shorter version of the
439      * name.
440      */
441     function symbol() public view returns (string memory) {
442         return _symbol;
443     }
444 
445     /**
446      * @dev Returns the number of decimals used to get its user representation.
447      * For example, if `decimals` equals `2`, a balance of `505` tokens should
448      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
449      *
450      * Tokens usually opt for a value of 18, imitating the relationship between
451      * Ether and Wei.
452      *
453      * > Note that this information is only used for _display_ purposes: it in
454      * no way affects any of the arithmetic of the contract, including
455      * `IERC20.balanceOf` and `IERC20.transfer`.
456      */
457     function decimals() public view returns (uint8) {
458         return _decimals;
459     }
460 }
461 
462 
463 
464 /**
465  * @title Roles
466  * @dev Library for managing addresses assigned to a Role.
467  */
468 library Roles {
469     struct Role {
470         mapping (address => bool) bearer;
471     }
472 
473     /**
474      * @dev Give an account access to this role.
475      */
476     function add(Role storage role, address account) internal {
477         require(!has(role, account), "Roles: account already has role");
478         role.bearer[account] = true;
479     }
480 
481     /**
482      * @dev Remove an account's access to this role.
483      */
484     function remove(Role storage role, address account) internal {
485         require(has(role, account), "Roles: account does not have role");
486         role.bearer[account] = false;
487     }
488 
489     /**
490      * @dev Check if an account has this role.
491      * @return bool
492      */
493     function has(Role storage role, address account) internal view returns (bool) {
494         require(account != address(0), "Roles: account is the zero address");
495         return role.bearer[account];
496     }
497 }
498 
499 contract MinterRole {
500     using Roles for Roles.Role;
501 
502     event MinterAdded(address indexed account);
503     event MinterRemoved(address indexed account);
504 
505     Roles.Role private _minters;
506 
507     constructor () internal {
508         _addMinter(msg.sender);
509     }
510 
511     modifier onlyMinter() {
512         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
513         _;
514     }
515 
516     function isMinter(address account) public view returns (bool) {
517         return _minters.has(account);
518     }
519 
520     function addMinter(address account) public onlyMinter {
521         _addMinter(account);
522     }
523 
524     function renounceMinter() public {
525         _removeMinter(msg.sender);
526     }
527 
528     function _addMinter(address account) internal {
529         _minters.add(account);
530         emit MinterAdded(account);
531     }
532 
533     function _removeMinter(address account) internal {
534         _minters.remove(account);
535         emit MinterRemoved(account);
536     }
537 }
538 
539 /**
540  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
541  * which have permission to mint (create) new tokens as they see fit.
542  *
543  * At construction, the deployer of the contract is the only minter.
544  */
545 contract ERC20Mintable is ERC20, MinterRole {
546     /**
547      * @dev See `ERC20._mint`.
548      *
549      * Requirements:
550      *
551      * - the caller must have the `MinterRole`.
552      */
553     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
554         _mint(account, amount);
555         return true;
556     }
557 }
558 
559 
560 /**
561  * @dev Extension of `ERC20` that allows token holders to destroy both their own
562  * tokens and those that they have an allowance for, in a way that can be
563  * recognized off-chain (via event analysis).
564  */
565 contract ERC20Burnable is ERC20 {
566     /**
567      * @dev Destoys `amount` tokens from the caller.
568      *
569      * See `ERC20._burn`.
570      */
571     function burn(uint256 amount) public {
572         _burn(msg.sender, amount);
573     }
574 
575     /**
576      * @dev See `ERC20._burnFrom`.
577      */
578     function burnFrom(address account, uint256 amount) public {
579         _burnFrom(account, amount);
580     }
581 }
582 
583 
584 contract Edex is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
585 
586     constructor(address _holder)
587     ERC20Burnable()
588     ERC20Mintable()
589     ERC20Detailed("Edex", "EDX", 18)
590     ERC20()
591     public {
592         _mint(_holder, 10000000 * 10 ** 18);
593         _addMinter(_holder);
594     }
595 
596 }