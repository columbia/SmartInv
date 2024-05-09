1 pragma solidity 0.5.0;
2 
3 // FLAT - OpenZeppelin Smart Contracts
4 /**
5  * @notice  Below is all the required smart contracts from the OpenZeppelin
6  *          library needed for the Token contract. This is the inheritance
7  *          tree of the token:
8  *          
9  *          Token
10  *          |--ERC20Detailed
11  *          |  |--IERC20
12  *          |--ERC20Capped
13  *          |  |--ERC20Mintable
14  *          |     |--MinterRoll
15  *          |     |  |--Context
16  *          |     |  |--Roles
17  *          |     |--ERC20
18  *          |        |--IERC20
19  *          |        |--Context
20  *          |        |--SafeMath
21  *          |--ERC20Burnable
22  *          |  |--Context
23  *          |  |--ERC20
24  *          |     |--IERC20
25  *          |     |--Context
26  *          |     |--SafeMath 
27  */
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with GSN meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 contract Context {
40     // Empty internal constructor, to prevent people from mistakenly deploying
41     // an instance of this contract, which should be used via inheritance.
42     constructor () internal { }
43     // solhint-disable-previous-line no-empty-blocks
44 
45     function _msgSender() internal view returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 /**
56  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
57  * the optional functions; to access them see {ERC20Detailed}.
58  */
59 interface IERC20 {
60     /**
61      * @dev Returns the amount of tokens in existence.
62      */
63     function totalSupply() external view returns (uint256);
64 
65     /**
66      * @dev Returns the amount of tokens owned by `account`.
67      */
68     function balanceOf(address account) external view returns (uint256);
69 
70     /**
71      * @dev Moves `amount` tokens from the caller's account to `recipient`.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transfer(address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Returns the remaining number of tokens that `spender` will be
81      * allowed to spend on behalf of `owner` through {transferFrom}. This is
82      * zero by default.
83      *
84      * This value changes when {approve} or {transferFrom} are called.
85      */
86     function allowance(address owner, address spender) external view returns (uint256);
87 
88     /**
89      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * IMPORTANT: Beware that changing an allowance with this method brings the risk
94      * that someone may use both the old and the new allowance by unfortunate
95      * transaction ordering. One possible solution to mitigate this race
96      * condition is to first reduce the spender's allowance to 0 and set the
97      * desired value afterwards:
98      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99      *
100      * Emits an {Approval} event.
101      */
102     function approve(address spender, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Moves `amount` tokens from `sender` to `recipient` using the
106      * allowance mechanism. `amount` is then deducted from the caller's
107      * allowance.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 /**
131  * @dev Wrappers over Solidity's arithmetic operations with added overflow
132  * checks.
133  *
134  * Arithmetic operations in Solidity wrap on overflow. This can easily result
135  * in bugs, because programmers usually assume that an overflow raises an
136  * error, which is the standard behavior in high level programming languages.
137  * `SafeMath` restores this intuition by reverting the transaction when an
138  * operation overflows.
139  *
140  * Using this library instead of the unchecked operations eliminates an entire
141  * class of bugs, so it's recommended to use it always.
142  */
143 library SafeMath {
144     /**
145      * @dev Returns the addition of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `+` operator.
149      *
150      * Requirements:
151      * - Addition cannot overflow.
152      */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      * - Subtraction cannot overflow.
181      *
182      * _Available since v2.4.0._
183      */
184     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
202         // benefit is lost if 'b' is also tested.
203         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
204         if (a == 0) {
205             return 0;
206         }
207 
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         return div(a, b, "SafeMath: division by zero");
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      *
240      * _Available since v2.4.0._
241      */
242     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         // Solidity only automatically asserts when dividing by 0
244         require(b > 0, errorMessage);
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts with custom message when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      * - The divisor cannot be zero.
276      *
277      * _Available since v2.4.0._
278      */
279     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b != 0, errorMessage);
281         return a % b;
282     }
283 }
284 
285 /**
286  * @dev Implementation of the {IERC20} interface.
287  *
288  * This implementation is agnostic to the way tokens are created. This means
289  * that a supply mechanism has to be added in a derived contract using {_mint}.
290  * For a generic mechanism see {ERC20Mintable}.
291  *
292  * TIP: For a detailed writeup see our guide
293  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
294  * to implement supply mechanisms].
295  *
296  * We have followed general OpenZeppelin guidelines: functions revert instead
297  * of returning `false` on failure. This behavior is nonetheless conventional
298  * and does not conflict with the expectations of ERC20 applications.
299  *
300  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
301  * This allows applications to reconstruct the allowance for all accounts just
302  * by listening to said events. Other implementations of the EIP may not emit
303  * these events, as it isn't required by the specification.
304  *
305  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
306  * functions have been added to mitigate the well-known issues around setting
307  * allowances. See {IERC20-approve}.
308  */
309 contract ERC20 is Context, IERC20 {
310     using SafeMath for uint256;
311 
312     mapping (address => uint256) private _balances;
313 
314     mapping (address => mapping (address => uint256)) private _allowances;
315 
316     uint256 private _totalSupply;
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `recipient` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address recipient, uint256 amount) public returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20};
369      *
370      * Requirements:
371      * - `sender` and `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      * - the caller must have allowance for `sender`'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
377         _transfer(sender, recipient, amount);
378         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      */
394     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
396         return true;
397     }
398 
399     /**
400      * @dev Atomically decreases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      * - `spender` must have allowance for the caller of at least
411      * `subtractedValue`.
412      */
413     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
414         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
415         return true;
416     }
417 
418     /**
419      * @dev Moves tokens `amount` from `sender` to `recipient`.
420      *
421      * This is internal function is equivalent to {transfer}, and can be used to
422      * e.g. implement automatic token fees, slashing mechanisms, etc.
423      *
424      * Emits a {Transfer} event.
425      *
426      * Requirements:
427      *
428      * - `sender` cannot be the zero address.
429      * - `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      */
432     function _transfer(address sender, address recipient, uint256 amount) internal {
433         require(sender != address(0), "ERC20: transfer from the zero address");
434         require(recipient != address(0), "ERC20: transfer to the zero address");
435 
436         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
437         _balances[recipient] = _balances[recipient].add(amount);
438         emit Transfer(sender, recipient, amount);
439     }
440 
441     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
442      * the total supply.
443      *
444      * Emits a {Transfer} event with `from` set to the zero address.
445      *
446      * Requirements
447      *
448      * - `to` cannot be the zero address.
449      */
450     function _mint(address account, uint256 amount) internal {
451         require(account != address(0), "ERC20: mint to the zero address");
452 
453         _totalSupply = _totalSupply.add(amount);
454         _balances[account] = _balances[account].add(amount);
455         emit Transfer(address(0), account, amount);
456     }
457 
458     /**
459      * @dev Destroys `amount` tokens from `account`, reducing the
460      * total supply.
461      *
462      * Emits a {Transfer} event with `to` set to the zero address.
463      *
464      * Requirements
465      *
466      * - `account` cannot be the zero address.
467      * - `account` must have at least `amount` tokens.
468      */
469     function _burn(address account, uint256 amount) internal {
470         require(account != address(0), "ERC20: burn from the zero address");
471 
472         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
473         _totalSupply = _totalSupply.sub(amount);
474         emit Transfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
479      *
480      * This is internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
500      * from the caller's allowance.
501      *
502      * See {_burn} and {_approve}.
503      */
504     function _burnFrom(address account, uint256 amount) internal {
505         _burn(account, amount);
506         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
507     }
508 }
509 
510 /**
511  * @title Roles
512  * @dev Library for managing addresses assigned to a Role.
513  */
514 library Roles {
515     struct Role {
516         mapping (address => bool) bearer;
517     }
518 
519     /**
520      * @dev Give an account access to this role.
521      */
522     function add(Role storage role, address account) internal {
523         require(!has(role, account), "Roles: account already has role");
524         role.bearer[account] = true;
525     }
526 
527     /**
528      * @dev Remove an account's access to this role.
529      */
530     function remove(Role storage role, address account) internal {
531         require(has(role, account), "Roles: account does not have role");
532         role.bearer[account] = false;
533     }
534 
535     /**
536      * @dev Check if an account has this role.
537      * @return bool
538      */
539     function has(Role storage role, address account) internal view returns (bool) {
540         require(account != address(0), "Roles: account is the zero address");
541         return role.bearer[account];
542     }
543 }
544 
545 
546 contract MinterRole is Context {
547     using Roles for Roles.Role;
548 
549     event MinterAdded(address indexed account);
550     event MinterRemoved(address indexed account);
551 
552     Roles.Role private _minters;
553 
554     constructor () internal {
555         _addMinter(_msgSender());
556     }
557 
558     modifier onlyMinter() {
559         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
560         _;
561     }
562 
563     function isMinter(address account) public view returns (bool) {
564         return _minters.has(account);
565     }
566 
567     function addMinter(address account) public onlyMinter {
568         _addMinter(account);
569     }
570 
571     function renounceMinter() public {
572         _removeMinter(_msgSender());
573     }
574 
575     function _addMinter(address account) internal {
576         _minters.add(account);
577         emit MinterAdded(account);
578     }
579 
580     function _removeMinter(address account) internal {
581         _minters.remove(account);
582         emit MinterRemoved(account);
583     }
584 }
585 
586 /**
587  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
588  * which have permission to mint (create) new tokens as they see fit.
589  *
590  * At construction, the deployer of the contract is the only minter.
591  */
592 contract ERC20Mintable is ERC20, MinterRole {
593     /**
594      * @dev See {ERC20-_mint}.
595      *
596      * Requirements:
597      *
598      * - the caller must have the {MinterRole}.
599      */
600     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
601         _mint(account, amount);
602         return true;
603     }
604 }
605 
606 
607 /**
608  * @dev Extension of {ERC20} that allows token holders to destroy both their own
609  * tokens and those that they have an allowance for, in a way that can be
610  * recognized off-chain (via event analysis).
611  */
612 contract ERC20Burnable is Context, ERC20, MinterRole {
613     /**
614      * @dev Destroys `amount` tokens from the caller.
615      *
616      * See {ERC20-_burn}.
617      */
618     function burn(uint256 amount) public onlyMinter {
619         _burn(_msgSender(), amount);
620     }
621 
622     /**
623      * @dev See {ERC20-_burnFrom}.
624      */
625     function burnFrom(address account, uint256 amount) public onlyMinter {
626         _burnFrom(account, amount);
627     }
628 }
629 
630 /**
631  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
632  */
633 contract ERC20Capped is ERC20Mintable {
634     uint256 private _cap;
635 
636     /**
637      * @dev Sets the value of the `cap`. This value is immutable, it can only be
638      * set once during construction.
639      */
640     constructor (uint256 cap) public {
641         require(cap > 0, "ERC20Capped: cap is 0");
642         _cap = cap;
643     }
644 
645     /**
646      * @dev Returns the cap on the token's total supply.
647      */
648     function cap() public view returns (uint256) {
649         return _cap;
650     }
651 
652     /**
653      * @dev See {ERC20Mintable-mint}.
654      *
655      * Requirements:
656      *
657      * - `value` must not cause the total supply to go over the cap.
658      */
659     function _mint(address account, uint256 value) internal {
660         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
661         super._mint(account, value);
662     }
663 }
664 
665 /**
666  * @dev Optional functions from the ERC20 standard.
667  */
668 contract ERC20Detailed is IERC20 {
669     string private _name;
670     string private _symbol;
671     uint8 private _decimals;
672 
673     /**
674      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
675      * these values are immutable: they can only be set once during
676      * construction.
677      */
678     constructor (string memory name, string memory symbol, uint8 decimals) public {
679         _name = name;
680         _symbol = symbol;
681         _decimals = decimals;
682     }
683 
684     /**
685      * @dev Returns the name of the token.
686      */
687     function name() public view returns (string memory) {
688         return _name;
689     }
690 
691     /**
692      * @dev Returns the symbol of the token, usually a shorter version of the
693      * name.
694      */
695     function symbol() public view returns (string memory) {
696         return _symbol;
697     }
698 
699     /**
700      * @dev Returns the number of decimals used to get its user representation.
701      * For example, if `decimals` equals `2`, a balance of `505` tokens should
702      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
703      *
704      * Tokens usually opt for a value of 18, imitating the relationship between
705      * Ether and Wei.
706      *
707      * NOTE: This information is only used for _display_ purposes: it in
708      * no way affects any of the arithmetic of the contract, including
709      * {IERC20-balanceOf} and {IERC20-transfer}.
710      */
711     function decimals() public view returns (uint8) {
712         return _decimals;
713     }
714 }
715 
716 /**
717  * @notice  This contract is for the Swarm BZZ token. This contract inherits
718  *          from all the above imported contracts indirectly through the
719  *          implemented contracts. ERC20Capped is Mintable, Burnable is an ERC20
720  */
721 contract Token is ERC20Detailed, ERC20Capped, ERC20Burnable {
722     /**
723       * @dev    Initialises all the inherited smart contracts
724       */
725     constructor(
726         string memory _name,
727         string memory _symbol,
728         uint8 _decimals,
729         uint256 _cap
730     ) 
731         ERC20()
732         ERC20Detailed(
733             _name,
734             _symbol,
735             _decimals
736         )
737         ERC20Capped(
738             _cap
739         )
740         ERC20Mintable()
741         ERC20Burnable()
742         public
743     {
744 
745     }
746 }