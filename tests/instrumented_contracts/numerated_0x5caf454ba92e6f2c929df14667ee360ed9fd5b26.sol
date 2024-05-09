1 pragma solidity ^0.5.0;
2 
3 // prettier-ignore
4 
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
8  * the optional functions; to access them see {ERC20Detailed}.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @dev Optional functions from the ERC20 standard.
83  */
84 contract ERC20Detailed is IERC20 {
85     string private _name;
86     string private _symbol;
87     uint8 private _decimals;
88 
89     /**
90      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
91      * these values are immutable: they can only be set once during
92      * construction.
93      */
94     constructor (string memory name, string memory symbol, uint8 decimals) public {
95         _name = name;
96         _symbol = symbol;
97         _decimals = decimals;
98     }
99 
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() public view returns (string memory) {
104         return _name;
105     }
106 
107     /**
108      * @dev Returns the symbol of the token, usually a shorter version of the
109      * name.
110      */
111     function symbol() public view returns (string memory) {
112         return _symbol;
113     }
114 
115     /**
116      * @dev Returns the number of decimals used to get its user representation.
117      * For example, if `decimals` equals `2`, a balance of `505` tokens should
118      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
119      *
120      * Tokens usually opt for a value of 18, imitating the relationship between
121      * Ether and Wei.
122      *
123      * NOTE: This information is only used for _display_ purposes: it in
124      * no way affects any of the arithmetic of the contract, including
125      * {IERC20-balanceOf} and {IERC20-transfer}.
126      */
127     function decimals() public view returns (uint8) {
128         return _decimals;
129     }
130 }
131 // prettier-ignore
132 
133 
134 
135 /*
136  * @dev Provides information about the current execution context, including the
137  * sender of the transaction and its data. While these are generally available
138  * via msg.sender and msg.data, they should not be accessed in such a direct
139  * manner, since when dealing with GSN meta-transactions the account sending and
140  * paying for execution may not be the actual sender (as far as an application
141  * is concerned).
142  *
143  * This contract is only required for intermediate, library-like contracts.
144  */
145 contract Context {
146     // Empty internal constructor, to prevent people from mistakenly deploying
147     // an instance of this contract, which should be used via inheritance.
148     constructor () internal { }
149     // solhint-disable-previous-line no-empty-blocks
150 
151     function _msgSender() internal view returns (address payable) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view returns (bytes memory) {
156         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
157         return msg.data;
158     }
159 }
160 
161 /**
162  * @dev Wrappers over Solidity's arithmetic operations with added overflow
163  * checks.
164  *
165  * Arithmetic operations in Solidity wrap on overflow. This can easily result
166  * in bugs, because programmers usually assume that an overflow raises an
167  * error, which is the standard behavior in high level programming languages.
168  * `SafeMath` restores this intuition by reverting the transaction when an
169  * operation overflows.
170  *
171  * Using this library instead of the unchecked operations eliminates an entire
172  * class of bugs, so it's recommended to use it always.
173  */
174 library SafeMath {
175     /**
176      * @dev Returns the addition of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `+` operator.
180      *
181      * Requirements:
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         return sub(a, b, "SafeMath: subtraction overflow");
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      * - Subtraction cannot overflow.
212      *
213      * _Available since v2.4.0._
214      */
215     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b <= a, errorMessage);
217         uint256 c = a - b;
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
233         // benefit is lost if 'b' is also tested.
234         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
235         if (a == 0) {
236             return 0;
237         }
238 
239         uint256 c = a * b;
240         require(c / a == b, "SafeMath: multiplication overflow");
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers. Reverts on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b) internal pure returns (uint256) {
257         return div(a, b, "SafeMath: division by zero");
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
262      * division by zero. The result is rounded towards zero.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      * - The divisor cannot be zero.
270      *
271      * _Available since v2.4.0._
272      */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         // Solidity only automatically asserts when dividing by 0
275         require(b > 0, errorMessage);
276         uint256 c = a / b;
277         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * Reverts when dividing by zero.
285      *
286      * Counterpart to Solidity's `%` operator. This function uses a `revert`
287      * opcode (which leaves remaining gas untouched) while Solidity uses an
288      * invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294         return mod(a, b, "SafeMath: modulo by zero");
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * Reverts with custom message when dividing by zero.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      * - The divisor cannot be zero.
307      *
308      * _Available since v2.4.0._
309      */
310     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         require(b != 0, errorMessage);
312         return a % b;
313     }
314 }
315 
316 /**
317  * @dev Implementation of the {IERC20} interface.
318  *
319  * This implementation is agnostic to the way tokens are created. This means
320  * that a supply mechanism has to be added in a derived contract using {_mint}.
321  * For a generic mechanism see {ERC20Mintable}.
322  *
323  * TIP: For a detailed writeup see our guide
324  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
325  * to implement supply mechanisms].
326  *
327  * We have followed general OpenZeppelin guidelines: functions revert instead
328  * of returning `false` on failure. This behavior is nonetheless conventional
329  * and does not conflict with the expectations of ERC20 applications.
330  *
331  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
332  * This allows applications to reconstruct the allowance for all accounts just
333  * by listening to said events. Other implementations of the EIP may not emit
334  * these events, as it isn't required by the specification.
335  *
336  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
337  * functions have been added to mitigate the well-known issues around setting
338  * allowances. See {IERC20-approve}.
339  */
340 contract ERC20 is Context, IERC20 {
341     using SafeMath for uint256;
342 
343     mapping (address => uint256) private _balances;
344 
345     mapping (address => mapping (address => uint256)) private _allowances;
346 
347     uint256 private _totalSupply;
348 
349     /**
350      * @dev See {IERC20-totalSupply}.
351      */
352     function totalSupply() public view returns (uint256) {
353         return _totalSupply;
354     }
355 
356     /**
357      * @dev See {IERC20-balanceOf}.
358      */
359     function balanceOf(address account) public view returns (uint256) {
360         return _balances[account];
361     }
362 
363     /**
364      * @dev See {IERC20-transfer}.
365      *
366      * Requirements:
367      *
368      * - `recipient` cannot be the zero address.
369      * - the caller must have a balance of at least `amount`.
370      */
371     function transfer(address recipient, uint256 amount) public returns (bool) {
372         _transfer(_msgSender(), recipient, amount);
373         return true;
374     }
375 
376     /**
377      * @dev See {IERC20-allowance}.
378      */
379     function allowance(address owner, address spender) public view returns (uint256) {
380         return _allowances[owner][spender];
381     }
382 
383     /**
384      * @dev See {IERC20-approve}.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function approve(address spender, uint256 amount) public returns (bool) {
391         _approve(_msgSender(), spender, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-transferFrom}.
397      *
398      * Emits an {Approval} event indicating the updated allowance. This is not
399      * required by the EIP. See the note at the beginning of {ERC20};
400      *
401      * Requirements:
402      * - `sender` and `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      * - the caller must have allowance for `sender`'s tokens of at least
405      * `amount`.
406      */
407     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
408         _transfer(sender, recipient, amount);
409         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
410         return true;
411     }
412 
413     /**
414      * @dev Atomically increases the allowance granted to `spender` by the caller.
415      *
416      * This is an alternative to {approve} that can be used as a mitigation for
417      * problems described in {IERC20-approve}.
418      *
419      * Emits an {Approval} event indicating the updated allowance.
420      *
421      * Requirements:
422      *
423      * - `spender` cannot be the zero address.
424      */
425     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
426         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
427         return true;
428     }
429 
430     /**
431      * @dev Atomically decreases the allowance granted to `spender` by the caller.
432      *
433      * This is an alternative to {approve} that can be used as a mitigation for
434      * problems described in {IERC20-approve}.
435      *
436      * Emits an {Approval} event indicating the updated allowance.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      * - `spender` must have allowance for the caller of at least
442      * `subtractedValue`.
443      */
444     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
446         return true;
447     }
448 
449     /**
450      * @dev Moves tokens `amount` from `sender` to `recipient`.
451      *
452      * This is internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `sender` cannot be the zero address.
460      * - `recipient` cannot be the zero address.
461      * - `sender` must have a balance of at least `amount`.
462      */
463     function _transfer(address sender, address recipient, uint256 amount) internal {
464         require(sender != address(0), "ERC20: transfer from the zero address");
465         require(recipient != address(0), "ERC20: transfer to the zero address");
466 
467         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
468         _balances[recipient] = _balances[recipient].add(amount);
469         emit Transfer(sender, recipient, amount);
470     }
471 
472     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
473      * the total supply.
474      *
475      * Emits a {Transfer} event with `from` set to the zero address.
476      *
477      * Requirements
478      *
479      * - `to` cannot be the zero address.
480      */
481     function _mint(address account, uint256 amount) internal {
482         require(account != address(0), "ERC20: mint to the zero address");
483 
484         _totalSupply = _totalSupply.add(amount);
485         _balances[account] = _balances[account].add(amount);
486         emit Transfer(address(0), account, amount);
487     }
488 
489      /**
490      * @dev Destroys `amount` tokens from `account`, reducing the
491      * total supply.
492      *
493      * Emits a {Transfer} event with `to` set to the zero address.
494      *
495      * Requirements
496      *
497      * - `account` cannot be the zero address.
498      * - `account` must have at least `amount` tokens.
499      */
500     function _burn(address account, uint256 amount) internal {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
504         _totalSupply = _totalSupply.sub(amount);
505         emit Transfer(account, address(0), amount);
506     }
507 
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
510      *
511      * This is internal function is equivalent to `approve`, and can be used to
512      * e.g. set automatic allowances for certain subsystems, etc.
513      *
514      * Emits an {Approval} event.
515      *
516      * Requirements:
517      *
518      * - `owner` cannot be the zero address.
519      * - `spender` cannot be the zero address.
520      */
521     function _approve(address owner, address spender, uint256 amount) internal {
522         require(owner != address(0), "ERC20: approve from the zero address");
523         require(spender != address(0), "ERC20: approve to the zero address");
524 
525         _allowances[owner][spender] = amount;
526         emit Approval(owner, spender, amount);
527     }
528 
529     /**
530      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
531      * from the caller's allowance.
532      *
533      * See {_burn} and {_approve}.
534      */
535     function _burnFrom(address account, uint256 amount) internal {
536         _burn(account, amount);
537         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
538     }
539 }
540 
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
577 contract MinterRole is Context {
578     using Roles for Roles.Role;
579 
580     event MinterAdded(address indexed account);
581     event MinterRemoved(address indexed account);
582 
583     Roles.Role private _minters;
584 
585     constructor () internal {
586         _addMinter(_msgSender());
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
636 // prettier-ignore
637 
638 
639 /**
640  * @dev Extension of {ERC20} that allows token holders to destroy both their own
641  * tokens and those that they have an allowance for, in a way that can be
642  * recognized off-chain (via event analysis).
643  */
644 contract ERC20Burnable is Context, ERC20 {
645     /**
646      * @dev Destroys `amount` tokens from the caller.
647      *
648      * See {ERC20-_burn}.
649      */
650     function burn(uint256 amount) public {
651         _burn(_msgSender(), amount);
652     }
653 
654     /**
655      * @dev See {ERC20-_burnFrom}.
656      */
657     function burnFrom(address account, uint256 amount) public {
658         _burnFrom(account, amount);
659     }
660 }
661 
662 // prettier-ignore
663 
664 
665 
666 contract IGroup {
667 	function isGroup(address _addr) public view returns (bool);
668 
669 	function addGroup(address _addr) external;
670 
671 	function getGroupKey(address _addr) internal pure returns (bytes32) {
672 		return keccak256(abi.encodePacked("_group", _addr));
673 	}
674 }
675 
676 
677 contract AddressValidator {
678 	string constant errorMessage = "this is illegal address";
679 
680 	function validateIllegalAddress(address _addr) external pure {
681 		require(_addr != address(0), errorMessage);
682 	}
683 
684 	function validateGroup(address _addr, address _groupAddr) external view {
685 		require(IGroup(_groupAddr).isGroup(_addr), errorMessage);
686 	}
687 
688 	function validateGroups(
689 		address _addr,
690 		address _groupAddr1,
691 		address _groupAddr2
692 	) external view {
693 		if (IGroup(_groupAddr1).isGroup(_addr)) {
694 			return;
695 		}
696 		require(IGroup(_groupAddr2).isGroup(_addr), errorMessage);
697 	}
698 
699 	function validateAddress(address _addr, address _target) external pure {
700 		require(_addr == _target, errorMessage);
701 	}
702 
703 	function validateAddresses(
704 		address _addr,
705 		address _target1,
706 		address _target2
707 	) external pure {
708 		if (_addr == _target1) {
709 			return;
710 		}
711 		require(_addr == _target2, errorMessage);
712 	}
713 }
714 
715 
716 contract UsingValidator {
717 	AddressValidator private _validator;
718 
719 	constructor() public {
720 		_validator = new AddressValidator();
721 	}
722 
723 	function addressValidator() internal view returns (AddressValidator) {
724 		return _validator;
725 	}
726 }
727 
728 
729 
730 
731 contract Killable {
732 	address payable public _owner;
733 
734 	constructor() internal {
735 		_owner = msg.sender;
736 	}
737 
738 	function kill() public {
739 		require(msg.sender == _owner, "only owner method");
740 		selfdestruct(_owner);
741 	}
742 }
743 
744 /**
745  * @dev Contract module which provides a basic access control mechanism, where
746  * there is an account (an owner) that can be granted exclusive access to
747  * specific functions.
748  *
749  * This module is used through inheritance. It will make available the modifier
750  * `onlyOwner`, which can be applied to your functions to restrict their use to
751  * the owner.
752  */
753 contract Ownable is Context {
754     address private _owner;
755 
756     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
757 
758     /**
759      * @dev Initializes the contract setting the deployer as the initial owner.
760      */
761     constructor () internal {
762         _owner = _msgSender();
763         emit OwnershipTransferred(address(0), _owner);
764     }
765 
766     /**
767      * @dev Returns the address of the current owner.
768      */
769     function owner() public view returns (address) {
770         return _owner;
771     }
772 
773     /**
774      * @dev Throws if called by any account other than the owner.
775      */
776     modifier onlyOwner() {
777         require(isOwner(), "Ownable: caller is not the owner");
778         _;
779     }
780 
781     /**
782      * @dev Returns true if the caller is the current owner.
783      */
784     function isOwner() public view returns (bool) {
785         return _msgSender() == _owner;
786     }
787 
788     /**
789      * @dev Leaves the contract without owner. It will not be possible to call
790      * `onlyOwner` functions anymore. Can only be called by the current owner.
791      *
792      * NOTE: Renouncing ownership will leave the contract without an owner,
793      * thereby removing any functionality that is only available to the owner.
794      */
795     function renounceOwnership() public onlyOwner {
796         emit OwnershipTransferred(_owner, address(0));
797         _owner = address(0);
798     }
799 
800     /**
801      * @dev Transfers ownership of the contract to a new account (`newOwner`).
802      * Can only be called by the current owner.
803      */
804     function transferOwnership(address newOwner) public onlyOwner {
805         _transferOwnership(newOwner);
806     }
807 
808     /**
809      * @dev Transfers ownership of the contract to a new account (`newOwner`).
810      */
811     function _transferOwnership(address newOwner) internal {
812         require(newOwner != address(0), "Ownable: new owner is the zero address");
813         emit OwnershipTransferred(_owner, newOwner);
814         _owner = newOwner;
815     }
816 }
817 
818 
819 contract AddressConfig is Ownable, UsingValidator, Killable {
820 	address public token = 0x98626E2C9231f03504273d55f397409deFD4a093;
821 	address public allocator;
822 	address public allocatorStorage;
823 	address public withdraw;
824 	address public withdrawStorage;
825 	address public marketFactory;
826 	address public marketGroup;
827 	address public propertyFactory;
828 	address public propertyGroup;
829 	address public metricsGroup;
830 	address public metricsFactory;
831 	address public policy;
832 	address public policyFactory;
833 	address public policySet;
834 	address public policyGroup;
835 	address public lockup;
836 	address public lockupStorage;
837 	address public voteTimes;
838 	address public voteTimesStorage;
839 	address public voteCounter;
840 	address public voteCounterStorage;
841 
842 	function setAllocator(address _addr) external onlyOwner {
843 		allocator = _addr;
844 	}
845 
846 	function setAllocatorStorage(address _addr) external onlyOwner {
847 		allocatorStorage = _addr;
848 	}
849 
850 	function setWithdraw(address _addr) external onlyOwner {
851 		withdraw = _addr;
852 	}
853 
854 	function setWithdrawStorage(address _addr) external onlyOwner {
855 		withdrawStorage = _addr;
856 	}
857 
858 	function setMarketFactory(address _addr) external onlyOwner {
859 		marketFactory = _addr;
860 	}
861 
862 	function setMarketGroup(address _addr) external onlyOwner {
863 		marketGroup = _addr;
864 	}
865 
866 	function setPropertyFactory(address _addr) external onlyOwner {
867 		propertyFactory = _addr;
868 	}
869 
870 	function setPropertyGroup(address _addr) external onlyOwner {
871 		propertyGroup = _addr;
872 	}
873 
874 	function setMetricsFactory(address _addr) external onlyOwner {
875 		metricsFactory = _addr;
876 	}
877 
878 	function setMetricsGroup(address _addr) external onlyOwner {
879 		metricsGroup = _addr;
880 	}
881 
882 	function setPolicyFactory(address _addr) external onlyOwner {
883 		policyFactory = _addr;
884 	}
885 
886 	function setPolicyGroup(address _addr) external onlyOwner {
887 		policyGroup = _addr;
888 	}
889 
890 	function setPolicySet(address _addr) external onlyOwner {
891 		policySet = _addr;
892 	}
893 
894 	function setPolicy(address _addr) external {
895 		addressValidator().validateAddress(msg.sender, policyFactory);
896 		policy = _addr;
897 	}
898 
899 	function setToken(address _addr) external onlyOwner {
900 		token = _addr;
901 	}
902 
903 	function setLockup(address _addr) external onlyOwner {
904 		lockup = _addr;
905 	}
906 
907 	function setLockupStorage(address _addr) external onlyOwner {
908 		lockupStorage = _addr;
909 	}
910 
911 	function setVoteTimes(address _addr) external onlyOwner {
912 		voteTimes = _addr;
913 	}
914 
915 	function setVoteTimesStorage(address _addr) external onlyOwner {
916 		voteTimesStorage = _addr;
917 	}
918 
919 	function setVoteCounter(address _addr) external onlyOwner {
920 		voteCounter = _addr;
921 	}
922 
923 	function setVoteCounterStorage(address _addr) external onlyOwner {
924 		voteCounterStorage = _addr;
925 	}
926 }
927 
928 
929 contract UsingConfig {
930 	AddressConfig private _config;
931 
932 	constructor(address _addressConfig) public {
933 		_config = AddressConfig(_addressConfig);
934 	}
935 
936 	function config() internal view returns (AddressConfig) {
937 		return _config;
938 	}
939 
940 	function configAddress() external view returns (address) {
941 		return address(_config);
942 	}
943 }
944 
945 // prettier-ignore
946 
947 
948 
949 contract PauserRole is Context {
950     using Roles for Roles.Role;
951 
952     event PauserAdded(address indexed account);
953     event PauserRemoved(address indexed account);
954 
955     Roles.Role private _pausers;
956 
957     constructor () internal {
958         _addPauser(_msgSender());
959     }
960 
961     modifier onlyPauser() {
962         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
963         _;
964     }
965 
966     function isPauser(address account) public view returns (bool) {
967         return _pausers.has(account);
968     }
969 
970     function addPauser(address account) public onlyPauser {
971         _addPauser(account);
972     }
973 
974     function renouncePauser() public {
975         _removePauser(_msgSender());
976     }
977 
978     function _addPauser(address account) internal {
979         _pausers.add(account);
980         emit PauserAdded(account);
981     }
982 
983     function _removePauser(address account) internal {
984         _pausers.remove(account);
985         emit PauserRemoved(account);
986     }
987 }
988 
989 /**
990  * @dev Contract module which allows children to implement an emergency stop
991  * mechanism that can be triggered by an authorized account.
992  *
993  * This module is used through inheritance. It will make available the
994  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
995  * the functions of your contract. Note that they will not be pausable by
996  * simply including this module, only once the modifiers are put in place.
997  */
998 contract Pausable is Context, PauserRole {
999     /**
1000      * @dev Emitted when the pause is triggered by a pauser (`account`).
1001      */
1002     event Paused(address account);
1003 
1004     /**
1005      * @dev Emitted when the pause is lifted by a pauser (`account`).
1006      */
1007     event Unpaused(address account);
1008 
1009     bool private _paused;
1010 
1011     /**
1012      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1013      * to the deployer.
1014      */
1015     constructor () internal {
1016         _paused = false;
1017     }
1018 
1019     /**
1020      * @dev Returns true if the contract is paused, and false otherwise.
1021      */
1022     function paused() public view returns (bool) {
1023         return _paused;
1024     }
1025 
1026     /**
1027      * @dev Modifier to make a function callable only when the contract is not paused.
1028      */
1029     modifier whenNotPaused() {
1030         require(!_paused, "Pausable: paused");
1031         _;
1032     }
1033 
1034     /**
1035      * @dev Modifier to make a function callable only when the contract is paused.
1036      */
1037     modifier whenPaused() {
1038         require(_paused, "Pausable: not paused");
1039         _;
1040     }
1041 
1042     /**
1043      * @dev Called by a pauser to pause, triggers stopped state.
1044      */
1045     function pause() public onlyPauser whenNotPaused {
1046         _paused = true;
1047         emit Paused(_msgSender());
1048     }
1049 
1050     /**
1051      * @dev Called by a pauser to unpause, returns to normal state.
1052      */
1053     function unpause() public onlyPauser whenPaused {
1054         _paused = false;
1055         emit Unpaused(_msgSender());
1056     }
1057 }
1058 
1059 
1060 
1061 library Decimals {
1062 	using SafeMath for uint256;
1063 	uint120 private constant basisValue = 1000000000000000000;
1064 
1065 	function outOf(uint256 _a, uint256 _b)
1066 		internal
1067 		pure
1068 		returns (uint256 result)
1069 	{
1070 		if (_a == 0) {
1071 			return 0;
1072 		}
1073 		uint256 a = _a.mul(basisValue);
1074 		require(a > _b, "the denominator is too big");
1075 		return (a.div(_b));
1076 	}
1077 
1078 	function basis() external pure returns (uint120) {
1079 		return basisValue;
1080 	}
1081 }
1082 
1083 // prettier-ignore
1084 
1085 
1086 
1087 contract IAllocator {
1088 	function allocate(address _metrics) external;
1089 
1090 	function calculatedCallback(address _metrics, uint256 _value) external;
1091 
1092 	function beforeBalanceChange(address _property, address _from, address _to)
1093 		external;
1094 
1095 	function getRewardsAmount(address _property)
1096 		external
1097 		view
1098 		returns (uint256);
1099 
1100 	function allocation(
1101 		uint256 _blocks,
1102 		uint256 _mint,
1103 		uint256 _value,
1104 		uint256 _marketValue,
1105 		uint256 _assets,
1106 		uint256 _totalAssets
1107 	)
1108 		public
1109 		pure
1110 		returns (
1111 			// solium-disable-next-line indentation
1112 			uint256
1113 		);
1114 }
1115 
1116 
1117 
1118 
1119 
1120 contract EternalStorage {
1121 	address private currentOwner = msg.sender;
1122 
1123 	mapping(bytes32 => uint256) private uIntStorage;
1124 	mapping(bytes32 => string) private stringStorage;
1125 	mapping(bytes32 => address) private addressStorage;
1126 	mapping(bytes32 => bytes32) private bytesStorage;
1127 	mapping(bytes32 => bool) private boolStorage;
1128 	mapping(bytes32 => int256) private intStorage;
1129 
1130 	modifier onlyCurrentOwner() {
1131 		require(msg.sender == currentOwner, "not current owner");
1132 		_;
1133 	}
1134 
1135 	function changeOwner(address _newOwner) external {
1136 		require(msg.sender == currentOwner, "not current owner");
1137 		currentOwner = _newOwner;
1138 	}
1139 
1140 	// *** Getter Methods ***
1141 	function getUint(bytes32 _key) external view returns (uint256) {
1142 		return uIntStorage[_key];
1143 	}
1144 
1145 	function getString(bytes32 _key) external view returns (string memory) {
1146 		return stringStorage[_key];
1147 	}
1148 
1149 	function getAddress(bytes32 _key) external view returns (address) {
1150 		return addressStorage[_key];
1151 	}
1152 
1153 	function getBytes(bytes32 _key) external view returns (bytes32) {
1154 		return bytesStorage[_key];
1155 	}
1156 
1157 	function getBool(bytes32 _key) external view returns (bool) {
1158 		return boolStorage[_key];
1159 	}
1160 
1161 	function getInt(bytes32 _key) external view returns (int256) {
1162 		return intStorage[_key];
1163 	}
1164 
1165 	// *** Setter Methods ***
1166 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
1167 		uIntStorage[_key] = _value;
1168 	}
1169 
1170 	function setString(bytes32 _key, string calldata _value)
1171 		external
1172 		onlyCurrentOwner
1173 	{
1174 		stringStorage[_key] = _value;
1175 	}
1176 
1177 	function setAddress(bytes32 _key, address _value)
1178 		external
1179 		onlyCurrentOwner
1180 	{
1181 		addressStorage[_key] = _value;
1182 	}
1183 
1184 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
1185 		bytesStorage[_key] = _value;
1186 	}
1187 
1188 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
1189 		boolStorage[_key] = _value;
1190 	}
1191 
1192 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
1193 		intStorage[_key] = _value;
1194 	}
1195 
1196 	// *** Delete Methods ***
1197 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
1198 		delete uIntStorage[_key];
1199 	}
1200 
1201 	function deleteString(bytes32 _key) external onlyCurrentOwner {
1202 		delete stringStorage[_key];
1203 	}
1204 
1205 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
1206 		delete addressStorage[_key];
1207 	}
1208 
1209 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
1210 		delete bytesStorage[_key];
1211 	}
1212 
1213 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
1214 		delete boolStorage[_key];
1215 	}
1216 
1217 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
1218 		delete intStorage[_key];
1219 	}
1220 }
1221 
1222 
1223 contract UsingStorage is Ownable {
1224 	address private _storage;
1225 
1226 	modifier hasStorage() {
1227 		require(_storage != address(0), "storage is not setted");
1228 		_;
1229 	}
1230 
1231 	function eternalStorage()
1232 		internal
1233 		view
1234 		hasStorage
1235 		returns (EternalStorage)
1236 	{
1237 		return EternalStorage(_storage);
1238 	}
1239 
1240 	function getStorageAddress() external view hasStorage returns (address) {
1241 		return _storage;
1242 	}
1243 
1244 	function createStorage() external onlyOwner {
1245 		require(_storage == address(0), "storage is setted");
1246 		EternalStorage tmp = new EternalStorage();
1247 		_storage = address(tmp);
1248 	}
1249 
1250 	function setStorage(address _storageAddress) external onlyOwner {
1251 		_storage = _storageAddress;
1252 	}
1253 
1254 	function changeOwner(address newOwner) external onlyOwner {
1255 		EternalStorage(_storage).changeOwner(newOwner);
1256 	}
1257 }
1258 
1259 
1260 
1261 
1262 contract VoteTimesStorage is
1263 	UsingStorage,
1264 	UsingConfig,
1265 	UsingValidator,
1266 	Killable
1267 {
1268 	// solium-disable-next-line no-empty-blocks
1269 	constructor(address _config) public UsingConfig(_config) {}
1270 
1271 	// Vote Times
1272 	function getVoteTimes() external view returns (uint256) {
1273 		return eternalStorage().getUint(getVoteTimesKey());
1274 	}
1275 
1276 	function setVoteTimes(uint256 times) external {
1277 		addressValidator().validateAddress(msg.sender, config().voteTimes());
1278 
1279 		return eternalStorage().setUint(getVoteTimesKey(), times);
1280 	}
1281 
1282 	function getVoteTimesKey() private pure returns (bytes32) {
1283 		return keccak256(abi.encodePacked("_voteTimes"));
1284 	}
1285 
1286 	//Vote Times By Property
1287 	function getVoteTimesByProperty(address _property)
1288 		external
1289 		view
1290 		returns (uint256)
1291 	{
1292 		return eternalStorage().getUint(getVoteTimesByPropertyKey(_property));
1293 	}
1294 
1295 	function setVoteTimesByProperty(address _property, uint256 times) external {
1296 		addressValidator().validateAddress(msg.sender, config().voteTimes());
1297 
1298 		return
1299 			eternalStorage().setUint(
1300 				getVoteTimesByPropertyKey(_property),
1301 				times
1302 			);
1303 	}
1304 
1305 	function getVoteTimesByPropertyKey(address _property)
1306 		private
1307 		pure
1308 		returns (bytes32)
1309 	{
1310 		return keccak256(abi.encodePacked("_voteTimesByProperty", _property));
1311 	}
1312 }
1313 
1314 
1315 contract VoteTimes is UsingConfig, UsingValidator, Killable {
1316 	using SafeMath for uint256;
1317 
1318 	// solium-disable-next-line no-empty-blocks
1319 	constructor(address _config) public UsingConfig(_config) {}
1320 
1321 	function addVoteTime() external {
1322 		addressValidator().validateAddresses(
1323 			msg.sender,
1324 			config().marketFactory(),
1325 			config().policyFactory()
1326 		);
1327 
1328 		uint256 voteTimes = getStorage().getVoteTimes();
1329 		voteTimes = voteTimes.add(1);
1330 		getStorage().setVoteTimes(voteTimes);
1331 	}
1332 
1333 	function addVoteTimesByProperty(address _property) external {
1334 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1335 
1336 		uint256 voteTimesByProperty = getStorage().getVoteTimesByProperty(
1337 			_property
1338 		);
1339 		voteTimesByProperty = voteTimesByProperty.add(1);
1340 		getStorage().setVoteTimesByProperty(_property, voteTimesByProperty);
1341 	}
1342 
1343 	function resetVoteTimesByProperty(address _property) external {
1344 		addressValidator().validateAddresses(
1345 			msg.sender,
1346 			config().allocator(),
1347 			config().propertyFactory()
1348 		);
1349 
1350 		uint256 voteTimes = getStorage().getVoteTimes();
1351 		getStorage().setVoteTimesByProperty(_property, voteTimes);
1352 	}
1353 
1354 	function getAbstentionTimes(address _property)
1355 		external
1356 		view
1357 		returns (uint256)
1358 	{
1359 		uint256 voteTimes = getStorage().getVoteTimes();
1360 		uint256 voteTimesByProperty = getStorage().getVoteTimesByProperty(
1361 			_property
1362 		);
1363 		return voteTimes.sub(voteTimesByProperty);
1364 	}
1365 
1366 	function getStorage() private view returns (VoteTimesStorage) {
1367 		return VoteTimesStorage(config().voteTimesStorage());
1368 	}
1369 }
1370 // prettier-ignore
1371 
1372 
1373 
1374 contract VoteCounterStorage is
1375 	UsingStorage,
1376 	UsingConfig,
1377 	UsingValidator,
1378 	Killable
1379 {
1380 	// solium-disable-next-line no-empty-blocks
1381 	constructor(address _config) public UsingConfig(_config) {}
1382 
1383 	// Already Vote Flg
1384 	function setAlreadyVoteFlg(
1385 		address _user,
1386 		address _sender,
1387 		address _property
1388 	) external {
1389 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1390 
1391 		bytes32 alreadyVoteKey = getAlreadyVoteKey(_user, _sender, _property);
1392 		return eternalStorage().setBool(alreadyVoteKey, true);
1393 	}
1394 
1395 	function getAlreadyVoteFlg(
1396 		address _user,
1397 		address _sender,
1398 		address _property
1399 	) external view returns (bool) {
1400 		bytes32 alreadyVoteKey = getAlreadyVoteKey(_user, _sender, _property);
1401 		return eternalStorage().getBool(alreadyVoteKey);
1402 	}
1403 
1404 	function getAlreadyVoteKey(
1405 		address _sender,
1406 		address _target,
1407 		address _property
1408 	) private pure returns (bytes32) {
1409 		return
1410 			keccak256(
1411 				abi.encodePacked("_alreadyVote", _sender, _target, _property)
1412 			);
1413 	}
1414 
1415 	// Agree Count
1416 	function getAgreeCount(address _sender) external view returns (uint256) {
1417 		return eternalStorage().getUint(getAgreeVoteCountKey(_sender));
1418 	}
1419 
1420 	function setAgreeCount(address _sender, uint256 count)
1421 		external
1422 		returns (uint256)
1423 	{
1424 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1425 
1426 		eternalStorage().setUint(getAgreeVoteCountKey(_sender), count);
1427 	}
1428 
1429 	function getAgreeVoteCountKey(address _sender)
1430 		private
1431 		pure
1432 		returns (bytes32)
1433 	{
1434 		return keccak256(abi.encodePacked(_sender, "_agreeVoteCount"));
1435 	}
1436 
1437 	// Opposite Count
1438 	function getOppositeCount(address _sender) external view returns (uint256) {
1439 		return eternalStorage().getUint(getOppositeVoteCountKey(_sender));
1440 	}
1441 
1442 	function setOppositeCount(address _sender, uint256 count)
1443 		external
1444 		returns (uint256)
1445 	{
1446 		addressValidator().validateAddress(msg.sender, config().voteCounter());
1447 
1448 		eternalStorage().setUint(getOppositeVoteCountKey(_sender), count);
1449 	}
1450 
1451 	function getOppositeVoteCountKey(address _sender)
1452 		private
1453 		pure
1454 		returns (bytes32)
1455 	{
1456 		return keccak256(abi.encodePacked(_sender, "_oppositeVoteCount"));
1457 	}
1458 }
1459 
1460 
1461 contract VoteCounter is UsingConfig, UsingValidator, Killable {
1462 	using SafeMath for uint256;
1463 
1464 	// solium-disable-next-line no-empty-blocks
1465 	constructor(address _config) public UsingConfig(_config) {}
1466 
1467 	function addVoteCount(address _user, address _property, bool _agree)
1468 		external
1469 	{
1470 		addressValidator().validateGroups(
1471 			msg.sender,
1472 			config().marketGroup(),
1473 			config().policyGroup()
1474 		);
1475 
1476 		bool alreadyVote = getStorage().getAlreadyVoteFlg(
1477 			_user,
1478 			msg.sender,
1479 			_property
1480 		);
1481 		require(alreadyVote == false, "already vote");
1482 		uint256 voteCount = getVoteCount(_user, _property);
1483 		require(voteCount != 0, "vote count is 0");
1484 		getStorage().setAlreadyVoteFlg(_user, msg.sender, _property);
1485 		if (_agree) {
1486 			addAgreeCount(msg.sender, voteCount);
1487 		} else {
1488 			addOppositeCount(msg.sender, voteCount);
1489 		}
1490 	}
1491 
1492 	function getAgreeCount(address _sender) external view returns (uint256) {
1493 		return getStorage().getAgreeCount(_sender);
1494 	}
1495 
1496 	function getOppositeCount(address _sender) external view returns (uint256) {
1497 		return getStorage().getOppositeCount(_sender);
1498 	}
1499 
1500 	function getVoteCount(address _sender, address _property)
1501 		private
1502 		returns (uint256)
1503 	{
1504 		uint256 voteCount;
1505 		if (Property(_property).author() == _sender) {
1506 			// solium-disable-next-line operator-whitespace
1507 			voteCount = Lockup(config().lockup())
1508 				.getPropertyValue(_property)
1509 				.add(
1510 				Allocator(config().allocator()).getRewardsAmount(_property)
1511 			);
1512 			VoteTimes(config().voteTimes()).addVoteTimesByProperty(_property);
1513 		} else {
1514 			voteCount = Lockup(config().lockup()).getValue(_property, _sender);
1515 		}
1516 		return voteCount;
1517 	}
1518 
1519 	function addAgreeCount(address _target, uint256 _voteCount) private {
1520 		uint256 agreeCount = getStorage().getAgreeCount(_target);
1521 		agreeCount = agreeCount.add(_voteCount);
1522 		getStorage().setAgreeCount(_target, agreeCount);
1523 	}
1524 
1525 	function addOppositeCount(address _target, uint256 _voteCount) private {
1526 		uint256 oppositeCount = getStorage().getOppositeCount(_target);
1527 		oppositeCount = oppositeCount.add(_voteCount);
1528 		getStorage().setOppositeCount(_target, oppositeCount);
1529 	}
1530 
1531 	function getStorage() private view returns (VoteCounterStorage) {
1532 		return VoteCounterStorage(config().voteCounterStorage());
1533 	}
1534 }
1535 
1536 
1537 contract IMarket {
1538 	function calculate(address _metrics, uint256 _start, uint256 _end)
1539 		external
1540 		returns (bool);
1541 
1542 	function authenticate(
1543 		address _prop,
1544 		string memory _args1,
1545 		string memory _args2,
1546 		string memory _args3,
1547 		string memory _args4,
1548 		string memory _args5
1549 	)
1550 		public
1551 		returns (
1552 			// solium-disable-next-line indentation
1553 			address
1554 		);
1555 
1556 	function getAuthenticationFee(address _property)
1557 		private
1558 		view
1559 		returns (uint256);
1560 
1561 	function authenticatedCallback(address _property, bytes32 _idHash)
1562 		external
1563 		returns (address);
1564 
1565 	function vote(address _property, bool _agree) external;
1566 
1567 	function schema() external view returns (string memory);
1568 }
1569 
1570 
1571 contract IMarketBehavior {
1572 	string public schema;
1573 
1574 	function authenticate(
1575 		address _prop,
1576 		string calldata _args1,
1577 		string calldata _args2,
1578 		string calldata _args3,
1579 		string calldata _args4,
1580 		string calldata _args5,
1581 		address market
1582 	)
1583 		external
1584 		returns (
1585 			// solium-disable-next-line indentation
1586 			address
1587 		);
1588 
1589 	function calculate(address _metrics, uint256 _start, uint256 _end)
1590 		external
1591 		returns (bool);
1592 }
1593 
1594 
1595 
1596 
1597 contract PropertyGroup is
1598 	UsingConfig,
1599 	UsingStorage,
1600 	UsingValidator,
1601 	IGroup,
1602 	Killable
1603 {
1604 	// solium-disable-next-line no-empty-blocks
1605 	constructor(address _config) public UsingConfig(_config) {}
1606 
1607 	function addGroup(address _addr) external {
1608 		addressValidator().validateAddress(
1609 			msg.sender,
1610 			config().propertyFactory()
1611 		);
1612 
1613 		require(isGroup(_addr) == false, "already enabled");
1614 		eternalStorage().setBool(getGroupKey(_addr), true);
1615 	}
1616 
1617 	function isGroup(address _addr) public view returns (bool) {
1618 		return eternalStorage().getBool(getGroupKey(_addr));
1619 	}
1620 }
1621 
1622 
1623 contract IPolicy {
1624 	function rewards(uint256 _lockups, uint256 _assets)
1625 		external
1626 		view
1627 		returns (uint256);
1628 
1629 	function holdersShare(uint256 _amount, uint256 _lockups)
1630 		external
1631 		view
1632 		returns (uint256);
1633 
1634 	function assetValue(uint256 _value, uint256 _lockups)
1635 		external
1636 		view
1637 		returns (uint256);
1638 
1639 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1640 		external
1641 		view
1642 		returns (uint256);
1643 
1644 	function marketApproval(uint256 _agree, uint256 _opposite)
1645 		external
1646 		view
1647 		returns (bool);
1648 
1649 	function policyApproval(uint256 _agree, uint256 _opposite)
1650 		external
1651 		view
1652 		returns (bool);
1653 
1654 	function marketVotingBlocks() external view returns (uint256);
1655 
1656 	function policyVotingBlocks() external view returns (uint256);
1657 
1658 	function abstentionPenalty(uint256 _count) external view returns (uint256);
1659 
1660 	function lockUpBlocks() external view returns (uint256);
1661 }
1662 
1663 
1664 
1665 
1666 
1667 contract MarketGroup is
1668 	UsingConfig,
1669 	UsingStorage,
1670 	IGroup,
1671 	UsingValidator,
1672 	Killable
1673 {
1674 	using SafeMath for uint256;
1675 
1676 	// solium-disable-next-line no-empty-blocks
1677 	constructor(address _config) public UsingConfig(_config) UsingStorage() {}
1678 
1679 	function addGroup(address _addr) external {
1680 		addressValidator().validateAddress(
1681 			msg.sender,
1682 			config().marketFactory()
1683 		);
1684 
1685 		require(isGroup(_addr) == false, "already enabled");
1686 		eternalStorage().setBool(getGroupKey(_addr), true);
1687 		addCount();
1688 	}
1689 
1690 	function isGroup(address _addr) public view returns (bool) {
1691 		return eternalStorage().getBool(getGroupKey(_addr));
1692 	}
1693 
1694 	function addCount() private {
1695 		bytes32 key = getCountKey();
1696 		uint256 number = eternalStorage().getUint(key);
1697 		number = number.add(1);
1698 		eternalStorage().setUint(key, number);
1699 	}
1700 
1701 	function getCount() external view returns (uint256) {
1702 		bytes32 key = getCountKey();
1703 		return eternalStorage().getUint(key);
1704 	}
1705 
1706 	function getCountKey() private pure returns (bytes32) {
1707 		return keccak256(abi.encodePacked("_count"));
1708 	}
1709 }
1710 
1711 
1712 contract PolicySet is UsingConfig, UsingStorage, UsingValidator, Killable {
1713 	using SafeMath for uint256;
1714 
1715 	// solium-disable-next-line no-empty-blocks
1716 	constructor(address _config) public UsingConfig(_config) {}
1717 
1718 	function addSet(address _addr) external {
1719 		addressValidator().validateAddress(
1720 			msg.sender,
1721 			config().policyFactory()
1722 		);
1723 
1724 		uint256 index = eternalStorage().getUint(getPlicySetIndexKey());
1725 		bytes32 key = getIndexKey(index);
1726 		eternalStorage().setAddress(key, _addr);
1727 		index = index.add(1);
1728 		eternalStorage().setUint(getPlicySetIndexKey(), index);
1729 	}
1730 
1731 	function deleteAll() external {
1732 		addressValidator().validateAddress(
1733 			msg.sender,
1734 			config().policyFactory()
1735 		);
1736 
1737 		uint256 index = eternalStorage().getUint(getPlicySetIndexKey());
1738 		for (uint256 i = 0; i < index; i++) {
1739 			bytes32 key = getIndexKey(i);
1740 			eternalStorage().setAddress(key, address(0));
1741 		}
1742 		eternalStorage().setUint(getPlicySetIndexKey(), 0);
1743 	}
1744 
1745 	function count() external view returns (uint256) {
1746 		return eternalStorage().getUint(getPlicySetIndexKey());
1747 	}
1748 
1749 	function get(uint256 _index) external view returns (address) {
1750 		bytes32 key = getIndexKey(_index);
1751 		return eternalStorage().getAddress(key);
1752 	}
1753 
1754 	function getIndexKey(uint256 _index) private pure returns (bytes32) {
1755 		return keccak256(abi.encodePacked("_index", _index));
1756 	}
1757 
1758 	function getPlicySetIndexKey() private pure returns (bytes32) {
1759 		return keccak256(abi.encodePacked("_policySetIndex"));
1760 	}
1761 }
1762 
1763 
1764 
1765 contract PolicyGroup is
1766 	UsingConfig,
1767 	UsingStorage,
1768 	UsingValidator,
1769 	IGroup,
1770 	Killable
1771 {
1772 	// solium-disable-next-line no-empty-blocks
1773 	constructor(address _config) public UsingConfig(_config) {}
1774 
1775 	function addGroup(address _addr) external {
1776 		addressValidator().validateAddress(
1777 			msg.sender,
1778 			config().policyFactory()
1779 		);
1780 
1781 		require(isGroup(_addr) == false, "already enabled");
1782 		eternalStorage().setBool(getGroupKey(_addr), true);
1783 	}
1784 
1785 	function deleteGroup(address _addr) external {
1786 		addressValidator().validateAddress(
1787 			msg.sender,
1788 			config().policyFactory()
1789 		);
1790 
1791 		require(isGroup(_addr), "not enabled");
1792 		return eternalStorage().setBool(getGroupKey(_addr), false);
1793 	}
1794 
1795 	function isGroup(address _addr) public view returns (bool) {
1796 		return eternalStorage().getBool(getGroupKey(_addr));
1797 	}
1798 }
1799 
1800 
1801 contract PolicyFactory is Pausable, UsingConfig, UsingValidator, Killable {
1802 	event Create(address indexed _from, address _policy, address _innerPolicy);
1803 
1804 	// solium-disable-next-line no-empty-blocks
1805 	constructor(address _config) public UsingConfig(_config) {}
1806 
1807 	function create(address _newPolicyAddress) external returns (address) {
1808 		require(paused() == false, "You cannot use that");
1809 		addressValidator().validateIllegalAddress(_newPolicyAddress);
1810 
1811 		Policy policy = new Policy(address(config()), _newPolicyAddress);
1812 		address policyAddress = address(policy);
1813 		emit Create(msg.sender, policyAddress, _newPolicyAddress);
1814 		if (config().policy() == address(0)) {
1815 			config().setPolicy(policyAddress);
1816 		} else {
1817 			VoteTimes(config().voteTimes()).addVoteTime();
1818 		}
1819 		PolicyGroup policyGroup = PolicyGroup(config().policyGroup());
1820 		policyGroup.addGroup(policyAddress);
1821 		PolicySet policySet = PolicySet(config().policySet());
1822 		policySet.addSet(policyAddress);
1823 		return policyAddress;
1824 	}
1825 
1826 	function convergePolicy(address _currentPolicyAddress) external {
1827 		addressValidator().validateGroup(msg.sender, config().policyGroup());
1828 
1829 		config().setPolicy(_currentPolicyAddress);
1830 		PolicySet policySet = PolicySet(config().policySet());
1831 		PolicyGroup policyGroup = PolicyGroup(config().policyGroup());
1832 		for (uint256 i = 0; i < policySet.count(); i++) {
1833 			address policyAddress = policySet.get(i);
1834 			if (policyAddress == _currentPolicyAddress) {
1835 				continue;
1836 			}
1837 			Policy(policyAddress).kill();
1838 			policyGroup.deleteGroup(policyAddress);
1839 		}
1840 		policySet.deleteAll();
1841 		policySet.addSet(_currentPolicyAddress);
1842 	}
1843 }
1844 
1845 
1846 contract Policy is Killable, UsingConfig, UsingValidator {
1847 	using SafeMath for uint256;
1848 	IPolicy private _policy;
1849 	uint256 private _votingEndBlockNumber;
1850 
1851 	constructor(address _config, address _innerPolicyAddress)
1852 		public
1853 		UsingConfig(_config)
1854 	{
1855 		addressValidator().validateAddress(
1856 			msg.sender,
1857 			config().policyFactory()
1858 		);
1859 
1860 		_policy = IPolicy(_innerPolicyAddress);
1861 		setVotingEndBlockNumber();
1862 	}
1863 
1864 	function voting() public view returns (bool) {
1865 		return block.number <= _votingEndBlockNumber;
1866 	}
1867 
1868 	function rewards(uint256 _lockups, uint256 _assets)
1869 		external
1870 		view
1871 		returns (uint256)
1872 	{
1873 		return _policy.rewards(_lockups, _assets);
1874 	}
1875 
1876 	function holdersShare(uint256 _amount, uint256 _lockups)
1877 		external
1878 		view
1879 		returns (uint256)
1880 	{
1881 		return _policy.holdersShare(_amount, _lockups);
1882 	}
1883 
1884 	function assetValue(uint256 _value, uint256 _lockups)
1885 		external
1886 		view
1887 		returns (uint256)
1888 	{
1889 		return _policy.assetValue(_value, _lockups);
1890 	}
1891 
1892 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1893 		external
1894 		view
1895 		returns (uint256)
1896 	{
1897 		return _policy.authenticationFee(_assets, _propertyAssets);
1898 	}
1899 
1900 	function marketApproval(uint256 _agree, uint256 _opposite)
1901 		external
1902 		view
1903 		returns (bool)
1904 	{
1905 		return _policy.marketApproval(_agree, _opposite);
1906 	}
1907 
1908 	function policyApproval(uint256 _agree, uint256 _opposite)
1909 		external
1910 		view
1911 		returns (bool)
1912 	{
1913 		return _policy.policyApproval(_agree, _opposite);
1914 	}
1915 
1916 	function marketVotingBlocks() external view returns (uint256) {
1917 		return _policy.marketVotingBlocks();
1918 	}
1919 
1920 	function policyVotingBlocks() external view returns (uint256) {
1921 		return _policy.policyVotingBlocks();
1922 	}
1923 
1924 	function abstentionPenalty(uint256 _count) external view returns (uint256) {
1925 		return _policy.abstentionPenalty(_count);
1926 	}
1927 
1928 	function lockUpBlocks() external view returns (uint256) {
1929 		return _policy.lockUpBlocks();
1930 	}
1931 
1932 	function vote(address _property, bool _agree) external {
1933 		addressValidator().validateGroup(_property, config().propertyGroup());
1934 
1935 		require(config().policy() != address(this), "this policy is current");
1936 		require(voting(), "voting deadline is over");
1937 		VoteCounter voteCounter = VoteCounter(config().voteCounter());
1938 		voteCounter.addVoteCount(msg.sender, _property, _agree);
1939 		bool result = Policy(config().policy()).policyApproval(
1940 			voteCounter.getAgreeCount(address(this)),
1941 			voteCounter.getOppositeCount(address(this))
1942 		);
1943 		if (result == false) {
1944 			return;
1945 		}
1946 		PolicyFactory(config().policyFactory()).convergePolicy(address(this));
1947 		_votingEndBlockNumber = 0;
1948 	}
1949 
1950 	function setVotingEndBlockNumber() private {
1951 		if (config().policy() == address(0)) {
1952 			return;
1953 		}
1954 		uint256 tmp = Policy(config().policy()).policyVotingBlocks();
1955 		_votingEndBlockNumber = block.number.add(tmp);
1956 	}
1957 }
1958 
1959 
1960 
1961 contract Metrics {
1962 	address public market;
1963 	address public property;
1964 
1965 	constructor(address _market, address _property) public {
1966 		//Do not validate because there is no AddressConfig
1967 		market = _market;
1968 		property = _property;
1969 	}
1970 }
1971 
1972 
1973 
1974 contract MetricsGroup is
1975 	UsingConfig,
1976 	UsingStorage,
1977 	UsingValidator,
1978 	IGroup,
1979 	Killable
1980 {
1981 	using SafeMath for uint256;
1982 
1983 	// solium-disable-next-line no-empty-blocks
1984 	constructor(address _config) public UsingConfig(_config) {}
1985 
1986 	function addGroup(address _addr) external {
1987 		addressValidator().validateAddress(
1988 			msg.sender,
1989 			config().metricsFactory()
1990 		);
1991 
1992 		require(isGroup(_addr) == false, "already enabled");
1993 		eternalStorage().setBool(getGroupKey(_addr), true);
1994 		uint256 totalCount = eternalStorage().getUint(getTotalCountKey());
1995 		totalCount = totalCount.add(1);
1996 		eternalStorage().setUint(getTotalCountKey(), totalCount);
1997 	}
1998 
1999 	function isGroup(address _addr) public view returns (bool) {
2000 		return eternalStorage().getBool(getGroupKey(_addr));
2001 	}
2002 
2003 	function totalIssuedMetrics() external view returns (uint256) {
2004 		return eternalStorage().getUint(getTotalCountKey());
2005 	}
2006 
2007 	function getTotalCountKey() private pure returns (bytes32) {
2008 		return keccak256(abi.encodePacked("_totalCount"));
2009 	}
2010 }
2011 
2012 
2013 contract MetricsFactory is Pausable, UsingConfig, UsingValidator, Killable {
2014 	event Create(address indexed _from, address _metrics);
2015 
2016 	// solium-disable-next-line no-empty-blocks
2017 	constructor(address _config) public UsingConfig(_config) {}
2018 
2019 	function create(address _property) external returns (address) {
2020 		require(paused() == false, "You cannot use that");
2021 		addressValidator().validateGroup(msg.sender, config().marketGroup());
2022 
2023 		Metrics metrics = new Metrics(msg.sender, _property);
2024 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2025 		address metricsAddress = address(metrics);
2026 		metricsGroup.addGroup(metricsAddress);
2027 		emit Create(msg.sender, metricsAddress);
2028 		return metricsAddress;
2029 	}
2030 }
2031 
2032 
2033 contract Market is UsingConfig, IMarket, UsingValidator {
2034 	using SafeMath for uint256;
2035 	bool public enabled;
2036 	address public behavior;
2037 	uint256 private _votingEndBlockNumber;
2038 	uint256 public issuedMetrics;
2039 	mapping(bytes32 => bool) private idMap;
2040 
2041 	constructor(address _config, address _behavior)
2042 		public
2043 		UsingConfig(_config)
2044 	{
2045 		addressValidator().validateAddress(
2046 			msg.sender,
2047 			config().marketFactory()
2048 		);
2049 
2050 		behavior = _behavior;
2051 		enabled = false;
2052 		uint256 marketVotingBlocks = Policy(config().policy())
2053 			.marketVotingBlocks();
2054 		_votingEndBlockNumber = block.number.add(marketVotingBlocks);
2055 	}
2056 
2057 	function toEnable() external {
2058 		addressValidator().validateAddress(
2059 			msg.sender,
2060 			config().marketFactory()
2061 		);
2062 		enabled = true;
2063 	}
2064 
2065 	function calculate(address _metrics, uint256 _start, uint256 _end)
2066 		external
2067 		returns (bool)
2068 	{
2069 		addressValidator().validateAddress(msg.sender, config().allocator());
2070 
2071 		return IMarketBehavior(behavior).calculate(_metrics, _start, _end);
2072 	}
2073 
2074 	function authenticate(
2075 		address _prop,
2076 		string memory _args1,
2077 		string memory _args2,
2078 		string memory _args3,
2079 		string memory _args4,
2080 		string memory _args5
2081 	) public returns (address) {
2082 		addressValidator().validateAddress(
2083 			msg.sender,
2084 			Property(_prop).author()
2085 		);
2086 		require(enabled, "market is not enabled");
2087 
2088 		uint256 len = bytes(_args1).length;
2089 		require(len > 0, "id is required");
2090 
2091 		return
2092 			IMarketBehavior(behavior).authenticate(
2093 				_prop,
2094 				_args1,
2095 				_args2,
2096 				_args3,
2097 				_args4,
2098 				_args5,
2099 				address(this)
2100 			);
2101 	}
2102 
2103 	function getAuthenticationFee(address _property)
2104 		private
2105 		view
2106 		returns (uint256)
2107 	{
2108 		uint256 tokenValue = Lockup(config().lockup()).getPropertyValue(
2109 			_property
2110 		);
2111 		Policy policy = Policy(config().policy());
2112 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2113 		return
2114 			policy.authenticationFee(
2115 				metricsGroup.totalIssuedMetrics(),
2116 				tokenValue
2117 			);
2118 	}
2119 
2120 	function authenticatedCallback(address _property, bytes32 _idHash)
2121 		external
2122 		returns (address)
2123 	{
2124 		addressValidator().validateAddress(msg.sender, behavior);
2125 		require(enabled, "market is not enabled");
2126 
2127 		require(idMap[_idHash] == false, "id is duplicated");
2128 		idMap[_idHash] = true;
2129 		address sender = Property(_property).author();
2130 		MetricsFactory metricsFactory = MetricsFactory(
2131 			config().metricsFactory()
2132 		);
2133 		address metrics = metricsFactory.create(_property);
2134 		uint256 authenticationFee = getAuthenticationFee(_property);
2135 		require(
2136 			Dev(config().token()).fee(sender, authenticationFee),
2137 			"dev fee failed"
2138 		);
2139 		issuedMetrics = issuedMetrics.add(1);
2140 		return metrics;
2141 	}
2142 
2143 	function vote(address _property, bool _agree) external {
2144 		addressValidator().validateGroup(_property, config().propertyGroup());
2145 		require(enabled == false, "market is already enabled");
2146 		require(
2147 			block.number <= _votingEndBlockNumber,
2148 			"voting deadline is over"
2149 		);
2150 
2151 		VoteCounter voteCounter = VoteCounter(config().voteCounter());
2152 		voteCounter.addVoteCount(msg.sender, _property, _agree);
2153 		enabled = Policy(config().policy()).marketApproval(
2154 			voteCounter.getAgreeCount(address(this)),
2155 			voteCounter.getOppositeCount(address(this))
2156 		);
2157 	}
2158 
2159 	function schema() external view returns (string memory) {
2160 		return IMarketBehavior(behavior).schema();
2161 	}
2162 }
2163 
2164 // prettier-ignore
2165 
2166 
2167 
2168 contract WithdrawStorage is
2169 	UsingStorage,
2170 	UsingConfig,
2171 	UsingValidator,
2172 	Killable
2173 {
2174 	// solium-disable-next-line no-empty-blocks
2175 	constructor(address _config) public UsingConfig(_config) {}
2176 
2177 	// RewardsAmount
2178 	function setRewardsAmount(address _property, uint256 _value) external {
2179 		addressValidator().validateAddress(msg.sender, config().withdraw());
2180 
2181 		eternalStorage().setUint(getRewardsAmountKey(_property), _value);
2182 	}
2183 
2184 	function getRewardsAmount(address _property)
2185 		external
2186 		view
2187 		returns (uint256)
2188 	{
2189 		return eternalStorage().getUint(getRewardsAmountKey(_property));
2190 	}
2191 
2192 	function getRewardsAmountKey(address _property)
2193 		private
2194 		pure
2195 		returns (bytes32)
2196 	{
2197 		return keccak256(abi.encodePacked("_rewardsAmount", _property));
2198 	}
2199 
2200 	// CumulativePrice
2201 	function setCumulativePrice(address _property, uint256 _value)
2202 		external
2203 		returns (uint256)
2204 	{
2205 		addressValidator().validateAddress(msg.sender, config().withdraw());
2206 
2207 		eternalStorage().setUint(getCumulativePriceKey(_property), _value);
2208 	}
2209 
2210 	function getCumulativePrice(address _property)
2211 		external
2212 		view
2213 		returns (uint256)
2214 	{
2215 		return eternalStorage().getUint(getCumulativePriceKey(_property));
2216 	}
2217 
2218 	function getCumulativePriceKey(address _property)
2219 		private
2220 		pure
2221 		returns (bytes32)
2222 	{
2223 		return keccak256(abi.encodePacked("_cumulativePrice", _property));
2224 	}
2225 
2226 	// WithdrawalLimitTotal
2227 	function setWithdrawalLimitTotal(
2228 		address _property,
2229 		address _user,
2230 		uint256 _value
2231 	) external {
2232 		addressValidator().validateAddress(msg.sender, config().withdraw());
2233 
2234 		eternalStorage().setUint(
2235 			getWithdrawalLimitTotalKey(_property, _user),
2236 			_value
2237 		);
2238 	}
2239 
2240 	function getWithdrawalLimitTotal(address _property, address _user)
2241 		external
2242 		view
2243 		returns (uint256)
2244 	{
2245 		return
2246 			eternalStorage().getUint(
2247 				getWithdrawalLimitTotalKey(_property, _user)
2248 			);
2249 	}
2250 
2251 	function getWithdrawalLimitTotalKey(address _property, address _user)
2252 		private
2253 		pure
2254 		returns (bytes32)
2255 	{
2256 		return
2257 			keccak256(
2258 				abi.encodePacked("_withdrawalLimitTotal", _property, _user)
2259 			);
2260 	}
2261 
2262 	// WithdrawalLimitBalance
2263 	function setWithdrawalLimitBalance(
2264 		address _property,
2265 		address _user,
2266 		uint256 _value
2267 	) external {
2268 		addressValidator().validateAddress(msg.sender, config().withdraw());
2269 
2270 		eternalStorage().setUint(
2271 			getWithdrawalLimitBalanceKey(_property, _user),
2272 			_value
2273 		);
2274 	}
2275 
2276 	function getWithdrawalLimitBalance(address _property, address _user)
2277 		external
2278 		view
2279 		returns (uint256)
2280 	{
2281 		return
2282 			eternalStorage().getUint(
2283 				getWithdrawalLimitBalanceKey(_property, _user)
2284 			);
2285 	}
2286 
2287 	function getWithdrawalLimitBalanceKey(address _property, address _user)
2288 		private
2289 		pure
2290 		returns (bytes32)
2291 	{
2292 		return
2293 			keccak256(
2294 				abi.encodePacked("_withdrawalLimitBalance", _property, _user)
2295 			);
2296 	}
2297 
2298 	//LastWithdrawalPrice
2299 	function setLastWithdrawalPrice(
2300 		address _property,
2301 		address _user,
2302 		uint256 _value
2303 	) external {
2304 		addressValidator().validateAddress(msg.sender, config().withdraw());
2305 
2306 		eternalStorage().setUint(
2307 			getLastWithdrawalPriceKey(_property, _user),
2308 			_value
2309 		);
2310 	}
2311 
2312 	function getLastWithdrawalPrice(address _property, address _user)
2313 		external
2314 		view
2315 		returns (uint256)
2316 	{
2317 		return
2318 			eternalStorage().getUint(
2319 				getLastWithdrawalPriceKey(_property, _user)
2320 			);
2321 	}
2322 
2323 	function getLastWithdrawalPriceKey(address _property, address _user)
2324 		private
2325 		pure
2326 		returns (bytes32)
2327 	{
2328 		return
2329 			keccak256(
2330 				abi.encodePacked("_lastWithdrawalPrice", _property, _user)
2331 			);
2332 	}
2333 
2334 	//PendingWithdrawal
2335 	function setPendingWithdrawal(
2336 		address _property,
2337 		address _user,
2338 		uint256 _value
2339 	) external {
2340 		addressValidator().validateAddress(msg.sender, config().withdraw());
2341 
2342 		eternalStorage().setUint(
2343 			getPendingWithdrawalKey(_property, _user),
2344 			_value
2345 		);
2346 	}
2347 
2348 	function getPendingWithdrawal(address _property, address _user)
2349 		external
2350 		view
2351 		returns (uint256)
2352 	{
2353 		return
2354 			eternalStorage().getUint(getPendingWithdrawalKey(_property, _user));
2355 	}
2356 
2357 	function getPendingWithdrawalKey(address _property, address _user)
2358 		private
2359 		pure
2360 		returns (bytes32)
2361 	{
2362 		return
2363 			keccak256(abi.encodePacked("_pendingWithdrawal", _property, _user));
2364 	}
2365 }
2366 
2367 
2368 contract Withdraw is Pausable, UsingConfig, UsingValidator, Killable {
2369 	using SafeMath for uint256;
2370 	using Decimals for uint256;
2371 
2372 	// solium-disable-next-line no-empty-blocks
2373 	constructor(address _config) public UsingConfig(_config) {}
2374 
2375 	function withdraw(address _property) external {
2376 		require(paused() == false, "You cannot use that");
2377 		addressValidator().validateGroup(_property, config().propertyGroup());
2378 
2379 		uint256 value = _calculateWithdrawableAmount(_property, msg.sender);
2380 		require(value != 0, "withdraw value is 0");
2381 		uint256 price = getStorage().getCumulativePrice(_property);
2382 		getStorage().setLastWithdrawalPrice(_property, msg.sender, price);
2383 		getStorage().setPendingWithdrawal(_property, msg.sender, 0);
2384 		ERC20Mintable erc20 = ERC20Mintable(config().token());
2385 		require(erc20.mint(msg.sender, value), "dev mint failed");
2386 	}
2387 
2388 	function beforeBalanceChange(address _property, address _from, address _to)
2389 		external
2390 	{
2391 		addressValidator().validateAddress(msg.sender, config().allocator());
2392 
2393 		uint256 price = getStorage().getCumulativePrice(_property);
2394 		uint256 amountFrom = _calculateAmount(_property, _from);
2395 		uint256 amountTo = _calculateAmount(_property, _to);
2396 		getStorage().setLastWithdrawalPrice(_property, _from, price);
2397 		getStorage().setLastWithdrawalPrice(_property, _to, price);
2398 		uint256 pendFrom = getStorage().getPendingWithdrawal(_property, _from);
2399 		uint256 pendTo = getStorage().getPendingWithdrawal(_property, _to);
2400 		getStorage().setPendingWithdrawal(
2401 			_property,
2402 			_from,
2403 			pendFrom.add(amountFrom)
2404 		);
2405 		getStorage().setPendingWithdrawal(_property, _to, pendTo.add(amountTo));
2406 		uint256 totalLimit = getStorage().getWithdrawalLimitTotal(
2407 			_property,
2408 			_to
2409 		);
2410 		uint256 total = getStorage().getRewardsAmount(_property);
2411 		if (totalLimit != total) {
2412 			getStorage().setWithdrawalLimitTotal(_property, _to, total);
2413 			getStorage().setWithdrawalLimitBalance(
2414 				_property,
2415 				_to,
2416 				ERC20(_property).balanceOf(_to)
2417 			);
2418 		}
2419 	}
2420 
2421 	function increment(address _property, uint256 _allocationResult) external {
2422 		addressValidator().validateAddress(msg.sender, config().allocator());
2423 		uint256 priceValue = _allocationResult.outOf(
2424 			ERC20(_property).totalSupply()
2425 		);
2426 		uint256 total = getStorage().getRewardsAmount(_property);
2427 		getStorage().setRewardsAmount(_property, total.add(_allocationResult));
2428 		uint256 price = getStorage().getCumulativePrice(_property);
2429 		getStorage().setCumulativePrice(_property, price.add(priceValue));
2430 	}
2431 
2432 	function getRewardsAmount(address _property)
2433 		external
2434 		view
2435 		returns (uint256)
2436 	{
2437 		return getStorage().getRewardsAmount(_property);
2438 	}
2439 
2440 	function _calculateAmount(address _property, address _user)
2441 		private
2442 		view
2443 		returns (uint256)
2444 	{
2445 		uint256 _last = getStorage().getLastWithdrawalPrice(_property, _user);
2446 		uint256 totalLimit = getStorage().getWithdrawalLimitTotal(
2447 			_property,
2448 			_user
2449 		);
2450 		uint256 balanceLimit = getStorage().getWithdrawalLimitBalance(
2451 			_property,
2452 			_user
2453 		);
2454 		uint256 price = getStorage().getCumulativePrice(_property);
2455 		uint256 priceGap = price.sub(_last);
2456 		uint256 balance = ERC20(_property).balanceOf(_user);
2457 		uint256 total = getStorage().getRewardsAmount(_property);
2458 		if (totalLimit == total) {
2459 			balance = balanceLimit;
2460 		}
2461 		uint256 value = priceGap.mul(balance);
2462 		return value.div(Decimals.basis());
2463 	}
2464 
2465 	function calculateAmount(address _property, address _user)
2466 		external
2467 		view
2468 		returns (uint256)
2469 	{
2470 		return _calculateAmount(_property, _user);
2471 	}
2472 
2473 	function _calculateWithdrawableAmount(address _property, address _user)
2474 		private
2475 		view
2476 		returns (uint256)
2477 	{
2478 		uint256 _value = _calculateAmount(_property, _user);
2479 		uint256 value = _value.add(
2480 			getStorage().getPendingWithdrawal(_property, _user)
2481 		);
2482 		return value;
2483 	}
2484 
2485 	function calculateWithdrawableAmount(address _property, address _user)
2486 		external
2487 		view
2488 		returns (uint256)
2489 	{
2490 		return _calculateWithdrawableAmount(_property, _user);
2491 	}
2492 
2493 	function getStorage() private view returns (WithdrawStorage) {
2494 		return WithdrawStorage(config().withdrawStorage());
2495 	}
2496 }
2497 
2498 
2499 
2500 contract AllocatorStorage is
2501 	UsingStorage,
2502 	UsingConfig,
2503 	UsingValidator,
2504 	Killable
2505 {
2506 	constructor(address _config) public UsingConfig(_config) UsingStorage() {}
2507 
2508 	// Last Block Number
2509 	function setLastBlockNumber(address _metrics, uint256 _blocks) external {
2510 		addressValidator().validateAddress(msg.sender, config().allocator());
2511 
2512 		eternalStorage().setUint(getLastBlockNumberKey(_metrics), _blocks);
2513 	}
2514 
2515 	function getLastBlockNumber(address _metrics)
2516 		external
2517 		view
2518 		returns (uint256)
2519 	{
2520 		return eternalStorage().getUint(getLastBlockNumberKey(_metrics));
2521 	}
2522 
2523 	function getLastBlockNumberKey(address _metrics)
2524 		private
2525 		pure
2526 		returns (bytes32)
2527 	{
2528 		return keccak256(abi.encodePacked("_lastBlockNumber", _metrics));
2529 	}
2530 
2531 	// Base Block Number
2532 	function setBaseBlockNumber(uint256 _blockNumber) external {
2533 		addressValidator().validateAddress(msg.sender, config().allocator());
2534 
2535 		eternalStorage().setUint(getBaseBlockNumberKey(), _blockNumber);
2536 	}
2537 
2538 	function getBaseBlockNumber() external view returns (uint256) {
2539 		return eternalStorage().getUint(getBaseBlockNumberKey());
2540 	}
2541 
2542 	function getBaseBlockNumberKey() private pure returns (bytes32) {
2543 		return keccak256(abi.encodePacked("_baseBlockNumber"));
2544 	}
2545 
2546 	// PendingIncrement
2547 	function setPendingIncrement(address _metrics, bool value) external {
2548 		addressValidator().validateAddress(msg.sender, config().allocator());
2549 
2550 		eternalStorage().setBool(getPendingIncrementKey(_metrics), value);
2551 	}
2552 
2553 	function getPendingIncrement(address _metrics)
2554 		external
2555 		view
2556 		returns (bool)
2557 	{
2558 		return eternalStorage().getBool(getPendingIncrementKey(_metrics));
2559 	}
2560 
2561 	function getPendingIncrementKey(address _metrics)
2562 		private
2563 		pure
2564 		returns (bytes32)
2565 	{
2566 		return keccak256(abi.encodePacked("_pendingIncrement", _metrics));
2567 	}
2568 
2569 	// LastAllocationBlockEachMetrics
2570 	function setLastAllocationBlockEachMetrics(
2571 		address _metrics,
2572 		uint256 blockNumber
2573 	) external {
2574 		addressValidator().validateAddress(msg.sender, config().allocator());
2575 
2576 		eternalStorage().setUint(
2577 			getLastAllocationBlockEachMetricsKey(_metrics),
2578 			blockNumber
2579 		);
2580 	}
2581 
2582 	function getLastAllocationBlockEachMetrics(address _metrics)
2583 		external
2584 		view
2585 		returns (uint256)
2586 	{
2587 		return
2588 			eternalStorage().getUint(
2589 				getLastAllocationBlockEachMetricsKey(_metrics)
2590 			);
2591 	}
2592 
2593 	function getLastAllocationBlockEachMetricsKey(address _addr)
2594 		private
2595 		pure
2596 		returns (bytes32)
2597 	{
2598 		return
2599 			keccak256(
2600 				abi.encodePacked("_lastAllocationBlockEachMetrics", _addr)
2601 			);
2602 	}
2603 
2604 	// LastAssetValueEachMetrics
2605 	function setLastAssetValueEachMetrics(address _metrics, uint256 value)
2606 		external
2607 	{
2608 		addressValidator().validateAddress(msg.sender, config().allocator());
2609 
2610 		eternalStorage().setUint(
2611 			getLastAssetValueEachMetricsKey(_metrics),
2612 			value
2613 		);
2614 	}
2615 
2616 	function getLastAssetValueEachMetrics(address _metrics)
2617 		external
2618 		view
2619 		returns (uint256)
2620 	{
2621 		return
2622 			eternalStorage().getUint(getLastAssetValueEachMetricsKey(_metrics));
2623 	}
2624 
2625 	function getLastAssetValueEachMetricsKey(address _addr)
2626 		private
2627 		pure
2628 		returns (bytes32)
2629 	{
2630 		return keccak256(abi.encodePacked("_lastAssetValueEachMetrics", _addr));
2631 	}
2632 
2633 	// lastAssetValueEachMarketPerBlock
2634 	function setLastAssetValueEachMarketPerBlock(address _market, uint256 value)
2635 		external
2636 	{
2637 		addressValidator().validateAddress(msg.sender, config().allocator());
2638 
2639 		eternalStorage().setUint(
2640 			getLastAssetValueEachMarketPerBlockKey(_market),
2641 			value
2642 		);
2643 	}
2644 
2645 	function getLastAssetValueEachMarketPerBlock(address _market)
2646 		external
2647 		view
2648 		returns (uint256)
2649 	{
2650 		return
2651 			eternalStorage().getUint(
2652 				getLastAssetValueEachMarketPerBlockKey(_market)
2653 			);
2654 	}
2655 
2656 	function getLastAssetValueEachMarketPerBlockKey(address _addr)
2657 		private
2658 		pure
2659 		returns (bytes32)
2660 	{
2661 		return
2662 			keccak256(
2663 				abi.encodePacked("_lastAssetValueEachMarketPerBlock", _addr)
2664 			);
2665 	}
2666 }
2667 
2668 
2669 contract Allocator is
2670 	Killable,
2671 	Ownable,
2672 	UsingConfig,
2673 	IAllocator,
2674 	UsingValidator
2675 {
2676 	using SafeMath for uint256;
2677 	using Decimals for uint256;
2678 	event BeforeAllocation(
2679 		uint256 _blocks,
2680 		uint256 _mint,
2681 		uint256 _value,
2682 		uint256 _marketValue,
2683 		uint256 _assets,
2684 		uint256 _totalAssets
2685 	);
2686 
2687 	uint64 public constant basis = 1000000000000000000;
2688 
2689 	// solium-disable-next-line no-empty-blocks
2690 	constructor(address _config) public UsingConfig(_config) {}
2691 
2692 	function allocate(address _metrics) external {
2693 		addressValidator().validateGroup(_metrics, config().metricsGroup());
2694 
2695 		validateTargetPeriod(_metrics);
2696 		address market = Metrics(_metrics).market();
2697 		getStorage().setPendingIncrement(_metrics, true);
2698 		Market(market).calculate(
2699 			_metrics,
2700 			getLastAllocationBlockNumber(_metrics),
2701 			block.number
2702 		);
2703 		getStorage().setLastBlockNumber(_metrics, block.number);
2704 	}
2705 
2706 	function calculatedCallback(address _metrics, uint256 _value) external {
2707 		addressValidator().validateGroup(_metrics, config().metricsGroup());
2708 
2709 		Metrics metrics = Metrics(_metrics);
2710 		Market market = Market(metrics.market());
2711 		require(
2712 			msg.sender == market.behavior(),
2713 			"don't call from other than market behavior"
2714 		);
2715 		require(
2716 			getStorage().getPendingIncrement(_metrics),
2717 			"not asking for an indicator"
2718 		);
2719 		Policy policy = Policy(config().policy());
2720 		uint256 totalAssets = MetricsGroup(config().metricsGroup())
2721 			.totalIssuedMetrics();
2722 		uint256 lockupValue = Lockup(config().lockup()).getPropertyValue(
2723 			metrics.property()
2724 		);
2725 		uint256 blocks = block.number.sub(
2726 			getStorage().getLastAllocationBlockEachMetrics(_metrics)
2727 		);
2728 		uint256 mint = policy.rewards(lockupValue, totalAssets);
2729 		uint256 value = (policy.assetValue(_value, lockupValue).mul(basis)).div(
2730 			blocks
2731 		);
2732 		uint256 marketValue = getStorage()
2733 			.getLastAssetValueEachMarketPerBlock(metrics.market())
2734 			.sub(getStorage().getLastAssetValueEachMetrics(_metrics))
2735 			.add(value);
2736 		uint256 assets = market.issuedMetrics();
2737 		getStorage().setLastAllocationBlockEachMetrics(_metrics, block.number);
2738 		getStorage().setLastAssetValueEachMetrics(_metrics, value);
2739 		getStorage().setLastAssetValueEachMarketPerBlock(
2740 			metrics.market(),
2741 			marketValue
2742 		);
2743 		emit BeforeAllocation(
2744 			blocks,
2745 			mint,
2746 			value,
2747 			marketValue,
2748 			assets,
2749 			totalAssets
2750 		);
2751 		uint256 result = allocation(
2752 			blocks,
2753 			mint,
2754 			value,
2755 			marketValue,
2756 			assets,
2757 			totalAssets
2758 		);
2759 		increment(metrics.property(), result, lockupValue);
2760 		getStorage().setPendingIncrement(_metrics, false);
2761 	}
2762 
2763 	function increment(address _property, uint256 _reward, uint256 _lockup)
2764 		private
2765 	{
2766 		uint256 holders = Policy(config().policy()).holdersShare(
2767 			_reward,
2768 			_lockup
2769 		);
2770 		uint256 interest = _reward.sub(holders);
2771 		Withdraw(config().withdraw()).increment(_property, holders);
2772 		Lockup(config().lockup()).increment(_property, interest);
2773 	}
2774 
2775 	function beforeBalanceChange(address _property, address _from, address _to)
2776 		external
2777 	{
2778 		addressValidator().validateGroup(msg.sender, config().propertyGroup());
2779 
2780 		Withdraw(config().withdraw()).beforeBalanceChange(
2781 			_property,
2782 			_from,
2783 			_to
2784 		);
2785 	}
2786 
2787 	function getRewardsAmount(address _property)
2788 		external
2789 		view
2790 		returns (uint256)
2791 	{
2792 		return Withdraw(config().withdraw()).getRewardsAmount(_property);
2793 	}
2794 
2795 	function allocation(
2796 		uint256 _blocks,
2797 		uint256 _mint,
2798 		uint256 _value,
2799 		uint256 _marketValue,
2800 		uint256 _assets,
2801 		uint256 _totalAssets
2802 	) public pure returns (uint256) {
2803 		uint256 aShare = _totalAssets > 0
2804 			? _assets.outOf(_totalAssets)
2805 			: Decimals.basis();
2806 		uint256 vShare = _marketValue > 0
2807 			? _value.outOf(_marketValue)
2808 			: Decimals.basis();
2809 		uint256 mint = _mint.mul(_blocks);
2810 		return
2811 			mint.mul(aShare).mul(vShare).div(Decimals.basis()).div(
2812 				Decimals.basis()
2813 			);
2814 	}
2815 
2816 	function validateTargetPeriod(address _metrics) private {
2817 		address property = Metrics(_metrics).property();
2818 		VoteTimes voteTimes = VoteTimes(config().voteTimes());
2819 		uint256 abstentionCount = voteTimes.getAbstentionTimes(property);
2820 		uint256 notTargetPeriod = Policy(config().policy()).abstentionPenalty(
2821 			abstentionCount
2822 		);
2823 		if (notTargetPeriod == 0) {
2824 			return;
2825 		}
2826 		uint256 blockNumber = getLastAllocationBlockNumber(_metrics);
2827 		uint256 notTargetBlockNumber = blockNumber.add(notTargetPeriod);
2828 		require(
2829 			notTargetBlockNumber < block.number,
2830 			"outside the target period"
2831 		);
2832 		getStorage().setLastBlockNumber(_metrics, notTargetBlockNumber);
2833 		voteTimes.resetVoteTimesByProperty(property);
2834 	}
2835 
2836 	function getLastAllocationBlockNumber(address _metrics)
2837 		private
2838 		returns (uint256)
2839 	{
2840 		uint256 blockNumber = getStorage().getLastBlockNumber(_metrics);
2841 		uint256 baseBlockNumber = getStorage().getBaseBlockNumber();
2842 		if (baseBlockNumber == 0) {
2843 			getStorage().setBaseBlockNumber(block.number);
2844 		}
2845 		uint256 lastAllocationBlockNumber = blockNumber > 0
2846 			? blockNumber
2847 			: getStorage().getBaseBlockNumber();
2848 		return lastAllocationBlockNumber;
2849 	}
2850 
2851 	function getStorage() private view returns (AllocatorStorage) {
2852 		return AllocatorStorage(config().allocatorStorage());
2853 	}
2854 }
2855 
2856 
2857 contract Property is ERC20, ERC20Detailed, UsingConfig, UsingValidator {
2858 	uint8 private constant _decimals = 18;
2859 	uint256 private constant _supply = 10000000;
2860 	address public author;
2861 
2862 	constructor(
2863 		address _config,
2864 		address _own,
2865 		string memory _name,
2866 		string memory _symbol
2867 	) public UsingConfig(_config) ERC20Detailed(_name, _symbol, _decimals) {
2868 		addressValidator().validateAddress(
2869 			msg.sender,
2870 			config().propertyFactory()
2871 		);
2872 
2873 		author = _own;
2874 		_mint(author, _supply);
2875 	}
2876 
2877 	function transfer(address _to, uint256 _value) public returns (bool) {
2878 		addressValidator().validateIllegalAddress(_to);
2879 		require(_value != 0, "illegal transfer value");
2880 
2881 		Allocator(config().allocator()).beforeBalanceChange(
2882 			address(this),
2883 			msg.sender,
2884 			_to
2885 		);
2886 		_transfer(msg.sender, _to, _value);
2887 	}
2888 
2889 	function withdraw(address _sender, uint256 _value) external {
2890 		addressValidator().validateAddress(msg.sender, config().lockup());
2891 
2892 		ERC20 devToken = ERC20(config().token());
2893 		devToken.transfer(_sender, _value);
2894 	}
2895 }
2896 
2897 
2898 
2899 contract LockupStorage is UsingConfig, UsingStorage, UsingValidator, Killable {
2900 	// solium-disable-next-line no-empty-blocks
2901 	constructor(address _config) public UsingConfig(_config) {}
2902 
2903 	//Value
2904 	function setValue(address _property, address _sender, uint256 _value)
2905 		external
2906 		returns (uint256)
2907 	{
2908 		addressValidator().validateAddress(msg.sender, config().lockup());
2909 
2910 		bytes32 key = getValueKey(_property, _sender);
2911 		eternalStorage().setUint(key, _value);
2912 	}
2913 
2914 	function getValue(address _property, address _sender)
2915 		external
2916 		view
2917 		returns (uint256)
2918 	{
2919 		bytes32 key = getValueKey(_property, _sender);
2920 		return eternalStorage().getUint(key);
2921 	}
2922 
2923 	function getValueKey(address _property, address _sender)
2924 		private
2925 		pure
2926 		returns (bytes32)
2927 	{
2928 		return keccak256(abi.encodePacked("_value", _property, _sender));
2929 	}
2930 
2931 	//PropertyValue
2932 	function setPropertyValue(address _property, uint256 _value)
2933 		external
2934 		returns (uint256)
2935 	{
2936 		addressValidator().validateAddress(msg.sender, config().lockup());
2937 
2938 		bytes32 key = getPropertyValueKey(_property);
2939 		eternalStorage().setUint(key, _value);
2940 	}
2941 
2942 	function getPropertyValue(address _property)
2943 		external
2944 		view
2945 		returns (uint256)
2946 	{
2947 		bytes32 key = getPropertyValueKey(_property);
2948 		return eternalStorage().getUint(key);
2949 	}
2950 
2951 	function getPropertyValueKey(address _property)
2952 		private
2953 		pure
2954 		returns (bytes32)
2955 	{
2956 		return keccak256(abi.encodePacked("_propertyValue", _property));
2957 	}
2958 
2959 	//WithdrawalStatus
2960 	function setWithdrawalStatus(
2961 		address _property,
2962 		address _from,
2963 		uint256 _value
2964 	) external {
2965 		addressValidator().validateAddress(msg.sender, config().lockup());
2966 
2967 		bytes32 key = getWithdrawalStatusKey(_property, _from);
2968 		eternalStorage().setUint(key, _value);
2969 	}
2970 
2971 	function getWithdrawalStatus(address _property, address _from)
2972 		external
2973 		view
2974 		returns (uint256)
2975 	{
2976 		bytes32 key = getWithdrawalStatusKey(_property, _from);
2977 		return eternalStorage().getUint(key);
2978 	}
2979 
2980 	function getWithdrawalStatusKey(address _property, address _sender)
2981 		private
2982 		pure
2983 		returns (bytes32)
2984 	{
2985 		return
2986 			keccak256(
2987 				abi.encodePacked("_withdrawalStatus", _property, _sender)
2988 			);
2989 	}
2990 
2991 	//InterestPrice
2992 	function setInterestPrice(address _property, uint256 _value)
2993 		external
2994 		returns (uint256)
2995 	{
2996 		addressValidator().validateAddress(msg.sender, config().lockup());
2997 
2998 		eternalStorage().setUint(getInterestPriceKey(_property), _value);
2999 	}
3000 
3001 	function getInterestPrice(address _property)
3002 		external
3003 		view
3004 		returns (uint256)
3005 	{
3006 		return eternalStorage().getUint(getInterestPriceKey(_property));
3007 	}
3008 
3009 	function getInterestPriceKey(address _property)
3010 		private
3011 		pure
3012 		returns (bytes32)
3013 	{
3014 		return keccak256(abi.encodePacked("_interestTotals", _property));
3015 	}
3016 
3017 	//LastInterestPrice
3018 	function setLastInterestPrice(
3019 		address _property,
3020 		address _user,
3021 		uint256 _value
3022 	) external {
3023 		addressValidator().validateAddress(msg.sender, config().lockup());
3024 
3025 		eternalStorage().setUint(
3026 			getLastInterestPriceKey(_property, _user),
3027 			_value
3028 		);
3029 	}
3030 
3031 	function getLastInterestPrice(address _property, address _user)
3032 		external
3033 		view
3034 		returns (uint256)
3035 	{
3036 		return
3037 			eternalStorage().getUint(getLastInterestPriceKey(_property, _user));
3038 	}
3039 
3040 	function getLastInterestPriceKey(address _property, address _user)
3041 		private
3042 		pure
3043 		returns (bytes32)
3044 	{
3045 		return
3046 			keccak256(
3047 				abi.encodePacked("_lastLastInterestPrice", _property, _user)
3048 			);
3049 	}
3050 
3051 	//PendingWithdrawal
3052 	function setPendingInterestWithdrawal(
3053 		address _property,
3054 		address _user,
3055 		uint256 _value
3056 	) external {
3057 		addressValidator().validateAddress(msg.sender, config().lockup());
3058 
3059 		eternalStorage().setUint(
3060 			getPendingInterestWithdrawalKey(_property, _user),
3061 			_value
3062 		);
3063 	}
3064 
3065 	function getPendingInterestWithdrawal(address _property, address _user)
3066 		external
3067 		view
3068 		returns (uint256)
3069 	{
3070 		return
3071 			eternalStorage().getUint(
3072 				getPendingInterestWithdrawalKey(_property, _user)
3073 			);
3074 	}
3075 
3076 	function getPendingInterestWithdrawalKey(address _property, address _user)
3077 		private
3078 		pure
3079 		returns (bytes32)
3080 	{
3081 		return
3082 			keccak256(
3083 				abi.encodePacked("_pendingInterestWithdrawal", _property, _user)
3084 			);
3085 	}
3086 }
3087 
3088 
3089 contract Lockup is Pausable, UsingConfig, UsingValidator, Killable {
3090 	using SafeMath for uint256;
3091 	using Decimals for uint256;
3092 	event Lockedup(address _from, address _property, uint256 _value);
3093 
3094 	// solium-disable-next-line no-empty-blocks
3095 	constructor(address _config) public UsingConfig(_config) {}
3096 
3097 	function lockup(address _from, address _property, uint256 _value) external {
3098 		require(paused() == false, "You cannot use that");
3099 		addressValidator().validateAddress(msg.sender, config().token());
3100 		addressValidator().validateGroup(_property, config().propertyGroup());
3101 		require(_value != 0, "illegal lockup value");
3102 
3103 		bool isWaiting = getStorage().getWithdrawalStatus(_property, _from) !=
3104 			0;
3105 		require(isWaiting == false, "lockup is already canceled");
3106 		updatePendingInterestWithdrawal(_property, _from);
3107 		addValue(_property, _from, _value);
3108 		addPropertyValue(_property, _value);
3109 		getStorage().setLastInterestPrice(
3110 			_property,
3111 			_from,
3112 			getStorage().getInterestPrice(_property)
3113 		);
3114 		emit Lockedup(_from, _property, _value);
3115 	}
3116 
3117 	function cancel(address _property) external {
3118 		addressValidator().validateGroup(_property, config().propertyGroup());
3119 
3120 		require(hasValue(_property, msg.sender), "dev token is not locked");
3121 		bool isWaiting = getStorage().getWithdrawalStatus(
3122 			_property,
3123 			msg.sender
3124 		) !=
3125 			0;
3126 		require(isWaiting == false, "lockup is already canceled");
3127 		uint256 blockNumber = Policy(config().policy()).lockUpBlocks();
3128 		blockNumber = blockNumber.add(block.number);
3129 		getStorage().setWithdrawalStatus(_property, msg.sender, blockNumber);
3130 	}
3131 
3132 	function withdraw(address _property) external {
3133 		addressValidator().validateGroup(_property, config().propertyGroup());
3134 
3135 		require(possible(_property, msg.sender), "waiting for release");
3136 		uint256 lockupedValue = getStorage().getValue(_property, msg.sender);
3137 		require(lockupedValue != 0, "dev token is not locked");
3138 		updatePendingInterestWithdrawal(_property, msg.sender);
3139 		Property(_property).withdraw(msg.sender, lockupedValue);
3140 		getStorage().setValue(_property, msg.sender, 0);
3141 		subPropertyValue(_property, lockupedValue);
3142 		getStorage().setWithdrawalStatus(_property, msg.sender, 0);
3143 	}
3144 
3145 	function increment(address _property, uint256 _interestResult) external {
3146 		addressValidator().validateAddress(msg.sender, config().allocator());
3147 		uint256 priceValue = _interestResult.outOf(
3148 			getStorage().getPropertyValue(_property)
3149 		);
3150 		incrementInterest(_property, priceValue);
3151 	}
3152 
3153 	function _calculateInterestAmount(address _property, address _user)
3154 		private
3155 		view
3156 		returns (uint256)
3157 	{
3158 		uint256 _last = getStorage().getLastInterestPrice(_property, _user);
3159 		uint256 price = getStorage().getInterestPrice(_property);
3160 		uint256 priceGap = price.sub(_last);
3161 		uint256 lockupedValue = getStorage().getValue(_property, _user);
3162 		uint256 value = priceGap.mul(lockupedValue);
3163 		return value.div(Decimals.basis());
3164 	}
3165 
3166 	function calculateInterestAmount(address _property, address _user)
3167 		external
3168 		view
3169 		returns (uint256)
3170 	{
3171 		return _calculateInterestAmount(_property, _user);
3172 	}
3173 
3174 	function _calculateWithdrawableInterestAmount(
3175 		address _property,
3176 		address _user
3177 	) private view returns (uint256) {
3178 		uint256 pending = getStorage().getPendingInterestWithdrawal(
3179 			_property,
3180 			_user
3181 		);
3182 		return _calculateInterestAmount(_property, _user).add(pending);
3183 	}
3184 
3185 	function calculateWithdrawableInterestAmount(
3186 		address _property,
3187 		address _user
3188 	) external view returns (uint256) {
3189 		return _calculateWithdrawableInterestAmount(_property, _user);
3190 	}
3191 
3192 	function withdrawInterest(address _property) external {
3193 		addressValidator().validateGroup(_property, config().propertyGroup());
3194 
3195 		uint256 value = _calculateWithdrawableInterestAmount(
3196 			_property,
3197 			msg.sender
3198 		);
3199 		require(value > 0, "your interest amount is 0");
3200 		getStorage().setLastInterestPrice(
3201 			_property,
3202 			msg.sender,
3203 			getStorage().getInterestPrice(_property)
3204 		);
3205 		getStorage().setPendingInterestWithdrawal(_property, msg.sender, 0);
3206 		ERC20Mintable erc20 = ERC20Mintable(config().token());
3207 		require(erc20.mint(msg.sender, value), "dev mint failed");
3208 	}
3209 
3210 	function getPropertyValue(address _property)
3211 		external
3212 		view
3213 		returns (uint256)
3214 	{
3215 		return getStorage().getPropertyValue(_property);
3216 	}
3217 
3218 	function getValue(address _property, address _sender)
3219 		external
3220 		view
3221 		returns (uint256)
3222 	{
3223 		return getStorage().getValue(_property, _sender);
3224 	}
3225 
3226 	function addValue(address _property, address _sender, uint256 _value)
3227 		private
3228 	{
3229 		uint256 value = getStorage().getValue(_property, _sender);
3230 		value = value.add(_value);
3231 		getStorage().setValue(_property, _sender, value);
3232 	}
3233 
3234 	function hasValue(address _property, address _sender)
3235 		private
3236 		view
3237 		returns (bool)
3238 	{
3239 		uint256 value = getStorage().getValue(_property, _sender);
3240 		return value != 0;
3241 	}
3242 
3243 	function addPropertyValue(address _property, uint256 _value) private {
3244 		uint256 value = getStorage().getPropertyValue(_property);
3245 		value = value.add(_value);
3246 		getStorage().setPropertyValue(_property, value);
3247 	}
3248 
3249 	function subPropertyValue(address _property, uint256 _value) private {
3250 		uint256 value = getStorage().getPropertyValue(_property);
3251 		value = value.sub(_value);
3252 		getStorage().setPropertyValue(_property, value);
3253 	}
3254 
3255 	function incrementInterest(address _property, uint256 _priceValue) private {
3256 		uint256 price = getStorage().getInterestPrice(_property);
3257 		getStorage().setInterestPrice(_property, price.add(_priceValue));
3258 	}
3259 
3260 	function updatePendingInterestWithdrawal(address _property, address _user)
3261 		private
3262 	{
3263 		uint256 pending = getStorage().getPendingInterestWithdrawal(
3264 			_property,
3265 			_user
3266 		);
3267 		getStorage().setPendingInterestWithdrawal(
3268 			_property,
3269 			_user,
3270 			_calculateInterestAmount(_property, _user).add(pending)
3271 		);
3272 	}
3273 
3274 	function possible(address _property, address _from)
3275 		private
3276 		view
3277 		returns (bool)
3278 	{
3279 		uint256 blockNumber = getStorage().getWithdrawalStatus(
3280 			_property,
3281 			_from
3282 		);
3283 		if (blockNumber == 0) {
3284 			return false;
3285 		}
3286 		return blockNumber <= block.number;
3287 	}
3288 
3289 	function getStorage() private view returns (LockupStorage) {
3290 		return LockupStorage(config().lockupStorage());
3291 	}
3292 }
3293 
3294 
3295 contract Dev is
3296 	ERC20Detailed,
3297 	ERC20Mintable,
3298 	ERC20Burnable,
3299 	UsingConfig,
3300 	UsingValidator
3301 {
3302 	constructor(address _config)
3303 		public
3304 		ERC20Detailed("Dev", "DEV", 18)
3305 		UsingConfig(_config)
3306 	{}
3307 
3308 	function deposit(address _to, uint256 _amount) external returns (bool) {
3309 		require(transfer(_to, _amount), "dev transfer failed");
3310 		lock(msg.sender, _to, _amount);
3311 		return true;
3312 	}
3313 
3314 	function depositFrom(address _from, address _to, uint256 _amount)
3315 		external
3316 		returns (bool)
3317 	{
3318 		require(transferFrom(_from, _to, _amount), "dev transferFrom failed");
3319 		lock(_from, _to, _amount);
3320 		return true;
3321 	}
3322 
3323 	function fee(address _from, uint256 _amount) external returns (bool) {
3324 		addressValidator().validateGroup(msg.sender, config().marketGroup());
3325 		_burn(_from, _amount);
3326 		return true;
3327 	}
3328 
3329 	function lock(address _from, address _to, uint256 _amount) private {
3330 		Lockup(config().lockup()).lockup(_from, _to, _amount);
3331 	}
3332 }