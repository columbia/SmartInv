1 /**
2  * @dev Wrappers over Solidity's arithmetic operations with added overflow
3  * checks.
4  *
5  * Arithmetic operations in Solidity wrap on overflow. This can easily result
6  * in bugs, because programmers usually assume that an overflow raises an
7  * error, which is the standard behavior in high level programming languages.
8  * `SafeMath` restores this intuition by reverting the transaction when an
9  * operation overflows.
10  *
11  * Using this library instead of the unchecked operations eliminates an entire
12  * class of bugs, so it's recommended to use it always.
13  */
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, reverting on
17      * overflow.
18      *
19      * Counterpart to Solidity's `+` operator.
20      *
21      * Requirements:
22      * - Addition cannot overflow.
23      */
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30 
31     /**
32      * @dev Returns the subtraction of two unsigned integers, reverting on
33      * overflow (when the result is negative).
34      *
35      * Counterpart to Solidity's `-` operator.
36      *
37      * Requirements:
38      * - Subtraction cannot overflow.
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      *
53      * _Available since v2.4.0._
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
110      *
111      * _Available since v2.4.0._
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      *
148      * _Available since v2.4.0._
149      */
150     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 
157 
158 /*
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with GSN meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 contract Context {
169     // Empty internal constructor, to prevent people from mistakenly deploying
170     // an instance of this contract, which should be used via inheritance.
171     constructor () internal { }
172     // solhint-disable-previous-line no-empty-blocks
173 
174     function _msgSender() internal view returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 
185 /**
186  * @title Roles
187  * @dev Library for managing addresses assigned to a Role.
188  */
189 library Roles {
190     struct Role {
191         mapping (address => bool) bearer;
192     }
193 
194     /**
195      * @dev Give an account access to this role.
196      */
197     function add(Role storage role, address account) internal {
198         require(!has(role, account), "Roles: account already has role");
199         role.bearer[account] = true;
200     }
201 
202     /**
203      * @dev Remove an account's access to this role.
204      */
205     function remove(Role storage role, address account) internal {
206         require(has(role, account), "Roles: account does not have role");
207         role.bearer[account] = false;
208     }
209 
210     /**
211      * @dev Check if an account has this role.
212      * @return bool
213      */
214     function has(Role storage role, address account) internal view returns (bool) {
215         require(account != address(0), "Roles: account is the zero address");
216         return role.bearer[account];
217     }
218 }
219 
220 
221 contract PauserRole is Context {
222     using Roles for Roles.Role;
223 
224     event PauserAdded(address indexed account);
225     event PauserRemoved(address indexed account);
226 
227     Roles.Role private _pausers;
228 
229     constructor () internal {
230         _addPauser(_msgSender());
231     }
232 
233     modifier onlyPauser() {
234         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
235         _;
236     }
237 
238     function isPauser(address account) public view returns (bool) {
239         return _pausers.has(account);
240     }
241 
242     function addPauser(address account) public onlyPauser {
243         _addPauser(account);
244     }
245 
246     function renouncePauser() public {
247         _removePauser(_msgSender());
248     }
249 
250     function _addPauser(address account) internal {
251         _pausers.add(account);
252         emit PauserAdded(account);
253     }
254 
255     function _removePauser(address account) internal {
256         _pausers.remove(account);
257         emit PauserRemoved(account);
258     }
259 }
260 
261 
262 contract MinterRole is Context {
263     using Roles for Roles.Role;
264 
265     event MinterAdded(address indexed account);
266     event MinterRemoved(address indexed account);
267 
268     Roles.Role private _minters;
269 
270     constructor () internal {
271         _addMinter(_msgSender());
272     }
273 
274     modifier onlyMinter() {
275         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
276         _;
277     }
278 
279     function isMinter(address account) public view returns (bool) {
280         return _minters.has(account);
281     }
282 
283     function addMinter(address account) public onlyMinter {
284         _addMinter(account);
285     }
286 
287     function renounceMinter() public {
288         _removeMinter(_msgSender());
289     }
290 
291     function _addMinter(address account) internal {
292         _minters.add(account);
293         emit MinterAdded(account);
294     }
295 
296     function _removeMinter(address account) internal {
297         _minters.remove(account);
298         emit MinterRemoved(account);
299     }
300 }
301 
302 
303 
304 /**
305  * @dev Contract module which allows children to implement an emergency stop
306  * mechanism that can be triggered by an authorized account.
307  *
308  * This module is used through inheritance. It will make available the
309  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
310  * the functions of your contract. Note that they will not be pausable by
311  * simply including this module, only once the modifiers are put in place.
312  */
313 contract Pausable is Context, PauserRole {
314     /**
315      * @dev Emitted when the pause is triggered by a pauser (`account`).
316      */
317     event Paused(address account);
318 
319     /**
320      * @dev Emitted when the pause is lifted by a pauser (`account`).
321      */
322     event Unpaused(address account);
323 
324     bool private _paused;
325 
326     /**
327      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
328      * to the deployer.
329      */
330     constructor () internal {
331         _paused = false;
332     }
333 
334     /**
335      * @dev Returns true if the contract is paused, and false otherwise.
336      */
337     function paused() public view returns (bool) {
338         return _paused;
339     }
340 
341     /**
342      * @dev Modifier to make a function callable only when the contract is not paused.
343      */
344     modifier whenNotPaused() {
345         require(!_paused, "Pausable: paused");
346         _;
347     }
348 
349     /**
350      * @dev Modifier to make a function callable only when the contract is paused.
351      */
352     modifier whenPaused() {
353         require(_paused, "Pausable: not paused");
354         _;
355     }
356 
357     /**
358      * @dev Called by a pauser to pause, triggers stopped state.
359      */
360     function pause() public onlyPauser whenNotPaused {
361         _paused = true;
362         emit Paused(_msgSender());
363     }
364 
365     /**
366      * @dev Called by a pauser to unpause, returns to normal state.
367      */
368     function unpause() public onlyPauser whenPaused {
369         _paused = false;
370         emit Unpaused(_msgSender());
371     }
372 }
373 
374 
375 /**
376  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
377  * the optional functions; to access them see {ERC20Detailed}.
378  */
379 interface IERC20 {
380     /**
381      * @dev Returns the amount of tokens in existence.
382      */
383     function totalSupply() external view returns (uint256);
384 
385     /**
386      * @dev Returns the amount of tokens owned by `account`.
387      */
388     function balanceOf(address account) external view returns (uint256);
389 
390     /**
391      * @dev Moves `amount` tokens from the caller's account to `recipient`.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transfer(address recipient, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Returns the remaining number of tokens that `spender` will be
401      * allowed to spend on behalf of `owner` through {transferFrom}. This is
402      * zero by default.
403      *
404      * This value changes when {approve} or {transferFrom} are called.
405      */
406     function allowance(address owner, address spender) external view returns (uint256);
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * IMPORTANT: Beware that changing an allowance with this method brings the risk
414      * that someone may use both the old and the new allowance by unfortunate
415      * transaction ordering. One possible solution to mitigate this race
416      * condition is to first reduce the spender's allowance to 0 and set the
417      * desired value afterwards:
418      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
419      *
420      * Emits an {Approval} event.
421      */
422     function approve(address spender, uint256 amount) external returns (bool);
423 
424     /**
425      * @dev Moves `amount` tokens from `sender` to `recipient` using the
426      * allowance mechanism. `amount` is then deducted from the caller's
427      * allowance.
428      *
429      * Returns a boolean value indicating whether the operation succeeded.
430      *
431      * Emits a {Transfer} event.
432      */
433     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
434 
435     /**
436      * @dev Emitted when `value` tokens are moved from one account (`from`) to
437      * another (`to`).
438      *
439      * Note that `value` may be zero.
440      */
441     event Transfer(address indexed from, address indexed to, uint256 value);
442 
443     /**
444      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
445      * a call to {approve}. `value` is the new allowance.
446      */
447     event Approval(address indexed owner, address indexed spender, uint256 value);
448 }
449 
450 
451 
452 /**
453  * @dev Implementation of the {IERC20} interface.
454  *
455  * This implementation is agnostic to the way tokens are created. This means
456  * that a supply mechanism has to be added in a derived contract using {_mint}.
457  * For a generic mechanism see {ERC20Mintable}.
458  *
459  * TIP: For a detailed writeup see our guide
460  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
461  * to implement supply mechanisms].
462  *
463  * We have followed general OpenZeppelin guidelines: functions revert instead
464  * of returning `false` on failure. This behavior is nonetheless conventional
465  * and does not conflict with the expectations of ERC20 applications.
466  *
467  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
468  * This allows applications to reconstruct the allowance for all accounts just
469  * by listening to said events. Other implementations of the EIP may not emit
470  * these events, as it isn't required by the specification.
471  *
472  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
473  * functions have been added to mitigate the well-known issues around setting
474  * allowances. See {IERC20-approve}.
475  */
476 contract ERC20 is Context, IERC20 {
477     using SafeMath for uint256;
478 
479     mapping (address => uint256) private _balances;
480 
481     mapping (address => mapping (address => uint256)) private _allowances;
482 
483     uint256 private _totalSupply;
484 
485     /**
486      * @dev See {IERC20-totalSupply}.
487      */
488     function totalSupply() public view returns (uint256) {
489         return _totalSupply;
490     }
491 
492     /**
493      * @dev See {IERC20-balanceOf}.
494      */
495     function balanceOf(address account) public view returns (uint256) {
496         return _balances[account];
497     }
498 
499     /**
500      * @dev See {IERC20-transfer}.
501      *
502      * Requirements:
503      *
504      * - `recipient` cannot be the zero address.
505      * - the caller must have a balance of at least `amount`.
506      */
507     function transfer(address recipient, uint256 amount) public returns (bool) {
508         _transfer(_msgSender(), recipient, amount);
509         return true;
510     }
511 
512     /**
513      * @dev See {IERC20-allowance}.
514      */
515     function allowance(address owner, address spender) public view returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     /**
520      * @dev See {IERC20-approve}.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function approve(address spender, uint256 amount) public returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-transferFrom}.
533      *
534      * Emits an {Approval} event indicating the updated allowance. This is not
535      * required by the EIP. See the note at the beginning of {ERC20};
536      *
537      * Requirements:
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for `sender`'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Moves tokens `amount` from `sender` to `recipient`.
587      *
588      * This is internal function is equivalent to {transfer}, and can be used to
589      * e.g. implement automatic token fees, slashing mechanisms, etc.
590      *
591      * Emits a {Transfer} event.
592      *
593      * Requirements:
594      *
595      * - `sender` cannot be the zero address.
596      * - `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      */
599     function _transfer(address sender, address recipient, uint256 amount) internal {
600         require(sender != address(0), "ERC20: transfer from the zero address");
601         require(recipient != address(0), "ERC20: transfer to the zero address");
602 
603         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
604         _balances[recipient] = _balances[recipient].add(amount);
605         emit Transfer(sender, recipient, amount);
606     }
607 
608     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
609      * the total supply.
610      *
611      * Emits a {Transfer} event with `from` set to the zero address.
612      *
613      * Requirements
614      *
615      * - `to` cannot be the zero address.
616      */
617     function _mint(address account, uint256 amount) internal {
618         require(account != address(0), "ERC20: mint to the zero address");
619 
620         _totalSupply = _totalSupply.add(amount);
621         _balances[account] = _balances[account].add(amount);
622         emit Transfer(address(0), account, amount);
623     }
624 
625     /**
626      * @dev Destroys `amount` tokens from `account`, reducing the
627      * total supply.
628      *
629      * Emits a {Transfer} event with `to` set to the zero address.
630      *
631      * Requirements
632      *
633      * - `account` cannot be the zero address.
634      * - `account` must have at least `amount` tokens.
635      */
636     function _burn(address account, uint256 amount) internal {
637         require(account != address(0), "ERC20: burn from the zero address");
638 
639         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
640         _totalSupply = _totalSupply.sub(amount);
641         emit Transfer(account, address(0), amount);
642     }
643 
644     /**
645      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
646      *
647      * This is internal function is equivalent to `approve`, and can be used to
648      * e.g. set automatic allowances for certain subsystems, etc.
649      *
650      * Emits an {Approval} event.
651      *
652      * Requirements:
653      *
654      * - `owner` cannot be the zero address.
655      * - `spender` cannot be the zero address.
656      */
657     function _approve(address owner, address spender, uint256 amount) internal {
658         require(owner != address(0), "ERC20: approve from the zero address");
659         require(spender != address(0), "ERC20: approve to the zero address");
660 
661         _allowances[owner][spender] = amount;
662         emit Approval(owner, spender, amount);
663     }
664 
665     /**
666      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
667      * from the caller's allowance.
668      *
669      * See {_burn} and {_approve}.
670      */
671     function _burnFrom(address account, uint256 amount) internal {
672         _burn(account, amount);
673         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
674     }
675 }
676 
677 
678 /**
679  * @title Pausable token
680  * @dev ERC20 with pausable transfers and allowances.
681  *
682  * Useful if you want to stop trades until the end of a crowdsale, or have
683  * an emergency switch for freezing all token transfers in the event of a large
684  * bug.
685  */
686 contract ERC20Pausable is ERC20, Pausable {
687     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
688         return super.transfer(to, value);
689     }
690 
691     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
692         return super.transferFrom(from, to, value);
693     }
694 
695     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
696         return super.approve(spender, value);
697     }
698 
699     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
700         return super.increaseAllowance(spender, addedValue);
701     }
702 
703     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
704         return super.decreaseAllowance(spender, subtractedValue);
705     }
706 }
707 
708 /**
709  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
710  * which have permission to mint (create) new tokens as they see fit.
711  *
712  * At construction, the deployer of the contract is the only minter.
713  */
714 contract ERC20Mintable is ERC20, MinterRole {
715     /**
716      * @dev See {ERC20-_mint}.
717      *
718      * Requirements:
719      *
720      * - the caller must have the {MinterRole}.
721      */
722     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
723         _mint(account, amount);
724         return true;
725     }
726 }
727 
728 
729 
730 contract CBERC20Token is ERC20Mintable, ERC20Pausable {
731 	  string public constant name = "CAPTAIN";
732 		string public constant symbol = "CAPT";
733 		uint8 public constant decimals = 18;
734 
735 		/**
736 		* @dev Constructor that gives _initialBeneficiar all of existing tokens.
737 		*/
738 		constructor(address _initialBeneficiar) public {
739 				uint256 INITIAL_SUPPLY = 2100000000 * (10 ** uint256(decimals));
740 				_mint(_initialBeneficiar, INITIAL_SUPPLY);
741 		}
742 }