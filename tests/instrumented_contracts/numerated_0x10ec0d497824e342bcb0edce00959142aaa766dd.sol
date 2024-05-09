1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
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
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
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
61      * Emits a {Transfer} event.
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
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/GSN/Context.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /*
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with GSN meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 contract Context {
95     // Empty internal constructor, to prevent people from mistakenly deploying
96     // an instance of this contract, which should be used via inheritance.
97     constructor () internal { }
98     // solhint-disable-previous-line no-empty-blocks
99 
100     function _msgSender() internal view returns (address payable) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view returns (bytes memory) {
105         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449      /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 /**
507  * @dev Optional functions from the ERC20 standard.
508  */
509 contract ERC20Detailed is IERC20 {
510     string private _name;
511     string private _symbol;
512     uint8 private _decimals;
513 
514     /**
515      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
516      * these values are immutable: they can only be set once during
517      * construction.
518      */
519     constructor (string memory name, string memory symbol, uint8 decimals) public {
520         _name = name;
521         _symbol = symbol;
522         _decimals = decimals;
523     }
524 
525     /**
526      * @dev Returns the name of the token.
527      */
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @dev Returns the symbol of the token, usually a shorter version of the
534      * name.
535      */
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev Returns the number of decimals used to get its user representation.
542      * For example, if `decimals` equals `2`, a balance of `505` tokens should
543      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
544      *
545      * Tokens usually opt for a value of 18, imitating the relationship between
546      * Ether and Wei.
547      *
548      * NOTE: This information is only used for _display_ purposes: it in
549      * no way affects any of the arithmetic of the contract, including
550      * {IERC20-balanceOf} and {IERC20-transfer}.
551      */
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @dev Contract module that helps prevent reentrant calls to a function.
563  *
564  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
565  * available, which can be applied to functions to make sure there are no nested
566  * (reentrant) calls to them.
567  *
568  * Note that because there is a single `nonReentrant` guard, functions marked as
569  * `nonReentrant` may not call one another. This can be worked around by making
570  * those functions `private`, and then adding `external` `nonReentrant` entry
571  * points to them.
572  */
573 contract ReentrancyGuard {
574     // counter to allow mutex lock with only one SSTORE operation
575     uint256 private _guardCounter;
576 
577     constructor () internal {
578         // The counter starts at one to prevent changing it from zero to a non-zero
579         // value, which is a more expensive operation.
580         _guardCounter = 1;
581     }
582 
583     /**
584      * @dev Prevents a contract from calling itself, directly or indirectly.
585      * Calling a `nonReentrant` function from another `nonReentrant`
586      * function is not supported. It is possible to prevent this from happening
587      * by making the `nonReentrant` function external, and make it call a
588      * `private` function that does the actual work.
589      */
590     modifier nonReentrant() {
591         _guardCounter += 1;
592         uint256 localCounter = _guardCounter;
593         _;
594         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
595     }
596 }
597 
598 // File: @openzeppelin/contracts/ownership/Ownable.sol
599 
600 pragma solidity ^0.5.0;
601 
602 /**
603  * @dev Contract module which provides a basic access control mechanism, where
604  * there is an account (an owner) that can be granted exclusive access to
605  * specific functions.
606  *
607  * This module is used through inheritance. It will make available the modifier
608  * `onlyOwner`, which can be applied to your functions to restrict their use to
609  * the owner.
610  */
611 contract Ownable is Context {
612     address private _owner;
613 
614     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
615 
616     /**
617      * @dev Initializes the contract setting the deployer as the initial owner.
618      */
619     constructor () internal {
620         _owner = _msgSender();
621         emit OwnershipTransferred(address(0), _owner);
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(isOwner(), "Ownable: caller is not the owner");
636         _;
637     }
638 
639     /**
640      * @dev Returns true if the caller is the current owner.
641      */
642     function isOwner() public view returns (bool) {
643         return _msgSender() == _owner;
644     }
645 
646     /**
647      * @dev Leaves the contract without owner. It will not be possible to call
648      * `onlyOwner` functions anymore. Can only be called by the current owner.
649      *
650      * NOTE: Renouncing ownership will leave the contract without an owner,
651      * thereby removing any functionality that is only available to the owner.
652      */
653     function renounceOwnership() public onlyOwner {
654         emit OwnershipTransferred(_owner, address(0));
655         _owner = address(0);
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      * Can only be called by the current owner.
661      */
662     function transferOwnership(address newOwner) public onlyOwner {
663         _transferOwnership(newOwner);
664     }
665 
666     /**
667      * @dev Transfers ownership of the contract to a new account (`newOwner`).
668      */
669     function _transferOwnership(address newOwner) internal {
670         require(newOwner != address(0), "Ownable: new owner is the zero address");
671         emit OwnershipTransferred(_owner, newOwner);
672         _owner = newOwner;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/access/Roles.sol
677 
678 pragma solidity ^0.5.0;
679 
680 /**
681  * @title Roles
682  * @dev Library for managing addresses assigned to a Role.
683  */
684 library Roles {
685     struct Role {
686         mapping (address => bool) bearer;
687     }
688 
689     /**
690      * @dev Give an account access to this role.
691      */
692     function add(Role storage role, address account) internal {
693         require(!has(role, account), "Roles: account already has role");
694         role.bearer[account] = true;
695     }
696 
697     /**
698      * @dev Remove an account's access to this role.
699      */
700     function remove(Role storage role, address account) internal {
701         require(has(role, account), "Roles: account does not have role");
702         role.bearer[account] = false;
703     }
704 
705     /**
706      * @dev Check if an account has this role.
707      * @return bool
708      */
709     function has(Role storage role, address account) internal view returns (bool) {
710         require(account != address(0), "Roles: account is the zero address");
711         return role.bearer[account];
712     }
713 }
714 
715 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
716 
717 pragma solidity ^0.5.0;
718 
719 
720 
721 contract PauserRole is Context {
722     using Roles for Roles.Role;
723 
724     event PauserAdded(address indexed account);
725     event PauserRemoved(address indexed account);
726 
727     Roles.Role private _pausers;
728 
729     constructor () internal {
730         _addPauser(_msgSender());
731     }
732 
733     modifier onlyPauser() {
734         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
735         _;
736     }
737 
738     function isPauser(address account) public view returns (bool) {
739         return _pausers.has(account);
740     }
741 
742     function addPauser(address account) public onlyPauser {
743         _addPauser(account);
744     }
745 
746     function renouncePauser() public {
747         _removePauser(_msgSender());
748     }
749 
750     function _addPauser(address account) internal {
751         _pausers.add(account);
752         emit PauserAdded(account);
753     }
754 
755     function _removePauser(address account) internal {
756         _pausers.remove(account);
757         emit PauserRemoved(account);
758     }
759 }
760 
761 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
762 
763 pragma solidity ^0.5.0;
764 
765 
766 
767 /**
768  * @dev Contract module which allows children to implement an emergency stop
769  * mechanism that can be triggered by an authorized account.
770  *
771  * This module is used through inheritance. It will make available the
772  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
773  * the functions of your contract. Note that they will not be pausable by
774  * simply including this module, only once the modifiers are put in place.
775  */
776 contract Pausable is Context, PauserRole {
777     /**
778      * @dev Emitted when the pause is triggered by a pauser (`account`).
779      */
780     event Paused(address account);
781 
782     /**
783      * @dev Emitted when the pause is lifted by a pauser (`account`).
784      */
785     event Unpaused(address account);
786 
787     bool private _paused;
788 
789     /**
790      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
791      * to the deployer.
792      */
793     constructor () internal {
794         _paused = false;
795     }
796 
797     /**
798      * @dev Returns true if the contract is paused, and false otherwise.
799      */
800     function paused() public view returns (bool) {
801         return _paused;
802     }
803 
804     /**
805      * @dev Modifier to make a function callable only when the contract is not paused.
806      */
807     modifier whenNotPaused() {
808         require(!_paused, "Pausable: paused");
809         _;
810     }
811 
812     /**
813      * @dev Modifier to make a function callable only when the contract is paused.
814      */
815     modifier whenPaused() {
816         require(_paused, "Pausable: not paused");
817         _;
818     }
819 
820     /**
821      * @dev Called by a pauser to pause, triggers stopped state.
822      */
823     function pause() public onlyPauser whenNotPaused {
824         _paused = true;
825         emit Paused(_msgSender());
826     }
827 
828     /**
829      * @dev Called by a pauser to unpause, returns to normal state.
830      */
831     function unpause() public onlyPauser whenPaused {
832         _paused = false;
833         emit Unpaused(_msgSender());
834     }
835 }
836 
837 // File: @openzeppelin/contracts/utils/Address.sol
838 
839 pragma solidity ^0.5.5;
840 
841 /**
842  * @dev Collection of functions related to the address type
843  */
844 library Address {
845     /**
846      * @dev Returns true if `account` is a contract.
847      *
848      * This test is non-exhaustive, and there may be false-negatives: during the
849      * execution of a contract's constructor, its address will be reported as
850      * not containing a contract.
851      *
852      * IMPORTANT: It is unsafe to assume that an address for which this
853      * function returns false is an externally-owned account (EOA) and not a
854      * contract.
855      */
856     function isContract(address account) internal view returns (bool) {
857         // This method relies in extcodesize, which returns 0 for contracts in
858         // construction, since the code is only stored at the end of the
859         // constructor execution.
860 
861         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
862         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
863         // for accounts without code, i.e. `keccak256('')`
864         bytes32 codehash;
865         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
866         // solhint-disable-next-line no-inline-assembly
867         assembly { codehash := extcodehash(account) }
868         return (codehash != 0x0 && codehash != accountHash);
869     }
870 
871     /**
872      * @dev Converts an `address` into `address payable`. Note that this is
873      * simply a type cast: the actual underlying value is not changed.
874      *
875      * _Available since v2.4.0._
876      */
877     function toPayable(address account) internal pure returns (address payable) {
878         return address(uint160(account));
879     }
880 
881     /**
882      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
883      * `recipient`, forwarding all available gas and reverting on errors.
884      *
885      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
886      * of certain opcodes, possibly making contracts go over the 2300 gas limit
887      * imposed by `transfer`, making them unable to receive funds via
888      * `transfer`. {sendValue} removes this limitation.
889      *
890      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
891      *
892      * IMPORTANT: because control is transferred to `recipient`, care must be
893      * taken to not create reentrancy vulnerabilities. Consider using
894      * {ReentrancyGuard} or the
895      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
896      *
897      * _Available since v2.4.0._
898      */
899     function sendValue(address payable recipient, uint256 amount) internal {
900         require(address(this).balance >= amount, "Address: insufficient balance");
901 
902         // solhint-disable-next-line avoid-call-value
903         (bool success, ) = recipient.call.value(amount)("");
904         require(success, "Address: unable to send value, recipient may have reverted");
905     }
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
909 
910 pragma solidity ^0.5.0;
911 
912 
913 
914 
915 /**
916  * @title SafeERC20
917  * @dev Wrappers around ERC20 operations that throw on failure (when the token
918  * contract returns false). Tokens that return no value (and instead revert or
919  * throw on failure) are also supported, non-reverting calls are assumed to be
920  * successful.
921  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
922  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
923  */
924 library SafeERC20 {
925     using SafeMath for uint256;
926     using Address for address;
927 
928     function safeTransfer(IERC20 token, address to, uint256 value) internal {
929         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
930     }
931 
932     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
933         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
934     }
935 
936     function safeApprove(IERC20 token, address spender, uint256 value) internal {
937         // safeApprove should only be called when setting an initial allowance,
938         // or when resetting it to zero. To increase and decrease it, use
939         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
940         // solhint-disable-next-line max-line-length
941         require((value == 0) || (token.allowance(address(this), spender) == 0),
942             "SafeERC20: approve from non-zero to non-zero allowance"
943         );
944         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
945     }
946 
947     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
948         uint256 newAllowance = token.allowance(address(this), spender).add(value);
949         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
950     }
951 
952     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
953         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
954         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
955     }
956 
957     /**
958      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
959      * on the return value: the return value is optional (but if data is returned, it must not be false).
960      * @param token The token targeted by the call.
961      * @param data The call data (encoded using abi.encode or one of its variants).
962      */
963     function callOptionalReturn(IERC20 token, bytes memory data) private {
964         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
965         // we're implementing it ourselves.
966 
967         // A Solidity high level call has three parts:
968         //  1. The target address is checked to verify it contains contract code
969         //  2. The call itself is made, and success asserted
970         //  3. The return value is decoded, which in turn checks the size of the returned data.
971         // solhint-disable-next-line max-line-length
972         require(address(token).isContract(), "SafeERC20: call to non-contract");
973 
974         // solhint-disable-next-line avoid-low-level-calls
975         (bool success, bytes memory returndata) = address(token).call(data);
976         require(success, "SafeERC20: low-level call failed");
977 
978         if (returndata.length > 0) { // Return data is optional
979             // solhint-disable-next-line max-line-length
980             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
981         }
982     }
983 }
984 
985 // File: contracts/interfaces/iERC20Fulcrum.sol
986 
987 pragma solidity 0.5.11;
988 
989 interface iERC20Fulcrum {
990   function mint(
991     address receiver,
992     uint256 depositAmount)
993     external
994     returns (uint256 mintAmount);
995 
996   function burn(
997     address receiver,
998     uint256 burnAmount)
999     external
1000     returns (uint256 loanAmountPaid);
1001 
1002   function tokenPrice()
1003     external
1004     view
1005     returns (uint256 price);
1006 
1007   function supplyInterestRate()
1008     external
1009     view
1010     returns (uint256);
1011 
1012   function rateMultiplier()
1013     external
1014     view
1015     returns (uint256);
1016   function baseRate()
1017     external
1018     view
1019     returns (uint256);
1020 
1021   function borrowInterestRate()
1022     external
1023     view
1024     returns (uint256);
1025 
1026   function avgBorrowInterestRate()
1027     external
1028     view
1029     returns (uint256);
1030 
1031   function protocolInterestRate()
1032     external
1033     view
1034     returns (uint256);
1035 
1036   function spreadMultiplier()
1037     external
1038     view
1039     returns (uint256);
1040 
1041   function totalAssetBorrow()
1042     external
1043     view
1044     returns (uint256);
1045 
1046   function totalAssetSupply()
1047     external
1048     view
1049     returns (uint256);
1050 
1051   function nextSupplyInterestRate(uint256)
1052     external
1053     view
1054     returns (uint256);
1055 
1056   function nextBorrowInterestRate(uint256)
1057     external
1058     view
1059     returns (uint256);
1060   function nextLoanInterestRate(uint256)
1061     external
1062     view
1063     returns (uint256);
1064 
1065   function claimLoanToken()
1066     external
1067     returns (uint256 claimedAmount);
1068 
1069   function dsr()
1070     external
1071     view
1072     returns (uint256);
1073 
1074   function chaiPrice()
1075     external
1076     view
1077     returns (uint256);
1078 }
1079 
1080 // File: contracts/interfaces/ILendingProtocol.sol
1081 
1082 pragma solidity 0.5.11;
1083 
1084 interface ILendingProtocol {
1085   function mint() external returns (uint256);
1086   function redeem(address account) external returns (uint256);
1087   function nextSupplyRate(uint256 amount) external view returns (uint256);
1088   function nextSupplyRateWithParams(uint256[] calldata params) external view returns (uint256);
1089   function getAPR() external view returns (uint256);
1090   function getPriceInToken() external view returns (uint256);
1091   function token() external view returns (address);
1092   function underlying() external view returns (address);
1093 }
1094 
1095 // File: contracts/interfaces/IIdleToken.sol
1096 
1097 /**
1098  * @title: Idle Token interface
1099  * @author: William Bergamo, idle.finance
1100  */
1101 pragma solidity 0.5.11;
1102 
1103 interface IIdleToken {
1104   // view
1105   /**
1106    * IdleToken price calculation, in underlying
1107    *
1108    * @return : price in underlying token
1109    */
1110   function tokenPrice() external view returns (uint256 price);
1111 
1112   /**
1113    * underlying token decimals
1114    *
1115    * @return : decimals of underlying token
1116    */
1117   function tokenDecimals() external view returns (uint256 decimals);
1118 
1119   /**
1120    * Get APR of every ILendingProtocol
1121    *
1122    * @return addresses: array of token addresses
1123    * @return aprs: array of aprs (ordered in respect to the `addresses` array)
1124    */
1125   function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);
1126 
1127   // external
1128   // We should save the amount one has deposited to calc interests
1129 
1130   /**
1131    * Used to mint IdleTokens, given an underlying amount (eg. DAI).
1132    * This method triggers a rebalance of the pools if needed
1133    * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
1134    * NOTE 2: this method can be paused
1135    *
1136    * @param _amount : amount of underlying token to be lended
1137    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1138    * @return mintedTokens : amount of IdleTokens minted
1139    */
1140   function mintIdleToken(uint256 _amount, uint256[] calldata _clientProtocolAmounts) external returns (uint256 mintedTokens);
1141 
1142   /**
1143    * @param _amount : amount of underlying token to be lended
1144    * @return : address[] array with all token addresses used,
1145    *                          eg [cTokenAddress, iTokenAddress]
1146    * @return : uint256[] array with all amounts for each protocol in order,
1147    *                   eg [amountCompound, amountFulcrum]
1148    */
1149   function getParamsForMintIdleToken(uint256 _amount) external returns (address[] memory, uint256[] memory);
1150 
1151   /**
1152    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1153    * This method triggers a rebalance of the pools if needed
1154    * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
1155    * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
1156    *         Ideally one should wait until the black swan event is terminated
1157    *
1158    * @param _amount : amount of IdleTokens to be burned
1159    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1160    * @return redeemedTokens : amount of underlying tokens redeemed
1161    */
1162   function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata _clientProtocolAmounts)
1163     external returns (uint256 redeemedTokens);
1164 
1165   /**
1166    * @param _amount : amount of IdleTokens to be burned
1167    * @param _skipRebalance : whether to skip the rebalance process or not
1168    * @return : address[] array with all token addresses used,
1169    *                          eg [cTokenAddress, iTokenAddress]
1170    * @return : uint256[] array with all amounts for each protocol in order,
1171    *                   eg [amountCompound, amountFulcrum]
1172    */
1173   function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
1174     external returns (address[] memory, uint256[] memory);
1175 
1176   /**
1177    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1178    * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
1179    * Underlying (eg. DAI) is not redeemed here.
1180    *
1181    * @param _amount : amount of IdleTokens to be burned
1182    */
1183   function redeemInterestBearingTokens(uint256 _amount) external;
1184 
1185   /**
1186    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1187    * @return claimedTokens : amount of underlying tokens claimed
1188    */
1189   function claimITokens(uint256[] calldata _clientProtocolAmounts) external returns (uint256 claimedTokens);
1190 
1191   /**
1192    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
1193    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1194    * @return : whether has rebalanced or not
1195    */
1196   function rebalance(uint256 _newAmount, uint256[] calldata _clientProtocolAmounts) external returns (bool);
1197 
1198   /**
1199    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
1200    * @return : address[] array with all token addresses used,
1201    *                          eg [cTokenAddress, iTokenAddress]
1202    * @return : uint256[] array with all amounts for each protocol in order,
1203    *                   eg [amountCompound, amountFulcrum]
1204    */
1205   function getParamsForRebalance(uint256 _newAmount) external returns (address[] memory, uint256[] memory);
1206 }
1207 
1208 // File: contracts/interfaces/CERC20.sol
1209 
1210 pragma solidity 0.5.11;
1211 
1212 interface CERC20 {
1213   function mint(uint256 mintAmount) external returns (uint256);
1214   function redeem(uint256 redeemTokens) external returns (uint256);
1215   function exchangeRateStored() external view returns (uint256);
1216   function supplyRatePerBlock() external view returns (uint256);
1217 
1218   function borrowRatePerBlock() external view returns (uint256);
1219   function totalReserves() external view returns (uint256);
1220   function getCash() external view returns (uint256);
1221   function totalBorrows() external view returns (uint256);
1222   function reserveFactorMantissa() external view returns (uint256);
1223   function interestRateModel() external view returns (address);
1224 }
1225 
1226 // File: contracts/interfaces/WhitePaperInterestRateModel.sol
1227 
1228 pragma solidity 0.5.11;
1229 
1230 interface WhitePaperInterestRateModel {
1231   function getBorrowRate(uint256 cash, uint256 borrows, uint256 _reserves) external view returns (uint256, uint256);
1232   function getSupplyRate(uint256 cash, uint256 borrows, uint256 reserves, uint256 reserveFactorMantissa) external view returns (uint256);
1233   function multiplier() external view returns (uint256);
1234   function baseRate() external view returns (uint256);
1235   function blocksPerYear() external view returns (uint256);
1236   function dsrPerBlock() external view returns (uint256);
1237 }
1238 
1239 // File: contracts/IdleRebalancer.sol
1240 
1241 /**
1242  * @title: Idle Rebalancer contract
1243  * @summary: Used for calculating amounts to lend on each implemented protocol.
1244  *           This implementation works with Compound and Fulcrum only,
1245  *           when a new protocol will be added this should be replaced
1246  * @author: William Bergamo, idle.finance
1247  */
1248 pragma solidity 0.5.11;
1249 
1250 
1251 
1252 
1253 
1254 
1255 
1256 
1257 contract IdleRebalancer is Ownable {
1258   using SafeMath for uint256;
1259   // IdleToken address
1260   address public idleToken;
1261   // protocol token (cToken) address
1262   address public cToken;
1263   // protocol token (iToken) address
1264   address public iToken;
1265   // cToken protocol wrapper IdleCompound
1266   address public cWrapper;
1267   // iToken protocol wrapper IdleFulcrum
1268   address public iWrapper;
1269   // max % difference between next supply rate of Fulcrum and Compound
1270   uint256 public maxRateDifference; // 10**17 -> 0.1 %
1271   // max % difference between off-chain user supplied params for rebalance and actual amount to be rebalanced
1272   uint256 public maxSupplyedParamsDifference; // 100000 -> 0.001%
1273   // max number of recursive calls for bisection algorithm
1274   uint256 public maxIterations;
1275 
1276   /**
1277    * @param _cToken : cToken address
1278    * @param _iToken : iToken address
1279    * @param _cWrapper : cWrapper address
1280    * @param _iWrapper : iWrapper address
1281    */
1282   constructor(address _cToken, address _iToken, address _cWrapper, address _iWrapper) public {
1283     require(_cToken != address(0) && _iToken != address(0) && _cWrapper != address(0) && _iWrapper != address(0), 'some addr is 0');
1284 
1285     cToken = _cToken;
1286     iToken = _iToken;
1287     cWrapper = _cWrapper;
1288     iWrapper = _iWrapper;
1289     maxRateDifference = 10**17; // 0.1%
1290     maxSupplyedParamsDifference = 100000; // 0.001%
1291     maxIterations = 30;
1292   }
1293 
1294   /**
1295    * Throws if called by any account other than IdleToken contract.
1296    */
1297   modifier onlyIdle() {
1298     require(msg.sender == idleToken, "Ownable: caller is not IdleToken contract");
1299     _;
1300   }
1301 
1302   // onlyOwner
1303   /**
1304    * sets idleToken address
1305    * NOTE: can be called only once. It's not on the constructor because we are deploying this contract
1306    *       after the IdleToken contract
1307    * @param _idleToken : idleToken address
1308    */
1309   function setIdleToken(address _idleToken)
1310     external onlyOwner {
1311       require(idleToken == address(0), "idleToken addr already set");
1312       require(_idleToken != address(0), "_idleToken addr is 0");
1313       idleToken = _idleToken;
1314   }
1315 
1316   /**
1317    * sets maxIterations for bisection recursive calls
1318    * @param _maxIterations : max number of iterations for the bisection algorithm
1319    */
1320   function setMaxIterations(uint256 _maxIterations)
1321     external onlyOwner {
1322       maxIterations = _maxIterations;
1323   }
1324 
1325   /**
1326    * sets maxRateDifference
1327    * @param _maxDifference : max rate difference in percentage scaled by 10**18
1328    */
1329   function setMaxRateDifference(uint256 _maxDifference)
1330     external onlyOwner {
1331       maxRateDifference = _maxDifference;
1332   }
1333 
1334   /**
1335    * sets maxSupplyedParamsDifference
1336    * @param _maxSupplyedParamsDifference : max slippage between the rebalance params given from the client
1337    *                                       and actual amount to be rebalanced
1338    */
1339   function setMaxSupplyedParamsDifference(uint256 _maxSupplyedParamsDifference)
1340     external onlyOwner {
1341       maxSupplyedParamsDifference = _maxSupplyedParamsDifference;
1342   }
1343   // end onlyOwner
1344 
1345   /**
1346    * Used by IdleToken contract to calculate the amount to be lended
1347    * on each protocol in order to get the best available rate for all funds.
1348    *
1349    * @param _rebalanceParams : first param is the total amount to be rebalanced,
1350    *                           all other elements are client side calculated amounts to put on each lending protocol
1351    * @return tokenAddresses : array with all token addresses used,
1352    *                          currently [cTokenAddress, iTokenAddress]
1353    * @return amounts : array with all amounts for each protocol in order,
1354    *                   currently [amountCompound, amountFulcrum]
1355    */
1356   function calcRebalanceAmounts(uint256[] calldata _rebalanceParams)
1357     external view onlyIdle
1358     returns (address[] memory tokenAddresses, uint256[] memory amounts)
1359   {
1360     // Get all params for calculating Compound nextSupplyRateWithParams
1361     CERC20 _cToken = CERC20(cToken);
1362     WhitePaperInterestRateModel white = WhitePaperInterestRateModel(_cToken.interestRateModel());
1363     uint256[] memory paramsCompound = new uint256[](10);
1364     paramsCompound[0] = 10**18; // j
1365     paramsCompound[1] = white.baseRate(); // a
1366     paramsCompound[2] = _cToken.totalBorrows(); // b
1367     paramsCompound[3] = white.multiplier(); // c
1368     paramsCompound[4] = _cToken.totalReserves(); // d
1369     paramsCompound[5] = paramsCompound[0].sub(_cToken.reserveFactorMantissa()); // e
1370     paramsCompound[6] = _cToken.getCash(); // s
1371     paramsCompound[7] = white.blocksPerYear(); // k
1372     paramsCompound[8] = 100; // f
1373 
1374     // Get all params for calculating Fulcrum nextSupplyRateWithParams
1375     iERC20Fulcrum _iToken = iERC20Fulcrum(iToken);
1376     uint256[] memory paramsFulcrum = new uint256[](4);
1377     paramsFulcrum[0] = _iToken.protocolInterestRate(); // a1
1378     paramsFulcrum[1] = _iToken.totalAssetBorrow(); // b1
1379     paramsFulcrum[2] = _iToken.totalAssetSupply(); // s1
1380 
1381     tokenAddresses = new address[](2);
1382     tokenAddresses[0] = cToken;
1383     tokenAddresses[1] = iToken;
1384 
1385     // _rebalanceParams should be [totAmountToRebalance, amountCompound, amountFulcrum];
1386     if (_rebalanceParams.length == 3) {
1387       (bool amountsAreCorrect, uint256[] memory checkedAmounts) = checkRebalanceAmounts(_rebalanceParams, paramsCompound, paramsFulcrum);
1388       if (amountsAreCorrect) {
1389         return (tokenAddresses, checkedAmounts);
1390       }
1391     }
1392 
1393     // Initial guess for shrinking initial bisection interval
1394     /*
1395       Compound: (getCash returns the available supply only, not the borrowed one)
1396       getCash + totalBorrows = totalSuppliedCompound
1397 
1398       Fulcrum:
1399       totalSupply = totalSuppliedFulcrum
1400 
1401       we try to correlate borrow and supply on both markets
1402       totC = totalSuppliedCompound + totalBorrowsCompound
1403       totF = totalSuppliedFulcrum + totalBorrowsFulcrum
1404 
1405       n : (totC + totF) = x : totF
1406       x = n * totF / (totC + totF)
1407     */
1408 
1409     uint256 amountFulcrum = _rebalanceParams[0].mul(paramsFulcrum[2].add(paramsFulcrum[1])).div(
1410       paramsFulcrum[2].add(paramsFulcrum[1]).add(paramsCompound[6].add(paramsCompound[2]).add(paramsCompound[2]))
1411     );
1412 
1413     // Recursive bisection algorithm
1414     amounts = bisectionRec(
1415       _rebalanceParams[0].sub(amountFulcrum), // amountCompound
1416       amountFulcrum,
1417       maxRateDifference, // 0.1% of rate difference,
1418       0, // currIter
1419       maxIterations, // maxIter
1420       _rebalanceParams[0],
1421       paramsCompound,
1422       paramsFulcrum
1423     ); // returns [amountCompound, amountFulcrum]
1424 
1425     return (tokenAddresses, amounts);
1426   }
1427   /**
1428    * Used by IdleToken contract to check if provided amounts
1429    * causes the rates of Fulcrum and Compound to be balanced
1430    * (counting a tolerance)
1431    *
1432    * @param rebalanceParams : first element is the total amount to be rebalanced,
1433    *                   the rest is an array with all amounts for each protocol in order,
1434    *                   currently [amountCompound, amountFulcrum]
1435    * @param paramsCompound : array with all params (except for the newDAIAmount)
1436    *                          for calculating next supply rate of Compound
1437    * @param paramsFulcrum : array with all params (except for the newDAIAmount)
1438    *                          for calculating next supply rate of Fulcrum
1439    * @return bool : if provided amount correctly rebalances the pool
1440    */
1441   function checkRebalanceAmounts(
1442     uint256[] memory rebalanceParams,
1443     uint256[] memory paramsCompound,
1444     uint256[] memory paramsFulcrum
1445   )
1446     internal view
1447     returns (bool, uint256[] memory checkedAmounts)
1448   {
1449     // This is the amount that should be rebalanced no more no less
1450     uint256 actualAmountToBeRebalanced = rebalanceParams[0]; // n
1451     // interest is earned between when tx was submitted and when it is mined so params sent by users
1452     // should always be slightly less than what should be rebalanced
1453     uint256 totAmountSentByUser;
1454     for (uint8 i = 1; i < rebalanceParams.length; i++) {
1455       totAmountSentByUser = totAmountSentByUser.add(rebalanceParams[i]);
1456     }
1457 
1458     // check if amounts sent from user are less than actualAmountToBeRebalanced and
1459     // at most `actualAmountToBeRebalanced - 0.001% of (actualAmountToBeRebalanced)`
1460     if (totAmountSentByUser > actualAmountToBeRebalanced ||
1461         totAmountSentByUser.add(totAmountSentByUser.div(maxSupplyedParamsDifference)) < actualAmountToBeRebalanced) {
1462       return (false, new uint256[](2));
1463     }
1464 
1465     uint256 interestToBeSplitted = actualAmountToBeRebalanced.sub(totAmountSentByUser);
1466 
1467     // sets newDAIAmount for each protocol
1468     paramsCompound[9] = rebalanceParams[1].add(interestToBeSplitted.div(2));
1469     paramsFulcrum[3] = rebalanceParams[2].add(interestToBeSplitted.sub(interestToBeSplitted.div(2)));
1470 
1471     // calculate next rates with amountCompound and amountFulcrum
1472 
1473     // For Fulcrum see https://github.com/bZxNetwork/bZx-monorepo/blob/development/packages/contracts/extensions/loanTokenization/contracts/LoanToken/LoanTokenLogicV3.sol#L1418
1474     // fulcrumUtilRate = fulcrumBorrow.mul(10**20).div(assetSupply);
1475     uint256 currFulcRate = (paramsFulcrum[1].mul(10**20).div(paramsFulcrum[2])) > 90 ether ?
1476       ILendingProtocol(iWrapper).nextSupplyRate(paramsFulcrum[3]) :
1477       ILendingProtocol(iWrapper).nextSupplyRateWithParams(paramsFulcrum);
1478     uint256 currCompRate = ILendingProtocol(cWrapper).nextSupplyRateWithParams(paramsCompound);
1479     bool isCompoundBest = currCompRate > currFulcRate;
1480     // |fulcrumRate - compoundRate| <= tolerance
1481     bool areParamsOk = (currFulcRate.add(maxRateDifference) >= currCompRate && isCompoundBest) ||
1482       (currCompRate.add(maxRateDifference) >= currFulcRate && !isCompoundBest);
1483 
1484     uint256[] memory actualParams = new uint256[](2);
1485     actualParams[0] = paramsCompound[9];
1486     actualParams[1] = paramsFulcrum[3];
1487 
1488     return (areParamsOk, actualParams);
1489   }
1490 
1491   /**
1492    * Internal implementation of our bisection algorithm
1493    *
1494    * @param amountCompound : amount to be lended in compound in current iteration
1495    * @param amountFulcrum : amount to be lended in Fulcrum in current iteration
1496    * @param tolerance : max % difference between next supply rate of Fulcrum and Compound
1497    * @param currIter : current iteration
1498    * @param maxIter : max number of iterations
1499    * @param n : amount of underlying tokens (eg. DAI) to rebalance
1500    * @param paramsCompound : array with all params (except for the newDAIAmount)
1501    *                          for calculating next supply rate of Compound
1502    * @param paramsFulcrum : array with all params (except for the newDAIAmount)
1503    *                          for calculating next supply rate of Fulcrum
1504    * @return amounts : array with all amounts for each protocol in order,
1505    *                   currently [amountCompound, amountFulcrum]
1506    */
1507   function bisectionRec(
1508     uint256 amountCompound, uint256 amountFulcrum,
1509     uint256 tolerance, uint256 currIter, uint256 maxIter, uint256 n,
1510     uint256[] memory paramsCompound,
1511     uint256[] memory paramsFulcrum
1512   )
1513     internal view
1514     returns (uint256[] memory amounts) {
1515 
1516     // sets newDAIAmount for each protocol
1517     paramsCompound[9] = amountCompound;
1518     paramsFulcrum[3] = amountFulcrum;
1519 
1520     // calculate next rates with amountCompound and amountFulcrum
1521 
1522     // For Fulcrum see https://github.com/bZxNetwork/bZx-monorepo/blob/development/packages/contracts/extensions/loanTokenization/contracts/LoanToken/LoanTokenLogicV3.sol#L1418
1523     // fulcrumUtilRate = fulcrumBorrow.mul(10**20).div(assetSupply);
1524     uint256 currFulcRate = (paramsFulcrum[1].mul(10**20).div(paramsFulcrum[2])) > 90 ether ?
1525       ILendingProtocol(iWrapper).nextSupplyRate(amountFulcrum) :
1526       ILendingProtocol(iWrapper).nextSupplyRateWithParams(paramsFulcrum);
1527 
1528     uint256 currCompRate = ILendingProtocol(cWrapper).nextSupplyRateWithParams(paramsCompound);
1529     bool isCompoundBest = currCompRate > currFulcRate;
1530 
1531     // bisection interval update, we choose to halve the smaller amount
1532     uint256 step = amountCompound < amountFulcrum ? amountCompound.div(2) : amountFulcrum.div(2);
1533 
1534     // base case
1535     // |fulcrumRate - compoundRate| <= tolerance
1536     if (
1537       ((currFulcRate.add(tolerance) >= currCompRate && isCompoundBest) ||
1538       (currCompRate.add(tolerance) >= currFulcRate && !isCompoundBest)) ||
1539       currIter >= maxIter
1540     ) {
1541       amounts = new uint256[](2);
1542       amounts[0] = amountCompound;
1543       amounts[1] = amountFulcrum;
1544       return amounts;
1545     }
1546 
1547     return bisectionRec(
1548       isCompoundBest ? amountCompound.add(step) : amountCompound.sub(step),
1549       isCompoundBest ? amountFulcrum.sub(step) : amountFulcrum.add(step),
1550       tolerance, currIter + 1, maxIter, n,
1551       paramsCompound, // paramsCompound[9] would be overwritten on next iteration
1552       paramsFulcrum // paramsFulcrum[3] would be overwritten on next iteration
1553     );
1554   }
1555 }
1556 
1557 // File: contracts/IdlePriceCalculator.sol
1558 
1559 /**
1560  * @title: Idle Price Calculator contract
1561  * @summary: Used for calculating the current IdleToken price in underlying (eg. DAI)
1562  *          price is: Net Asset Value / totalSupply
1563  * @author: William Bergamo, idle.finance
1564  */
1565 pragma solidity 0.5.11;
1566 
1567 
1568 
1569 
1570 
1571 
1572 contract IdlePriceCalculator {
1573   using SafeMath for uint256;
1574   /**
1575    * IdleToken price calculation, in underlying (eg. DAI)
1576    *
1577    * @return : price in underlying token
1578    */
1579   function tokenPrice(
1580     uint256 totalSupply,
1581     address idleToken,
1582     address[] calldata currentTokensUsed,
1583     address[] calldata protocolWrappersAddresses
1584   )
1585     external view
1586     returns (uint256 price) {
1587       require(currentTokensUsed.length == protocolWrappersAddresses.length, "Different Length");
1588 
1589       if (totalSupply == 0) {
1590         return 10**(IIdleToken(idleToken).tokenDecimals());
1591       }
1592 
1593       uint256 currPrice;
1594       uint256 currNav;
1595       uint256 totNav;
1596 
1597       for (uint8 i = 0; i < currentTokensUsed.length; i++) {
1598         currPrice = ILendingProtocol(protocolWrappersAddresses[i]).getPriceInToken();
1599         // NAV = price * poolSupply
1600         currNav = currPrice.mul(IERC20(currentTokensUsed[i]).balanceOf(idleToken));
1601         totNav = totNav.add(currNav);
1602       }
1603 
1604       price = totNav.div(totalSupply); // idleToken price in token wei
1605   }
1606 }
1607 
1608 // File: contracts/IdleToken.sol
1609 
1610 /**
1611  * @title: Idle Token main contract
1612  * @summary: ERC20 that holds pooled user funds together
1613  *           Each token rapresent a share of the underlying pools
1614  *           and with each token user have the right to redeem a portion of these pools
1615  * @author: William Bergamo, idle.finance
1616  */
1617 pragma solidity 0.5.11;
1618 
1619 
1620 
1621 
1622 
1623 
1624 
1625 
1626 
1627 
1628 
1629 
1630 
1631 
1632 contract IdleToken is ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Pausable, IIdleToken {
1633   using SafeERC20 for IERC20;
1634   using SafeMath for uint256;
1635 
1636   // protocolWrappers may be changed/updated/removed do not rely on their
1637   // addresses to determine where funds are allocated
1638 
1639   // eg. cTokenAddress => IdleCompoundAddress
1640   mapping(address => address) public protocolWrappers;
1641   // eg. DAI address
1642   address public token;
1643   // eg. 18 for DAI
1644   uint256 public tokenDecimals;
1645   // eg. iDAI address
1646   address public iToken; // used for claimITokens and userClaimITokens
1647   // Min thresold of APR difference between protocols to trigger a rebalance
1648   uint256 public minRateDifference;
1649   // Idle rebalancer current implementation address
1650   address public rebalancer;
1651   // Idle rebalancer current implementation address
1652   address public priceCalculator;
1653   // Last iToken price, used to pause contract in case of a black swan event
1654   uint256 public lastITokenPrice;
1655   // Manual trigger for unpausing contract in case of a black swan event that caused the iToken price to not
1656   // return to the normal level
1657   bool public manualPlay = false;
1658   bool private _notLocalEntered;
1659 
1660   // no one can directly change this
1661   // Idle pool current investments eg. [cTokenAddress, iTokenAddress]
1662   address[] public currentTokensUsed;
1663   // eg. [cTokenAddress, iTokenAddress, ...]
1664   address[] public allAvailableTokens;
1665 
1666   struct TokenProtocol {
1667     address tokenAddr;
1668     address protocolAddr;
1669   }
1670 
1671   event Rebalance(uint256 amount);
1672 
1673   /**
1674    * @dev constructor, initialize some variables, mainly addresses of other contracts
1675    *
1676    * @param _name : IdleToken name
1677    * @param _symbol : IdleToken symbol
1678    * @param _decimals : IdleToken decimals
1679    * @param _token : underlying token address
1680    * @param _cToken : cToken address
1681    * @param _iToken : iToken address
1682    * @param _rebalancer : Idle Rebalancer address
1683    * @param _idleCompound : Idle Compound address
1684    * @param _idleFulcrum : Idle Fulcrum address
1685    */
1686   constructor(
1687     string memory _name, // eg. IdleDAI
1688     string memory _symbol, // eg. IDLEDAI
1689     uint8 _decimals, // eg. 18
1690     address _token,
1691     address _cToken,
1692     address _iToken,
1693     address _rebalancer,
1694     address _priceCalculator,
1695     address _idleCompound,
1696     address _idleFulcrum)
1697     public
1698     ERC20Detailed(_name, _symbol, _decimals) {
1699       token = _token;
1700       tokenDecimals = ERC20Detailed(_token).decimals();
1701       iToken = _iToken; // used for claimITokens and userClaimITokens methods
1702       rebalancer = _rebalancer;
1703       priceCalculator = _priceCalculator;
1704       protocolWrappers[_cToken] = _idleCompound;
1705       protocolWrappers[_iToken] = _idleFulcrum;
1706       allAvailableTokens = [_cToken, _iToken];
1707       minRateDifference = 100000000000000000; // 0.1% min
1708       _notLocalEntered = true;
1709   }
1710 
1711   modifier whenITokenPriceHasNotDecreased() {
1712     uint256 iTokenPrice = iERC20Fulcrum(iToken).tokenPrice();
1713     require(
1714       iTokenPrice >= lastITokenPrice || manualPlay,
1715       "Paused: iToken price decreased"
1716     );
1717 
1718     _;
1719 
1720     if (iTokenPrice > lastITokenPrice) {
1721       lastITokenPrice = iTokenPrice;
1722     }
1723   }
1724 
1725   modifier nonLocallyReentrant() {
1726     // On the first call to nonReentrant, _notEntered will be true
1727     require(_notLocalEntered, "LocalReentrancyGuard: reentrant call");
1728 
1729     // Any calls to nonReentrant after this point will fail
1730     _notLocalEntered = false;
1731 
1732     _;
1733 
1734     // By storing the original value once again, a refund is triggered (see
1735     // https://eips.ethereum.org/EIPS/eip-2200)
1736     _notLocalEntered = true;
1737   }
1738 
1739   // onlyOwner
1740   /**
1741    * It allows owner to set the iToken (Fulcrum) address
1742    *
1743    * @param _iToken : iToken address
1744    */
1745   function setIToken(address _iToken)
1746     external onlyOwner {
1747       iToken = _iToken;
1748   }
1749   /**
1750    * It allows owner to set the IdleRebalancer address
1751    *
1752    * @param _rebalancer : new IdleRebalancer address
1753    */
1754   function setRebalancer(address _rebalancer)
1755     external onlyOwner {
1756       rebalancer = _rebalancer;
1757   }
1758   /**
1759    * It allows owner to set the IdlePriceCalculator address
1760    *
1761    * @param _priceCalculator : new IdlePriceCalculator address
1762    */
1763   function setPriceCalculator(address _priceCalculator)
1764     external onlyOwner {
1765       priceCalculator = _priceCalculator;
1766   }
1767   /**
1768    * It allows owner to set a protocol wrapper address
1769    *
1770    * @param _token : underlying token address (eg. DAI)
1771    * @param _wrapper : Idle protocol wrapper address
1772    */
1773   function setProtocolWrapper(address _token, address _wrapper)
1774     external onlyOwner {
1775       require(_token != address(0) && _wrapper != address(0), 'some addr is 0');
1776       // update allAvailableTokens if needed
1777       if (protocolWrappers[_token] == address(0)) {
1778         allAvailableTokens.push(_token);
1779       }
1780       protocolWrappers[_token] = _wrapper;
1781   }
1782 
1783   function setMinRateDifference(uint256 _rate)
1784     external onlyOwner {
1785       minRateDifference = _rate;
1786   }
1787   /**
1788    * It allows owner to unpause the contract when iToken price decreased and didn't return to the expected level
1789    *
1790    * @param _manualPlay : new IdleRebalancer address
1791    */
1792   function setManualPlay(bool _manualPlay)
1793     external onlyOwner {
1794       manualPlay = _manualPlay;
1795   }
1796 
1797   // view
1798   /**
1799    * IdleToken price calculation, in underlying
1800    *
1801    * @return : price in underlying token
1802    */
1803   function tokenPrice()
1804     public view
1805     returns (uint256 price) {
1806       address[] memory protocolWrappersAddresses = new address[](currentTokensUsed.length);
1807       for (uint8 i = 0; i < currentTokensUsed.length; i++) {
1808         protocolWrappersAddresses[i] = protocolWrappers[currentTokensUsed[i]];
1809       }
1810       price = IdlePriceCalculator(priceCalculator).tokenPrice(
1811         this.totalSupply(), address(this), currentTokensUsed, protocolWrappersAddresses
1812       );
1813   }
1814 
1815   /**
1816    * Get APR of every ILendingProtocol
1817    *
1818    * @return addresses: array of token addresses
1819    * @return aprs: array of aprs (ordered in respect to the `addresses` array)
1820    */
1821   function getAPRs()
1822     public view
1823     returns (address[] memory addresses, uint256[] memory aprs) {
1824       address currToken;
1825       addresses = new address[](allAvailableTokens.length);
1826       aprs = new uint256[](allAvailableTokens.length);
1827       for (uint8 i = 0; i < allAvailableTokens.length; i++) {
1828         currToken = allAvailableTokens[i];
1829         addresses[i] = currToken;
1830         aprs[i] = ILendingProtocol(protocolWrappers[currToken]).getAPR();
1831       }
1832   }
1833 
1834   // external
1835   /**
1836    * Used to mint IdleTokens, given an underlying amount (eg. DAI).
1837    * This method triggers a rebalance of the pools if needed
1838    * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
1839    * NOTE 2: this method can be paused
1840    *
1841    * @param _amount : amount of underlying token to be lended
1842    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1843    * @return mintedTokens : amount of IdleTokens minted
1844    */
1845   function mintIdleToken(uint256 _amount, uint256[] memory _clientProtocolAmounts)
1846     public nonReentrant whenNotPaused whenITokenPriceHasNotDecreased
1847     returns (uint256 mintedTokens) {
1848       // Get current IdleToken price
1849       uint256 idlePrice = tokenPrice();
1850       // transfer tokens to this contract
1851       IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
1852       // Rebalance the current pool if needed and mint new supplyied amount
1853       rebalance(_amount, _clientProtocolAmounts);
1854 
1855       mintedTokens = _amount.mul(10**18).div(idlePrice);
1856       _mint(msg.sender, mintedTokens);
1857   }
1858 
1859   /**
1860    * Used to get `_clientProtocolAmounts` for `mintIdleToken` method, given an underlying amount (eg. DAI).
1861    * This should be used only for a call not an actual tx
1862    * NOTE: User should 'approve' _amount of tokens before calling this method
1863    * NOTE 2: this method can be paused
1864    *
1865    * @param _amount : amount of underlying token to be lended
1866    * @return : address[] array with all token addresses used,
1867    *                          eg [cTokenAddress, iTokenAddress]
1868    * @return : uint256[] array with all amounts for each protocol in order,
1869    *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
1870    */
1871   function getParamsForMintIdleToken(uint256 _amount)
1872     external nonLocallyReentrant whenNotPaused whenITokenPriceHasNotDecreased
1873     returns (address[] memory, uint256[] memory) {
1874       mintIdleToken(_amount, new uint256[](0));
1875       return _getCurrentAllocations();
1876   }
1877 
1878   /**
1879    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1880    * This method triggers a rebalance of the pools if needed
1881    * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
1882    * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
1883    *         Ideally one should wait until the black swan event is terminated
1884    *
1885    * @param _amount : amount of IdleTokens to be burned
1886    * @param _skipRebalance : whether to skip the rebalance process or not
1887    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1888    * @return redeemedTokens : amount of underlying tokens redeemed
1889    */
1890   function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] memory _clientProtocolAmounts)
1891     public nonReentrant
1892     returns (uint256 redeemedTokens) {
1893       address currentToken;
1894 
1895       for (uint8 i = 0; i < currentTokensUsed.length; i++) {
1896         currentToken = currentTokensUsed[i];
1897         redeemedTokens = redeemedTokens.add(
1898           _redeemProtocolTokens(
1899             protocolWrappers[currentToken],
1900             currentToken,
1901             // _amount * protocolPoolBalance / idleSupply
1902             _amount.mul(IERC20(currentToken).balanceOf(address(this))).div(this.totalSupply()), // amount to redeem
1903             msg.sender
1904           )
1905         );
1906       }
1907 
1908       _burn(msg.sender, _amount);
1909 
1910       // Do not rebalance if contract is paused or iToken price has decreased
1911       if (this.paused() || iERC20Fulcrum(iToken).tokenPrice() < lastITokenPrice || _skipRebalance) {
1912         return redeemedTokens;
1913       }
1914 
1915       rebalance(0, _clientProtocolAmounts);
1916   }
1917 
1918   /**
1919    * Used to get `_clientProtocolAmounts` for `redeemIdleToken` method
1920    * This should be used only for a call not an actual tx
1921    * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
1922    * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
1923    *         Ideally one should wait until the black swan event is terminated
1924    *
1925    * @param _amount : amount of IdleTokens to be burned
1926    * @param _skipRebalance : whether to skip the rebalance process or not
1927    * @return : address[] array with all token addresses used,
1928    *                          eg [cTokenAddress, iTokenAddress]
1929    * @return : uint256[] array with all amounts for each protocol in order,
1930    *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
1931    */
1932    function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
1933     external nonLocallyReentrant
1934     returns (address[] memory, uint256[] memory) {
1935       redeemIdleToken(_amount, _skipRebalance, new uint256[](0));
1936       return _getCurrentAllocations();
1937   }
1938 
1939   /**
1940    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1941    * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
1942    * Underlying (eg. DAI) is not redeemed here.
1943    *
1944    * @param _amount : amount of IdleTokens to be burned
1945    */
1946   function redeemInterestBearingTokens(uint256 _amount)
1947     external nonReentrant {
1948       uint256 idleSupply = this.totalSupply();
1949       address currentToken;
1950 
1951       for (uint8 i = 0; i < currentTokensUsed.length; i++) {
1952         currentToken = currentTokensUsed[i];
1953         IERC20(currentToken).safeTransfer(
1954           msg.sender,
1955           _amount.mul(IERC20(currentToken).balanceOf(address(this))).div(idleSupply) // amount to redeem
1956         );
1957       }
1958 
1959       _burn(msg.sender, _amount);
1960   }
1961 
1962   /**
1963    * Here we are redeeming unclaimed token from iToken contract to this contracts
1964    * then allocating claimedTokens with rebalancing
1965    * Everyone should be incentivized in calling this method
1966    * NOTE: this method can be paused
1967    *
1968    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1969    * @return claimedTokens : amount of underlying tokens claimed
1970    */
1971   function claimITokens(uint256[] calldata _clientProtocolAmounts)
1972     external whenNotPaused whenITokenPriceHasNotDecreased
1973     returns (uint256 claimedTokens) {
1974       claimedTokens = iERC20Fulcrum(iToken).claimLoanToken();
1975       rebalance(claimedTokens, _clientProtocolAmounts);
1976   }
1977 
1978   /**
1979    * Dynamic allocate all the pool across different lending protocols if needed
1980    * Everyone should be incentivized in calling this method
1981    *
1982    * If _newAmount == 0 then simple rebalance
1983    * else rebalance (if needed) and mint (always)
1984    * NOTE: this method can be paused
1985    *
1986    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
1987    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1988    * @return : whether has rebalanced or not
1989    */
1990   function rebalance(uint256 _newAmount, uint256[] memory _clientProtocolAmounts)
1991     public whenNotPaused whenITokenPriceHasNotDecreased
1992     returns (bool) {
1993       // If we are using only one protocol we check if that protocol has still the best apr
1994       // if yes we check if it can support all `_newAmount` provided and still has the best apr
1995 
1996       bool shouldRebalance;
1997       address bestToken;
1998 
1999       if (currentTokensUsed.length == 1 && _newAmount > 0) {
2000         (shouldRebalance, bestToken) = _rebalanceCheck(_newAmount, currentTokensUsed[0]);
2001 
2002         if (!shouldRebalance) {
2003           // only one protocol is currently used and can support all the new liquidity
2004           _mintProtocolTokens(protocolWrappers[currentTokensUsed[0]], _newAmount);
2005           return false; // hasNotRebalanced
2006         }
2007       }
2008 
2009       // otherwise we redeem everything from every protocol and check if the protocol with the
2010       // best apr can support all the liquidity that we redeemed
2011 
2012       // - get current protocol used
2013       TokenProtocol[] memory tokenProtocols = _getCurrentProtocols();
2014       // - redeem everything from each protocol
2015       for (uint8 i = 0; i < tokenProtocols.length; i++) {
2016         _redeemProtocolTokens(
2017           tokenProtocols[i].protocolAddr,
2018           tokenProtocols[i].tokenAddr,
2019           IERC20(tokenProtocols[i].tokenAddr).balanceOf(address(this)),
2020           address(this) // tokens are now in this contract
2021         );
2022       }
2023       // remove all elements from `currentTokensUsed`
2024       delete currentTokensUsed;
2025 
2026       // tokenBalance here has already _newAmount counted
2027       uint256 tokenBalance = IERC20(token).balanceOf(address(this));
2028       if (tokenBalance == 0) {
2029         return false;
2030       }
2031       // (we are re-fetching aprs because after redeeming they changed)
2032       (shouldRebalance, bestToken) = _rebalanceCheck(tokenBalance, address(0));
2033 
2034       if (!shouldRebalance) {
2035         // only one protocol is currently used and can support all the new liquidity
2036         _mintProtocolTokens(protocolWrappers[bestToken], tokenBalance);
2037         // update current tokens used in IdleToken storage
2038         currentTokensUsed.push(bestToken);
2039         return false; // hasNotRebalanced
2040       }
2041 
2042       // if it's not the case we calculate the dynamic allocation for every protocol
2043       (address[] memory tokenAddresses, uint256[] memory protocolAmounts) = _calcAmounts(tokenBalance, _clientProtocolAmounts);
2044 
2045       // mint for each protocol and update currentTokensUsed
2046       uint256 currAmount;
2047       address currAddr;
2048       for (uint8 i = 0; i < protocolAmounts.length; i++) {
2049         currAmount = protocolAmounts[i];
2050         if (currAmount == 0) {
2051           continue;
2052         }
2053         currAddr = tokenAddresses[i];
2054         _mintProtocolTokens(protocolWrappers[currAddr], currAmount);
2055         // update current tokens used in IdleToken storage
2056         currentTokensUsed.push(currAddr);
2057       }
2058 
2059       emit Rebalance(tokenBalance);
2060 
2061       return true; // hasRebalanced
2062   }
2063 
2064   /**
2065    * Used to get `_clientProtocolAmounts` for `rebalance` method
2066    * This should be used only for a call not an actual tx
2067    * NOTE: this method can be paused
2068    *
2069    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
2070    * @return : address[] array with all token addresses used,
2071    *                          eg [cTokenAddress, iTokenAddress]
2072    * @return : uint256[] array with all amounts for each protocol in order,
2073    *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
2074    */
2075   function getParamsForRebalance(uint256 _newAmount)
2076     external whenNotPaused whenITokenPriceHasNotDecreased
2077     returns (address[] memory, uint256[] memory) {
2078       rebalance(_newAmount, new uint256[](0));
2079       return _getCurrentAllocations();
2080   }
2081 
2082   // internal
2083   /**
2084    * Check if a rebalance is needed
2085    * if there is only one protocol and has the best rate then check the nextRateWithAmount()
2086    * if rate is still the highest then put everything there
2087    * otherwise rebalance with all amount
2088    *
2089    * @param _amount : amount of underlying tokens that needs to be added to the current pools NAV
2090    * @return : whether should rebalanced or not
2091    */
2092 
2093   function _rebalanceCheck(uint256 _amount, address currentToken)
2094     internal view
2095     returns (bool, address) {
2096       (address[] memory addresses, uint256[] memory aprs) = getAPRs();
2097       if (aprs.length == 0) {
2098         return (false, address(0));
2099       }
2100 
2101       // we are trying to find if the protocol with the highest APR can support all the liquidity
2102       // we intend to provide
2103       uint256 maxRate;
2104       address maxAddress;
2105       uint256 secondBestRate;
2106       uint256 currApr;
2107       address currAddr;
2108 
2109       // find best rate and secondBestRate
2110       for (uint8 i = 0; i < aprs.length; i++) {
2111         currApr = aprs[i];
2112         currAddr = addresses[i];
2113         if (currApr > maxRate) {
2114           secondBestRate = maxRate;
2115           maxRate = currApr;
2116           maxAddress = currAddr;
2117         } else if (currApr <= maxRate && currApr >= secondBestRate) {
2118           secondBestRate = currApr;
2119         }
2120       }
2121 
2122       if (currentToken != address(0) && currentToken != maxAddress) {
2123         return (true, maxAddress);
2124       } else {
2125         uint256 nextRate = _getProtocolNextRate(protocolWrappers[maxAddress], _amount);
2126         if (nextRate.add(minRateDifference) < secondBestRate) {
2127           return (true, maxAddress);
2128         }
2129       }
2130 
2131       return (false, maxAddress);
2132   }
2133 
2134   /**
2135    * Calls IdleRebalancer `calcRebalanceAmounts` method
2136    *
2137    * @param _amount : amount of underlying tokens that needs to be allocated on lending protocols
2138    * @return tokenAddresses : array with all token addresses used,
2139    * @return amounts : array with all amounts for each protocol in order,
2140    */
2141   function _calcAmounts(uint256 _amount, uint256[] memory _clientProtocolAmounts)
2142     internal view
2143     returns (address[] memory, uint256[] memory) {
2144       uint256[] memory paramsRebalance = new uint256[](_clientProtocolAmounts.length + 1);
2145       paramsRebalance[0] = _amount;
2146 
2147       for (uint8 i = 1; i <= _clientProtocolAmounts.length; i++) {
2148         paramsRebalance[i] = _clientProtocolAmounts[i-1];
2149       }
2150 
2151       return IdleRebalancer(rebalancer).calcRebalanceAmounts(paramsRebalance);
2152   }
2153 
2154   /**
2155    * Get addresses of current tokens and protocol wrappers used
2156    *
2157    * @return currentProtocolsUsed : array of `TokenProtocol` (currentToken address, protocolWrapper address)
2158    */
2159   function _getCurrentProtocols()
2160     internal view
2161     returns (TokenProtocol[] memory currentProtocolsUsed) {
2162       currentProtocolsUsed = new TokenProtocol[](currentTokensUsed.length);
2163       for (uint8 i = 0; i < currentTokensUsed.length; i++) {
2164         currentProtocolsUsed[i] = TokenProtocol(
2165           currentTokensUsed[i],
2166           protocolWrappers[currentTokensUsed[i]]
2167         );
2168       }
2169   }
2170 
2171   /**
2172    * Get the contract balance of every protocol currently used
2173    *
2174    * @return tokenAddresses : array with all token addresses used,
2175    *                          eg [cTokenAddress, iTokenAddress]
2176    * @return amounts : array with all amounts for each protocol in order,
2177    *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
2178    */
2179   function _getCurrentAllocations() internal view
2180     returns (address[] memory tokenAddresses, uint256[] memory amounts) {
2181       // Get balance of every protocol implemented
2182       tokenAddresses = new address[](allAvailableTokens.length);
2183       amounts = new uint256[](allAvailableTokens.length);
2184 
2185       address currentToken;
2186       uint256 currTokenPrice;
2187 
2188       for (uint8 i = 0; i < allAvailableTokens.length; i++) {
2189         currentToken = allAvailableTokens[i];
2190         tokenAddresses[i] = currentToken;
2191         currTokenPrice = ILendingProtocol(protocolWrappers[currentToken]).getPriceInToken();
2192         amounts[i] = currTokenPrice.mul(
2193           IERC20(currentToken).balanceOf(address(this))
2194         ).div(10**18);
2195       }
2196 
2197       // return addresses and respective amounts in underlying
2198       return (tokenAddresses, amounts);
2199   }
2200 
2201   // ILendingProtocols calls
2202   /**
2203    * Get next rate of a lending protocol given an amount to be lended
2204    *
2205    * @param _wrapperAddr : address of protocol wrapper
2206    * @param _amount : amount of underlying to be lended
2207    * @return apr : new apr one will get after lending `_amount`
2208    */
2209   function _getProtocolNextRate(address _wrapperAddr, uint256 _amount)
2210     internal view
2211     returns (uint256 apr) {
2212       ILendingProtocol _wrapper = ILendingProtocol(_wrapperAddr);
2213       apr = _wrapper.nextSupplyRate(_amount);
2214   }
2215 
2216   /**
2217    * Mint protocol tokens through protocol wrapper
2218    *
2219    * @param _wrapperAddr : address of protocol wrapper
2220    * @param _amount : amount of underlying to be lended
2221    * @return tokens : new tokens minted
2222    */
2223   function _mintProtocolTokens(address _wrapperAddr, uint256 _amount)
2224     internal
2225     returns (uint256 tokens) {
2226       if (_amount == 0) {
2227         return tokens;
2228       }
2229       ILendingProtocol _wrapper = ILendingProtocol(_wrapperAddr);
2230       // Transfer _amount underlying token (eg. DAI) to _wrapperAddr
2231       IERC20(token).safeTransfer(_wrapperAddr, _amount);
2232       tokens = _wrapper.mint();
2233   }
2234 
2235   /**
2236    * Redeem underlying tokens through protocol wrapper
2237    *
2238    * @param _wrapperAddr : address of protocol wrapper
2239    * @param _amount : amount of `_token` to redeem
2240    * @param _token : protocol token address
2241    * @param _account : should be msg.sender when rebalancing and final user when redeeming
2242    * @return tokens : new tokens minted
2243    */
2244   function _redeemProtocolTokens(address _wrapperAddr, address _token, uint256 _amount, address _account)
2245     internal
2246     returns (uint256 tokens) {
2247       if (_amount == 0) {
2248         return tokens;
2249       }
2250       ILendingProtocol _wrapper = ILendingProtocol(_wrapperAddr);
2251       // Transfer _amount of _protocolToken (eg. cDAI) to _wrapperAddr
2252       IERC20(_token).safeTransfer(_wrapperAddr, _amount);
2253       tokens = _wrapper.redeem(_account);
2254   }
2255 }