1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         _owner = _msgSender();
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
110 
111 pragma solidity ^0.5.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
115  * the optional functions; to access them see {ERC20Detailed}.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
189 
190 pragma solidity ^0.5.0;
191 
192 
193 /**
194  * @dev Optional functions from the ERC20 standard.
195  */
196 contract ERC20Detailed is IERC20 {
197     string private _name;
198     string private _symbol;
199     uint8 private _decimals;
200 
201     /**
202      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
203      * these values are immutable: they can only be set once during
204      * construction.
205      */
206     constructor (string memory name, string memory symbol, uint8 decimals) public {
207         _name = name;
208         _symbol = symbol;
209         _decimals = decimals;
210     }
211 
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view returns (string memory) {
216         return _name;
217     }
218 
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view returns (string memory) {
224         return _symbol;
225     }
226 
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei.
234      *
235      * NOTE: This information is only used for _display_ purposes: it in
236      * no way affects any of the arithmetic of the contract, including
237      * {IERC20-balanceOf} and {IERC20-transfer}.
238      */
239     function decimals() public view returns (uint8) {
240         return _decimals;
241     }
242 }
243 
244 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
245 
246 pragma solidity ^0.5.0;
247 
248 /**
249  * @dev Wrappers over Solidity's arithmetic operations with added overflow
250  * checks.
251  *
252  * Arithmetic operations in Solidity wrap on overflow. This can easily result
253  * in bugs, because programmers usually assume that an overflow raises an
254  * error, which is the standard behavior in high level programming languages.
255  * `SafeMath` restores this intuition by reverting the transaction when an
256  * operation overflows.
257  *
258  * Using this library instead of the unchecked operations eliminates an entire
259  * class of bugs, so it's recommended to use it always.
260  */
261 library SafeMath {
262     /**
263      * @dev Returns the addition of two unsigned integers, reverting on
264      * overflow.
265      *
266      * Counterpart to Solidity's `+` operator.
267      *
268      * Requirements:
269      * - Addition cannot overflow.
270      */
271     function add(uint256 a, uint256 b) internal pure returns (uint256) {
272         uint256 c = a + b;
273         require(c >= a, "SafeMath: addition overflow");
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, reverting on
280      * overflow (when the result is negative).
281      *
282      * Counterpart to Solidity's `-` operator.
283      *
284      * Requirements:
285      * - Subtraction cannot overflow.
286      */
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return sub(a, b, "SafeMath: subtraction overflow");
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      * - Subtraction cannot overflow.
299      *
300      * _Available since v2.4.0._
301      */
302     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         require(b <= a, errorMessage);
304         uint256 c = a - b;
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the multiplication of two unsigned integers, reverting on
311      * overflow.
312      *
313      * Counterpart to Solidity's `*` operator.
314      *
315      * Requirements:
316      * - Multiplication cannot overflow.
317      */
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
322         if (a == 0) {
323             return 0;
324         }
325 
326         uint256 c = a * b;
327         require(c / a == b, "SafeMath: multiplication overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      */
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         return div(a, b, "SafeMath: division by zero");
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      * - The divisor cannot be zero.
357      *
358      * _Available since v2.4.0._
359      */
360     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         // Solidity only automatically asserts when dividing by 0
362         require(b > 0, errorMessage);
363         uint256 c = a / b;
364         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
365 
366         return c;
367     }
368 
369     /**
370      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
371      * Reverts when dividing by zero.
372      *
373      * Counterpart to Solidity's `%` operator. This function uses a `revert`
374      * opcode (which leaves remaining gas untouched) while Solidity uses an
375      * invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      * - The divisor cannot be zero.
379      */
380     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
381         return mod(a, b, "SafeMath: modulo by zero");
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
386      * Reverts with custom message when dividing by zero.
387      *
388      * Counterpart to Solidity's `%` operator. This function uses a `revert`
389      * opcode (which leaves remaining gas untouched) while Solidity uses an
390      * invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      * - The divisor cannot be zero.
394      *
395      * _Available since v2.4.0._
396      */
397     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
398         require(b != 0, errorMessage);
399         return a % b;
400     }
401 }
402 
403 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
404 
405 pragma solidity ^0.5.0;
406 
407 
408 
409 
410 /**
411  * @dev Implementation of the {IERC20} interface.
412  *
413  * This implementation is agnostic to the way tokens are created. This means
414  * that a supply mechanism has to be added in a derived contract using {_mint}.
415  * For a generic mechanism see {ERC20Mintable}.
416  *
417  * TIP: For a detailed writeup see our guide
418  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
419  * to implement supply mechanisms].
420  *
421  * We have followed general OpenZeppelin guidelines: functions revert instead
422  * of returning `false` on failure. This behavior is nonetheless conventional
423  * and does not conflict with the expectations of ERC20 applications.
424  *
425  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
426  * This allows applications to reconstruct the allowance for all accounts just
427  * by listening to said events. Other implementations of the EIP may not emit
428  * these events, as it isn't required by the specification.
429  *
430  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
431  * functions have been added to mitigate the well-known issues around setting
432  * allowances. See {IERC20-approve}.
433  */
434 contract ERC20 is Context, IERC20 {
435     using SafeMath for uint256;
436 
437     mapping (address => uint256) private _balances;
438 
439     mapping (address => mapping (address => uint256)) private _allowances;
440 
441     uint256 private _totalSupply;
442 
443     /**
444      * @dev See {IERC20-totalSupply}.
445      */
446     function totalSupply() public view returns (uint256) {
447         return _totalSupply;
448     }
449 
450     /**
451      * @dev See {IERC20-balanceOf}.
452      */
453     function balanceOf(address account) public view returns (uint256) {
454         return _balances[account];
455     }
456 
457     /**
458      * @dev See {IERC20-transfer}.
459      *
460      * Requirements:
461      *
462      * - `recipient` cannot be the zero address.
463      * - the caller must have a balance of at least `amount`.
464      */
465     function transfer(address recipient, uint256 amount) public returns (bool) {
466         _transfer(_msgSender(), recipient, amount);
467         return true;
468     }
469 
470     /**
471      * @dev See {IERC20-allowance}.
472      */
473     function allowance(address owner, address spender) public view returns (uint256) {
474         return _allowances[owner][spender];
475     }
476 
477     /**
478      * @dev See {IERC20-approve}.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      */
484     function approve(address spender, uint256 amount) public returns (bool) {
485         _approve(_msgSender(), spender, amount);
486         return true;
487     }
488 
489     /**
490      * @dev See {IERC20-transferFrom}.
491      *
492      * Emits an {Approval} event indicating the updated allowance. This is not
493      * required by the EIP. See the note at the beginning of {ERC20};
494      *
495      * Requirements:
496      * - `sender` and `recipient` cannot be the zero address.
497      * - `sender` must have a balance of at least `amount`.
498      * - the caller must have allowance for `sender`'s tokens of at least
499      * `amount`.
500      */
501     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
502         _transfer(sender, recipient, amount);
503         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
504         return true;
505     }
506 
507     /**
508      * @dev Atomically increases the allowance granted to `spender` by the caller.
509      *
510      * This is an alternative to {approve} that can be used as a mitigation for
511      * problems described in {IERC20-approve}.
512      *
513      * Emits an {Approval} event indicating the updated allowance.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      */
519     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
520         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
521         return true;
522     }
523 
524     /**
525      * @dev Atomically decreases the allowance granted to `spender` by the caller.
526      *
527      * This is an alternative to {approve} that can be used as a mitigation for
528      * problems described in {IERC20-approve}.
529      *
530      * Emits an {Approval} event indicating the updated allowance.
531      *
532      * Requirements:
533      *
534      * - `spender` cannot be the zero address.
535      * - `spender` must have allowance for the caller of at least
536      * `subtractedValue`.
537      */
538     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
540         return true;
541     }
542 
543     /**
544      * @dev Moves tokens `amount` from `sender` to `recipient`.
545      *
546      * This is internal function is equivalent to {transfer}, and can be used to
547      * e.g. implement automatic token fees, slashing mechanisms, etc.
548      *
549      * Emits a {Transfer} event.
550      *
551      * Requirements:
552      *
553      * - `sender` cannot be the zero address.
554      * - `recipient` cannot be the zero address.
555      * - `sender` must have a balance of at least `amount`.
556      */
557     function _transfer(address sender, address recipient, uint256 amount) internal {
558         require(sender != address(0), "ERC20: transfer from the zero address");
559         require(recipient != address(0), "ERC20: transfer to the zero address");
560 
561         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
562         _balances[recipient] = _balances[recipient].add(amount);
563         emit Transfer(sender, recipient, amount);
564     }
565 
566     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
567      * the total supply.
568      *
569      * Emits a {Transfer} event with `from` set to the zero address.
570      *
571      * Requirements
572      *
573      * - `to` cannot be the zero address.
574      */
575     function _mint(address account, uint256 amount) internal {
576         require(account != address(0), "ERC20: mint to the zero address");
577 
578         _totalSupply = _totalSupply.add(amount);
579         _balances[account] = _balances[account].add(amount);
580         emit Transfer(address(0), account, amount);
581     }
582 
583      /**
584      * @dev Destroys `amount` tokens from `account`, reducing the
585      * total supply.
586      *
587      * Emits a {Transfer} event with `to` set to the zero address.
588      *
589      * Requirements
590      *
591      * - `account` cannot be the zero address.
592      * - `account` must have at least `amount` tokens.
593      */
594     function _burn(address account, uint256 amount) internal {
595         require(account != address(0), "ERC20: burn from the zero address");
596 
597         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
598         _totalSupply = _totalSupply.sub(amount);
599         emit Transfer(account, address(0), amount);
600     }
601 
602     /**
603      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
604      *
605      * This is internal function is equivalent to `approve`, and can be used to
606      * e.g. set automatic allowances for certain subsystems, etc.
607      *
608      * Emits an {Approval} event.
609      *
610      * Requirements:
611      *
612      * - `owner` cannot be the zero address.
613      * - `spender` cannot be the zero address.
614      */
615     function _approve(address owner, address spender, uint256 amount) internal {
616         require(owner != address(0), "ERC20: approve from the zero address");
617         require(spender != address(0), "ERC20: approve to the zero address");
618 
619         _allowances[owner][spender] = amount;
620         emit Approval(owner, spender, amount);
621     }
622 
623     /**
624      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
625      * from the caller's allowance.
626      *
627      * See {_burn} and {_approve}.
628      */
629     function _burnFrom(address account, uint256 amount) internal {
630         _burn(account, amount);
631         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
632     }
633 }
634 
635 // File: openzeppelin-solidity/contracts/access/Roles.sol
636 
637 pragma solidity ^0.5.0;
638 
639 /**
640  * @title Roles
641  * @dev Library for managing addresses assigned to a Role.
642  */
643 library Roles {
644     struct Role {
645         mapping (address => bool) bearer;
646     }
647 
648     /**
649      * @dev Give an account access to this role.
650      */
651     function add(Role storage role, address account) internal {
652         require(!has(role, account), "Roles: account already has role");
653         role.bearer[account] = true;
654     }
655 
656     /**
657      * @dev Remove an account's access to this role.
658      */
659     function remove(Role storage role, address account) internal {
660         require(has(role, account), "Roles: account does not have role");
661         role.bearer[account] = false;
662     }
663 
664     /**
665      * @dev Check if an account has this role.
666      * @return bool
667      */
668     function has(Role storage role, address account) internal view returns (bool) {
669         require(account != address(0), "Roles: account is the zero address");
670         return role.bearer[account];
671     }
672 }
673 
674 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
675 
676 pragma solidity ^0.5.0;
677 
678 
679 
680 contract PauserRole is Context {
681     using Roles for Roles.Role;
682 
683     event PauserAdded(address indexed account);
684     event PauserRemoved(address indexed account);
685 
686     Roles.Role private _pausers;
687 
688     constructor () internal {
689         _addPauser(_msgSender());
690     }
691 
692     modifier onlyPauser() {
693         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
694         _;
695     }
696 
697     function isPauser(address account) public view returns (bool) {
698         return _pausers.has(account);
699     }
700 
701     function addPauser(address account) public onlyPauser {
702         _addPauser(account);
703     }
704 
705     function renouncePauser() public {
706         _removePauser(_msgSender());
707     }
708 
709     function _addPauser(address account) internal {
710         _pausers.add(account);
711         emit PauserAdded(account);
712     }
713 
714     function _removePauser(address account) internal {
715         _pausers.remove(account);
716         emit PauserRemoved(account);
717     }
718 }
719 
720 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
721 
722 pragma solidity ^0.5.0;
723 
724 
725 
726 /**
727  * @dev Contract module which allows children to implement an emergency stop
728  * mechanism that can be triggered by an authorized account.
729  *
730  * This module is used through inheritance. It will make available the
731  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
732  * the functions of your contract. Note that they will not be pausable by
733  * simply including this module, only once the modifiers are put in place.
734  */
735 contract Pausable is Context, PauserRole {
736     /**
737      * @dev Emitted when the pause is triggered by a pauser (`account`).
738      */
739     event Paused(address account);
740 
741     /**
742      * @dev Emitted when the pause is lifted by a pauser (`account`).
743      */
744     event Unpaused(address account);
745 
746     bool private _paused;
747 
748     /**
749      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
750      * to the deployer.
751      */
752     constructor () internal {
753         _paused = false;
754     }
755 
756     /**
757      * @dev Returns true if the contract is paused, and false otherwise.
758      */
759     function paused() public view returns (bool) {
760         return _paused;
761     }
762 
763     /**
764      * @dev Modifier to make a function callable only when the contract is not paused.
765      */
766     modifier whenNotPaused() {
767         require(!_paused, "Pausable: paused");
768         _;
769     }
770 
771     /**
772      * @dev Modifier to make a function callable only when the contract is paused.
773      */
774     modifier whenPaused() {
775         require(_paused, "Pausable: not paused");
776         _;
777     }
778 
779     /**
780      * @dev Called by a pauser to pause, triggers stopped state.
781      */
782     function pause() public onlyPauser whenNotPaused {
783         _paused = true;
784         emit Paused(_msgSender());
785     }
786 
787     /**
788      * @dev Called by a pauser to unpause, returns to normal state.
789      */
790     function unpause() public onlyPauser whenPaused {
791         _paused = false;
792         emit Unpaused(_msgSender());
793     }
794 }
795 
796 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
797 
798 pragma solidity ^0.5.0;
799 
800 
801 
802 /**
803  * @title Pausable token
804  * @dev ERC20 with pausable transfers and allowances.
805  *
806  * Useful if you want to stop trades until the end of a crowdsale, or have
807  * an emergency switch for freezing all token transfers in the event of a large
808  * bug.
809  */
810 contract ERC20Pausable is ERC20, Pausable {
811     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
812         return super.transfer(to, value);
813     }
814 
815     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
816         return super.transferFrom(from, to, value);
817     }
818 
819     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
820         return super.approve(spender, value);
821     }
822 
823     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
824         return super.increaseAllowance(spender, addedValue);
825     }
826 
827     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
828         return super.decreaseAllowance(spender, subtractedValue);
829     }
830 }
831 
832 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
833 
834 pragma solidity ^0.5.0;
835 
836 
837 
838 /**
839  * @dev Extension of {ERC20} that allows token holders to destroy both their own
840  * tokens and those that they have an allowance for, in a way that can be
841  * recognized off-chain (via event analysis).
842  */
843 contract ERC20Burnable is Context, ERC20 {
844     /**
845      * @dev Destroys `amount` tokens from the caller.
846      *
847      * See {ERC20-_burn}.
848      */
849     function burn(uint256 amount) public {
850         _burn(_msgSender(), amount);
851     }
852 
853     /**
854      * @dev See {ERC20-_burnFrom}.
855      */
856     function burnFrom(address account, uint256 amount) public {
857         _burnFrom(account, amount);
858     }
859 }
860 
861 // File: contracts/GTEToken.sol
862 
863 pragma solidity 0.5.8;
864 
865 
866 
867 
868 
869 contract GTEToken is Ownable, ERC20Detailed, ERC20Pausable, ERC20Burnable {
870     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint initialSupply)
871     ERC20Detailed(_name, _symbol, _decimals)
872     public
873     {
874         _mint(msg.sender, initialSupply);
875     }
876 }