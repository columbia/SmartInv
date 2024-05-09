1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
32  * the optional functions; to access them see {ERC20Detailed}.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      *
157      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
158      * @dev Get it via `npm install @openzeppelin/contracts@next`.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
216      * @dev Get it via `npm install @openzeppelin/contracts@next`.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         // Solidity only automatically asserts when dividing by 0
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      *
253      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
254      * @dev Get it via `npm install @openzeppelin/contracts@next`.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 
263 /**
264  * @dev Implementation of the {IERC20} interface.
265  *
266  * This implementation is agnostic to the way tokens are created. This means
267  * that a supply mechanism has to be added in a derived contract using {_mint}.
268  * For a generic mechanism see {ERC20Mintable}.
269  *
270  * TIP: For a detailed writeup see our guide
271  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
272  * to implement supply mechanisms].
273  *
274  * We have followed general OpenZeppelin guidelines: functions revert instead
275  * of returning `false` on failure. This behavior is nonetheless conventional
276  * and does not conflict with the expectations of ERC20 applications.
277  *
278  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
279  * This allows applications to reconstruct the allowance for all accounts just
280  * by listening to said events. Other implementations of the EIP may not emit
281  * these events, as it isn't required by the specification.
282  *
283  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
284  * functions have been added to mitigate the well-known issues around setting
285  * allowances. See {IERC20-approve}.
286  */
287 contract ERC20 is Context, IERC20 {
288     using SafeMath for uint256;
289 
290     mapping (address => uint256) private _balances;
291 
292     mapping (address => mapping (address => uint256)) private _allowances;
293 
294     uint256 private _totalSupply;
295 
296     /**
297      * @dev See {IERC20-totalSupply}.
298      */
299     function totalSupply() public view returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev See {IERC20-balanceOf}.
305      */
306     function balanceOf(address account) public view returns (uint256) {
307         return _balances[account];
308     }
309 
310     /**
311      * @dev See {IERC20-transfer}.
312      *
313      * Requirements:
314      *
315      * - `recipient` cannot be the zero address.
316      * - the caller must have a balance of at least `amount`.
317      */
318     function transfer(address recipient, uint256 amount) public returns (bool) {
319         _transfer(_msgSender(), recipient, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function approve(address spender, uint256 amount) public returns (bool) {
338         _approve(_msgSender(), spender, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-transferFrom}.
344      *
345      * Emits an {Approval} event indicating the updated allowance. This is not
346      * required by the EIP. See the note at the beginning of {ERC20};
347      *
348      * Requirements:
349      * - `sender` and `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      * - the caller must have allowance for `sender`'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
355         _transfer(sender, recipient, amount);
356         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
357         return true;
358     }
359 
360     /**
361      * @dev Atomically increases the allowance granted to `spender` by the caller.
362      *
363      * This is an alternative to {approve} that can be used as a mitigation for
364      * problems described in {IERC20-approve}.
365      *
366      * Emits an {Approval} event indicating the updated allowance.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
373         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
374         return true;
375     }
376 
377     /**
378      * @dev Atomically decreases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      * - `spender` must have allowance for the caller of at least
389      * `subtractedValue`.
390      */
391     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
392         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
393         return true;
394     }
395 
396     /**
397      * @dev Moves tokens `amount` from `sender` to `recipient`.
398      *
399      * This is internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(address sender, address recipient, uint256 amount) internal {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
415         _balances[recipient] = _balances[recipient].add(amount);
416         emit Transfer(sender, recipient, amount);
417     }
418 
419     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
420      * the total supply.
421      *
422      * Emits a {Transfer} event with `from` set to the zero address.
423      *
424      * Requirements
425      *
426      * - `to` cannot be the zero address.
427      */
428     function _mint(address account, uint256 amount) internal {
429         require(account != address(0), "ERC20: mint to the zero address");
430 
431         _totalSupply = _totalSupply.add(amount);
432         _balances[account] = _balances[account].add(amount);
433         emit Transfer(address(0), account, amount);
434     }
435 
436     /**
437      * @dev Destroys `amount` tokens from `account`, reducing the
438      * total supply.
439      *
440      * Emits a {Transfer} event with `to` set to the zero address.
441      *
442      * Requirements
443      *
444      * - `account` cannot be the zero address.
445      * - `account` must have at least `amount` tokens.
446      */
447     function _burn(address account, uint256 amount) internal {
448         require(account != address(0), "ERC20: burn from the zero address");
449 
450         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
451         _totalSupply = _totalSupply.sub(amount);
452         emit Transfer(account, address(0), amount);
453     }
454 
455     /**
456      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
457      *
458      * This is internal function is equivalent to `approve`, and can be used to
459      * e.g. set automatic allowances for certain subsystems, etc.
460      *
461      * Emits an {Approval} event.
462      *
463      * Requirements:
464      *
465      * - `owner` cannot be the zero address.
466      * - `spender` cannot be the zero address.
467      */
468     function _approve(address owner, address spender, uint256 amount) internal {
469         require(owner != address(0), "ERC20: approve from the zero address");
470         require(spender != address(0), "ERC20: approve to the zero address");
471 
472         _allowances[owner][spender] = amount;
473         emit Approval(owner, spender, amount);
474     }
475 
476     /**
477      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
478      * from the caller's allowance.
479      *
480      * See {_burn} and {_approve}.
481      */
482     function _burnFrom(address account, uint256 amount) internal {
483         _burn(account, amount);
484         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
485     }
486 }
487 
488 
489 /**
490  * @dev Optional functions from the ERC20 standard.
491  */
492 contract ERC20Detailed is IERC20 {
493     string private _name;
494     string private _symbol;
495     uint8 private _decimals;
496 
497     /**
498      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
499      * these values are immutable: they can only be set once during
500      * construction.
501      */
502     constructor (string memory name, string memory symbol, uint8 decimals) public {
503         _name = name;
504         _symbol = symbol;
505         _decimals = decimals;
506     }
507 
508     /**
509      * @dev Returns the name of the token.
510      */
511     function name() public view returns (string memory) {
512         return _name;
513     }
514 
515     /**
516      * @dev Returns the symbol of the token, usually a shorter version of the
517      * name.
518      */
519     function symbol() public view returns (string memory) {
520         return _symbol;
521     }
522 
523     /**
524      * @dev Returns the number of decimals used to get its user representation.
525      * For example, if `decimals` equals `2`, a balance of `505` tokens should
526      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
527      *
528      * Tokens usually opt for a value of 18, imitating the relationship between
529      * Ether and Wei.
530      *
531      * NOTE: This information is only used for _display_ purposes: it in
532      * no way affects any of the arithmetic of the contract, including
533      * {IERC20-balanceOf} and {IERC20-transfer}.
534      */
535     function decimals() public view returns (uint8) {
536         return _decimals;
537     }
538 }
539 
540 
541 /**
542  * @title Roles
543  * @dev Library for managing addresses assigned to a Role.
544  */
545 library Roles {
546     struct Role {
547         mapping (address => bool) bearer;
548     }
549 
550     /**
551      * @dev Give an account access to this role.
552      */
553     function add(Role storage role, address account) internal {
554         require(!has(role, account), "Roles: account already has role");
555         role.bearer[account] = true;
556     }
557 
558     /**
559      * @dev Remove an account's access to this role.
560      */
561     function remove(Role storage role, address account) internal {
562         require(has(role, account), "Roles: account does not have role");
563         role.bearer[account] = false;
564     }
565 
566     /**
567      * @dev Check if an account has this role.
568      * @return bool
569      */
570     function has(Role storage role, address account) internal view returns (bool) {
571         require(account != address(0), "Roles: account is the zero address");
572         return role.bearer[account];
573     }
574 }
575 
576 
577 contract MinterRole is Context {
578     using Roles for Roles.Role;
579 
580     event MinterAdded(address indexed account);
581     event MinterRemoved(address indexed account);
582 
583     Roles.Role private _minters;
584 
585     constructor () internal {
586         _addMinter(0x6cdFB19632E4D0805064B741d39c6Ff0A9141952);
587     }
588     
589     modifier onlyMinter() {
590         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
591         _;
592     }
593 
594     function isMinter(address account) public view returns (bool) {
595         return _minters.has(account);
596     }
597 
598     function addMinter(address account) public onlyMinter {
599         _addMinter(account);
600     }
601 
602     function renounceMinter() public {
603         _removeMinter(_msgSender());
604     }
605 
606     function _addMinter(address account) internal {
607         _minters.add(account);
608         emit MinterAdded(account);
609     }
610 
611     function _removeMinter(address account) internal {
612         _minters.remove(account);
613         emit MinterRemoved(account);
614     }
615 }
616 
617 /**
618  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
619  * which have permission to mint (create) new tokens as they see fit.
620  *
621  * At construction, the deployer of the contract is the only minter.
622  */
623 contract ERC20Mintable is ERC20, MinterRole {
624     /**
625      * @dev See {ERC20-_mint}.
626      *
627      * Requirements:
628      *
629      * - the caller must have the {MinterRole}.
630      */
631     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
632         _mint(account, amount);
633         return true;
634     }
635 }
636 
637 
638 /**
639  * @dev Extension of {ERC20} that allows token holders to destroy both their own
640  * tokens and those that they have an allowance for, in a way that can be
641  * recognized off-chain (via event analysis).
642  */
643 contract ERC20Burnable is Context, ERC20 {
644     /**
645      * @dev Destroys `amount` tokens from the caller.
646      *
647      * See {ERC20-_burn}.
648      */
649     function burn(uint256 amount) public {
650         _burn(_msgSender(), amount);
651     }
652 
653     /**
654      * @dev See {ERC20-_burnFrom}.
655      */
656     function burnFrom(address account, uint256 amount) public {
657         _burnFrom(account, amount);
658     }
659 }
660 
661 
662 /**
663  * @title MobileMiningToken
664  * @dev MobileMiningToken ERC20 Token, where all tokens are pre-assigned to the owner.
665  * Note they can later distribute these tokens as they wish using `transfer` and other
666  * `ERC20` functions.
667  */
668  contract MobileMiningToken is Context, ERC20Detailed, ERC20Mintable, ERC20Burnable {
669 
670     /**
671      * @dev Constructor that gives _msgSender() all of existing tokens.
672      */
673     constructor () public ERC20Detailed("Mobile Mining Token", "MMTN", 2) {
674         _mint(0x6cdFB19632E4D0805064B741d39c6Ff0A9141952, 1250000000 * (10 ** uint256(decimals())));
675     }
676  
677     function transferMulti(address[] memory recipients, uint256[] memory amounts) public returns (bool) {
678         for (uint i = 0; i < recipients.length; i++) {
679             if (amounts[i] > 0) {
680                 if (recipients[i] == address(0)) {
681                     _burn(_msgSender(), amounts[i]);
682                 } else {
683                     _transfer(_msgSender(), recipients[i], amounts[i]);
684                 }
685             }
686         }
687         return true;
688     }
689 
690 }