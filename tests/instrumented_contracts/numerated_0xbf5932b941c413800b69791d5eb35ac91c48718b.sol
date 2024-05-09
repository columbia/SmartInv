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
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts with custom message when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 library Roles {
153     struct Role {
154         mapping (address => bool) bearer;
155     }
156 
157     /**
158      * @dev Give an account access to this role.
159      */
160     function add(Role storage role, address account) internal {
161         require(!has(role, account), "Roles: account already has role");
162         role.bearer[account] = true;
163     }
164 
165     /**
166      * @dev Remove an account's access to this role.
167      */
168     function remove(Role storage role, address account) internal {
169         require(has(role, account), "Roles: account does not have role");
170         role.bearer[account] = false;
171     }
172 
173     /**
174      * @dev Check if an account has this role.
175      * @return bool
176      */
177     function has(Role storage role, address account) internal view returns (bool) {
178         require(account != address(0), "Roles: account is the zero address");
179         return role.bearer[account];
180     }
181 }
182 
183 contract MinterRole {
184     using Roles for Roles.Role;
185 
186     event MinterAdded(address indexed account);
187     event MinterRemoved(address indexed account);
188 
189     Roles.Role private _minters;
190 
191     constructor () internal {
192         _addMinter(msg.sender);
193     }
194 
195     modifier onlyMinter() {
196         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
197         _;
198     }
199 
200     function isMinter(address account) public view returns (bool) {
201         return _minters.has(account);
202     }
203 
204     function addMinter(address account) public onlyMinter {
205         _addMinter(account);
206     }
207 
208     function renounceMinter() public {
209         _removeMinter(msg.sender);
210     }
211 
212     function _addMinter(address account) internal {
213         _minters.add(account);
214         emit MinterAdded(account);
215     }
216 
217     function _removeMinter(address account) internal {
218         _minters.remove(account);
219         emit MinterRemoved(account);
220     }
221 }
222 
223 /**
224  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
225  * the optional functions; to access them see {ERC20Detailed}.
226  */
227 interface IERC20 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `recipient`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `sender` to `recipient` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Emitted when `value` tokens are moved from one account (`from`) to
285      * another (`to`).
286      *
287      * Note that `value` may be zero.
288      */
289     event Transfer(address indexed from, address indexed to, uint256 value);
290 
291     /**
292      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
293      * a call to {approve}. `value` is the new allowance.
294      */
295     event Approval(address indexed owner, address indexed spender, uint256 value);
296 }
297 
298 /**
299  * @dev Implementation of the {IERC20} interface.
300  *
301  * This implementation is agnostic to the way tokens are created. This means
302  * that a supply mechanism has to be added in a derived contract using {_mint}.
303  * For a generic mechanism see {ERC20Mintable}.
304  *
305  * TIP: For a detailed writeup see our guide
306  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
307  * to implement supply mechanisms].
308  *
309  * We have followed general OpenZeppelin guidelines: functions revert instead
310  * of returning `false` on failure. This behavior is nonetheless conventional
311  * and does not conflict with the expectations of ERC20 applications.
312  *
313  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
314  * This allows applications to reconstruct the allowance for all accounts just
315  * by listening to said events. Other implementations of the EIP may not emit
316  * these events, as it isn't required by the specification.
317  *
318  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
319  * functions have been added to mitigate the well-known issues around setting
320  * allowances. See {IERC20-approve}.
321  */
322 contract ERC20 is IERC20 {
323     using SafeMath for uint256;
324 
325     mapping (address => uint256) private _balances;
326 
327     mapping (address => mapping (address => uint256)) private _allowances;
328 
329     uint256 private _totalSupply;
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account) public view returns (uint256) {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `recipient` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address recipient, uint256 amount) public returns (bool) {
354         _transfer(msg.sender, recipient, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-allowance}.
360      */
361     function allowance(address owner, address spender) public view returns (uint256) {
362         return _allowances[owner][spender];
363     }
364 
365     /**
366      * @dev See {IERC20-approve}.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 value) public returns (bool) {
373         _approve(msg.sender, spender, value);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-transferFrom}.
379      *
380      * Emits an {Approval} event indicating the updated allowance. This is not
381      * required by the EIP. See the note at the beginning of {ERC20};
382      *
383      * Requirements:
384      * - `sender` and `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `value`.
386      * - the caller must have allowance for `sender`'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
390         _transfer(sender, recipient, amount);
391         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
408         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
427         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
428         return true;
429     }
430 
431     /**
432      * @dev Moves tokens `amount` from `sender` to `recipient`.
433      *
434      * This is internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `sender` cannot be the zero address.
442      * - `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      */
445     function _transfer(address sender, address recipient, uint256 amount) internal {
446         require(sender != address(0), "ERC20: transfer from the zero address");
447         require(recipient != address(0), "ERC20: transfer to the zero address");
448 
449         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
450         _balances[recipient] = _balances[recipient].add(amount);
451         emit Transfer(sender, recipient, amount);
452     }
453 
454     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
455      * the total supply.
456      *
457      * Emits a {Transfer} event with `from` set to the zero address.
458      *
459      * Requirements
460      *
461      * - `to` cannot be the zero address.
462      */
463     function _mint(address account, uint256 amount) internal {
464         require(account != address(0), "ERC20: mint to the zero address");
465 
466         _totalSupply = _totalSupply.add(amount);
467         _balances[account] = _balances[account].add(amount);
468         emit Transfer(address(0), account, amount);
469     }
470 
471      /**
472      * @dev Destroys `amount` tokens from `account`, reducing the
473      * total supply.
474      *
475      * Emits a {Transfer} event with `to` set to the zero address.
476      *
477      * Requirements
478      *
479      * - `account` cannot be the zero address.
480      * - `account` must have at least `amount` tokens.
481      */
482     function _burn(address account, uint256 value) internal {
483         require(account != address(0), "ERC20: burn from the zero address");
484 
485         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
486         _totalSupply = _totalSupply.sub(value);
487         emit Transfer(account, address(0), value);
488     }
489 
490     /**
491      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
492      *
493      * This is internal function is equivalent to `approve`, and can be used to
494      * e.g. set automatic allowances for certain subsystems, etc.
495      *
496      * Emits an {Approval} event.
497      *
498      * Requirements:
499      *
500      * - `owner` cannot be the zero address.
501      * - `spender` cannot be the zero address.
502      */
503     function _approve(address owner, address spender, uint256 value) internal {
504         require(owner != address(0), "ERC20: approve from the zero address");
505         require(spender != address(0), "ERC20: approve to the zero address");
506 
507         _allowances[owner][spender] = value;
508         emit Approval(owner, spender, value);
509     }
510 
511     /**
512      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
513      * from the caller's allowance.
514      *
515      * See {_burn} and {_approve}.
516      */
517     function _burnFrom(address account, uint256 amount) internal {
518         _burn(account, amount);
519         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
520     }
521 }
522 
523 /**
524  * @dev Extension of {ERC20} that allows token holders to destroy both their own
525  * tokens and those that they have an allowance for, in a way that can be
526  * recognized off-chain (via event analysis).
527  */
528 contract ERC20Burnable is ERC20 {
529     /**
530      * @dev Destroys `amount` tokens from the caller.
531      *
532      * See {ERC20-_burn}.
533      */
534     function burn(uint256 amount) public {
535         _burn(msg.sender, amount);
536     }
537 
538     /**
539      * @dev See {ERC20-_burnFrom}.
540      */
541     function burnFrom(address account, uint256 amount) public {
542         _burnFrom(account, amount);
543     }
544 }
545 
546 /**
547  * @dev Optional functions from the ERC20 standard.
548  */
549 contract ERC20Detailed is IERC20 {
550     string private _name;
551     string private _symbol;
552     uint8 private _decimals;
553 
554     /**
555      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
556      * these values are immutable: they can only be set once during
557      * construction.
558      */
559     constructor (string memory name, string memory symbol, uint8 decimals) public {
560         _name = name;
561         _symbol = symbol;
562         _decimals = decimals;
563     }
564 
565     /**
566      * @dev Returns the name of the token.
567      */
568     function name() public view returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the symbol of the token, usually a shorter version of the
574      * name.
575      */
576     function symbol() public view returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the number of decimals used to get its user representation.
582      * For example, if `decimals` equals `2`, a balance of `505` tokens should
583      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
584      *
585      * Tokens usually opt for a value of 18, imitating the relationship between
586      * Ether and Wei.
587      *
588      * NOTE: This information is only used for _display_ purposes: it in
589      * no way affects any of the arithmetic of the contract, including
590      * {IERC20-balanceOf} and {IERC20-transfer}.
591      */
592     function decimals() public view returns (uint8) {
593         return _decimals;
594     }
595 }
596 
597 /**
598  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
599  * which have permission to mint (create) new tokens as they see fit.
600  *
601  * At construction, the deployer of the contract is the only minter.
602  */
603 contract ERC20Mintable is ERC20, MinterRole {
604     /**
605      * @dev See {ERC20-_mint}.
606      *
607      * Requirements:
608      *
609      * - the caller must have the {MinterRole}.
610      */
611     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
612         _mint(account, amount);
613         return true;
614     }
615 }
616 
617 contract CUS is ERC20Burnable, ERC20Mintable, ERC20Detailed{
618     
619     constructor ()
620         ERC20Detailed("CUS Crypto Coin", "CUS", 18) public{
621     }
622 }