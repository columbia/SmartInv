1 pragma solidity ^0.5.8;
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
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a, "SafeMath: subtraction overflow");
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Solidity only automatically asserts when dividing by 0
161         require(b > 0, "SafeMath: division by zero");
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b != 0, "SafeMath: modulo by zero");
181         return a % b;
182     }
183 }
184 
185 
186 /**
187  * @title Roles
188  * @dev Library for managing addresses assigned to a Role.
189  */
190 library Roles {
191     struct Role {
192         mapping (address => bool) bearer;
193     }
194 
195     /**
196      * @dev Give an account access to this role.
197      */
198     function add(Role storage role, address account) internal {
199         require(!has(role, account), "Roles: account already has role");
200         role.bearer[account] = true;
201     }
202 
203     /**
204      * @dev Remove an account's access to this role.
205      */
206     function remove(Role storage role, address account) internal {
207         require(has(role, account), "Roles: account does not have role");
208         role.bearer[account] = false;
209     }
210 
211     /**
212      * @dev Check if an account has this role.
213      * @return bool
214      */
215     function has(Role storage role, address account) internal view returns (bool) {
216         require(account != address(0), "Roles: account is the zero address");
217         return role.bearer[account];
218     }
219 }
220 
221 
222 /**
223  * @dev Optional functions from the ERC20 standard.
224  */
225 contract ERC20Detailed is IERC20 {
226     string private _name;
227     string private _symbol;
228     uint8 private _decimals;
229 
230     /**
231      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
232      * these values are immutable: they can only be set once during
233      * construction.
234      */
235     constructor (string memory name, string memory symbol, uint8 decimals) public {
236         _name = name;
237         _symbol = symbol;
238         _decimals = decimals;
239     }
240 
241     /**
242      * @dev Returns the name of the token.
243      */
244     function name() public view returns (string memory) {
245         return _name;
246     }
247 
248     /**
249      * @dev Returns the symbol of the token, usually a shorter version of the
250      * name.
251      */
252     function symbol() public view returns (string memory) {
253         return _symbol;
254     }
255 
256     /**
257      * @dev Returns the number of decimals used to get its user representation.
258      * For example, if `decimals` equals `2`, a balance of `505` tokens should
259      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
260      *
261      * Tokens usually opt for a value of 18, imitating the relationship between
262      * Ether and Wei.
263      *
264      * > Note that this information is only used for _display_ purposes: it in
265      * no way affects any of the arithmetic of the contract, including
266      * `IERC20.balanceOf` and `IERC20.transfer`.
267      */
268     function decimals() public view returns (uint8) {
269         return _decimals;
270     }
271 }
272 
273 
274 
275 /**
276  * @dev Implementation of the `IERC20` interface.
277  *
278  * This implementation is agnostic to the way tokens are created. This means
279  * that a supply mechanism has to be added in a derived contract using `_mint`.
280  * For a generic mechanism see `ERC20Mintable`.
281  *
282  * *For a detailed writeup see our guide [How to implement supply
283  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
284  *
285  * We have followed general OpenZeppelin guidelines: functions revert instead
286  * of returning `false` on failure. This behavior is nonetheless conventional
287  * and does not conflict with the expectations of ERC20 applications.
288  *
289  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
290  * This allows applications to reconstruct the allowance for all accounts just
291  * by listening to said events. Other implementations of the EIP may not emit
292  * these events, as it isn't required by the specification.
293  *
294  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
295  * functions have been added to mitigate the well-known issues around setting
296  * allowances. See `IERC20.approve`.
297  */
298 contract ERC20 is IERC20 {
299     using SafeMath for uint256;
300 
301     mapping (address => uint256) private _balances;
302 
303     mapping (address => mapping (address => uint256)) private _allowances;
304 
305     uint256 private _totalSupply;
306 
307     /**
308      * @dev See `IERC20.totalSupply`.
309      */
310     function totalSupply() public view returns (uint256) {
311         return _totalSupply;
312     }
313 
314     /**
315      * @dev See `IERC20.balanceOf`.
316      */
317     function balanceOf(address account) public view returns (uint256) {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See `IERC20.transfer`.
323      *
324      * Requirements:
325      *
326      * - `recipient` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address recipient, uint256 amount) public returns (bool) {
330         _transfer(msg.sender, recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See `IERC20.allowance`.
336      */
337     function allowance(address owner, address spender) public view returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See `IERC20.approve`.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 value) public returns (bool) {
349         _approve(msg.sender, spender, value);
350         return true;
351     }
352 
353     /**
354      * @dev See `IERC20.transferFrom`.
355      *
356      * Emits an `Approval` event indicating the updated allowance. This is not
357      * required by the EIP. See the note at the beginning of `ERC20`;
358      *
359      * Requirements:
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `value`.
362      * - the caller must have allowance for `sender`'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
366         _transfer(sender, recipient, amount);
367         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to `approve` that can be used as a mitigation for
375      * problems described in `IERC20.approve`.
376      *
377      * Emits an `Approval` event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
384         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
385         return true;
386     }
387 
388     /**
389      * @dev Atomically decreases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to `approve` that can be used as a mitigation for
392      * problems described in `IERC20.approve`.
393      *
394      * Emits an `Approval` event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      * - `spender` must have allowance for the caller of at least
400      * `subtractedValue`.
401      */
402     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
403         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
404         return true;
405     }
406 
407     /**
408      * @dev Moves tokens `amount` from `sender` to `recipient`.
409      *
410      * This is internal function is equivalent to `transfer`, and can be used to
411      * e.g. implement automatic token fees, slashing mechanisms, etc.
412      *
413      * Emits a `Transfer` event.
414      *
415      * Requirements:
416      *
417      * - `sender` cannot be the zero address.
418      * - `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      */
421     function _transfer(address sender, address recipient, uint256 amount) internal {
422         require(sender != address(0), "ERC20: transfer from the zero address");
423         require(recipient != address(0), "ERC20: transfer to the zero address");
424 
425         _balances[sender] = _balances[sender].sub(amount);
426         _balances[recipient] = _balances[recipient].add(amount);
427         emit Transfer(sender, recipient, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a `Transfer` event with `from` set to the zero address.
434      *
435      * Requirements
436      *
437      * - `to` cannot be the zero address.
438      */
439     function _mint(address account, uint256 amount) internal {
440         require(account != address(0), "ERC20: mint to the zero address");
441 
442         _totalSupply = _totalSupply.add(amount);
443         _balances[account] = _balances[account].add(amount);
444         emit Transfer(address(0), account, amount);
445     }
446 
447      /**
448      * @dev Destoys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a `Transfer` event with `to` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 value) internal {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _totalSupply = _totalSupply.sub(value);
462         _balances[account] = _balances[account].sub(value);
463         emit Transfer(account, address(0), value);
464     }
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
468      *
469      * This is internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an `Approval` event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(address owner, address spender, uint256 value) internal {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = value;
484         emit Approval(owner, spender, value);
485     }
486 
487     /**
488      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
489      * from the caller's allowance.
490      *
491      * See `_burn` and `_approve`.
492      */
493     function _burnFrom(address account, uint256 amount) internal {
494         _burn(account, amount);
495         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
496     }
497 }
498 
499 
500 contract MinterRole {
501     using Roles for Roles.Role;
502 
503     event MinterAdded(address indexed account);
504     event MinterRemoved(address indexed account);
505 
506     Roles.Role private _minters;
507 
508     constructor () internal {
509         _addMinter(msg.sender);
510     }
511 
512     modifier onlyMinter() {
513         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
514         _;
515     }
516 
517     function isMinter(address account) public view returns (bool) {
518         return _minters.has(account);
519     }
520 
521     function addMinter(address account) public onlyMinter {
522         _addMinter(account);
523     }
524 
525     function renounceMinter() public {
526         _removeMinter(msg.sender);
527     }
528 
529     function _addMinter(address account) internal {
530         _minters.add(account);
531         emit MinterAdded(account);
532     }
533 
534     function _removeMinter(address account) internal {
535         _minters.remove(account);
536         emit MinterRemoved(account);
537     }
538 }
539 
540 
541 
542 /**
543  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
544  * which have permission to mint (create) new tokens as they see fit.
545  *
546  * At construction, the deployer of the contract is the only minter.
547  */
548 contract ERC20Mintable is ERC20, MinterRole {
549     /**
550      * @dev See `ERC20._mint`.
551      *
552      * Requirements:
553      *
554      * - the caller must have the `MinterRole`.
555      */
556     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
557         _mint(account, amount);
558         return true;
559     }
560 }
561 
562 
563 /**
564  * @dev Extension of `ERC20` that allows token holders to destroy both their own
565  * tokens and those that they have an allowance for, in a way that can be
566  * recognized off-chain (via event analysis).
567  */
568 contract ERC20Burnable is ERC20 {
569     /**
570      * @dev Destoys `amount` tokens from the caller.
571      *
572      * See `ERC20._burn`.
573      */
574     function burn(uint256 amount) public {
575         _burn(msg.sender, amount);
576     }
577 
578     /**
579      * @dev See `ERC20._burnFrom`.
580      */
581     function burnFrom(address account, uint256 amount) public {
582         _burnFrom(account, amount);
583     }
584 }
585 
586 
587 
588 
589 contract SpiritToken is ERC20Mintable, ERC20Burnable, ERC20Detailed {
590 
591 	constructor (string memory name, string memory symbol, uint8 decimals) ERC20Detailed(name, symbol, decimals) public {
592 
593 	}
594 }