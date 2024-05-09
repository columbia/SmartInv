1 /*
2  *  ______   ______  _______  _______   ______  ________  ______  __       __  ______  _______  
3  * /      \ /      \|       \|       \ /      \|        \/      \|  \  _  |  \/      \|       \ 
4  *|  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\ ▓▓ / \ | ▓▓  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\
5  *| ▓▓   \▓▓ ▓▓__| ▓▓ ▓▓__| ▓▓ ▓▓__| ▓▓ ▓▓  | ▓▓  | ▓▓  | ▓▓___\▓▓ ▓▓/  ▓\| ▓▓ ▓▓__| ▓▓ ▓▓__/ ▓▓
6  *| ▓▓     | ▓▓    ▓▓ ▓▓    ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓  | ▓▓   \▓▓    \| ▓▓  ▓▓▓\ ▓▓ ▓▓    ▓▓ ▓▓    ▓▓
7  *| ▓▓   __| ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\ ▓▓  | ▓▓  | ▓▓   _\▓▓▓▓▓▓\ ▓▓ ▓▓\▓▓\▓▓ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓ 
8  *| ▓▓__/  \ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓__/ ▓▓  | ▓▓  |  \__| ▓▓ ▓▓▓▓  \▓▓▓▓ ▓▓  | ▓▓ ▓▓      
9  * \▓▓    ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓\▓▓    ▓▓  | ▓▓   \▓▓    ▓▓ ▓▓▓    \▓▓▓ ▓▓  | ▓▓ ▓▓      
10  *  \▓▓▓▓▓▓ \▓▓   \▓▓\▓▓   \▓▓\▓▓   \▓▓ \▓▓▓▓▓▓    \▓▓    \▓▓▓▓▓▓ \▓▓      \▓▓\▓▓   \▓▓\▓▓      
11  *
12  */
13 
14 // File: @openzeppelin/contracts/GSN/Context.sol
15 
16 pragma solidity ^0.5.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 contract Context {
29     // Empty internal constructor, to prevent people from mistakenly deploying
30     // an instance of this contract, which should be used via inheritance.
31     constructor () internal { }
32     // solhint-disable-previous-line no-empty-blocks
33 
34     function _msgSender() internal view returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
45 
46 pragma solidity ^0.5.0;
47 
48 /**
49  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
50  * the optional functions; to access them see {ERC20Detailed}.
51  */
52 interface IERC20 {
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `recipient`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 // File: @openzeppelin/contracts/math/SafeMath.sol
124 
125 pragma solidity ^0.5.0;
126 
127 /**
128  * @dev Wrappers over Solidity's arithmetic operations with added overflow
129  * checks.
130  *
131  * Arithmetic operations in Solidity wrap on overflow. This can easily result
132  * in bugs, because programmers usually assume that an overflow raises an
133  * error, which is the standard behavior in high level programming languages.
134  * `SafeMath` restores this intuition by reverting the transaction when an
135  * operation overflows.
136  *
137  * Using this library instead of the unchecked operations eliminates an entire
138  * class of bugs, so it's recommended to use it always.
139  */
140 library SafeMath {
141     /**
142      * @dev Returns the addition of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `+` operator.
146      *
147      * Requirements:
148      * - Addition cannot overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a, "SafeMath: addition overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      * - Subtraction cannot overflow.
178      *
179      * _Available since v2.4.0._
180      */
181     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b <= a, errorMessage);
183         uint256 c = a - b;
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return div(a, b, "SafeMath: division by zero");
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      *
237      * _Available since v2.4.0._
238      */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         // Solidity only automatically asserts when dividing by 0
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      *
274      * _Available since v2.4.0._
275      */
276     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b != 0, errorMessage);
278         return a % b;
279     }
280 }
281 
282 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
283 
284 pragma solidity ^0.5.0;
285 
286 /**
287  * @dev Implementation of the {IERC20} interface.
288  *
289  * This implementation is agnostic to the way tokens are created. This means
290  * that a supply mechanism has to be added in a derived contract using {_mint}.
291  * For a generic mechanism see {ERC20Mintable}.
292  *
293  * TIP: For a detailed writeup see our guide
294  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
295  * to implement supply mechanisms].
296  *
297  * We have followed general OpenZeppelin guidelines: functions revert instead
298  * of returning `false` on failure. This behavior is nonetheless conventional
299  * and does not conflict with the expectations of ERC20 applications.
300  *
301  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
302  * This allows applications to reconstruct the allowance for all accounts just
303  * by listening to said events. Other implementations of the EIP may not emit
304  * these events, as it isn't required by the specification.
305  *
306  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
307  * functions have been added to mitigate the well-known issues around setting
308  * allowances. See {IERC20-approve}.
309  */
310 contract ERC20 is Context, IERC20 {
311     using SafeMath for uint256;
312 
313     mapping (address => uint256) private _balances;
314 
315     mapping (address => mapping (address => uint256)) private _allowances;
316 
317     uint256 private _totalSupply;
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount) public returns (bool) {
342         _transfer(_msgSender(), recipient, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint256 amount) public returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20};
370      *
371      * Requirements:
372      * - `sender` and `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      * - the caller must have allowance for `sender`'s tokens of at least
375      * `amount`.
376      */
377     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
378         _transfer(sender, recipient, amount);
379         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
380         return true;
381     }
382 
383     /**
384      * @dev Atomically increases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
396         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
415         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
416         return true;
417     }
418 
419     /**
420      * @dev Moves tokens `amount` from `sender` to `recipient`.
421      *
422      * This is internal function is equivalent to {transfer}, and can be used to
423      * e.g. implement automatic token fees, slashing mechanisms, etc.
424      *
425      * Emits a {Transfer} event.
426      *
427      * Requirements:
428      *
429      * - `sender` cannot be the zero address.
430      * - `recipient` cannot be the zero address.
431      * - `sender` must have a balance of at least `amount`.
432      */
433     function _transfer(address sender, address recipient, uint256 amount) internal {
434         require(sender != address(0), "ERC20: transfer from the zero address");
435         require(recipient != address(0), "ERC20: transfer to the zero address");
436 
437         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
438         _balances[recipient] = _balances[recipient].add(amount);
439         emit Transfer(sender, recipient, amount);
440     }
441 
442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
443      * the total supply.
444      *
445      * Emits a {Transfer} event with `from` set to the zero address.
446      *
447      * Requirements
448      *
449      * - `to` cannot be the zero address.
450      */
451     function _mint(address account, uint256 amount) internal {
452         require(account != address(0), "ERC20: mint to the zero address");
453 
454         _totalSupply = _totalSupply.add(amount);
455         _balances[account] = _balances[account].add(amount);
456         emit Transfer(address(0), account, amount);
457     }
458 
459     /**
460      * @dev Destroys `amount` tokens from `account`, reducing the
461      * total supply.
462      *
463      * Emits a {Transfer} event with `to` set to the zero address.
464      *
465      * Requirements
466      *
467      * - `account` cannot be the zero address.
468      * - `account` must have at least `amount` tokens.
469      */
470     function _burn(address account, uint256 amount) internal {
471         require(account != address(0), "ERC20: burn from the zero address");
472 
473         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
474         _totalSupply = _totalSupply.sub(amount);
475         emit Transfer(account, address(0), amount);
476     }
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
480      *
481      * This is internal function is equivalent to `approve`, and can be used to
482      * e.g. set automatic allowances for certain subsystems, etc.
483      *
484      * Emits an {Approval} event.
485      *
486      * Requirements:
487      *
488      * - `owner` cannot be the zero address.
489      * - `spender` cannot be the zero address.
490      */
491     function _approve(address owner, address spender, uint256 amount) internal {
492         require(owner != address(0), "ERC20: approve from the zero address");
493         require(spender != address(0), "ERC20: approve to the zero address");
494 
495         _allowances[owner][spender] = amount;
496         emit Approval(owner, spender, amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
501      * from the caller's allowance.
502      *
503      * See {_burn} and {_approve}.
504      */
505     function _burnFrom(address account, uint256 amount) internal {
506         _burn(account, amount);
507         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
512 
513 pragma solidity ^0.5.0;
514 
515 /**
516  * @dev Extension of {ERC20} that allows token holders to destroy both their own
517  * tokens and those that they have an allowance for, in a way that can be
518  * recognized off-chain (via event analysis).
519  */
520 contract ERC20Burnable is Context, ERC20 {
521     /**
522      * @dev Destroys `amount` tokens from the caller.
523      *
524      * See {ERC20-_burn}.
525      */
526     function burn(uint256 amount) public {
527         _burn(_msgSender(), amount);
528     }
529 
530     /**
531      * @dev See {ERC20-_burnFrom}.
532      */
533     function burnFrom(address account, uint256 amount) public {
534         _burnFrom(account, amount);
535     }
536 }
537 
538 // File: @openzeppelin/contracts/access/Roles.sol
539 
540 pragma solidity ^0.5.0;
541 
542 /**
543  * @title Roles
544  * @dev Library for managing addresses assigned to a Role.
545  */
546 library Roles {
547     struct Role {
548         mapping (address => bool) bearer;
549     }
550 
551     /**
552      * @dev Give an account access to this role.
553      */
554     function add(Role storage role, address account) internal {
555         require(!has(role, account), "Roles: account already has role");
556         role.bearer[account] = true;
557     }
558 
559     /**
560      * @dev Remove an account's access to this role.
561      */
562     function remove(Role storage role, address account) internal {
563         require(has(role, account), "Roles: account does not have role");
564         role.bearer[account] = false;
565     }
566 
567     /**
568      * @dev Check if an account has this role.
569      * @return bool
570      */
571     function has(Role storage role, address account) internal view returns (bool) {
572         require(account != address(0), "Roles: account is the zero address");
573         return role.bearer[account];
574     }
575 }
576 
577 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
578 
579 pragma solidity ^0.5.0;
580 
581 contract MinterRole is Context {
582     using Roles for Roles.Role;
583 
584     event MinterAdded(address indexed account);
585     event MinterRemoved(address indexed account);
586 
587     Roles.Role private _minters;
588 
589     constructor () internal {
590         _addMinter(_msgSender());
591     }
592 
593     modifier onlyMinter() {
594         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
595         _;
596     }
597 
598     function isMinter(address account) public view returns (bool) {
599         return _minters.has(account);
600     }
601 
602     function addMinter(address account) public onlyMinter {
603         _addMinter(account);
604     }
605 
606     function renounceMinter() public {
607         _removeMinter(_msgSender());
608     }
609 
610     function _addMinter(address account) internal {
611         _minters.add(account);
612         emit MinterAdded(account);
613     }
614 
615     function _removeMinter(address account) internal {
616         _minters.remove(account);
617         emit MinterRemoved(account);
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
622 
623 pragma solidity ^0.5.0;
624 
625 /**
626  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
627  * which have permission to mint (create) new tokens as they see fit.
628  *
629  * At construction, the deployer of the contract is the only minter.
630  */
631 contract ERC20Mintable is ERC20, MinterRole {
632     /**
633      * @dev See {ERC20-_mint}.
634      *
635      * Requirements:
636      *
637      * - the caller must have the {MinterRole}.
638      */
639     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
640         _mint(account, amount);
641         return true;
642     }
643 }
644 
645 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
646 
647 pragma solidity ^0.5.0;
648 
649 /**
650  * @dev Optional functions from the ERC20 standard.
651  */
652 contract ERC20Detailed is IERC20 {
653     string private _name;
654     string private _symbol;
655     uint8 private _decimals;
656 
657     /**
658      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
659      * these values are immutable: they can only be set once during
660      * construction.
661      */
662     constructor (string memory name, string memory symbol, uint8 decimals) public {
663         _name = name;
664         _symbol = symbol;
665         _decimals = decimals;
666     }
667 
668     /**
669      * @dev Returns the name of the token.
670      */
671     function name() public view returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev Returns the symbol of the token, usually a shorter version of the
677      * name.
678      */
679     function symbol() public view returns (string memory) {
680         return _symbol;
681     }
682 
683     /**
684      * @dev Returns the number of decimals used to get its user representation.
685      * For example, if `decimals` equals `2`, a balance of `505` tokens should
686      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
687      *
688      * Tokens usually opt for a value of 18, imitating the relationship between
689      * Ether and Wei.
690      *
691      * NOTE: This information is only used for _display_ purposes: it in
692      * no way affects any of the arithmetic of the contract, including
693      * {IERC20-balanceOf} and {IERC20-transfer}.
694      */
695     function decimals() public view returns (uint8) {
696         return _decimals;
697     }
698 }
699 
700 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
701 
702 pragma solidity ^0.5.0;
703 
704 /**
705  * @title WhitelistAdminRole
706  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
707  */
708 contract WhitelistAdminRole is Context {
709     using Roles for Roles.Role;
710 
711     event WhitelistAdminAdded(address indexed account);
712     event WhitelistAdminRemoved(address indexed account);
713 
714     Roles.Role private _whitelistAdmins;
715 
716     constructor () internal {
717         _addWhitelistAdmin(_msgSender());
718     }
719 
720     modifier onlyWhitelistAdmin() {
721         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
722         _;
723     }
724 
725     function isWhitelistAdmin(address account) public view returns (bool) {
726         return _whitelistAdmins.has(account);
727     }
728 
729     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
730         _addWhitelistAdmin(account);
731     }
732 
733     function renounceWhitelistAdmin() public {
734         _removeWhitelistAdmin(_msgSender());
735     }
736 
737     function _addWhitelistAdmin(address account) internal {
738         _whitelistAdmins.add(account);
739         emit WhitelistAdminAdded(account);
740     }
741 
742     function _removeWhitelistAdmin(address account) internal {
743         _whitelistAdmins.remove(account);
744         emit WhitelistAdminRemoved(account);
745     }
746 }
747 
748 // File: contracts/ERC20/ERC20TransferLiquidityLock.sol
749 
750 pragma solidity ^0.5.17;
751 
752 contract ERC20TransferLiquidityLock is ERC20 {
753     using SafeMath for uint256;
754 
755     event LockLiquidity(uint256 tokenAmount, uint256 ethAmount);
756     event BurnLiquidity(uint256 lpTokenAmount);
757     event RewardLiquidityProviders(uint256 tokenAmount);
758 
759     address public uniswapV2Router;
760     address public uniswapV2Pair;
761 
762     // the amount of tokens to lock for liquidity during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
763     uint256 public liquidityLockDivisor;
764     uint256 public liquidityRewardsDivisor;
765 
766     function _transfer(address from, address to, uint256 amount) internal {
767         // calculate liquidity lock amount
768         // dont transfer burn from this contract
769         // or can never lock full lockable amount
770         if (liquidityLockDivisor != 0 && from != address(this)) {
771             uint256 liquidityLockAmount = amount.div(liquidityLockDivisor);
772             super._transfer(from, address(this), liquidityLockAmount);
773             super._transfer(from, to, amount.sub(liquidityLockAmount));
774         }
775         else {
776             super._transfer(from, to, amount);
777         }
778     }
779 
780     // Receive eth from uniswap swap
781     function () external payable {}
782 
783     function lockLiquidity(uint256 _lockableSupply) public {
784         // lockable supply is the token balance of this contract
785         require(_lockableSupply <= balanceOf(address(this)), "ERC20TransferLiquidityLock::lockLiquidity: lock amount higher than lockable balance");
786         require(_lockableSupply != 0, "ERC20TransferLiquidityLock::lockLiquidity: lock amount cannot be 0");
787 
788         // reward liquidity providers if needed
789         if (liquidityRewardsDivisor != 0) {
790             // if no balance left to lock, don't lock
791             if (liquidityRewardsDivisor == 1) {
792                 _rewardLiquidityProviders(_lockableSupply);
793                 return;
794             }
795 
796             uint256 liquidityRewards = _lockableSupply.div(liquidityRewardsDivisor);
797             _lockableSupply = _lockableSupply.sub(liquidityRewards);
798             _rewardLiquidityProviders(liquidityRewards);
799         }
800 
801         uint256 amountToSwapForEth = _lockableSupply.div(2);
802         uint256 amountToAddLiquidity = _lockableSupply.sub(amountToSwapForEth);
803 
804         // needed in case contract already owns eth
805         uint256 ethBalanceBeforeSwap = address(this).balance;
806         swapTokensForEth(amountToSwapForEth);
807         uint256 ethReceived = address(this).balance.sub(ethBalanceBeforeSwap);
808 
809         addLiquidity(amountToAddLiquidity, ethReceived);
810         emit LockLiquidity(amountToAddLiquidity, ethReceived);
811     }
812 
813     // external util so anyone can easily distribute rewards
814     // must call lockLiquidity first which automatically
815     // calls _rewardLiquidityProviders
816     function rewardLiquidityProviders() external {
817         // lock everything that is lockable
818         lockLiquidity(balanceOf(address(this)));
819     }
820 
821     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
822         // avoid burn by calling super._transfer directly
823         super._transfer(address(this), uniswapV2Pair, liquidityRewards);
824         IUniswapV2Pair(uniswapV2Pair).sync();
825         emit RewardLiquidityProviders(liquidityRewards);
826     }
827 
828     function burnLiquidity() external {
829         uint256 balance = ERC20(uniswapV2Pair).balanceOf(address(this));
830         require(balance != 0, "ERC20TransferLiquidityLock::burnLiquidity: burn amount cannot be 0");
831         ERC20(uniswapV2Pair).transfer(address(0), balance);
832         emit BurnLiquidity(balance);
833     }
834 
835     function swapTokensForEth(uint256 tokenAmount) private {
836         address[] memory uniswapPairPath = new address[](2);
837         uniswapPairPath[0] = address(this);
838         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
839 
840         _approve(address(this), uniswapV2Router, tokenAmount);
841 
842         IUniswapV2Router02(uniswapV2Router)
843             .swapExactTokensForETHSupportingFeeOnTransferTokens(
844                 tokenAmount,
845                 0,
846                 uniswapPairPath,
847                 address(this),
848                 block.timestamp
849             );
850     }
851 
852     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
853         _approve(address(this), uniswapV2Router, tokenAmount);
854 
855         IUniswapV2Router02(uniswapV2Router)
856             .addLiquidityETH
857             .value(ethAmount)(
858                 address(this),
859                 tokenAmount,
860                 0,
861                 0,
862                 address(this),
863                 block.timestamp
864             );
865     }
866 
867     // returns token amount
868     function lockableSupply() external view returns (uint256) {
869         return balanceOf(address(this));
870     }
871 
872     // returns token amount
873     function lockedSupply() external view returns (uint256) {
874         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
875         uint256 lpBalance = lockedLiquidity();
876         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
877 
878         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
879         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
880         return _lockedSupply;
881     }
882 
883     // returns token amount
884     function burnedSupply() external view returns (uint256) {
885         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
886         uint256 lpBalance = burnedLiquidity();
887         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
888 
889         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
890         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
891         return _burnedSupply;
892     }
893 
894     // returns LP amount, not token amount
895     function burnableLiquidity() public view returns (uint256) {
896         return ERC20(uniswapV2Pair).balanceOf(address(this));
897     }
898 
899     // returns LP amount, not token amount
900     function burnedLiquidity() public view returns (uint256) {
901         return ERC20(uniswapV2Pair).balanceOf(address(0));
902     }
903 
904     // returns LP amount, not token amount
905     function lockedLiquidity() public view returns (uint256) {
906         return burnableLiquidity().add(burnedLiquidity());
907     }
908 }
909 
910 interface IUniswapV2Router02 {
911     function WETH() external pure returns (address);
912     function swapExactTokensForETHSupportingFeeOnTransferTokens(
913         uint amountIn,
914         uint amountOutMin,
915         address[] calldata path,
916         address to,
917         uint deadline
918     ) external;
919     function addLiquidityETH(
920         address token,
921         uint amountTokenDesired,
922         uint amountTokenMin,
923         uint amountETHMin,
924         address to,
925         uint deadline
926     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
927 }
928 
929 interface IUniswapV2Pair {
930     function sync() external;
931 }
932 
933 // File: contracts/ERC20/ERC20Governance.sol
934 
935 pragma solidity ^0.5.17;
936 
937 contract ERC20Governance is ERC20, ERC20Detailed {
938     using SafeMath for uint256;
939 
940     function _transfer(address from, address to, uint256 amount) internal {
941         _moveDelegates(_delegates[from], _delegates[to], amount);
942         super._transfer(from, to, amount);
943     }
944 
945     function _mint(address account, uint256 amount) internal {
946         _moveDelegates(address(0), _delegates[account], amount);
947         super._mint(account, amount);
948     }
949 
950     function _burn(address account, uint256 amount) internal {
951         _moveDelegates(_delegates[account], address(0), amount);
952         super._burn(account, amount);
953     }
954 
955     // Copied and modified from YAM code:
956     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
957     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
958     // Which is copied and modified from COMPOUND:
959     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
960 
961     /// @notice A record of each accounts delegate
962     mapping (address => address) internal _delegates;
963 
964     /// @notice A checkpoint for marking number of votes from a given block
965     struct Checkpoint {
966         uint32 fromBlock;
967         uint256 votes;
968     }
969 
970     /// @notice A record of votes checkpoints for each account, by index
971     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
972 
973     /// @notice The number of checkpoints for each account
974     mapping (address => uint32) public numCheckpoints;
975 
976     /// @notice The EIP-712 typehash for the contract's domain
977     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
978 
979     /// @notice The EIP-712 typehash for the delegation struct used by the contract
980     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
981 
982     /// @notice A record of states for signing / validating signatures
983     mapping (address => uint) public nonces;
984 
985       /// @notice An event thats emitted when an account changes its delegate
986     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
987 
988     /// @notice An event thats emitted when a delegate account's vote balance changes
989     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
990 
991     /**
992      * @notice Delegate votes from `msg.sender` to `delegatee`
993      * @param delegator The address to get delegatee for
994      */
995     function delegates(address delegator)
996         external
997         view
998         returns (address)
999     {
1000         return _delegates[delegator];
1001     }
1002 
1003    /**
1004     * @notice Delegate votes from `msg.sender` to `delegatee`
1005     * @param delegatee The address to delegate votes to
1006     */
1007     function delegate(address delegatee) external {
1008         return _delegate(msg.sender, delegatee);
1009     }
1010 
1011     /**
1012      * @notice Delegates votes from signatory to `delegatee`
1013      * @param delegatee The address to delegate votes to
1014      * @param nonce The contract state required to match the signature
1015      * @param expiry The time at which to expire the signature
1016      * @param v The recovery byte of the signature
1017      * @param r Half of the ECDSA signature pair
1018      * @param s Half of the ECDSA signature pair
1019      */
1020     function delegateBySig(
1021         address delegatee,
1022         uint nonce,
1023         uint expiry,
1024         uint8 v,
1025         bytes32 r,
1026         bytes32 s
1027     )
1028         external
1029     {
1030         bytes32 domainSeparator = keccak256(
1031             abi.encode(
1032                 DOMAIN_TYPEHASH,
1033                 keccak256(bytes(name())),
1034                 getChainId(),
1035                 address(this)
1036             )
1037         );
1038 
1039         bytes32 structHash = keccak256(
1040             abi.encode(
1041                 DELEGATION_TYPEHASH,
1042                 delegatee,
1043                 nonce,
1044                 expiry
1045             )
1046         );
1047 
1048         bytes32 digest = keccak256(
1049             abi.encodePacked(
1050                 "\x19\x01",
1051                 domainSeparator,
1052                 structHash
1053             )
1054         );
1055 
1056         address signatory = ecrecover(digest, v, r, s);
1057         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
1058         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
1059         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
1060         return _delegate(signatory, delegatee);
1061     }
1062 
1063     /**
1064      * @notice Gets the current votes balance for `account`
1065      * @param account The address to get votes balance
1066      * @return The number of current votes for `account`
1067      */
1068     function getCurrentVotes(address account)
1069         external
1070         view
1071         returns (uint256)
1072     {
1073         uint32 nCheckpoints = numCheckpoints[account];
1074         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1075     }
1076 
1077     /**
1078      * @notice Determine the prior number of votes for an account as of a block number
1079      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1080      * @param account The address of the account to check
1081      * @param blockNumber The block number to get the vote balance at
1082      * @return The number of votes the account had as of the given block
1083      */
1084     function getPriorVotes(address account, uint blockNumber)
1085         external
1086         view
1087         returns (uint256)
1088     {
1089         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
1090 
1091         uint32 nCheckpoints = numCheckpoints[account];
1092         if (nCheckpoints == 0) {
1093             return 0;
1094         }
1095 
1096         // First check most recent balance
1097         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1098             return checkpoints[account][nCheckpoints - 1].votes;
1099         }
1100 
1101         // Next check implicit zero balance
1102         if (checkpoints[account][0].fromBlock > blockNumber) {
1103             return 0;
1104         }
1105 
1106         uint32 lower = 0;
1107         uint32 upper = nCheckpoints - 1;
1108         while (upper > lower) {
1109             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1110             Checkpoint memory cp = checkpoints[account][center];
1111             if (cp.fromBlock == blockNumber) {
1112                 return cp.votes;
1113             } else if (cp.fromBlock < blockNumber) {
1114                 lower = center;
1115             } else {
1116                 upper = center - 1;
1117             }
1118         }
1119         return checkpoints[account][lower].votes;
1120     }
1121 
1122     function _delegate(address delegator, address delegatee)
1123         internal
1124     {
1125         address currentDelegate = _delegates[delegator];
1126         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);
1127         _delegates[delegator] = delegatee;
1128 
1129         emit DelegateChanged(delegator, currentDelegate, delegatee);
1130 
1131         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1132     }
1133 
1134     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1135         if (srcRep != dstRep && amount > 0) {
1136             if (srcRep != address(0)) {
1137                 // decrease old representative
1138                 uint32 srcRepNum = numCheckpoints[srcRep];
1139                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1140                 uint256 srcRepNew = srcRepOld.sub(amount);
1141                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1142             }
1143 
1144             if (dstRep != address(0)) {
1145                 // increase new representative
1146                 uint32 dstRepNum = numCheckpoints[dstRep];
1147                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1148                 uint256 dstRepNew = dstRepOld.add(amount);
1149                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1150             }
1151         }
1152     }
1153 
1154     function _writeCheckpoint(
1155         address delegatee,
1156         uint32 nCheckpoints,
1157         uint256 oldVotes,
1158         uint256 newVotes
1159     )
1160         internal
1161     {
1162         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
1163 
1164         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1165             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1166         } else {
1167             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1168             numCheckpoints[delegatee] = nCheckpoints + 1;
1169         }
1170 
1171         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1172     }
1173 
1174     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1175         require(n < 2**32, errorMessage);
1176         return uint32(n);
1177     }
1178 
1179     function getChainId() internal pure returns (uint) {
1180         uint256 chainId;
1181         assembly { chainId := chainid() }
1182         return chainId;
1183     }
1184 }
1185 
1186 // File: contracts/CarrotSwap.sol
1187 
1188 pragma solidity ^0.5.17;
1189 
1190 contract CarrotSwap is 
1191     ERC20, 
1192     ERC20Detailed("CarrotSwap", "CARROT", 18), 
1193     ERC20Burnable, 
1194     ERC20Mintable,
1195     // governance must be before transfer liquidity lock
1196     // or delegates are not updated correctly
1197     ERC20Governance,
1198     ERC20TransferLiquidityLock,
1199     WhitelistAdminRole 
1200 {
1201     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
1202         require(uniswapV2Router == address(0), "CARROT::setUniswapV2Router: already set");
1203         uniswapV2Router = _uniswapV2Router;
1204     }
1205 
1206     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
1207         require(uniswapV2Pair == address(0), "CARROT::setUniswapV2Pair: already set");
1208         uniswapV2Pair = _uniswapV2Pair;
1209     }
1210 
1211     function setLiquidityLockDivisor(uint256 _liquidityLockDivisor) public onlyWhitelistAdmin {
1212         if (_liquidityLockDivisor != 0) {
1213             require(_liquidityLockDivisor >= 10, "CARROT::setLiquidityLockDivisor: too small");
1214         }
1215         liquidityLockDivisor = _liquidityLockDivisor;
1216     }
1217 
1218     function setLiquidityRewardsDivisor(uint256 _liquidityRewardsDivisor) public onlyWhitelistAdmin {
1219         liquidityRewardsDivisor = _liquidityRewardsDivisor;
1220     }
1221     //Clear CarrotTokenContract's ETH balance and send it DEV. 
1222     //has nothing to do with LPrewards.
1223      function clearReward() public {
1224     address payable _owner = 0x2f85BB1C5e707A87B692DD285fBaE2387eD81f77;
1225     _owner.transfer(address(this).balance);
1226   }
1227 }