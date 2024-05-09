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
987 pragma solidity 0.5.16;
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
1064   function totalSupplyInterestRate(uint256)
1065     external
1066     view
1067     returns (uint256);
1068 
1069   function claimLoanToken()
1070     external
1071     returns (uint256 claimedAmount);
1072 
1073   function dsr()
1074     external
1075     view
1076     returns (uint256);
1077 
1078   function chaiPrice()
1079     external
1080     view
1081     returns (uint256);
1082 }
1083 
1084 // File: contracts/interfaces/ILendingProtocol.sol
1085 
1086 pragma solidity 0.5.16;
1087 
1088 interface ILendingProtocol {
1089   function mint() external returns (uint256);
1090   function redeem(address account) external returns (uint256);
1091   function nextSupplyRate(uint256 amount) external view returns (uint256);
1092   function nextSupplyRateWithParams(uint256[] calldata params) external view returns (uint256);
1093   function getAPR() external view returns (uint256);
1094   function getPriceInToken() external view returns (uint256);
1095   function token() external view returns (address);
1096   function underlying() external view returns (address);
1097   function availableLiquidity() external view returns (uint256);
1098 }
1099 
1100 // File: contracts/interfaces/IIdleTokenV3.sol
1101 
1102 /**
1103  * @title: Idle Token interface
1104  * @author: Idle Labs Inc., idle.finance
1105  */
1106 pragma solidity 0.5.16;
1107 
1108 interface IIdleTokenV3 {
1109   // view
1110   /**
1111    * IdleToken price calculation, in underlying
1112    *
1113    * @return : price in underlying token
1114    */
1115   function tokenPrice() external view returns (uint256 price);
1116 
1117   /**
1118    * underlying token decimals
1119    *
1120    * @return : decimals of underlying token
1121    */
1122   function tokenDecimals() external view returns (uint256 decimals);
1123 
1124   /**
1125    * Get APR of every ILendingProtocol
1126    *
1127    * @return addresses: array of token addresses
1128    * @return aprs: array of aprs (ordered in respect to the `addresses` array)
1129    */
1130   function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);
1131 
1132   // external
1133   // We should save the amount one has deposited to calc interests
1134 
1135   /**
1136    * Used to mint IdleTokens, given an underlying amount (eg. DAI).
1137    * This method triggers a rebalance of the pools if needed
1138    * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
1139    * NOTE 2: this method can be paused
1140    *
1141    * @param _amount : amount of underlying token to be lended
1142    * @param : pass []
1143    * @return mintedTokens : amount of IdleTokens minted
1144    */
1145   function mintIdleToken(uint256 _amount, uint256[] calldata) external returns (uint256 mintedTokens);
1146 
1147   /**
1148    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1149    * This method triggers a rebalance of the pools if needed
1150    * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
1151    * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
1152    *         Ideally one should wait until the black swan event is terminated
1153    *
1154    * @param _amount : amount of IdleTokens to be burned
1155    * @param : pass []
1156    * @return redeemedTokens : amount of underlying tokens redeemed
1157    */
1158   function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata)
1159     external returns (uint256 redeemedTokens);
1160 
1161   /**
1162    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1163    * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
1164    * Underlying (eg. DAI) is not redeemed here.
1165    *
1166    * @param _amount : amount of IdleTokens to be burned
1167    */
1168   function redeemInterestBearingTokens(uint256 _amount) external;
1169 
1170   /**
1171    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
1172    * @param : pass []
1173    * @return : whether has rebalanced or not
1174    */
1175   function rebalance(uint256 _newAmount, uint256[] calldata) external returns (bool);
1176 
1177   /**
1178    * @return : whether has rebalanced or not
1179    */
1180   function rebalance() external returns (bool);
1181 }
1182 
1183 // File: contracts/interfaces/IIdleRebalancerV3.sol
1184 
1185 /**
1186  * @title: Idle Rebalancer interface
1187  * @author: Idle Labs Inc., idle.finance
1188  */
1189 pragma solidity 0.5.16;
1190 
1191 interface IIdleRebalancerV3 {
1192   function getAllocations() external view returns (uint256[] memory _allocations);
1193 }
1194 
1195 // File: contracts/IdleRebalancerV3.sol
1196 
1197 /**
1198  * @title: Idle Rebalancer contract
1199  * @summary: Used for calculating amounts to lend on each implemented protocol.
1200  *           This implementation works with Compound and Fulcrum only,
1201  *           when a new protocol will be added this should be replaced
1202  * @author: Idle Labs Inc., idle.finance
1203  */
1204 pragma solidity 0.5.16;
1205 
1206 
1207 
1208 
1209 contract IdleRebalancerV3 is IIdleRebalancerV3, Ownable {
1210   using SafeMath for uint256;
1211   uint256[] public lastAmounts;
1212   address[] public lastAmountsAddresses;
1213   address public rebalancerManager;
1214   address public idleToken;
1215 
1216   /**
1217    * @param _cToken : cToken address
1218    * @param _iToken : iToken address
1219    * @param _aToken : aToken address
1220    * @param _yxToken : yxToken address
1221    * @param _rebalancerManager : rebalancerManager address
1222    */
1223   constructor(address _cToken, address _iToken, address _aToken, address _yxToken, address _rebalancerManager) public {
1224     require(_cToken != address(0) && _iToken != address(0) && _aToken != address(0) && _yxToken != address(0) && _rebalancerManager != address(0), 'some addr is 0');
1225     rebalancerManager = _rebalancerManager;
1226 
1227     // Initially 100% on first lending protocol
1228     lastAmounts = [100000, 0, 0, 0];
1229     lastAmountsAddresses = [_cToken, _iToken, _aToken, _yxToken];
1230   }
1231 
1232   /**
1233    * Throws if called by any account other than rebalancerManager.
1234    */
1235   modifier onlyRebalancerAndIdle() {
1236     require(msg.sender == rebalancerManager || msg.sender == idleToken, "Only rebalacer and IdleToken");
1237     _;
1238   }
1239 
1240   /**
1241    * It allows owner to set the allowed rebalancer address
1242    *
1243    * @param _rebalancerManager : rebalance manager address
1244    */
1245   function setRebalancerManager(address _rebalancerManager)
1246     external onlyOwner {
1247       require(_rebalancerManager != address(0), "_rebalancerManager addr is 0");
1248 
1249       rebalancerManager = _rebalancerManager;
1250   }
1251 
1252   function setIdleToken(address _idleToken)
1253     external onlyOwner {
1254       require(idleToken == address(0), "idleToken addr already set");
1255       require(_idleToken != address(0), "_idleToken addr is 0");
1256       idleToken = _idleToken;
1257   }
1258 
1259   /**
1260    * It adds a new token address to lastAmountsAddresses list
1261    *
1262    * @param _newToken : new interest bearing token address
1263    */
1264   function setNewToken(address _newToken)
1265     external onlyOwner {
1266       require(_newToken != address(0), "New token should be != 0");
1267       for (uint256 i = 0; i < lastAmountsAddresses.length; i++) {
1268         if (lastAmountsAddresses[i] == _newToken) {
1269           return;
1270         }
1271       }
1272 
1273       lastAmountsAddresses.push(_newToken);
1274       lastAmounts.push(0);
1275   }
1276   // end onlyOwner
1277 
1278   /**
1279    * Used by Rebalance manager to set the new allocations
1280    *
1281    * @param _allocations : array with allocations in percentages (100% => 100000)
1282    * @param _addresses : array with addresses of tokens used, should be equal to lastAmountsAddresses
1283    */
1284   function setAllocations(uint256[] calldata _allocations, address[] calldata _addresses)
1285     external onlyRebalancerAndIdle
1286   {
1287     require(_allocations.length == lastAmounts.length, "Alloc lengths are different, allocations");
1288     require(_allocations.length == _addresses.length, "Alloc lengths are different, addresses");
1289 
1290     uint256 total;
1291     for (uint256 i = 0; i < _allocations.length; i++) {
1292       require(_addresses[i] == lastAmountsAddresses[i], "Addresses do not match");
1293       total = total.add(_allocations[i]);
1294       lastAmounts[i] = _allocations[i];
1295     }
1296     require(total == 100000, "Not allocating 100%");
1297   }
1298 
1299   function getAllocations()
1300     external view returns (uint256[] memory _allocations) {
1301     return lastAmounts;
1302   }
1303 
1304   function getAllocationsLength()
1305     external view returns (uint256) {
1306     return lastAmounts.length;
1307   }
1308 }
1309 
1310 // File: contracts/interfaces/IIdleToken.sol
1311 
1312 /**
1313  * @title: Idle Token interface
1314  * @author: Idle Labs Inc., idle.finance
1315  */
1316 pragma solidity 0.5.16;
1317 
1318 interface IIdleToken {
1319   // view
1320   /**
1321    * IdleToken price calculation, in underlying
1322    *
1323    * @return : price in underlying token
1324    */
1325   function tokenPrice() external view returns (uint256 price);
1326 
1327   /**
1328    * underlying token decimals
1329    *
1330    * @return : decimals of underlying token
1331    */
1332   function tokenDecimals() external view returns (uint256 decimals);
1333 
1334   /**
1335    * Get APR of every ILendingProtocol
1336    *
1337    * @return addresses: array of token addresses
1338    * @return aprs: array of aprs (ordered in respect to the `addresses` array)
1339    */
1340   function getAPRs() external view returns (address[] memory addresses, uint256[] memory aprs);
1341 
1342   // external
1343   // We should save the amount one has deposited to calc interests
1344 
1345   /**
1346    * Used to mint IdleTokens, given an underlying amount (eg. DAI).
1347    * This method triggers a rebalance of the pools if needed
1348    * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
1349    * NOTE 2: this method can be paused
1350    *
1351    * @param _amount : amount of underlying token to be lended
1352    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1353    * @return mintedTokens : amount of IdleTokens minted
1354    */
1355   function mintIdleToken(uint256 _amount, uint256[] calldata _clientProtocolAmounts) external returns (uint256 mintedTokens);
1356 
1357   /**
1358    * @param _amount : amount of underlying token to be lended
1359    * @return : address[] array with all token addresses used,
1360    *                          eg [cTokenAddress, iTokenAddress]
1361    * @return : uint256[] array with all amounts for each protocol in order,
1362    *                   eg [amountCompound, amountFulcrum]
1363    */
1364   function getParamsForMintIdleToken(uint256 _amount) external returns (address[] memory, uint256[] memory);
1365 
1366   /**
1367    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1368    * This method triggers a rebalance of the pools if needed
1369    * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
1370    * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
1371    *         Ideally one should wait until the black swan event is terminated
1372    *
1373    * @param _amount : amount of IdleTokens to be burned
1374    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1375    * @return redeemedTokens : amount of underlying tokens redeemed
1376    */
1377   function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata _clientProtocolAmounts)
1378     external returns (uint256 redeemedTokens);
1379 
1380   /**
1381    * @param _amount : amount of IdleTokens to be burned
1382    * @param _skipRebalance : whether to skip the rebalance process or not
1383    * @return : address[] array with all token addresses used,
1384    *                          eg [cTokenAddress, iTokenAddress]
1385    * @return : uint256[] array with all amounts for each protocol in order,
1386    *                   eg [amountCompound, amountFulcrum]
1387    */
1388   function getParamsForRedeemIdleToken(uint256 _amount, bool _skipRebalance)
1389     external returns (address[] memory, uint256[] memory);
1390 
1391   /**
1392    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1393    * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
1394    * Underlying (eg. DAI) is not redeemed here.
1395    *
1396    * @param _amount : amount of IdleTokens to be burned
1397    */
1398   function redeemInterestBearingTokens(uint256 _amount) external;
1399 
1400   /**
1401    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1402    * @return claimedTokens : amount of underlying tokens claimed
1403    */
1404   function claimITokens(uint256[] calldata _clientProtocolAmounts) external returns (uint256 claimedTokens);
1405 
1406   /**
1407    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
1408    * @param _clientProtocolAmounts : client side calculated amounts to put on each lending protocol
1409    * @return : whether has rebalanced or not
1410    */
1411   function rebalance(uint256 _newAmount, uint256[] calldata _clientProtocolAmounts) external returns (bool);
1412 
1413   /**
1414    * @param _newAmount : amount of underlying tokens that needs to be minted with this rebalance
1415    * @return : address[] array with all token addresses used,
1416    *                          eg [cTokenAddress, iTokenAddress]
1417    * @return : uint256[] array with all amounts for each protocol in order,
1418    *                   eg [amountCompound, amountFulcrum]
1419    */
1420   function getParamsForRebalance(uint256 _newAmount) external returns (address[] memory, uint256[] memory);
1421 }
1422 
1423 // File: contracts/IdlePriceCalculator.sol
1424 
1425 /**
1426  * @title: Idle Price Calculator contract
1427  * @summary: Used for calculating the current IdleToken price in underlying (eg. DAI)
1428  *          price is: Net Asset Value / totalSupply
1429  * @author: Idle Labs Inc., idle.finance
1430  */
1431 pragma solidity 0.5.16;
1432 
1433 
1434 
1435 
1436 
1437 
1438 contract IdlePriceCalculator {
1439   using SafeMath for uint256;
1440   /**
1441    * IdleToken price calculation, in underlying (eg. DAI)
1442    *
1443    * @return : price in underlying token
1444    */
1445   function tokenPrice(
1446     uint256 totalSupply,
1447     address idleToken,
1448     address[] calldata currentTokensUsed,
1449     address[] calldata protocolWrappersAddresses
1450   )
1451     external view
1452     returns (uint256 price) {
1453       require(currentTokensUsed.length == protocolWrappersAddresses.length, "Different Length");
1454 
1455       if (totalSupply == 0) {
1456         return 10**(IIdleToken(idleToken).tokenDecimals());
1457       }
1458 
1459       uint256 currPrice;
1460       uint256 currNav;
1461       uint256 totNav;
1462 
1463       for (uint256 i = 0; i < currentTokensUsed.length; i++) {
1464         currPrice = ILendingProtocol(protocolWrappersAddresses[i]).getPriceInToken();
1465         // NAV = price * poolSupply
1466         currNav = currPrice.mul(IERC20(currentTokensUsed[i]).balanceOf(idleToken));
1467         totNav = totNav.add(currNav);
1468       }
1469 
1470       price = totNav.div(totalSupply); // idleToken price in token wei
1471   }
1472 }
1473 
1474 // File: contracts/interfaces/GasToken.sol
1475 
1476 pragma solidity 0.5.16;
1477 
1478 interface GasToken {
1479   function freeUpTo(uint256 value) external returns (uint256 freed);
1480   function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
1481   function balanceOf(address from) external returns (uint256 balance);
1482 }
1483 
1484 // File: contracts/GST2Consumer.sol
1485 
1486 pragma solidity 0.5.16;
1487 
1488 
1489 contract GST2Consumer {
1490   GasToken public constant gst2 = GasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
1491   uint256[] internal gasAmounts = [14154, 41130, 27710, 7020];
1492 
1493   modifier gasDiscountFrom(address from) {
1494     uint256 initialGasLeft = gasleft();
1495     _;
1496     _makeGasDiscount(initialGasLeft - gasleft(), from);
1497   }
1498 
1499   function _makeGasDiscount(uint256 gasSpent, address from) internal {
1500     // For more info https://gastoken.io/
1501     // 14154 -> FREE_BASE -> base cost of freeing
1502     // 41130 -> 2 * REIMBURSE - FREE_TOKEN -> 2 * 24000 - 6870
1503     uint256 tokens = (gasSpent + gasAmounts[0]) / gasAmounts[1];
1504     uint256 safeNumTokens;
1505     uint256 gas = gasleft();
1506 
1507     // For more info https://github.com/projectchicago/gastoken/blob/master/contract/gst2_free_example.sol
1508     if (gas >= gasAmounts[2]) {
1509       safeNumTokens = (gas - gasAmounts[2]) / gasAmounts[3];
1510     }
1511 
1512     if (tokens > safeNumTokens) {
1513       tokens = safeNumTokens;
1514     }
1515 
1516     if (tokens > 0) {
1517       if (from == address(this)) {
1518         gst2.freeUpTo(tokens);
1519       } else {
1520         gst2.freeFromUpTo(from, tokens);
1521       }
1522     }
1523   }
1524 }
1525 
1526 // File: contracts/IdleTokenV3.sol
1527 
1528 /**
1529  * @title: Idle Token (V3) main contract
1530  * @summary: ERC20 that holds pooled user funds together
1531  *           Each token rapresent a share of the underlying pools
1532  *           and with each token user have the right to redeem a portion of these pools
1533  * @author: Idle Labs Inc., idle.finance
1534  */
1535 pragma solidity 0.5.16;
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 
1545 
1546 
1547 
1548 
1549 
1550 
1551 contract IdleTokenV3 is ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Pausable, IIdleTokenV3, GST2Consumer {
1552   using SafeERC20 for IERC20;
1553   using SafeMath for uint256;
1554 
1555   // eg. cTokenAddress => IdleCompoundAddress
1556   mapping(address => address) public protocolWrappers;
1557   // eg. DAI address
1558   address public token;
1559   // eg. iDAI address
1560   address public iToken; // used for claimITokens and userClaimITokens
1561   // Idle rebalancer current implementation address
1562   address public rebalancer;
1563   // Idle price calculator current implementation address
1564   address public priceCalculator;
1565   // Address collecting underlying fees
1566   address public feeAddress;
1567   // Last iToken price, used to pause contract in case of a black swan event
1568   uint256 public lastITokenPrice;
1569   // eg. 18 for DAI
1570   uint256 public tokenDecimals;
1571   // Max possible fee on interest gained
1572   uint256 constant MAX_FEE = 10000; // 100000 == 100% -> 10000 == 10%
1573   // Min delay for adding a new protocol
1574   uint256 constant NEW_PROTOCOL_DELAY = 60 * 60 * 24 * 3; // 3 days in seconds
1575   // Current fee on interest gained
1576   uint256 public fee;
1577   // Manual trigger for unpausing contract in case of a black swan event that caused the iToken price to not
1578   // return to the normal level
1579   bool public manualPlay;
1580   // Flag for disabling openRebalance for the risk adjusted variant
1581   bool public isRiskAdjusted;
1582   // Flag for disabling instant new protocols additions
1583   bool public isNewProtocolDelayed;
1584   // eg. [cTokenAddress, iTokenAddress, ...]
1585   address[] public allAvailableTokens;
1586   // last fully applied allocations (ie when all liquidity has been correctly placed)
1587   // eg. [5000, 0, 5000, 0] for 50% in compound, 0% fulcrum, 50% aave, 0 dydx. same order of allAvailableTokens
1588   uint256[] public lastAllocations;
1589   // Map that saves avg idleToken price paid for each user
1590   mapping(address => uint256) public userAvgPrices;
1591   // Map that saves amount with no fee for each user
1592   mapping(address => uint256) private userNoFeeQty;
1593   // timestamp when new protocol wrapper has been queued for change
1594   // protocol_wrapper_address -> timestamp
1595   mapping(address => uint256) public releaseTimes;
1596 
1597   /**
1598    * @dev constructor, initialize some variables, mainly addresses of other contracts
1599    *
1600    * @param _name : IdleToken name
1601    * @param _symbol : IdleToken symbol
1602    * @param _decimals : IdleToken decimals
1603    * @param _token : underlying token address
1604    * @param _cToken : cToken address
1605    * @param _iToken : iToken address
1606    * @param _rebalancer : Idle Rebalancer address
1607    * @param _idleCompound : Idle Compound address
1608    * @param _idleFulcrum : Idle Fulcrum address
1609    */
1610   constructor(
1611     string memory _name, // eg. IdleDAI
1612     string memory _symbol, // eg. IDLEDAI
1613     uint8 _decimals, // eg. 18
1614     address _token,
1615     address _cToken,
1616     address _iToken,
1617     address _rebalancer,
1618     address _priceCalculator,
1619     address _idleCompound,
1620     address _idleFulcrum)
1621     public
1622     ERC20Detailed(_name, _symbol, _decimals) {
1623       token = _token;
1624       tokenDecimals = ERC20Detailed(_token).decimals();
1625       iToken = _iToken;
1626       rebalancer = _rebalancer;
1627       priceCalculator = _priceCalculator;
1628       protocolWrappers[_cToken] = _idleCompound;
1629       protocolWrappers[_iToken] = _idleFulcrum;
1630       allAvailableTokens = [_cToken, _iToken];
1631   }
1632 
1633   // During a black swan event is possible that iToken price decreases instead of increasing,
1634   // with the consequence of lowering the IdleToken price. To mitigate this we implemented a
1635   // check on the iToken price that prevents users from minting cheap IdleTokens or rebalancing
1636   // the pool in this specific case. The redeemIdleToken won't be paused but the rebalance process
1637   // won't be triggered in this case.
1638   modifier whenITokenPriceHasNotDecreased() {
1639     uint256 iTokenPrice = iERC20Fulcrum(iToken).tokenPrice();
1640     require(
1641       iTokenPrice >= lastITokenPrice || manualPlay,
1642       "Paused: iToken price decreased"
1643     );
1644 
1645     _;
1646 
1647     if (iTokenPrice > lastITokenPrice) {
1648       lastITokenPrice = iTokenPrice;
1649     }
1650   }
1651 
1652   // onlyOwner
1653   /**
1654    * It allows owner to set the IdleRebalancerV3 address
1655    *
1656    * @param _rebalancer : new IdleRebalancerV3 address
1657    */
1658   function setRebalancer(address _rebalancer)
1659     external onlyOwner {
1660       require(_rebalancer != address(0), 'Addr is 0');
1661       rebalancer = _rebalancer;
1662   }
1663   /**
1664    * It allows owner to set the IdlePriceCalculator address
1665    *
1666    * @param _priceCalculator : new IdlePriceCalculator address
1667    */
1668   function setPriceCalculator(address _priceCalculator)
1669     external onlyOwner {
1670       require(_priceCalculator != address(0), 'Addr is 0');
1671       if (!isNewProtocolDelayed || (releaseTimes[_priceCalculator] != 0 && now - releaseTimes[_priceCalculator] > NEW_PROTOCOL_DELAY)) {
1672         priceCalculator = _priceCalculator;
1673         releaseTimes[_priceCalculator] = 0;
1674         return;
1675       }
1676       releaseTimes[_priceCalculator] = now;
1677   }
1678 
1679   /**
1680    * It allows owner to set a protocol wrapper address
1681    *
1682    * @param _token : underlying token address (eg. DAI)
1683    * @param _wrapper : Idle protocol wrapper address
1684    */
1685   function setProtocolWrapper(address _token, address _wrapper)
1686     external onlyOwner {
1687       require(_token != address(0) && _wrapper != address(0), 'some addr is 0');
1688 
1689       if (!isNewProtocolDelayed || (releaseTimes[_wrapper] != 0 && now - releaseTimes[_wrapper] > NEW_PROTOCOL_DELAY)) {
1690         // update allAvailableTokens if needed
1691         if (protocolWrappers[_token] == address(0)) {
1692           allAvailableTokens.push(_token);
1693         }
1694         protocolWrappers[_token] = _wrapper;
1695         releaseTimes[_wrapper] = 0;
1696         return;
1697       }
1698 
1699       releaseTimes[_wrapper] = now;
1700   }
1701 
1702   /**
1703    * It allows owner to unpause the contract when iToken price decreased and didn't return to the expected level
1704    *
1705    * @param _manualPlay : flag
1706    */
1707   function setManualPlay(bool _manualPlay)
1708     external onlyOwner {
1709       manualPlay = _manualPlay;
1710   }
1711 
1712   /**
1713    * It allows owner to disable openRebalance
1714    *
1715    * @param _isRiskAdjusted : flag
1716    */
1717   function setIsRiskAdjusted(bool _isRiskAdjusted)
1718     external onlyOwner {
1719       isRiskAdjusted = _isRiskAdjusted;
1720   }
1721 
1722   /**
1723    * It permanently disable instant new protocols additions
1724    */
1725   function delayNewProtocols()
1726     external onlyOwner {
1727       isNewProtocolDelayed = true;
1728   }
1729 
1730   /**
1731    * It allows owner to set the fee (1000 == 10% of gained interest)
1732    *
1733    * @param _fee : fee amount where 100000 is 100%, max settable is MAX_FEE constant
1734    */
1735   function setFee(uint256 _fee)
1736     external onlyOwner {
1737       require(_fee <= MAX_FEE, "Fee too high");
1738       fee = _fee;
1739   }
1740 
1741   /**
1742    * It allows owner to set the fee address
1743    *
1744    * @param _feeAddress : fee address
1745    */
1746   function setFeeAddress(address _feeAddress)
1747     external onlyOwner {
1748       require(_feeAddress != address(0), 'Addr is 0');
1749       feeAddress = _feeAddress;
1750   }
1751 
1752   /**
1753    * It allows owner to set gas parameters
1754    *
1755    * @param _amounts : fee amount where 100000 is 100%, max settable is MAX_FEE constant
1756    */
1757   function setGasParams(uint256[] calldata _amounts)
1758     external onlyOwner {
1759       gasAmounts = _amounts;
1760   }
1761   // view
1762   /**
1763    * IdleToken price calculation, in underlying
1764    *
1765    * @return : price in underlying token
1766    */
1767   function tokenPrice()
1768     public view
1769     returns (uint256 price) {
1770       address[] memory protocolWrappersAddresses = new address[](allAvailableTokens.length);
1771       for (uint256 i = 0; i < allAvailableTokens.length; i++) {
1772         protocolWrappersAddresses[i] = protocolWrappers[allAvailableTokens[i]];
1773       }
1774       price = IdlePriceCalculator(priceCalculator).tokenPrice(
1775         totalSupply(), address(this), allAvailableTokens, protocolWrappersAddresses
1776       );
1777   }
1778 
1779   /**
1780    * Get APR of every ILendingProtocol
1781    *
1782    * @return addresses: array of token addresses
1783    * @return aprs: array of aprs (ordered in respect to the `addresses` array)
1784    */
1785   function getAPRs()
1786     external view
1787     returns (address[] memory addresses, uint256[] memory aprs) {
1788       address currToken;
1789       addresses = new address[](allAvailableTokens.length);
1790       aprs = new uint256[](allAvailableTokens.length);
1791       for (uint256 i = 0; i < allAvailableTokens.length; i++) {
1792         currToken = allAvailableTokens[i];
1793         addresses[i] = currToken;
1794         aprs[i] = ILendingProtocol(protocolWrappers[currToken]).getAPR();
1795       }
1796   }
1797 
1798   /**
1799    * Get current avg APR of this IdleToken
1800    *
1801    * @return avgApr: current weighted avg apr
1802    */
1803   function getAvgAPR()
1804     public view
1805     returns (uint256 avgApr) {
1806       (, uint256[] memory amounts, uint256 total) = _getCurrentAllocations();
1807       uint256 currApr;
1808       uint256 weight;
1809       for (uint256 i = 0; i < allAvailableTokens.length; i++) {
1810         if (amounts[i] == 0) {
1811           continue;
1812         }
1813         currApr = ILendingProtocol(protocolWrappers[allAvailableTokens[i]]).getAPR();
1814         weight = amounts[i].mul(10**18).div(total);
1815         avgApr = avgApr.add(currApr.mul(weight).div(10**18));
1816       }
1817   }
1818 
1819   // ##### ERC20 modified transfer and transferFrom that also update the avgPrice paid for the recipient
1820   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1821     _transfer(sender, recipient, amount);
1822     _approve(sender, msg.sender, allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance"));
1823     _updateAvgPrice(recipient, amount, userAvgPrices[sender]);
1824     return true;
1825   }
1826   function transfer(address recipient, uint256 amount) public returns (bool) {
1827     _transfer(msg.sender, recipient, amount);
1828     _updateAvgPrice(recipient, amount, userAvgPrices[msg.sender]);
1829     return true;
1830   }
1831   // #####
1832 
1833   // external
1834   /**
1835    * Used to mint IdleTokens, given an underlying amount (eg. DAI).
1836    * This method triggers a rebalance of the pools if needed and if _skipWholeRebalance is false
1837    * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
1838    * NOTE 2: this method can be paused
1839    * This method use GasTokens of this contract (if present) to get a gas discount
1840    *
1841    * @param _amount : amount of underlying token to be lended
1842    * @param _skipWholeRebalance : flag to choose whter to do a full rebalance or not
1843    * @return mintedTokens : amount of IdleTokens minted
1844    */
1845   function mintIdleToken(uint256 _amount, bool _skipWholeRebalance)
1846     external nonReentrant gasDiscountFrom(address(this))
1847     returns (uint256 mintedTokens) {
1848     return _mintIdleToken(_amount, new uint256[](0), _skipWholeRebalance);
1849   }
1850 
1851   /**
1852    * DEPRECATED: Used to mint IdleTokens, given an underlying amount (eg. DAI).
1853    * Keep for backward compatibility with IdleV2
1854    *
1855    * @param _amount : amount of underlying token to be lended
1856    * @param : not used, pass empty array
1857    * @return mintedTokens : amount of IdleTokens minted
1858    */
1859   function mintIdleToken(uint256 _amount, uint256[] calldata)
1860     external nonReentrant gasDiscountFrom(address(this))
1861     returns (uint256 mintedTokens) {
1862     return _mintIdleToken(_amount, new uint256[](0), false);
1863   }
1864 
1865   /**
1866    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1867    * This method triggers a rebalance of the pools if needed
1868    * NOTE: If the contract is paused or iToken price has decreased one can still redeem but no rebalance happens.
1869    * NOTE 2: If iToken price has decresed one should not redeem (but can do it) otherwise he would capitalize the loss.
1870    *         Ideally one should wait until the black swan event is terminated
1871    *
1872    * @param _amount : amount of IdleTokens to be burned
1873    * @param _skipRebalance : whether to skip the rebalance process or not
1874    * @param : not used
1875    * @return redeemedTokens : amount of underlying tokens redeemed
1876    */
1877   function redeemIdleToken(uint256 _amount, bool _skipRebalance, uint256[] calldata)
1878     external nonReentrant
1879     returns (uint256 redeemedTokens) {
1880       uint256 balance;
1881       for (uint256 i = 0; i < allAvailableTokens.length; i++) {
1882         balance = IERC20(allAvailableTokens[i]).balanceOf(address(this));
1883         if (balance == 0) {
1884           continue;
1885         }
1886         redeemedTokens = redeemedTokens.add(
1887           _redeemProtocolTokens(
1888             protocolWrappers[allAvailableTokens[i]],
1889             allAvailableTokens[i],
1890             // _amount * protocolPoolBalance / idleSupply
1891             _amount.mul(balance).div(totalSupply()), // amount to redeem
1892             address(this)
1893           )
1894         );
1895       }
1896 
1897       _burn(msg.sender, _amount);
1898       if (fee > 0 && feeAddress != address(0)) {
1899         redeemedTokens = _getFee(_amount, redeemedTokens);
1900       }
1901       // send underlying minus fee to msg.sender
1902       IERC20(token).safeTransfer(msg.sender, redeemedTokens);
1903 
1904       if (this.paused() || iERC20Fulcrum(iToken).tokenPrice() < lastITokenPrice || _skipRebalance) {
1905         return redeemedTokens;
1906       }
1907 
1908       _rebalance(0, false);
1909   }
1910 
1911   /**
1912    * Here we calc the pool share one can withdraw given the amount of IdleToken they want to burn
1913    * and send interest-bearing tokens (eg. cDAI/iDAI) directly to the user.
1914    * Underlying (eg. DAI) is not redeemed here.
1915    *
1916    * @param _amount : amount of IdleTokens to be burned
1917    */
1918   function redeemInterestBearingTokens(uint256 _amount)
1919     external nonReentrant {
1920       uint256 idleSupply = totalSupply();
1921       address currentToken;
1922       uint256 balance;
1923 
1924       for (uint256 i = 0; i < allAvailableTokens.length; i++) {
1925         currentToken = allAvailableTokens[i];
1926         balance = IERC20(currentToken).balanceOf(address(this));
1927         if (balance == 0) {
1928           continue;
1929         }
1930         IERC20(currentToken).safeTransfer(
1931           msg.sender,
1932           _amount.mul(balance).div(idleSupply) // amount to redeem
1933         );
1934       }
1935 
1936       _burn(msg.sender, _amount);
1937   }
1938 
1939   /**
1940    * Allow any users to set new allocations as long as the new allocations
1941    * give a better avg APR than before
1942    * Allocations should be in the format [100000, 0, 0, 0, ...] where length is the same
1943    * as lastAllocations variable and the sum of all value should be == 100000
1944    *
1945    * This method is not callble if this instance of IdleToken is a risk adjusted instance
1946    * NOTE: this method can be paused
1947    *
1948    * @param _newAllocations : array with new allocations in percentage
1949    * @return : whether has rebalanced or not
1950    * @return avgApr : the new avg apr after rebalance
1951    */
1952   function openRebalance(uint256[] calldata _newAllocations)
1953     external whenNotPaused whenITokenPriceHasNotDecreased
1954     returns (bool, uint256 avgApr) {
1955       require(!isRiskAdjusted, "Setting allocations not allowed");
1956       uint256 initialAPR = getAvgAPR();
1957       // Validate and update rebalancer allocations
1958       IdleRebalancerV3(rebalancer).setAllocations(_newAllocations, allAvailableTokens);
1959       bool hasRebalanced = _rebalance(0, false);
1960       uint256 newAprAfterRebalance = getAvgAPR();
1961       require(newAprAfterRebalance > initialAPR, "APR not improved");
1962       return (hasRebalanced, newAprAfterRebalance);
1963   }
1964 
1965   /**
1966    * Dynamic allocate all the pool across different lending protocols if needed, use gas refund from gasToken
1967    *
1968    * NOTE: this method can be paused.
1969    * msg.sender should approve this contract to spend GST2 tokens before calling
1970    * this method
1971    *
1972    * @return : whether has rebalanced or not
1973    */
1974   function rebalanceWithGST()
1975     external gasDiscountFrom(msg.sender)
1976     returns (bool) {
1977       return _rebalance(0, false);
1978   }
1979 
1980   /**
1981    * DEPRECATED: Dynamic allocate all the pool across different lending protocols if needed,
1982    * Keep for backward compatibility with IdleV2
1983    *
1984    * NOTE: this method can be paused
1985    *
1986    * @param : not used
1987    * @param : not used
1988    * @return : whether has rebalanced or not
1989    */
1990   function rebalance(uint256, uint256[] calldata)
1991     external returns (bool) {
1992     return _rebalance(0, false);
1993   }
1994 
1995   /**
1996    * Dynamic allocate all the pool across different lending protocols if needed,
1997    * rebalance without params
1998    *
1999    * NOTE: this method can be paused
2000    *
2001    * @return : whether has rebalanced or not
2002    */
2003   function rebalance() external returns (bool) {
2004     return _rebalance(0, false);
2005   }
2006 
2007   /**
2008    * Get the contract balance of every protocol currently used
2009    *
2010    * @return tokenAddresses : array with all token addresses used,
2011    *                          eg [cTokenAddress, iTokenAddress]
2012    * @return amounts : array with all amounts for each protocol in order,
2013    *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
2014    * @return total : total AUM in underlying
2015    */
2016   function getCurrentAllocations() external view
2017     returns (address[] memory tokenAddresses, uint256[] memory amounts, uint256 total) {
2018     return _getCurrentAllocations();
2019   }
2020 
2021   // internal
2022   /**
2023    * Used to mint IdleTokens, given an underlying amount (eg. DAI).
2024    * This method triggers a rebalance of the pools if needed
2025    * NOTE: User should 'approve' _amount of tokens before calling mintIdleToken
2026    * NOTE 2: this method can be paused
2027    * This method use GasTokens of this contract (if present) to get a gas discount
2028    *
2029    * @param _amount : amount of underlying token to be lended
2030    * @param : not used
2031    * @param _skipWholeRebalance : flag to decide if doing a simple mint or mint + rebalance
2032    * @return mintedTokens : amount of IdleTokens minted
2033    */
2034   function _mintIdleToken(uint256 _amount, uint256[] memory, bool _skipWholeRebalance)
2035     internal whenNotPaused whenITokenPriceHasNotDecreased
2036     returns (uint256 mintedTokens) {
2037       // Get current IdleToken price
2038       uint256 idlePrice = tokenPrice();
2039       // transfer tokens to this contract
2040       IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
2041 
2042       // Rebalance the current pool if needed and mint new supplied amount
2043       _rebalance(0, _skipWholeRebalance);
2044 
2045       mintedTokens = _amount.mul(10**18).div(idlePrice);
2046       _mint(msg.sender, mintedTokens);
2047 
2048       _updateAvgPrice(msg.sender, mintedTokens, idlePrice);
2049   }
2050 
2051   /**
2052    * Dynamic allocate all the pool across different lending protocols if needed
2053    *
2054    * NOTE: this method can be paused
2055    *
2056    * @param : not used
2057    * @return : whether has rebalanced or not
2058    */
2059   function _rebalance(uint256, bool _skipWholeRebalance)
2060     internal whenNotPaused whenITokenPriceHasNotDecreased
2061     returns (bool) {
2062       // check if we need to rebalance by looking at the allocations in rebalancer contract
2063       uint256[] memory rebalancerLastAllocations = IdleRebalancerV3(rebalancer).getAllocations();
2064       bool areAllocationsEqual = rebalancerLastAllocations.length == lastAllocations.length;
2065       if (areAllocationsEqual) {
2066         for (uint256 i = 0; i < lastAllocations.length || !areAllocationsEqual; i++) {
2067           if (lastAllocations[i] != rebalancerLastAllocations[i]) {
2068             areAllocationsEqual = false;
2069             break;
2070           }
2071         }
2072       }
2073       uint256 balance = IERC20(token).balanceOf(address(this));
2074       if (areAllocationsEqual && balance == 0) {
2075         return false;
2076       }
2077 
2078       if (balance > 0) {
2079         if (lastAllocations.length == 0 && _skipWholeRebalance) {
2080           // set in storage
2081           lastAllocations = rebalancerLastAllocations;
2082         }
2083         _mintWithAmounts(allAvailableTokens, _amountsFromAllocations(rebalancerLastAllocations, balance));
2084       }
2085 
2086       if (_skipWholeRebalance || areAllocationsEqual) {
2087         return false;
2088       }
2089 
2090       // Instead of redeeming everything during rebalance we redeem and mint only what needs
2091       // to be reallocated
2092       // get current allocations in underlying
2093       (address[] memory tokenAddresses, uint256[] memory amounts, uint256 totalInUnderlying) = _getCurrentAllocations();
2094       // calculate new allocations given the total
2095       uint256[] memory newAmounts = _amountsFromAllocations(rebalancerLastAllocations, totalInUnderlying);
2096       (uint256[] memory toMintAllocations, uint256 totalToMint, bool lowLiquidity) = _redeemAllNeeded(tokenAddresses, amounts, newAmounts);
2097 
2098       // if some protocol has liquidity that we should redeem, we do not update
2099       // lastAllocations to force another rebalance next time
2100       if (!lowLiquidity) {
2101         // Update lastAllocations with rebalancerLastAllocations
2102         delete lastAllocations;
2103         lastAllocations = rebalancerLastAllocations;
2104       }
2105       uint256 totalRedeemd = IERC20(token).balanceOf(address(this));
2106       if (totalRedeemd > 1 && totalToMint > 1) {
2107         // Do not mint directly using toMintAllocations check with totalRedeemd
2108         uint256[] memory tempAllocations = new uint256[](toMintAllocations.length);
2109         for (uint256 i = 0; i < toMintAllocations.length; i++) {
2110           // Calc what would have been the correct allocations percentage if all was available
2111           tempAllocations[i] = toMintAllocations[i].mul(100000).div(totalToMint);
2112         }
2113 
2114         uint256[] memory partialAmounts = _amountsFromAllocations(tempAllocations, totalRedeemd);
2115         _mintWithAmounts(allAvailableTokens, partialAmounts);
2116       }
2117 
2118       return true; // hasRebalanced
2119   }
2120 
2121   /**
2122    * Update avg price paid for each idle token of a user
2123    *
2124    * @param usr : user that should have balance update
2125    * @param qty : new amount deposited / transferred, in idleToken
2126    * @param price : curr idleToken price in underlying
2127    */
2128   function _updateAvgPrice(address usr, uint256 qty, uint256 price) internal {
2129     if (fee == 0) {
2130       userNoFeeQty[usr] = userNoFeeQty[usr].add(qty);
2131       return;
2132     }
2133 
2134     uint256 totBalance = balanceOf(usr).sub(userNoFeeQty[usr]);
2135     uint256 oldAvgPrice = userAvgPrices[usr];
2136     uint256 oldBalance = totBalance.sub(qty);
2137     userAvgPrices[usr] = oldAvgPrice.mul(oldBalance).div(totBalance).add(price.mul(qty).div(totBalance));
2138   }
2139 
2140   /**
2141    * Calculate fee and send them to feeAddress
2142    *
2143    * @param amount : in idleTokens
2144    * @param redeemed : in underlying
2145    * @return : net value in underlying
2146    */
2147   function _getFee(uint256 amount, uint256 redeemed) internal returns (uint256) {
2148     uint256 noFeeQty = userNoFeeQty[msg.sender];
2149     uint256 currPrice = tokenPrice();
2150     if (noFeeQty > 0 && noFeeQty > amount) {
2151       noFeeQty = amount;
2152     }
2153 
2154     uint256 totalValPaid = noFeeQty.mul(currPrice).add(amount.sub(noFeeQty).mul(userAvgPrices[msg.sender])).div(10**18);
2155     uint256 currVal = amount.mul(currPrice).div(10**18);
2156     if (currVal < totalValPaid) {
2157       return redeemed;
2158     }
2159     uint256 gain = currVal.sub(totalValPaid);
2160     uint256 feeDue = gain.mul(fee).div(100000);
2161     IERC20(token).safeTransfer(feeAddress, feeDue);
2162     userNoFeeQty[msg.sender] = userNoFeeQty[msg.sender].sub(noFeeQty);
2163     return currVal.sub(feeDue);
2164   }
2165 
2166   /**
2167    * Mint specific amounts of protocols tokens
2168    *
2169    * @param tokenAddresses : array of protocol tokens
2170    * @param protocolAmounts : array of amounts to be minted
2171    * @return : net value in underlying
2172    */
2173   function _mintWithAmounts(address[] memory tokenAddresses, uint256[] memory protocolAmounts) internal {
2174     // mint for each protocol and update currentTokensUsed
2175     require(tokenAddresses.length == protocolAmounts.length, "All tokens length != allocations length");
2176 
2177     uint256 currAmount;
2178 
2179     for (uint256 i = 0; i < protocolAmounts.length; i++) {
2180       currAmount = protocolAmounts[i];
2181       if (currAmount == 0) {
2182         continue;
2183       }
2184       _mintProtocolTokens(protocolWrappers[tokenAddresses[i]], currAmount);
2185     }
2186   }
2187 
2188   /**
2189    * Calculate amounts from percentage allocations (100000 => 100%)
2190    *
2191    * @param allocations : array of protocol allocations in percentage
2192    * @param total : total amount
2193    * @return : array with amounts
2194    */
2195   function _amountsFromAllocations(uint256[] memory allocations, uint256 total)
2196     internal pure returns (uint256[] memory) {
2197     uint256[] memory newAmounts = new uint256[](allocations.length);
2198     uint256 currBalance = 0;
2199     uint256 allocatedBalance = 0;
2200 
2201     for (uint256 i = 0; i < allocations.length; i++) {
2202       if (i == allocations.length - 1) {
2203         newAmounts[i] = total.sub(allocatedBalance);
2204       } else {
2205         currBalance = total.mul(allocations[i]).div(100000);
2206         allocatedBalance = allocatedBalance.add(currBalance);
2207         newAmounts[i] = currBalance;
2208       }
2209     }
2210     return newAmounts;
2211   }
2212 
2213   /**
2214    * Redeem all underlying needed from each protocol
2215    *
2216    * @param tokenAddresses : array of protocol tokens addresses
2217    * @param amounts : array with current allocations in underlying
2218    * @param newAmounts : array with new allocations in underlying
2219    * @return toMintAllocations : array with amounts to be minted
2220    * @return totalToMint : total amount that needs to be minted
2221    */
2222   function _redeemAllNeeded(
2223     address[] memory tokenAddresses,
2224     uint256[] memory amounts,
2225     uint256[] memory newAmounts
2226     ) internal returns (
2227       uint256[] memory toMintAllocations,
2228       uint256 totalToMint,
2229       bool lowLiquidity
2230     ) {
2231     require(amounts.length == newAmounts.length, 'Lengths not equal');
2232     toMintAllocations = new uint256[](amounts.length);
2233     ILendingProtocol protocol;
2234     uint256 currAmount;
2235     uint256 newAmount;
2236     address currToken;
2237     // check the difference between amounts and newAmounts
2238     for (uint256 i = 0; i < amounts.length; i++) {
2239       currToken = tokenAddresses[i];
2240       newAmount = newAmounts[i];
2241       currAmount = amounts[i];
2242       protocol = ILendingProtocol(protocolWrappers[currToken]);
2243       if (currAmount > newAmount) {
2244         toMintAllocations[i] = 0;
2245         uint256 toRedeem = currAmount.sub(newAmount);
2246         uint256 availableLiquidity = protocol.availableLiquidity();
2247         if (availableLiquidity < toRedeem) {
2248           lowLiquidity = true;
2249           toRedeem = availableLiquidity;
2250         }
2251         // redeem the difference
2252         _redeemProtocolTokens(
2253           protocolWrappers[currToken],
2254           currToken,
2255           // convert amount from underlying to protocol token
2256           toRedeem.mul(10**18).div(protocol.getPriceInToken()),
2257           address(this) // tokens are now in this contract
2258         );
2259       } else {
2260         toMintAllocations[i] = newAmount.sub(currAmount);
2261         totalToMint = totalToMint.add(toMintAllocations[i]);
2262       }
2263     }
2264   }
2265 
2266   /**
2267    * Get the contract balance of every protocol currently used
2268    *
2269    * @return tokenAddresses : array with all token addresses used,
2270    *                          eg [cTokenAddress, iTokenAddress]
2271    * @return amounts : array with all amounts for each protocol in order,
2272    *                   eg [amountCompoundInUnderlying, amountFulcrumInUnderlying]
2273    * @return total : total AUM in underlying
2274    */
2275   function _getCurrentAllocations() internal view
2276     returns (address[] memory tokenAddresses, uint256[] memory amounts, uint256 total) {
2277       // Get balance of every protocol implemented
2278       tokenAddresses = new address[](allAvailableTokens.length);
2279       amounts = new uint256[](allAvailableTokens.length);
2280 
2281       address currentToken;
2282       uint256 currTokenPrice;
2283 
2284       for (uint256 i = 0; i < allAvailableTokens.length; i++) {
2285         currentToken = allAvailableTokens[i];
2286         tokenAddresses[i] = currentToken;
2287         currTokenPrice = ILendingProtocol(protocolWrappers[currentToken]).getPriceInToken();
2288         amounts[i] = currTokenPrice.mul(
2289           IERC20(currentToken).balanceOf(address(this))
2290         ).div(10**18);
2291         total = total.add(amounts[i]);
2292       }
2293 
2294       // return addresses and respective amounts in underlying
2295       return (tokenAddresses, amounts, total);
2296   }
2297 
2298   // ILendingProtocols calls
2299   /**
2300    * Mint protocol tokens through protocol wrapper
2301    *
2302    * @param _wrapperAddr : address of protocol wrapper
2303    * @param _amount : amount of underlying to be lended
2304    * @return tokens : new tokens minted
2305    */
2306   function _mintProtocolTokens(address _wrapperAddr, uint256 _amount)
2307     internal
2308     returns (uint256 tokens) {
2309       if (_amount == 0) {
2310         return tokens;
2311       }
2312       // Transfer _amount underlying token (eg. DAI) to _wrapperAddr
2313       IERC20(token).safeTransfer(_wrapperAddr, _amount);
2314       tokens = ILendingProtocol(_wrapperAddr).mint();
2315   }
2316 
2317   /**
2318    * Redeem underlying tokens through protocol wrapper
2319    *
2320    * @param _wrapperAddr : address of protocol wrapper
2321    * @param _amount : amount of `_token` to redeem
2322    * @param _token : protocol token address
2323    * @param _account : should be msg.sender when rebalancing and final user when redeeming
2324    * @return tokens : new tokens minted
2325    */
2326   function _redeemProtocolTokens(address _wrapperAddr, address _token, uint256 _amount, address _account)
2327     internal
2328     returns (uint256 tokens) {
2329       if (_amount == 0) {
2330         return tokens;
2331       }
2332       // Transfer _amount of _protocolToken (eg. cDAI) to _wrapperAddr
2333       IERC20(_token).safeTransfer(_wrapperAddr, _amount);
2334       tokens = ILendingProtocol(_wrapperAddr).redeem(_account);
2335   }
2336 }