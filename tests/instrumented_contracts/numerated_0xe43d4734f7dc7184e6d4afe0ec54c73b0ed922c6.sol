1 // File: @openzeppelin/contracts/GSN/Context.sol
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
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
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
449     /**
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
501 // File: @openzeppelin/contracts/access/Roles.sol
502 
503 pragma solidity ^0.5.0;
504 
505 /**
506  * @title Roles
507  * @dev Library for managing addresses assigned to a Role.
508  */
509 library Roles {
510     struct Role {
511         mapping (address => bool) bearer;
512     }
513 
514     /**
515      * @dev Give an account access to this role.
516      */
517     function add(Role storage role, address account) internal {
518         require(!has(role, account), "Roles: account already has role");
519         role.bearer[account] = true;
520     }
521 
522     /**
523      * @dev Remove an account's access to this role.
524      */
525     function remove(Role storage role, address account) internal {
526         require(has(role, account), "Roles: account does not have role");
527         role.bearer[account] = false;
528     }
529 
530     /**
531      * @dev Check if an account has this role.
532      * @return bool
533      */
534     function has(Role storage role, address account) internal view returns (bool) {
535         require(account != address(0), "Roles: account is the zero address");
536         return role.bearer[account];
537     }
538 }
539 
540 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
541 
542 pragma solidity ^0.5.0;
543 
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
586 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 /**
593  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
594  * which have permission to mint (create) new tokens as they see fit.
595  *
596  * At construction, the deployer of the contract is the only minter.
597  */
598 contract ERC20Mintable is ERC20, MinterRole {
599     /**
600      * @dev See {ERC20-_mint}.
601      *
602      * Requirements:
603      *
604      * - the caller must have the {MinterRole}.
605      */
606     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
607         _mint(account, amount);
608         return true;
609     }
610 }
611 
612 // File: contracts/src/common/libs/Decimals.sol
613 
614 pragma solidity 0.5.17;
615 
616 
617 /**
618  * Library for emulating calculations involving decimals.
619  */
620 library Decimals {
621 	using SafeMath for uint256;
622 	uint120 private constant basisValue = 1000000000000000000;
623 
624 	/**
625 	 * Returns the ratio of the first argument to the second argument.
626 	 */
627 	function outOf(uint256 _a, uint256 _b)
628 		internal
629 		pure
630 		returns (uint256 result)
631 	{
632 		if (_a == 0) {
633 			return 0;
634 		}
635 		uint256 a = _a.mul(basisValue);
636 		if (a < _b) {
637 			return 0;
638 		}
639 		return (a.div(_b));
640 	}
641 
642 	/**
643 	 * Returns multiplied the number by 10^18.
644 	 * This is used when there is a very large difference between the two numbers passed to the `outOf` function.
645 	 */
646 	function mulBasis(uint256 _a) internal pure returns (uint256) {
647 		return _a.mul(basisValue);
648 	}
649 
650 	/**
651 	 * Returns by changing the numerical value being emulated to the original number of digits.
652 	 */
653 	function divBasis(uint256 _a) internal pure returns (uint256) {
654 		return _a.div(basisValue);
655 	}
656 }
657 
658 // File: contracts/src/common/interface/IGroup.sol
659 
660 pragma solidity 0.5.17;
661 
662 contract IGroup {
663 	function isGroup(address _addr) public view returns (bool);
664 
665 	function addGroup(address _addr) external;
666 
667 	function getGroupKey(address _addr) internal pure returns (bytes32) {
668 		return keccak256(abi.encodePacked("_group", _addr));
669 	}
670 }
671 
672 // File: contracts/src/common/validate/AddressValidator.sol
673 
674 pragma solidity 0.5.17;
675 
676 
677 /**
678  * A module that provides common validations patterns.
679  */
680 contract AddressValidator {
681 	string constant errorMessage = "this is illegal address";
682 
683 	/**
684 	 * Validates passed address is not a zero address.
685 	 */
686 	function validateIllegalAddress(address _addr) external pure {
687 		require(_addr != address(0), errorMessage);
688 	}
689 
690 	/**
691 	 * Validates passed address is included in an address set.
692 	 */
693 	function validateGroup(address _addr, address _groupAddr) external view {
694 		require(IGroup(_groupAddr).isGroup(_addr), errorMessage);
695 	}
696 
697 	/**
698 	 * Validates passed address is included in two address sets.
699 	 */
700 	function validateGroups(
701 		address _addr,
702 		address _groupAddr1,
703 		address _groupAddr2
704 	) external view {
705 		if (IGroup(_groupAddr1).isGroup(_addr)) {
706 			return;
707 		}
708 		require(IGroup(_groupAddr2).isGroup(_addr), errorMessage);
709 	}
710 
711 	/**
712 	 * Validates that the address of the first argument is equal to the address of the second argument.
713 	 */
714 	function validateAddress(address _addr, address _target) external pure {
715 		require(_addr == _target, errorMessage);
716 	}
717 
718 	/**
719 	 * Validates passed address equals to the two addresses.
720 	 */
721 	function validateAddresses(
722 		address _addr,
723 		address _target1,
724 		address _target2
725 	) external pure {
726 		if (_addr == _target1) {
727 			return;
728 		}
729 		require(_addr == _target2, errorMessage);
730 	}
731 
732 	/**
733 	 * Validates passed address equals to the three addresses.
734 	 */
735 	function validate3Addresses(
736 		address _addr,
737 		address _target1,
738 		address _target2,
739 		address _target3
740 	) external pure {
741 		if (_addr == _target1) {
742 			return;
743 		}
744 		if (_addr == _target2) {
745 			return;
746 		}
747 		require(_addr == _target3, errorMessage);
748 	}
749 }
750 
751 // File: contracts/src/common/validate/UsingValidator.sol
752 
753 pragma solidity 0.5.17;
754 
755 // prettier-ignore
756 
757 
758 /**
759  * Module for contrast handling AddressValidator.
760  */
761 contract UsingValidator {
762 	AddressValidator private _validator;
763 
764 	/**
765 	 * Create a new AddressValidator contract when initialize.
766 	 */
767 	constructor() public {
768 		_validator = new AddressValidator();
769 	}
770 
771 	/**
772 	 * Returns the set AddressValidator address.
773 	 */
774 	function addressValidator() internal view returns (AddressValidator) {
775 		return _validator;
776 	}
777 }
778 
779 // File: contracts/src/property/IProperty.sol
780 
781 pragma solidity 0.5.17;
782 
783 contract IProperty {
784 	function author() external view returns (address);
785 
786 	function withdraw(address _sender, uint256 _value) external;
787 }
788 
789 // File: contracts/src/common/lifecycle/Killable.sol
790 
791 pragma solidity 0.5.17;
792 
793 /**
794  * A module that allows contracts to self-destruct.
795  */
796 contract Killable {
797 	address payable public _owner;
798 
799 	/**
800 	 * Initialized with the deployer as the owner.
801 	 */
802 	constructor() internal {
803 		_owner = msg.sender;
804 	}
805 
806 	/**
807 	 * Self-destruct the contract.
808 	 * This function can only be executed by the owner.
809 	 */
810 	function kill() public {
811 		require(msg.sender == _owner, "only owner method");
812 		selfdestruct(_owner);
813 	}
814 }
815 
816 // File: @openzeppelin/contracts/ownership/Ownable.sol
817 
818 pragma solidity ^0.5.0;
819 
820 /**
821  * @dev Contract module which provides a basic access control mechanism, where
822  * there is an account (an owner) that can be granted exclusive access to
823  * specific functions.
824  *
825  * This module is used through inheritance. It will make available the modifier
826  * `onlyOwner`, which can be applied to your functions to restrict their use to
827  * the owner.
828  */
829 contract Ownable is Context {
830     address private _owner;
831 
832     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
833 
834     /**
835      * @dev Initializes the contract setting the deployer as the initial owner.
836      */
837     constructor () internal {
838         address msgSender = _msgSender();
839         _owner = msgSender;
840         emit OwnershipTransferred(address(0), msgSender);
841     }
842 
843     /**
844      * @dev Returns the address of the current owner.
845      */
846     function owner() public view returns (address) {
847         return _owner;
848     }
849 
850     /**
851      * @dev Throws if called by any account other than the owner.
852      */
853     modifier onlyOwner() {
854         require(isOwner(), "Ownable: caller is not the owner");
855         _;
856     }
857 
858     /**
859      * @dev Returns true if the caller is the current owner.
860      */
861     function isOwner() public view returns (bool) {
862         return _msgSender() == _owner;
863     }
864 
865     /**
866      * @dev Leaves the contract without owner. It will not be possible to call
867      * `onlyOwner` functions anymore. Can only be called by the current owner.
868      *
869      * NOTE: Renouncing ownership will leave the contract without an owner,
870      * thereby removing any functionality that is only available to the owner.
871      */
872     function renounceOwnership() public onlyOwner {
873         emit OwnershipTransferred(_owner, address(0));
874         _owner = address(0);
875     }
876 
877     /**
878      * @dev Transfers ownership of the contract to a new account (`newOwner`).
879      * Can only be called by the current owner.
880      */
881     function transferOwnership(address newOwner) public onlyOwner {
882         _transferOwnership(newOwner);
883     }
884 
885     /**
886      * @dev Transfers ownership of the contract to a new account (`newOwner`).
887      */
888     function _transferOwnership(address newOwner) internal {
889         require(newOwner != address(0), "Ownable: new owner is the zero address");
890         emit OwnershipTransferred(_owner, newOwner);
891         _owner = newOwner;
892     }
893 }
894 
895 // File: contracts/src/common/config/AddressConfig.sol
896 
897 pragma solidity 0.5.17;
898 
899 
900 
901 
902 /**
903  * A registry contract to hold the latest contract addresses.
904  * Dev Protocol will be upgradeable by this contract.
905  */
906 contract AddressConfig is Ownable, UsingValidator, Killable {
907 	address public token = 0x98626E2C9231f03504273d55f397409deFD4a093;
908 	address public allocator;
909 	address public allocatorStorage;
910 	address public withdraw;
911 	address public withdrawStorage;
912 	address public marketFactory;
913 	address public marketGroup;
914 	address public propertyFactory;
915 	address public propertyGroup;
916 	address public metricsGroup;
917 	address public metricsFactory;
918 	address public policy;
919 	address public policyFactory;
920 	address public policySet;
921 	address public policyGroup;
922 	address public lockup;
923 	address public lockupStorage;
924 	address public voteTimes;
925 	address public voteTimesStorage;
926 	address public voteCounter;
927 	address public voteCounterStorage;
928 
929 	/**
930 	 * Set the latest Allocator contract address.
931 	 * Only the owner can execute this function.
932 	 */
933 	function setAllocator(address _addr) external onlyOwner {
934 		allocator = _addr;
935 	}
936 
937 	/**
938 	 * Set the latest AllocatorStorage contract address.
939 	 * Only the owner can execute this function.
940 	 * NOTE: But currently, the AllocatorStorage contract is not used.
941 	 */
942 	function setAllocatorStorage(address _addr) external onlyOwner {
943 		allocatorStorage = _addr;
944 	}
945 
946 	/**
947 	 * Set the latest Withdraw contract address.
948 	 * Only the owner can execute this function.
949 	 */
950 	function setWithdraw(address _addr) external onlyOwner {
951 		withdraw = _addr;
952 	}
953 
954 	/**
955 	 * Set the latest WithdrawStorage contract address.
956 	 * Only the owner can execute this function.
957 	 */
958 	function setWithdrawStorage(address _addr) external onlyOwner {
959 		withdrawStorage = _addr;
960 	}
961 
962 	/**
963 	 * Set the latest MarketFactory contract address.
964 	 * Only the owner can execute this function.
965 	 */
966 	function setMarketFactory(address _addr) external onlyOwner {
967 		marketFactory = _addr;
968 	}
969 
970 	/**
971 	 * Set the latest MarketGroup contract address.
972 	 * Only the owner can execute this function.
973 	 */
974 	function setMarketGroup(address _addr) external onlyOwner {
975 		marketGroup = _addr;
976 	}
977 
978 	/**
979 	 * Set the latest PropertyFactory contract address.
980 	 * Only the owner can execute this function.
981 	 */
982 	function setPropertyFactory(address _addr) external onlyOwner {
983 		propertyFactory = _addr;
984 	}
985 
986 	/**
987 	 * Set the latest PropertyGroup contract address.
988 	 * Only the owner can execute this function.
989 	 */
990 	function setPropertyGroup(address _addr) external onlyOwner {
991 		propertyGroup = _addr;
992 	}
993 
994 	/**
995 	 * Set the latest MetricsFactory contract address.
996 	 * Only the owner can execute this function.
997 	 */
998 	function setMetricsFactory(address _addr) external onlyOwner {
999 		metricsFactory = _addr;
1000 	}
1001 
1002 	/**
1003 	 * Set the latest MetricsGroup contract address.
1004 	 * Only the owner can execute this function.
1005 	 */
1006 	function setMetricsGroup(address _addr) external onlyOwner {
1007 		metricsGroup = _addr;
1008 	}
1009 
1010 	/**
1011 	 * Set the latest PolicyFactory contract address.
1012 	 * Only the owner can execute this function.
1013 	 */
1014 	function setPolicyFactory(address _addr) external onlyOwner {
1015 		policyFactory = _addr;
1016 	}
1017 
1018 	/**
1019 	 * Set the latest PolicyGroup contract address.
1020 	 * Only the owner can execute this function.
1021 	 */
1022 	function setPolicyGroup(address _addr) external onlyOwner {
1023 		policyGroup = _addr;
1024 	}
1025 
1026 	/**
1027 	 * Set the latest PolicySet contract address.
1028 	 * Only the owner can execute this function.
1029 	 */
1030 	function setPolicySet(address _addr) external onlyOwner {
1031 		policySet = _addr;
1032 	}
1033 
1034 	/**
1035 	 * Set the latest Policy contract address.
1036 	 * Only the latest PolicyFactory contract can execute this function.
1037 	 */
1038 	function setPolicy(address _addr) external {
1039 		addressValidator().validateAddress(msg.sender, policyFactory);
1040 		policy = _addr;
1041 	}
1042 
1043 	/**
1044 	 * Set the latest Dev contract address.
1045 	 * Only the owner can execute this function.
1046 	 */
1047 	function setToken(address _addr) external onlyOwner {
1048 		token = _addr;
1049 	}
1050 
1051 	/**
1052 	 * Set the latest Lockup contract address.
1053 	 * Only the owner can execute this function.
1054 	 */
1055 	function setLockup(address _addr) external onlyOwner {
1056 		lockup = _addr;
1057 	}
1058 
1059 	/**
1060 	 * Set the latest LockupStorage contract address.
1061 	 * Only the owner can execute this function.
1062 	 * NOTE: But currently, the LockupStorage contract is not used as a stand-alone because it is inherited from the Lockup contract.
1063 	 */
1064 	function setLockupStorage(address _addr) external onlyOwner {
1065 		lockupStorage = _addr;
1066 	}
1067 
1068 	/**
1069 	 * Set the latest VoteTimes contract address.
1070 	 * Only the owner can execute this function.
1071 	 * NOTE: But currently, the VoteTimes contract is not used.
1072 	 */
1073 	function setVoteTimes(address _addr) external onlyOwner {
1074 		voteTimes = _addr;
1075 	}
1076 
1077 	/**
1078 	 * Set the latest VoteTimesStorage contract address.
1079 	 * Only the owner can execute this function.
1080 	 * NOTE: But currently, the VoteTimesStorage contract is not used.
1081 	 */
1082 	function setVoteTimesStorage(address _addr) external onlyOwner {
1083 		voteTimesStorage = _addr;
1084 	}
1085 
1086 	/**
1087 	 * Set the latest VoteCounter contract address.
1088 	 * Only the owner can execute this function.
1089 	 */
1090 	function setVoteCounter(address _addr) external onlyOwner {
1091 		voteCounter = _addr;
1092 	}
1093 
1094 	/**
1095 	 * Set the latest VoteCounterStorage contract address.
1096 	 * Only the owner can execute this function.
1097 	 * NOTE: But currently, the VoteCounterStorage contract is not used as a stand-alone because it is inherited from the VoteCounter contract.
1098 	 */
1099 	function setVoteCounterStorage(address _addr) external onlyOwner {
1100 		voteCounterStorage = _addr;
1101 	}
1102 }
1103 
1104 // File: contracts/src/common/config/UsingConfig.sol
1105 
1106 pragma solidity 0.5.17;
1107 
1108 
1109 /**
1110  * Module for using AddressConfig contracts.
1111  */
1112 contract UsingConfig {
1113 	AddressConfig private _config;
1114 
1115 	/**
1116 	 * Initialize the argument as AddressConfig address.
1117 	 */
1118 	constructor(address _addressConfig) public {
1119 		_config = AddressConfig(_addressConfig);
1120 	}
1121 
1122 	/**
1123 	 * Returns the latest AddressConfig instance.
1124 	 */
1125 	function config() internal view returns (AddressConfig) {
1126 		return _config;
1127 	}
1128 
1129 	/**
1130 	 * Returns the latest AddressConfig address.
1131 	 */
1132 	function configAddress() external view returns (address) {
1133 		return address(_config);
1134 	}
1135 }
1136 
1137 // File: contracts/src/common/storage/EternalStorage.sol
1138 
1139 pragma solidity 0.5.17;
1140 
1141 /**
1142  * Module for persisting states.
1143  * Stores a map for `uint256`, `string`, `address`, `bytes32`, `bool`, and `int256` type with `bytes32` type as a key.
1144  */
1145 contract EternalStorage {
1146 	address private currentOwner = msg.sender;
1147 
1148 	mapping(bytes32 => uint256) private uIntStorage;
1149 	mapping(bytes32 => string) private stringStorage;
1150 	mapping(bytes32 => address) private addressStorage;
1151 	mapping(bytes32 => bytes32) private bytesStorage;
1152 	mapping(bytes32 => bool) private boolStorage;
1153 	mapping(bytes32 => int256) private intStorage;
1154 
1155 	/**
1156 	 * Modifiers to validate that only the owner can execute.
1157 	 */
1158 	modifier onlyCurrentOwner() {
1159 		require(msg.sender == currentOwner, "not current owner");
1160 		_;
1161 	}
1162 
1163 	/**
1164 	 * Transfer the owner.
1165 	 * Only the owner can execute this function.
1166 	 */
1167 	function changeOwner(address _newOwner) external {
1168 		require(msg.sender == currentOwner, "not current owner");
1169 		currentOwner = _newOwner;
1170 	}
1171 
1172 	// *** Getter Methods ***
1173 
1174 	/**
1175 	 * Returns the value of the `uint256` type that mapped to the given key.
1176 	 */
1177 	function getUint(bytes32 _key) external view returns (uint256) {
1178 		return uIntStorage[_key];
1179 	}
1180 
1181 	/**
1182 	 * Returns the value of the `string` type that mapped to the given key.
1183 	 */
1184 	function getString(bytes32 _key) external view returns (string memory) {
1185 		return stringStorage[_key];
1186 	}
1187 
1188 	/**
1189 	 * Returns the value of the `address` type that mapped to the given key.
1190 	 */
1191 	function getAddress(bytes32 _key) external view returns (address) {
1192 		return addressStorage[_key];
1193 	}
1194 
1195 	/**
1196 	 * Returns the value of the `bytes32` type that mapped to the given key.
1197 	 */
1198 	function getBytes(bytes32 _key) external view returns (bytes32) {
1199 		return bytesStorage[_key];
1200 	}
1201 
1202 	/**
1203 	 * Returns the value of the `bool` type that mapped to the given key.
1204 	 */
1205 	function getBool(bytes32 _key) external view returns (bool) {
1206 		return boolStorage[_key];
1207 	}
1208 
1209 	/**
1210 	 * Returns the value of the `int256` type that mapped to the given key.
1211 	 */
1212 	function getInt(bytes32 _key) external view returns (int256) {
1213 		return intStorage[_key];
1214 	}
1215 
1216 	// *** Setter Methods ***
1217 
1218 	/**
1219 	 * Maps a value of `uint256` type to a given key.
1220 	 * Only the owner can execute this function.
1221 	 */
1222 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
1223 		uIntStorage[_key] = _value;
1224 	}
1225 
1226 	/**
1227 	 * Maps a value of `string` type to a given key.
1228 	 * Only the owner can execute this function.
1229 	 */
1230 	function setString(bytes32 _key, string calldata _value)
1231 		external
1232 		onlyCurrentOwner
1233 	{
1234 		stringStorage[_key] = _value;
1235 	}
1236 
1237 	/**
1238 	 * Maps a value of `address` type to a given key.
1239 	 * Only the owner can execute this function.
1240 	 */
1241 	function setAddress(bytes32 _key, address _value)
1242 		external
1243 		onlyCurrentOwner
1244 	{
1245 		addressStorage[_key] = _value;
1246 	}
1247 
1248 	/**
1249 	 * Maps a value of `bytes32` type to a given key.
1250 	 * Only the owner can execute this function.
1251 	 */
1252 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
1253 		bytesStorage[_key] = _value;
1254 	}
1255 
1256 	/**
1257 	 * Maps a value of `bool` type to a given key.
1258 	 * Only the owner can execute this function.
1259 	 */
1260 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
1261 		boolStorage[_key] = _value;
1262 	}
1263 
1264 	/**
1265 	 * Maps a value of `int256` type to a given key.
1266 	 * Only the owner can execute this function.
1267 	 */
1268 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
1269 		intStorage[_key] = _value;
1270 	}
1271 
1272 	// *** Delete Methods ***
1273 
1274 	/**
1275 	 * Deletes the value of the `uint256` type that mapped to the given key.
1276 	 * Only the owner can execute this function.
1277 	 */
1278 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
1279 		delete uIntStorage[_key];
1280 	}
1281 
1282 	/**
1283 	 * Deletes the value of the `string` type that mapped to the given key.
1284 	 * Only the owner can execute this function.
1285 	 */
1286 	function deleteString(bytes32 _key) external onlyCurrentOwner {
1287 		delete stringStorage[_key];
1288 	}
1289 
1290 	/**
1291 	 * Deletes the value of the `address` type that mapped to the given key.
1292 	 * Only the owner can execute this function.
1293 	 */
1294 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
1295 		delete addressStorage[_key];
1296 	}
1297 
1298 	/**
1299 	 * Deletes the value of the `bytes32` type that mapped to the given key.
1300 	 * Only the owner can execute this function.
1301 	 */
1302 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
1303 		delete bytesStorage[_key];
1304 	}
1305 
1306 	/**
1307 	 * Deletes the value of the `bool` type that mapped to the given key.
1308 	 * Only the owner can execute this function.
1309 	 */
1310 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
1311 		delete boolStorage[_key];
1312 	}
1313 
1314 	/**
1315 	 * Deletes the value of the `int256` type that mapped to the given key.
1316 	 * Only the owner can execute this function.
1317 	 */
1318 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
1319 		delete intStorage[_key];
1320 	}
1321 }
1322 
1323 // File: contracts/src/common/storage/UsingStorage.sol
1324 
1325 pragma solidity 0.5.17;
1326 
1327 
1328 
1329 /**
1330  * Module for contrast handling EternalStorage.
1331  */
1332 contract UsingStorage is Ownable {
1333 	address private _storage;
1334 
1335 	/**
1336 	 * Modifier to verify that EternalStorage is set.
1337 	 */
1338 	modifier hasStorage() {
1339 		require(_storage != address(0), "storage is not set");
1340 		_;
1341 	}
1342 
1343 	/**
1344 	 * Returns the set EternalStorage instance.
1345 	 */
1346 	function eternalStorage()
1347 		internal
1348 		view
1349 		hasStorage
1350 		returns (EternalStorage)
1351 	{
1352 		return EternalStorage(_storage);
1353 	}
1354 
1355 	/**
1356 	 * Returns the set EternalStorage address.
1357 	 */
1358 	function getStorageAddress() external view hasStorage returns (address) {
1359 		return _storage;
1360 	}
1361 
1362 	/**
1363 	 * Create a new EternalStorage contract.
1364 	 * This function call will fail if the EternalStorage contract is already set.
1365 	 * Also, only the owner can execute it.
1366 	 */
1367 	function createStorage() external onlyOwner {
1368 		require(_storage == address(0), "storage is set");
1369 		EternalStorage tmp = new EternalStorage();
1370 		_storage = address(tmp);
1371 	}
1372 
1373 	/**
1374 	 * Assigns the EternalStorage contract that has already been created.
1375 	 * Only the owner can execute this function.
1376 	 */
1377 	function setStorage(address _storageAddress) external onlyOwner {
1378 		_storage = _storageAddress;
1379 	}
1380 
1381 	/**
1382 	 * Delegates the owner of the current EternalStorage contract.
1383 	 * Only the owner can execute this function.
1384 	 */
1385 	function changeOwner(address newOwner) external onlyOwner {
1386 		EternalStorage(_storage).changeOwner(newOwner);
1387 	}
1388 }
1389 
1390 // File: contracts/src/lockup/LockupStorage.sol
1391 
1392 pragma solidity 0.5.17;
1393 
1394 
1395 
1396 contract LockupStorage is UsingStorage {
1397 	using SafeMath for uint256;
1398 
1399 	uint256 public constant basis = 100000000000000000000000000000000;
1400 
1401 	//AllValue
1402 	function setStorageAllValue(uint256 _value) internal {
1403 		bytes32 key = getStorageAllValueKey();
1404 		eternalStorage().setUint(key, _value);
1405 	}
1406 
1407 	function getStorageAllValue() public view returns (uint256) {
1408 		bytes32 key = getStorageAllValueKey();
1409 		return eternalStorage().getUint(key);
1410 	}
1411 
1412 	function getStorageAllValueKey() private pure returns (bytes32) {
1413 		return keccak256(abi.encodePacked("_allValue"));
1414 	}
1415 
1416 	//Value
1417 	function setStorageValue(
1418 		address _property,
1419 		address _sender,
1420 		uint256 _value
1421 	) internal {
1422 		bytes32 key = getStorageValueKey(_property, _sender);
1423 		eternalStorage().setUint(key, _value);
1424 	}
1425 
1426 	function getStorageValue(address _property, address _sender)
1427 		public
1428 		view
1429 		returns (uint256)
1430 	{
1431 		bytes32 key = getStorageValueKey(_property, _sender);
1432 		return eternalStorage().getUint(key);
1433 	}
1434 
1435 	function getStorageValueKey(address _property, address _sender)
1436 		private
1437 		pure
1438 		returns (bytes32)
1439 	{
1440 		return keccak256(abi.encodePacked("_value", _property, _sender));
1441 	}
1442 
1443 	//PropertyValue
1444 	function setStoragePropertyValue(address _property, uint256 _value)
1445 		internal
1446 	{
1447 		bytes32 key = getStoragePropertyValueKey(_property);
1448 		eternalStorage().setUint(key, _value);
1449 	}
1450 
1451 	function getStoragePropertyValue(address _property)
1452 		public
1453 		view
1454 		returns (uint256)
1455 	{
1456 		bytes32 key = getStoragePropertyValueKey(_property);
1457 		return eternalStorage().getUint(key);
1458 	}
1459 
1460 	function getStoragePropertyValueKey(address _property)
1461 		private
1462 		pure
1463 		returns (bytes32)
1464 	{
1465 		return keccak256(abi.encodePacked("_propertyValue", _property));
1466 	}
1467 
1468 	//WithdrawalStatus
1469 	function setStorageWithdrawalStatus(
1470 		address _property,
1471 		address _from,
1472 		uint256 _value
1473 	) internal {
1474 		bytes32 key = getStorageWithdrawalStatusKey(_property, _from);
1475 		eternalStorage().setUint(key, _value);
1476 	}
1477 
1478 	function getStorageWithdrawalStatus(address _property, address _from)
1479 		public
1480 		view
1481 		returns (uint256)
1482 	{
1483 		bytes32 key = getStorageWithdrawalStatusKey(_property, _from);
1484 		return eternalStorage().getUint(key);
1485 	}
1486 
1487 	function getStorageWithdrawalStatusKey(address _property, address _sender)
1488 		private
1489 		pure
1490 		returns (bytes32)
1491 	{
1492 		return
1493 			keccak256(
1494 				abi.encodePacked("_withdrawalStatus", _property, _sender)
1495 			);
1496 	}
1497 
1498 	//InterestPrice
1499 	function setStorageInterestPrice(address _property, uint256 _value)
1500 		internal
1501 	{
1502 		// The previously used function
1503 		// This function is only used in testing
1504 		eternalStorage().setUint(getStorageInterestPriceKey(_property), _value);
1505 	}
1506 
1507 	function getStorageInterestPrice(address _property)
1508 		public
1509 		view
1510 		returns (uint256)
1511 	{
1512 		return eternalStorage().getUint(getStorageInterestPriceKey(_property));
1513 	}
1514 
1515 	function getStorageInterestPriceKey(address _property)
1516 		private
1517 		pure
1518 		returns (bytes32)
1519 	{
1520 		return keccak256(abi.encodePacked("_interestTotals", _property));
1521 	}
1522 
1523 	//LastInterestPrice
1524 	function setStorageLastInterestPrice(
1525 		address _property,
1526 		address _user,
1527 		uint256 _value
1528 	) internal {
1529 		eternalStorage().setUint(
1530 			getStorageLastInterestPriceKey(_property, _user),
1531 			_value
1532 		);
1533 	}
1534 
1535 	function getStorageLastInterestPrice(address _property, address _user)
1536 		public
1537 		view
1538 		returns (uint256)
1539 	{
1540 		return
1541 			eternalStorage().getUint(
1542 				getStorageLastInterestPriceKey(_property, _user)
1543 			);
1544 	}
1545 
1546 	function getStorageLastInterestPriceKey(address _property, address _user)
1547 		private
1548 		pure
1549 		returns (bytes32)
1550 	{
1551 		return
1552 			keccak256(
1553 				abi.encodePacked("_lastLastInterestPrice", _property, _user)
1554 			);
1555 	}
1556 
1557 	//LastSameRewardsAmountAndBlock
1558 	function setStorageLastSameRewardsAmountAndBlock(
1559 		uint256 _amount,
1560 		uint256 _block
1561 	) internal {
1562 		uint256 record = _amount.mul(basis).add(_block);
1563 		eternalStorage().setUint(
1564 			getStorageLastSameRewardsAmountAndBlockKey(),
1565 			record
1566 		);
1567 	}
1568 
1569 	function getStorageLastSameRewardsAmountAndBlock()
1570 		public
1571 		view
1572 		returns (uint256 _amount, uint256 _block)
1573 	{
1574 		uint256 record = eternalStorage().getUint(
1575 			getStorageLastSameRewardsAmountAndBlockKey()
1576 		);
1577 		uint256 amount = record.div(basis);
1578 		uint256 blockNumber = record.sub(amount.mul(basis));
1579 		return (amount, blockNumber);
1580 	}
1581 
1582 	function getStorageLastSameRewardsAmountAndBlockKey()
1583 		private
1584 		pure
1585 		returns (bytes32)
1586 	{
1587 		return keccak256(abi.encodePacked("_LastSameRewardsAmountAndBlock"));
1588 	}
1589 
1590 	//CumulativeGlobalRewards
1591 	function setStorageCumulativeGlobalRewards(uint256 _value) internal {
1592 		eternalStorage().setUint(
1593 			getStorageCumulativeGlobalRewardsKey(),
1594 			_value
1595 		);
1596 	}
1597 
1598 	function getStorageCumulativeGlobalRewards() public view returns (uint256) {
1599 		return eternalStorage().getUint(getStorageCumulativeGlobalRewardsKey());
1600 	}
1601 
1602 	function getStorageCumulativeGlobalRewardsKey()
1603 		private
1604 		pure
1605 		returns (bytes32)
1606 	{
1607 		return keccak256(abi.encodePacked("_cumulativeGlobalRewards"));
1608 	}
1609 
1610 	//LastCumulativeGlobalReward
1611 	function setStorageLastCumulativeGlobalReward(
1612 		address _property,
1613 		address _user,
1614 		uint256 _value
1615 	) internal {
1616 		eternalStorage().setUint(
1617 			getStorageLastCumulativeGlobalRewardKey(_property, _user),
1618 			_value
1619 		);
1620 	}
1621 
1622 	function getStorageLastCumulativeGlobalReward(
1623 		address _property,
1624 		address _user
1625 	) public view returns (uint256) {
1626 		return
1627 			eternalStorage().getUint(
1628 				getStorageLastCumulativeGlobalRewardKey(_property, _user)
1629 			);
1630 	}
1631 
1632 	function getStorageLastCumulativeGlobalRewardKey(
1633 		address _property,
1634 		address _user
1635 	) private pure returns (bytes32) {
1636 		return
1637 			keccak256(
1638 				abi.encodePacked(
1639 					"_LastCumulativeGlobalReward",
1640 					_property,
1641 					_user
1642 				)
1643 			);
1644 	}
1645 
1646 	//LastCumulativePropertyInterest
1647 	function setStorageLastCumulativePropertyInterest(
1648 		address _property,
1649 		address _user,
1650 		uint256 _value
1651 	) internal {
1652 		eternalStorage().setUint(
1653 			getStorageLastCumulativePropertyInterestKey(_property, _user),
1654 			_value
1655 		);
1656 	}
1657 
1658 	function getStorageLastCumulativePropertyInterest(
1659 		address _property,
1660 		address _user
1661 	) public view returns (uint256) {
1662 		return
1663 			eternalStorage().getUint(
1664 				getStorageLastCumulativePropertyInterestKey(_property, _user)
1665 			);
1666 	}
1667 
1668 	function getStorageLastCumulativePropertyInterestKey(
1669 		address _property,
1670 		address _user
1671 	) private pure returns (bytes32) {
1672 		return
1673 			keccak256(
1674 				abi.encodePacked(
1675 					"_lastCumulativePropertyInterest",
1676 					_property,
1677 					_user
1678 				)
1679 			);
1680 	}
1681 
1682 	//CumulativeLockedUpUnitAndBlock
1683 	function setStorageCumulativeLockedUpUnitAndBlock(
1684 		address _addr,
1685 		uint256 _unit,
1686 		uint256 _block
1687 	) internal {
1688 		uint256 record = _unit.mul(basis).add(_block);
1689 		eternalStorage().setUint(
1690 			getStorageCumulativeLockedUpUnitAndBlockKey(_addr),
1691 			record
1692 		);
1693 	}
1694 
1695 	function getStorageCumulativeLockedUpUnitAndBlock(address _addr)
1696 		public
1697 		view
1698 		returns (uint256 _unit, uint256 _block)
1699 	{
1700 		uint256 record = eternalStorage().getUint(
1701 			getStorageCumulativeLockedUpUnitAndBlockKey(_addr)
1702 		);
1703 		uint256 unit = record.div(basis);
1704 		uint256 blockNumber = record.sub(unit.mul(basis));
1705 		return (unit, blockNumber);
1706 	}
1707 
1708 	function getStorageCumulativeLockedUpUnitAndBlockKey(address _addr)
1709 		private
1710 		pure
1711 		returns (bytes32)
1712 	{
1713 		return
1714 			keccak256(
1715 				abi.encodePacked("_cumulativeLockedUpUnitAndBlock", _addr)
1716 			);
1717 	}
1718 
1719 	//CumulativeLockedUpValue
1720 	function setStorageCumulativeLockedUpValue(address _addr, uint256 _value)
1721 		internal
1722 	{
1723 		eternalStorage().setUint(
1724 			getStorageCumulativeLockedUpValueKey(_addr),
1725 			_value
1726 		);
1727 	}
1728 
1729 	function getStorageCumulativeLockedUpValue(address _addr)
1730 		public
1731 		view
1732 		returns (uint256)
1733 	{
1734 		return
1735 			eternalStorage().getUint(
1736 				getStorageCumulativeLockedUpValueKey(_addr)
1737 			);
1738 	}
1739 
1740 	function getStorageCumulativeLockedUpValueKey(address _addr)
1741 		private
1742 		pure
1743 		returns (bytes32)
1744 	{
1745 		return keccak256(abi.encodePacked("_cumulativeLockedUpValue", _addr));
1746 	}
1747 
1748 	//PendingWithdrawal
1749 	function setStoragePendingInterestWithdrawal(
1750 		address _property,
1751 		address _user,
1752 		uint256 _value
1753 	) internal {
1754 		eternalStorage().setUint(
1755 			getStoragePendingInterestWithdrawalKey(_property, _user),
1756 			_value
1757 		);
1758 	}
1759 
1760 	function getStoragePendingInterestWithdrawal(
1761 		address _property,
1762 		address _user
1763 	) public view returns (uint256) {
1764 		return
1765 			eternalStorage().getUint(
1766 				getStoragePendingInterestWithdrawalKey(_property, _user)
1767 			);
1768 	}
1769 
1770 	function getStoragePendingInterestWithdrawalKey(
1771 		address _property,
1772 		address _user
1773 	) private pure returns (bytes32) {
1774 		return
1775 			keccak256(
1776 				abi.encodePacked("_pendingInterestWithdrawal", _property, _user)
1777 			);
1778 	}
1779 
1780 	//DIP4GenesisBlock
1781 	function setStorageDIP4GenesisBlock(uint256 _block) internal {
1782 		eternalStorage().setUint(getStorageDIP4GenesisBlockKey(), _block);
1783 	}
1784 
1785 	function getStorageDIP4GenesisBlock() public view returns (uint256) {
1786 		return eternalStorage().getUint(getStorageDIP4GenesisBlockKey());
1787 	}
1788 
1789 	function getStorageDIP4GenesisBlockKey() private pure returns (bytes32) {
1790 		return keccak256(abi.encodePacked("_dip4GenesisBlock"));
1791 	}
1792 
1793 	//LastCumulativeLockedUpAndBlock
1794 	function setStorageLastCumulativeLockedUpAndBlock(
1795 		address _property,
1796 		address _user,
1797 		uint256 _cLocked,
1798 		uint256 _block
1799 	) internal {
1800 		uint256 record = _cLocked.mul(basis).add(_block);
1801 		eternalStorage().setUint(
1802 			getStorageLastCumulativeLockedUpAndBlockKey(_property, _user),
1803 			record
1804 		);
1805 	}
1806 
1807 	function getStorageLastCumulativeLockedUpAndBlock(
1808 		address _property,
1809 		address _user
1810 	) public view returns (uint256 _cLocked, uint256 _block) {
1811 		uint256 record = eternalStorage().getUint(
1812 			getStorageLastCumulativeLockedUpAndBlockKey(_property, _user)
1813 		);
1814 		uint256 cLocked = record.div(basis);
1815 		uint256 blockNumber = record.sub(cLocked.mul(basis));
1816 
1817 		return (cLocked, blockNumber);
1818 	}
1819 
1820 	function getStorageLastCumulativeLockedUpAndBlockKey(
1821 		address _property,
1822 		address _user
1823 	) private pure returns (bytes32) {
1824 		return
1825 			keccak256(
1826 				abi.encodePacked(
1827 					"_lastCumulativeLockedUpAndBlock",
1828 					_property,
1829 					_user
1830 				)
1831 			);
1832 	}
1833 
1834 	//lastStakedInterestPrice
1835 	function setStorageLastStakedInterestPrice(
1836 		address _property,
1837 		address _user,
1838 		uint256 _value
1839 	) internal {
1840 		eternalStorage().setUint(
1841 			getStorageLastStakedInterestPriceKey(_property, _user),
1842 			_value
1843 		);
1844 	}
1845 
1846 	function getStorageLastStakedInterestPrice(address _property, address _user)
1847 		public
1848 		view
1849 		returns (uint256)
1850 	{
1851 		return
1852 			eternalStorage().getUint(
1853 				getStorageLastStakedInterestPriceKey(_property, _user)
1854 			);
1855 	}
1856 
1857 	function getStorageLastStakedInterestPriceKey(
1858 		address _property,
1859 		address _user
1860 	) private pure returns (bytes32) {
1861 		return
1862 			keccak256(
1863 				abi.encodePacked("_lastStakedInterestPrice", _property, _user)
1864 			);
1865 	}
1866 
1867 	//lastStakesChangedCumulativeReward
1868 	function setStorageLastStakesChangedCumulativeReward(uint256 _value)
1869 		internal
1870 	{
1871 		eternalStorage().setUint(
1872 			getStorageLastStakesChangedCumulativeRewardKey(),
1873 			_value
1874 		);
1875 	}
1876 
1877 	function getStorageLastStakesChangedCumulativeReward()
1878 		public
1879 		view
1880 		returns (uint256)
1881 	{
1882 		return
1883 			eternalStorage().getUint(
1884 				getStorageLastStakesChangedCumulativeRewardKey()
1885 			);
1886 	}
1887 
1888 	function getStorageLastStakesChangedCumulativeRewardKey()
1889 		private
1890 		pure
1891 		returns (bytes32)
1892 	{
1893 		return
1894 			keccak256(abi.encodePacked("_lastStakesChangedCumulativeReward"));
1895 	}
1896 
1897 	//LastCumulativeHoldersRewardPrice
1898 	function setStorageLastCumulativeHoldersRewardPrice(uint256 _holders)
1899 		internal
1900 	{
1901 		eternalStorage().setUint(
1902 			getStorageLastCumulativeHoldersRewardPriceKey(),
1903 			_holders
1904 		);
1905 	}
1906 
1907 	function getStorageLastCumulativeHoldersRewardPrice()
1908 		public
1909 		view
1910 		returns (uint256)
1911 	{
1912 		return
1913 			eternalStorage().getUint(
1914 				getStorageLastCumulativeHoldersRewardPriceKey()
1915 			);
1916 	}
1917 
1918 	function getStorageLastCumulativeHoldersRewardPriceKey()
1919 		private
1920 		pure
1921 		returns (bytes32)
1922 	{
1923 		return keccak256(abi.encodePacked("0lastCumulativeHoldersRewardPrice"));
1924 	}
1925 
1926 	//LastCumulativeInterestPrice
1927 	function setStorageLastCumulativeInterestPrice(uint256 _interest) internal {
1928 		eternalStorage().setUint(
1929 			getStorageLastCumulativeInterestPriceKey(),
1930 			_interest
1931 		);
1932 	}
1933 
1934 	function getStorageLastCumulativeInterestPrice()
1935 		public
1936 		view
1937 		returns (uint256)
1938 	{
1939 		return
1940 			eternalStorage().getUint(
1941 				getStorageLastCumulativeInterestPriceKey()
1942 			);
1943 	}
1944 
1945 	function getStorageLastCumulativeInterestPriceKey()
1946 		private
1947 		pure
1948 		returns (bytes32)
1949 	{
1950 		return keccak256(abi.encodePacked("0lastCumulativeInterestPrice"));
1951 	}
1952 
1953 	//LastCumulativeHoldersRewardAmountPerProperty
1954 	function setStorageLastCumulativeHoldersRewardAmountPerProperty(
1955 		address _property,
1956 		uint256 _value
1957 	) internal {
1958 		eternalStorage().setUint(
1959 			getStorageLastCumulativeHoldersRewardAmountPerPropertyKey(
1960 				_property
1961 			),
1962 			_value
1963 		);
1964 	}
1965 
1966 	function getStorageLastCumulativeHoldersRewardAmountPerProperty(
1967 		address _property
1968 	) public view returns (uint256) {
1969 		return
1970 			eternalStorage().getUint(
1971 				getStorageLastCumulativeHoldersRewardAmountPerPropertyKey(
1972 					_property
1973 				)
1974 			);
1975 	}
1976 
1977 	function getStorageLastCumulativeHoldersRewardAmountPerPropertyKey(
1978 		address _property
1979 	) private pure returns (bytes32) {
1980 		return
1981 			keccak256(
1982 				abi.encodePacked(
1983 					"0lastCumulativeHoldersRewardAmountPerProperty",
1984 					_property
1985 				)
1986 			);
1987 	}
1988 
1989 	//LastCumulativeHoldersRewardPricePerProperty
1990 	function setStorageLastCumulativeHoldersRewardPricePerProperty(
1991 		address _property,
1992 		uint256 _price
1993 	) internal {
1994 		eternalStorage().setUint(
1995 			getStorageLastCumulativeHoldersRewardPricePerPropertyKey(_property),
1996 			_price
1997 		);
1998 	}
1999 
2000 	function getStorageLastCumulativeHoldersRewardPricePerProperty(
2001 		address _property
2002 	) public view returns (uint256) {
2003 		return
2004 			eternalStorage().getUint(
2005 				getStorageLastCumulativeHoldersRewardPricePerPropertyKey(
2006 					_property
2007 				)
2008 			);
2009 	}
2010 
2011 	function getStorageLastCumulativeHoldersRewardPricePerPropertyKey(
2012 		address _property
2013 	) private pure returns (bytes32) {
2014 		return
2015 			keccak256(
2016 				abi.encodePacked(
2017 					"0lastCumulativeHoldersRewardPricePerProperty",
2018 					_property
2019 				)
2020 			);
2021 	}
2022 }
2023 
2024 // File: contracts/src/policy/IPolicy.sol
2025 
2026 pragma solidity 0.5.17;
2027 
2028 contract IPolicy {
2029 	function rewards(uint256 _lockups, uint256 _assets)
2030 		external
2031 		view
2032 		returns (uint256);
2033 
2034 	function holdersShare(uint256 _amount, uint256 _lockups)
2035 		external
2036 		view
2037 		returns (uint256);
2038 
2039 	function assetValue(uint256 _value, uint256 _lockups)
2040 		external
2041 		view
2042 		returns (uint256);
2043 
2044 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
2045 		external
2046 		view
2047 		returns (uint256);
2048 
2049 	function marketApproval(uint256 _agree, uint256 _opposite)
2050 		external
2051 		view
2052 		returns (bool);
2053 
2054 	function policyApproval(uint256 _agree, uint256 _opposite)
2055 		external
2056 		view
2057 		returns (bool);
2058 
2059 	function marketVotingBlocks() external view returns (uint256);
2060 
2061 	function policyVotingBlocks() external view returns (uint256);
2062 
2063 	function abstentionPenalty(uint256 _count) external view returns (uint256);
2064 
2065 	function lockUpBlocks() external view returns (uint256);
2066 }
2067 
2068 // File: contracts/src/allocator/IAllocator.sol
2069 
2070 pragma solidity 0.5.17;
2071 
2072 contract IAllocator {
2073 	function calculateMaxRewardsPerBlock() public view returns (uint256);
2074 
2075 	function beforeBalanceChange(
2076 		address _property,
2077 		address _from,
2078 		address _to
2079 		// solium-disable-next-line indentation
2080 	) external;
2081 }
2082 
2083 // File: contracts/src/lockup/ILegacyLockup.sol
2084 
2085 pragma solidity 0.5.17;
2086 
2087 contract ILegacyLockup {
2088 	function lockup(
2089 		address _from,
2090 		address _property,
2091 		uint256 _value
2092 		// solium-disable-next-line indentation
2093 	) external;
2094 
2095 	function update() public;
2096 
2097 	function cancel(address _property) external;
2098 
2099 	function withdraw(address _property) external;
2100 
2101 	function difference(address _property, uint256 _lastReward)
2102 		public
2103 		view
2104 		returns (
2105 			uint256 _reward,
2106 			uint256 _holdersAmount,
2107 			uint256 _holdersPrice,
2108 			uint256 _interestAmount,
2109 			uint256 _interestPrice
2110 		);
2111 
2112 	function getPropertyValue(address _property)
2113 		external
2114 		view
2115 		returns (uint256);
2116 
2117 	function getAllValue() external view returns (uint256);
2118 
2119 	function getValue(address _property, address _sender)
2120 		external
2121 		view
2122 		returns (uint256);
2123 
2124 	function calculateWithdrawableInterestAmount(
2125 		address _property,
2126 		address _user
2127 	)
2128 		public
2129 		view
2130 		returns (
2131 			// solium-disable-next-line indentation
2132 			uint256
2133 		);
2134 
2135 	function withdrawInterest(address _property) external;
2136 }
2137 
2138 // File: contracts/src/metrics/IMetricsGroup.sol
2139 
2140 pragma solidity 0.5.17;
2141 
2142 
2143 contract IMetricsGroup is IGroup {
2144 	function removeGroup(address _addr) external;
2145 
2146 	function totalIssuedMetrics() external view returns (uint256);
2147 
2148 	function getMetricsCountPerProperty(address _property)
2149 		public
2150 		view
2151 		returns (uint256);
2152 
2153 	function hasAssets(address _property) public view returns (bool);
2154 }
2155 
2156 // File: contracts/src/lockup/LegacyLockup.sol
2157 
2158 pragma solidity 0.5.17;
2159 
2160 // prettier-ignore
2161 
2162 
2163 
2164 
2165 
2166 
2167 
2168 
2169 
2170 
2171 
2172 
2173 /**
2174  * A contract that manages the staking of DEV tokens and calculates rewards.
2175  * Staking and the following mechanism determines that reward calculation.
2176  *
2177  * Variables:
2178  * -`M`: Maximum mint amount per block determined by Allocator contract
2179  * -`B`: Number of blocks during staking
2180  * -`P`: Total number of staking locked up in a Property contract
2181  * -`S`: Total number of staking locked up in all Property contracts
2182  * -`U`: Number of staking per account locked up in a Property contract
2183  *
2184  * Formula:
2185  * Staking Rewards = M * B * (P / S) * (U / P)
2186  *
2187  * Note:
2188  * -`M`, `P` and `S` vary from block to block, and the variation cannot be predicted.
2189  * -`B` is added every time the Ethereum block is created.
2190  * - Only `U` and `B` are predictable variables.
2191  * - As `M`, `P` and `S` cannot be observed from a staker, the "cumulative sum" is often used to calculate ratio variation with history.
2192  * - Reward withdrawal always withdraws the total withdrawable amount.
2193  *
2194  * Scenario:
2195  * - Assume `M` is fixed at 500
2196  * - Alice stakes 100 DEV on Property-A (Alice's staking state on Property-A: `M`=500, `B`=0, `P`=100, `S`=100, `U`=100)
2197  * - After 10 blocks, Bob stakes 60 DEV on Property-B (Alice's staking state on Property-A: `M`=500, `B`=10, `P`=100, `S`=160, `U`=100)
2198  * - After 10 blocks, Carol stakes 40 DEV on Property-A (Alice's staking state on Property-A: `M`=500, `B`=20, `P`=140, `S`=200, `U`=100)
2199  * - After 10 blocks, Alice withdraws Property-A staking reward. The reward at this time is 5000 DEV (10 blocks * 500 DEV) + 3125 DEV (10 blocks * 62.5% * 500 DEV) + 2500 DEV (10 blocks * 50% * 500 DEV).
2200  */
2201 contract LegacyLockup is
2202 	ILegacyLockup,
2203 	UsingConfig,
2204 	UsingValidator,
2205 	LockupStorage
2206 {
2207 	using SafeMath for uint256;
2208 	using Decimals for uint256;
2209 	event Lockedup(address _from, address _property, uint256 _value);
2210 
2211 	/**
2212 	 * Initialize the passed address as AddressConfig address.
2213 	 */
2214 	// solium-disable-next-line no-empty-blocks
2215 	constructor(address _config) public UsingConfig(_config) {}
2216 
2217 	/**
2218 	 * Adds staking.
2219 	 * Only the Dev contract can execute this function.
2220 	 */
2221 	function lockup(
2222 		address _from,
2223 		address _property,
2224 		uint256 _value
2225 	) external {
2226 		/**
2227 		 * Validates the sender is Dev contract.
2228 		 */
2229 		addressValidator().validateAddress(msg.sender, config().token());
2230 
2231 		/**
2232 		 * Validates _value is not 0.
2233 		 */
2234 		require(_value != 0, "illegal lockup value");
2235 
2236 		/**
2237 		 * Validates the passed Property has greater than 1 asset.
2238 		 */
2239 		require(
2240 			IMetricsGroup(config().metricsGroup()).hasAssets(_property),
2241 			"unable to stake to unauthenticated property"
2242 		);
2243 
2244 		/**
2245 		 * Refuses new staking when after cancel staking and until release it.
2246 		 */
2247 		bool isWaiting = getStorageWithdrawalStatus(_property, _from) != 0;
2248 		require(isWaiting == false, "lockup is already canceled");
2249 
2250 		/**
2251 		 * Since the reward per block that can be withdrawn will change with the addition of staking,
2252 		 * saves the undrawn withdrawable reward before addition it.
2253 		 */
2254 		updatePendingInterestWithdrawal(_property, _from);
2255 
2256 		/**
2257 		 * Saves the variables at the time of staking to prepare for reward calculation.
2258 		 */
2259 		(, , , uint256 interest, ) = difference(_property, 0);
2260 		updateStatesAtLockup(_property, _from, interest);
2261 
2262 		/**
2263 		 * Saves variables that should change due to the addition of staking.
2264 		 */
2265 		updateValues(true, _from, _property, _value);
2266 		emit Lockedup(_from, _property, _value);
2267 	}
2268 
2269 	/**
2270 	 * Cancel staking.
2271 	 * The staking amount can be withdrawn after the blocks specified by `Policy.lockUpBlocks` have passed.
2272 	 */
2273 	function cancel(address _property) external {
2274 		/**
2275 		 * Validates the target of staked is included Property set.
2276 		 */
2277 		addressValidator().validateGroup(_property, config().propertyGroup());
2278 
2279 		/**
2280 		 * Validates the sender is staking to the target Property.
2281 		 */
2282 		require(hasValue(_property, msg.sender), "dev token is not locked");
2283 
2284 		/**
2285 		 * Validates not already been canceled.
2286 		 */
2287 		bool isWaiting = getStorageWithdrawalStatus(_property, msg.sender) != 0;
2288 		require(isWaiting == false, "lockup is already canceled");
2289 
2290 		/**
2291 		 * Get `Policy.lockUpBlocks`, add it to the current block number, and saves that block number in `WithdrawalStatus`.
2292 		 * Staking is cannot release until the block number saved in `WithdrawalStatus` is reached.
2293 		 */
2294 		uint256 blockNumber = IPolicy(config().policy()).lockUpBlocks();
2295 		blockNumber = blockNumber.add(block.number);
2296 		setStorageWithdrawalStatus(_property, msg.sender, blockNumber);
2297 	}
2298 
2299 	/**
2300 	 * Withdraw staking.
2301 	 * Releases canceled staking and transfer the staked amount to the sender.
2302 	 */
2303 	function withdraw(address _property) external {
2304 		/**
2305 		 * Validates the target of staked is included Property set.
2306 		 */
2307 		addressValidator().validateGroup(_property, config().propertyGroup());
2308 
2309 		/**
2310 		 * Validates the block number reaches the block number where staking can be released.
2311 		 */
2312 		require(possible(_property, msg.sender), "waiting for release");
2313 
2314 		/**
2315 		 * Validates the sender is staking to the target Property.
2316 		 */
2317 		uint256 lockedUpValue = getStorageValue(_property, msg.sender);
2318 		require(lockedUpValue != 0, "dev token is not locked");
2319 
2320 		/**
2321 		 * Since the increase of rewards will stop with the release of the staking,
2322 		 * saves the undrawn withdrawable reward before releasing it.
2323 		 */
2324 		updatePendingInterestWithdrawal(_property, msg.sender);
2325 
2326 		/**
2327 		 * Transfer the staked amount to the sender.
2328 		 */
2329 		IProperty(_property).withdraw(msg.sender, lockedUpValue);
2330 
2331 		/**
2332 		 * Saves variables that should change due to the canceling staking..
2333 		 */
2334 		updateValues(false, msg.sender, _property, lockedUpValue);
2335 
2336 		/**
2337 		 * Sets the staked amount to 0.
2338 		 */
2339 		setStorageValue(_property, msg.sender, 0);
2340 
2341 		/**
2342 		 * Sets the cancellation status to not have.
2343 		 */
2344 		setStorageWithdrawalStatus(_property, msg.sender, 0);
2345 	}
2346 
2347 	/**
2348 	 * Returns the current staking amount, and the block number in which the recorded last.
2349 	 * These values are used to calculate the cumulative sum of the staking.
2350 	 */
2351 	function getCumulativeLockedUpUnitAndBlock(address _property)
2352 		private
2353 		view
2354 		returns (uint256 _unit, uint256 _block)
2355 	{
2356 		/**
2357 		 * Get the current staking amount and the last recorded block number from the `CumulativeLockedUpUnitAndBlock` storage.
2358 		 * If the last recorded block number is not 0, it is returns as it is.
2359 		 */
2360 		(
2361 			uint256 unit,
2362 			uint256 lastBlock
2363 		) = getStorageCumulativeLockedUpUnitAndBlock(_property);
2364 		if (lastBlock > 0) {
2365 			return (unit, lastBlock);
2366 		}
2367 
2368 		/**
2369 		 * If the last recorded block number is 0, this function falls back as already staked before the current specs (before DIP4).
2370 		 * More detail for DIP4: https://github.com/dev-protocol/DIPs/issues/4
2371 		 *
2372 		 * When the passed address is 0, the caller wants to know the total staking amount on the protocol,
2373 		 * so gets the total staking amount from `AllValue` storage.
2374 		 * When the address is other than 0, the caller wants to know the staking amount of a Property,
2375 		 * so gets the staking amount from the `PropertyValue` storage.
2376 		 */
2377 		unit = _property == address(0)
2378 			? getStorageAllValue()
2379 			: getStoragePropertyValue(_property);
2380 
2381 		/**
2382 		 * Staking pre-DIP4 will be treated as staked simultaneously with the DIP4 release.
2383 		 * Therefore, the last recorded block number is the same as the DIP4 release block.
2384 		 */
2385 		lastBlock = getStorageDIP4GenesisBlock();
2386 		return (unit, lastBlock);
2387 	}
2388 
2389 	/**
2390 	 * Returns the cumulative sum of the staking on passed address, the current staking amount,
2391 	 * and the block number in which the recorded last.
2392 	 * The latest cumulative sum can be calculated using the following formula:
2393 	 * (current staking amount) * (current block number - last recorded block number) + (last cumulative sum)
2394 	 */
2395 	function getCumulativeLockedUp(address _property)
2396 		public
2397 		view
2398 		returns (
2399 			uint256 _value,
2400 			uint256 _unit,
2401 			uint256 _block
2402 		)
2403 	{
2404 		/**
2405 		 * Gets the current staking amount and the last recorded block number from the `getCumulativeLockedUpUnitAndBlock` function.
2406 		 */
2407 		(uint256 unit, uint256 lastBlock) = getCumulativeLockedUpUnitAndBlock(
2408 			_property
2409 		);
2410 
2411 		/**
2412 		 * Gets the last cumulative sum of the staking from `CumulativeLockedUpValue` storage.
2413 		 */
2414 		uint256 lastValue = getStorageCumulativeLockedUpValue(_property);
2415 
2416 		/**
2417 		 * Returns the latest cumulative sum, current staking amount as a unit, and last recorded block number.
2418 		 */
2419 		return (
2420 			lastValue.add(unit.mul(block.number.sub(lastBlock))),
2421 			unit,
2422 			lastBlock
2423 		);
2424 	}
2425 
2426 	/**
2427 	 * Returns the cumulative sum of the staking on the protocol totally, the current staking amount,
2428 	 * and the block number in which the recorded last.
2429 	 */
2430 	function getCumulativeLockedUpAll()
2431 		public
2432 		view
2433 		returns (
2434 			uint256 _value,
2435 			uint256 _unit,
2436 			uint256 _block
2437 		)
2438 	{
2439 		/**
2440 		 * If the 0 address is passed as a key, it indicates the entire protocol.
2441 		 */
2442 		return getCumulativeLockedUp(address(0));
2443 	}
2444 
2445 	/**
2446 	 * Updates the `CumulativeLockedUpValue` and `CumulativeLockedUpUnitAndBlock` storage.
2447 	 * This function expected to executes when the amount of staking as a unit changes.
2448 	 */
2449 	function updateCumulativeLockedUp(
2450 		bool _addition,
2451 		address _property,
2452 		uint256 _unit
2453 	) private {
2454 		address zero = address(0);
2455 
2456 		/**
2457 		 * Gets the cumulative sum of the staking amount, staking amount, and last recorded block number for the passed Property address.
2458 		 */
2459 		(uint256 lastValue, uint256 lastUnit, ) = getCumulativeLockedUp(
2460 			_property
2461 		);
2462 
2463 		/**
2464 		 * Gets the cumulative sum of the staking amount, staking amount, and last recorded block number for the protocol total.
2465 		 */
2466 		(uint256 lastValueAll, uint256 lastUnitAll, ) = getCumulativeLockedUp(
2467 			zero
2468 		);
2469 
2470 		/**
2471 		 * Adds or subtracts the staking amount as a new unit to the cumulative sum of the staking for the passed Property address.
2472 		 */
2473 		setStorageCumulativeLockedUpValue(
2474 			_property,
2475 			_addition ? lastValue.add(_unit) : lastValue.sub(_unit)
2476 		);
2477 
2478 		/**
2479 		 * Adds or subtracts the staking amount as a new unit to the cumulative sum of the staking for the protocol total.
2480 		 */
2481 		setStorageCumulativeLockedUpValue(
2482 			zero,
2483 			_addition ? lastValueAll.add(_unit) : lastValueAll.sub(_unit)
2484 		);
2485 
2486 		/**
2487 		 * Adds or subtracts the staking amount to the staking unit for the passed Property address.
2488 		 * Also, record the latest block number.
2489 		 */
2490 		setStorageCumulativeLockedUpUnitAndBlock(
2491 			_property,
2492 			_addition ? lastUnit.add(_unit) : lastUnit.sub(_unit),
2493 			block.number
2494 		);
2495 
2496 		/**
2497 		 * Adds or subtracts the staking amount to the staking unit for the protocol total.
2498 		 * Also, record the latest block number.
2499 		 */
2500 		setStorageCumulativeLockedUpUnitAndBlock(
2501 			zero,
2502 			_addition ? lastUnitAll.add(_unit) : lastUnitAll.sub(_unit),
2503 			block.number
2504 		);
2505 	}
2506 
2507 	/**
2508 	 * Updates cumulative sum of the maximum mint amount calculated by Allocator contract, the latest maximum mint amount per block,
2509 	 * and the last recorded block number.
2510 	 * The cumulative sum of the maximum mint amount is always added.
2511 	 * By recording that value when the staker last stakes, the difference from the when the staker stakes can be calculated.
2512 	 */
2513 	function update() public {
2514 		/**
2515 		 * Gets the cumulative sum of the maximum mint amount and the maximum mint number per block.
2516 		 */
2517 		(uint256 _nextRewards, uint256 _amount) = dry();
2518 
2519 		/**
2520 		 * Records each value and the latest block number.
2521 		 */
2522 		setStorageCumulativeGlobalRewards(_nextRewards);
2523 		setStorageLastSameRewardsAmountAndBlock(_amount, block.number);
2524 	}
2525 
2526 	/**
2527 	 * Updates the cumulative sum of the maximum mint amount when staking, the cumulative sum of staker reward as an interest of the target Property
2528 	 * and the cumulative staking amount, and the latest block number.
2529 	 */
2530 	function updateStatesAtLockup(
2531 		address _property,
2532 		address _user,
2533 		uint256 _interest
2534 	) private {
2535 		/**
2536 		 * Gets the cumulative sum of the maximum mint amount.
2537 		 */
2538 		(uint256 _reward, ) = dry();
2539 
2540 		/**
2541 		 * Records each value and the latest block number.
2542 		 */
2543 		if (isSingle(_property, _user)) {
2544 			setStorageLastCumulativeGlobalReward(_property, _user, _reward);
2545 		}
2546 		setStorageLastCumulativePropertyInterest(_property, _user, _interest);
2547 		(uint256 cLocked, , ) = getCumulativeLockedUp(_property);
2548 		setStorageLastCumulativeLockedUpAndBlock(
2549 			_property,
2550 			_user,
2551 			cLocked,
2552 			block.number
2553 		);
2554 	}
2555 
2556 	/**
2557 	 * Returns the last cumulative staking amount of the passed Property address and the last recorded block number.
2558 	 */
2559 	function getLastCumulativeLockedUpAndBlock(address _property, address _user)
2560 		private
2561 		view
2562 		returns (uint256 _cLocked, uint256 _block)
2563 	{
2564 		/**
2565 		 * Gets the values from `LastCumulativeLockedUpAndBlock` storage.
2566 		 */
2567 		(
2568 			uint256 cLocked,
2569 			uint256 blockNumber
2570 		) = getStorageLastCumulativeLockedUpAndBlock(_property, _user);
2571 
2572 		/**
2573 		 * When the last recorded block number is 0, the block number at the time of the DIP4 release is returned as being staked at the same time as the DIP4 release.
2574 		 * More detail for DIP4: https://github.com/dev-protocol/DIPs/issues/4
2575 		 */
2576 		if (blockNumber == 0) {
2577 			blockNumber = getStorageDIP4GenesisBlock();
2578 		}
2579 		return (cLocked, blockNumber);
2580 	}
2581 
2582 	/**
2583 	 * Referring to the values recorded in each storage to returns the latest cumulative sum of the maximum mint amount and the latest maximum mint amount per block.
2584 	 */
2585 	function dry()
2586 		private
2587 		view
2588 		returns (uint256 _nextRewards, uint256 _amount)
2589 	{
2590 		/**
2591 		 * Gets the latest mint amount per block from Allocator contract.
2592 		 */
2593 		uint256 rewardsAmount = IAllocator(config().allocator())
2594 			.calculateMaxRewardsPerBlock();
2595 
2596 		/**
2597 		 * Gets the maximum mint amount per block, and the last recorded block number from `LastSameRewardsAmountAndBlock` storage.
2598 		 */
2599 		(
2600 			uint256 lastAmount,
2601 			uint256 lastBlock
2602 		) = getStorageLastSameRewardsAmountAndBlock();
2603 
2604 		/**
2605 		 * If the recorded maximum mint amount per block and the result of the Allocator contract are different,
2606 		 * the result of the Allocator contract takes precedence as a maximum mint amount per block.
2607 		 */
2608 		uint256 lastMaxRewards = lastAmount == rewardsAmount
2609 			? rewardsAmount
2610 			: lastAmount;
2611 
2612 		/**
2613 		 * Calculates the difference between the latest block number and the last recorded block number.
2614 		 */
2615 		uint256 blocks = lastBlock > 0 ? block.number.sub(lastBlock) : 0;
2616 
2617 		/**
2618 		 * Adds the calculated new cumulative maximum mint amount to the recorded cumulative maximum mint amount.
2619 		 */
2620 		uint256 additionalRewards = lastMaxRewards.mul(blocks);
2621 		uint256 nextRewards = getStorageCumulativeGlobalRewards().add(
2622 			additionalRewards
2623 		);
2624 
2625 		/**
2626 		 * Returns the latest theoretical cumulative sum of maximum mint amount and maximum mint amount per block.
2627 		 */
2628 		return (nextRewards, rewardsAmount);
2629 	}
2630 
2631 	/**
2632 	 * Returns the latest theoretical cumulative sum of maximum mint amount, the holder's reward of the passed Property address and its unit price,
2633 	 * and the staker's reward as interest and its unit price.
2634 	 * The latest theoretical cumulative sum of maximum mint amount is got from `dry` function.
2635 	 * The Holder's reward is a staking(delegation) reward received by the holder of the Property contract(token) according to the share.
2636 	 * The unit price of the holder's reward is the reward obtained per 1 piece of Property contract(token).
2637 	 * The staker rewards are rewards for staking users.
2638 	 * The unit price of the staker reward is the reward per DEV token 1 piece that is staking.
2639 	 */
2640 	function difference(address _property, uint256 _lastReward)
2641 		public
2642 		view
2643 		returns (
2644 			uint256 _reward,
2645 			uint256 _holdersAmount,
2646 			uint256 _holdersPrice,
2647 			uint256 _interestAmount,
2648 			uint256 _interestPrice
2649 		)
2650 	{
2651 		/**
2652 		 * Gets the cumulative sum of the maximum mint amount.
2653 		 */
2654 		(uint256 rewards, ) = dry();
2655 
2656 		/**
2657 		 * Gets the cumulative sum of the staking amount of the passed Property address and
2658 		 * the cumulative sum of the staking amount of the protocol total.
2659 		 */
2660 		(uint256 valuePerProperty, , ) = getCumulativeLockedUp(_property);
2661 		(uint256 valueAll, , ) = getCumulativeLockedUpAll();
2662 
2663 		/**
2664 		 * Calculates the amount of reward that can be received by the Property from the ratio of the cumulative sum of the staking amount of the Property address
2665 		 * and the cumulative sum of the staking amount of the protocol total.
2666 		 * If the past cumulative sum of the maximum mint amount passed as the second argument is 1 or more,
2667 		 * this result is the difference from that cumulative sum.
2668 		 */
2669 		uint256 propertyRewards = rewards.sub(_lastReward).mul(
2670 			valuePerProperty.mulBasis().outOf(valueAll)
2671 		);
2672 
2673 		/**
2674 		 * Gets the staking amount and total supply of the Property and calls `Policy.holdersShare` function to calculates
2675 		 * the holder's reward amount out of the total reward amount.
2676 		 */
2677 		uint256 lockedUpPerProperty = getStoragePropertyValue(_property);
2678 		uint256 totalSupply = ERC20Mintable(_property).totalSupply();
2679 		uint256 holders = IPolicy(config().policy()).holdersShare(
2680 			propertyRewards,
2681 			lockedUpPerProperty
2682 		);
2683 
2684 		/**
2685 		 * The total rewards amount minus the holder reward amount is the staker rewards as an interest.
2686 		 */
2687 		uint256 interest = propertyRewards.sub(holders);
2688 
2689 		/**
2690 		 * Returns each value and a unit price of each reward.
2691 		 */
2692 		return (
2693 			rewards,
2694 			holders,
2695 			holders.div(totalSupply),
2696 			interest,
2697 			lockedUpPerProperty > 0 ? interest.div(lockedUpPerProperty) : 0
2698 		);
2699 	}
2700 
2701 	/**
2702 	 * Returns the staker reward as interest.
2703 	 */
2704 	function _calculateInterestAmount(address _property, address _user)
2705 		private
2706 		view
2707 		returns (uint256)
2708 	{
2709 		/**
2710 		 * Gets the cumulative sum of the staking amount, current staking amount, and last recorded block number of the Property.
2711 		 */
2712 		(
2713 			uint256 cLockProperty,
2714 			uint256 unit,
2715 			uint256 lastBlock
2716 		) = getCumulativeLockedUp(_property);
2717 
2718 		/**
2719 		 * Gets the cumulative sum of staking amount and block number of Property when the user staked.
2720 		 */
2721 		(
2722 			uint256 lastCLocked,
2723 			uint256 lastBlockUser
2724 		) = getLastCumulativeLockedUpAndBlock(_property, _user);
2725 
2726 		/**
2727 		 * Get the amount the user is staking for the Property.
2728 		 */
2729 		uint256 lockedUpPerAccount = getStorageValue(_property, _user);
2730 
2731 		/**
2732 		 * Gets the cumulative sum of the Property's staker reward when the user staked.
2733 		 */
2734 		uint256 lastInterest = getStorageLastCumulativePropertyInterest(
2735 			_property,
2736 			_user
2737 		);
2738 
2739 		/**
2740 		 * Calculates the cumulative sum of the staking amount from the time the user staked to the present.
2741 		 * It can be calculated by multiplying the staking amount by the number of elapsed blocks.
2742 		 */
2743 		uint256 cLockUser = lockedUpPerAccount.mul(
2744 			block.number.sub(lastBlockUser)
2745 		);
2746 
2747 		/**
2748 		 * Determines if the user is the only staker to the Property.
2749 		 */
2750 		bool isOnly = unit == lockedUpPerAccount && lastBlock <= lastBlockUser;
2751 
2752 		/**
2753 		 * If the user is the Property's only staker and the first staker, and the only staker on the protocol:
2754 		 */
2755 		if (isSingle(_property, _user)) {
2756 			/**
2757 			 * Passing the cumulative sum of the maximum mint amount when staked, to the `difference` function,
2758 			 * gets the staker reward amount that the user can receive from the time of staking to the present.
2759 			 * In the case of the staking is single, the ratio of the Property and the user account for 100% of the cumulative sum of the maximum mint amount,
2760 			 * so the difference cannot be calculated with the value of `LastCumulativePropertyInterest`.
2761 			 * Therefore, it is necessary to calculate the difference using the cumulative sum of the maximum mint amounts at the time of staked.
2762 			 */
2763 			(, , , , uint256 interestPrice) = difference(
2764 				_property,
2765 				getStorageLastCumulativeGlobalReward(_property, _user)
2766 			);
2767 
2768 			/**
2769 			 * Returns the result after adjusted decimals to 10^18.
2770 			 */
2771 			uint256 result = interestPrice
2772 				.mul(lockedUpPerAccount)
2773 				.divBasis()
2774 				.divBasis();
2775 			return result;
2776 
2777 			/**
2778 			 * If not the single but the only staker:
2779 			 */
2780 		} else if (isOnly) {
2781 			/**
2782 			 * Pass 0 to the `difference` function to gets the Property's cumulative sum of the staker reward.
2783 			 */
2784 			(, , , uint256 interest, ) = difference(_property, 0);
2785 
2786 			/**
2787 			 * Calculates the difference in rewards that can be received by subtracting the Property's cumulative sum of staker rewards at the time of staking.
2788 			 */
2789 			uint256 result = interest >= lastInterest
2790 				? interest.sub(lastInterest).divBasis().divBasis()
2791 				: 0;
2792 			return result;
2793 		}
2794 
2795 		/**
2796 		 * If the user is the Property's not the first staker and not the only staker:
2797 		 */
2798 
2799 		/**
2800 		 * Pass 0 to the `difference` function to gets the Property's cumulative sum of the staker reward.
2801 		 */
2802 		(, , , uint256 interest, ) = difference(_property, 0);
2803 
2804 		/**
2805 		 * Calculates the share of rewards that can be received by the user among Property's staker rewards.
2806 		 * "Cumulative sum of the staking amount of the Property at the time of staking" is subtracted from "cumulative sum of the staking amount of the Property",
2807 		 * and calculates the cumulative sum of staking amounts from the time of staking to the present.
2808 		 * The ratio of the "cumulative sum of staking amount from the time the user staked to the present" to that value is the share.
2809 		 */
2810 		uint256 share = cLockUser.outOf(cLockProperty.sub(lastCLocked));
2811 
2812 		/**
2813 		 * If the Property's staker reward is greater than the value of the `CumulativePropertyInterest` storage,
2814 		 * calculates the difference and multiply by the share.
2815 		 * Otherwise, it returns 0.
2816 		 */
2817 		uint256 result = interest >= lastInterest
2818 			? interest
2819 				.sub(lastInterest)
2820 				.mul(share)
2821 				.divBasis()
2822 				.divBasis()
2823 				.divBasis()
2824 			: 0;
2825 		return result;
2826 	}
2827 
2828 	/**
2829 	 * Returns the total rewards currently available for withdrawal. (For calling from inside the contract)
2830 	 */
2831 	function _calculateWithdrawableInterestAmount(
2832 		address _property,
2833 		address _user
2834 	) private view returns (uint256) {
2835 		/**
2836 		 * If the passed Property has not authenticated, returns always 0.
2837 		 */
2838 		if (
2839 			IMetricsGroup(config().metricsGroup()).hasAssets(_property) == false
2840 		) {
2841 			return 0;
2842 		}
2843 
2844 		/**
2845 		 * Gets the reward amount in saved without withdrawal.
2846 		 */
2847 		uint256 pending = getStoragePendingInterestWithdrawal(_property, _user);
2848 
2849 		/**
2850 		 * Gets the reward amount of before DIP4.
2851 		 */
2852 		uint256 legacy = __legacyWithdrawableInterestAmount(_property, _user);
2853 
2854 		/**
2855 		 * Gets the latest withdrawal reward amount.
2856 		 */
2857 		uint256 amount = _calculateInterestAmount(_property, _user);
2858 
2859 		/**
2860 		 * Returns the sum of all values.
2861 		 */
2862 		uint256 withdrawableAmount = amount
2863 			.add(pending) // solium-disable-next-line indentation
2864 			.add(legacy);
2865 		return withdrawableAmount;
2866 	}
2867 
2868 	/**
2869 	 * Returns the total rewards currently available for withdrawal. (For calling from external of the contract)
2870 	 */
2871 	function calculateWithdrawableInterestAmount(
2872 		address _property,
2873 		address _user
2874 	) public view returns (uint256) {
2875 		uint256 amount = _calculateWithdrawableInterestAmount(_property, _user);
2876 		return amount;
2877 	}
2878 
2879 	/**
2880 	 * Withdraws staking reward as an interest.
2881 	 */
2882 	function withdrawInterest(address _property) external {
2883 		/**
2884 		 * Validates the target of staking is included Property set.
2885 		 */
2886 		addressValidator().validateGroup(_property, config().propertyGroup());
2887 
2888 		/**
2889 		 * Gets the withdrawable amount.
2890 		 */
2891 		uint256 value = _calculateWithdrawableInterestAmount(
2892 			_property,
2893 			msg.sender
2894 		);
2895 
2896 		/**
2897 		 * Gets the cumulative sum of staker rewards of the passed Property address.
2898 		 */
2899 		(, , , uint256 interest, ) = difference(_property, 0);
2900 
2901 		/**
2902 		 * Validates rewards amount there are 1 or more.
2903 		 */
2904 		require(value > 0, "your interest amount is 0");
2905 
2906 		/**
2907 		 * Sets the unwithdrawn reward amount to 0.
2908 		 */
2909 		setStoragePendingInterestWithdrawal(_property, msg.sender, 0);
2910 
2911 		/**
2912 		 * Creates a Dev token instance.
2913 		 */
2914 		ERC20Mintable erc20 = ERC20Mintable(config().token());
2915 
2916 		/**
2917 		 * Updates the staking status to avoid double rewards.
2918 		 */
2919 		updateStatesAtLockup(_property, msg.sender, interest);
2920 		__updateLegacyWithdrawableInterestAmount(_property, msg.sender);
2921 
2922 		/**
2923 		 * Mints the reward.
2924 		 */
2925 		require(erc20.mint(msg.sender, value), "dev mint failed");
2926 
2927 		/**
2928 		 * Since the total supply of tokens has changed, updates the latest maximum mint amount.
2929 		 */
2930 		update();
2931 	}
2932 
2933 	/**
2934 	 * Status updates with the addition or release of staking.
2935 	 */
2936 	function updateValues(
2937 		bool _addition,
2938 		address _account,
2939 		address _property,
2940 		uint256 _value
2941 	) private {
2942 		/**
2943 		 * If added staking:
2944 		 */
2945 		if (_addition) {
2946 			/**
2947 			 * Updates the cumulative sum of the staking amount of the passed Property and the cumulative amount of the staking amount of the protocol total.
2948 			 */
2949 			updateCumulativeLockedUp(true, _property, _value);
2950 
2951 			/**
2952 			 * Updates the current staking amount of the protocol total.
2953 			 */
2954 			addAllValue(_value);
2955 
2956 			/**
2957 			 * Updates the current staking amount of the Property.
2958 			 */
2959 			addPropertyValue(_property, _value);
2960 
2961 			/**
2962 			 * Updates the user's current staking amount in the Property.
2963 			 */
2964 			addValue(_property, _account, _value);
2965 
2966 			/**
2967 			 * If released staking:
2968 			 */
2969 		} else {
2970 			/**
2971 			 * Updates the cumulative sum of the staking amount of the passed Property and the cumulative amount of the staking amount of the protocol total.
2972 			 */
2973 			updateCumulativeLockedUp(false, _property, _value);
2974 
2975 			/**
2976 			 * Updates the current staking amount of the protocol total.
2977 			 */
2978 			subAllValue(_value);
2979 
2980 			/**
2981 			 * Updates the current staking amount of the Property.
2982 			 */
2983 			subPropertyValue(_property, _value);
2984 		}
2985 
2986 		/**
2987 		 * Since each staking amount has changed, updates the latest maximum mint amount.
2988 		 */
2989 		update();
2990 	}
2991 
2992 	/**
2993 	 * Returns the staking amount of the protocol total.
2994 	 */
2995 	function getAllValue() external view returns (uint256) {
2996 		return getStorageAllValue();
2997 	}
2998 
2999 	/**
3000 	 * Adds the staking amount of the protocol total.
3001 	 */
3002 	function addAllValue(uint256 _value) private {
3003 		uint256 value = getStorageAllValue();
3004 		value = value.add(_value);
3005 		setStorageAllValue(value);
3006 	}
3007 
3008 	/**
3009 	 * Subtracts the staking amount of the protocol total.
3010 	 */
3011 	function subAllValue(uint256 _value) private {
3012 		uint256 value = getStorageAllValue();
3013 		value = value.sub(_value);
3014 		setStorageAllValue(value);
3015 	}
3016 
3017 	/**
3018 	 * Returns the user's staking amount in the Property.
3019 	 */
3020 	function getValue(address _property, address _sender)
3021 		external
3022 		view
3023 		returns (uint256)
3024 	{
3025 		return getStorageValue(_property, _sender);
3026 	}
3027 
3028 	/**
3029 	 * Adds the user's staking amount in the Property.
3030 	 */
3031 	function addValue(
3032 		address _property,
3033 		address _sender,
3034 		uint256 _value
3035 	) private {
3036 		uint256 value = getStorageValue(_property, _sender);
3037 		value = value.add(_value);
3038 		setStorageValue(_property, _sender, value);
3039 	}
3040 
3041 	/**
3042 	 * Returns whether the user is staking in the Property.
3043 	 */
3044 	function hasValue(address _property, address _sender)
3045 		private
3046 		view
3047 		returns (bool)
3048 	{
3049 		uint256 value = getStorageValue(_property, _sender);
3050 		return value != 0;
3051 	}
3052 
3053 	/**
3054 	 * Returns whether a single user has all staking share.
3055 	 * This value is true when only one Property and one user is historically the only staker.
3056 	 */
3057 	function isSingle(address _property, address _user)
3058 		private
3059 		view
3060 		returns (bool)
3061 	{
3062 		uint256 perAccount = getStorageValue(_property, _user);
3063 		(uint256 cLockProperty, uint256 unitProperty, ) = getCumulativeLockedUp(
3064 			_property
3065 		);
3066 		(uint256 cLockTotal, , ) = getCumulativeLockedUpAll();
3067 		return perAccount == unitProperty && cLockProperty == cLockTotal;
3068 	}
3069 
3070 	/**
3071 	 * Returns the staking amount of the Property.
3072 	 */
3073 	function getPropertyValue(address _property)
3074 		external
3075 		view
3076 		returns (uint256)
3077 	{
3078 		return getStoragePropertyValue(_property);
3079 	}
3080 
3081 	/**
3082 	 * Adds the staking amount of the Property.
3083 	 */
3084 	function addPropertyValue(address _property, uint256 _value) private {
3085 		uint256 value = getStoragePropertyValue(_property);
3086 		value = value.add(_value);
3087 		setStoragePropertyValue(_property, value);
3088 	}
3089 
3090 	/**
3091 	 * Subtracts the staking amount of the Property.
3092 	 */
3093 	function subPropertyValue(address _property, uint256 _value) private {
3094 		uint256 value = getStoragePropertyValue(_property);
3095 		uint256 nextValue = value.sub(_value);
3096 		setStoragePropertyValue(_property, nextValue);
3097 	}
3098 
3099 	/**
3100 	 * Saves the latest reward amount as an undrawn amount.
3101 	 */
3102 	function updatePendingInterestWithdrawal(address _property, address _user)
3103 		private
3104 	{
3105 		/**
3106 		 * Gets the latest reward amount.
3107 		 */
3108 		uint256 withdrawableAmount = _calculateWithdrawableInterestAmount(
3109 			_property,
3110 			_user
3111 		);
3112 
3113 		/**
3114 		 * Saves the amount to `PendingInterestWithdrawal` storage.
3115 		 */
3116 		setStoragePendingInterestWithdrawal(
3117 			_property,
3118 			_user,
3119 			withdrawableAmount
3120 		);
3121 
3122 		/**
3123 		 * Updates the reward amount of before DIP4 to prevent further addition it.
3124 		 */
3125 		__updateLegacyWithdrawableInterestAmount(_property, _user);
3126 	}
3127 
3128 	/**
3129 	 * Returns whether the staking can be released.
3130 	 */
3131 	function possible(address _property, address _from)
3132 		private
3133 		view
3134 		returns (bool)
3135 	{
3136 		uint256 blockNumber = getStorageWithdrawalStatus(_property, _from);
3137 		if (blockNumber == 0) {
3138 			return false;
3139 		}
3140 		if (blockNumber <= block.number) {
3141 			return true;
3142 		} else {
3143 			if (IPolicy(config().policy()).lockUpBlocks() == 1) {
3144 				return true;
3145 			}
3146 		}
3147 		return false;
3148 	}
3149 
3150 	/**
3151 	 * Returns the reward amount of the calculation model before DIP4.
3152 	 * It can be calculated by subtracting "the last cumulative sum of reward unit price" from
3153 	 * "the current cumulative sum of reward unit price," and multiplying by the staking amount.
3154 	 */
3155 	function __legacyWithdrawableInterestAmount(
3156 		address _property,
3157 		address _user
3158 	) private view returns (uint256) {
3159 		uint256 _last = getStorageLastInterestPrice(_property, _user);
3160 		uint256 price = getStorageInterestPrice(_property);
3161 		uint256 priceGap = price.sub(_last);
3162 		uint256 lockedUpValue = getStorageValue(_property, _user);
3163 		uint256 value = priceGap.mul(lockedUpValue);
3164 		return value.divBasis();
3165 	}
3166 
3167 	/**
3168 	 * Updates and treats the reward of before DIP4 as already received.
3169 	 */
3170 	function __updateLegacyWithdrawableInterestAmount(
3171 		address _property,
3172 		address _user
3173 	) private {
3174 		uint256 interestPrice = getStorageInterestPrice(_property);
3175 		if (getStorageLastInterestPrice(_property, _user) != interestPrice) {
3176 			setStorageLastInterestPrice(_property, _user, interestPrice);
3177 		}
3178 	}
3179 
3180 	/**
3181 	 * Updates the block number of the time of DIP4 release.
3182 	 */
3183 	function setDIP4GenesisBlock(uint256 _block) external onlyOwner {
3184 		/**
3185 		 * Validates the value is not set.
3186 		 */
3187 		require(getStorageDIP4GenesisBlock() == 0, "already set the value");
3188 
3189 		/**
3190 		 * Sets the value.
3191 		 */
3192 		setStorageDIP4GenesisBlock(_block);
3193 	}
3194 }
3195 
3196 // File: contracts/src/lockup/MigrateLockup.sol
3197 
3198 pragma solidity 0.5.17;
3199 
3200 
3201 contract MigrateLockup is LegacyLockup {
3202 	constructor(address _config) public LegacyLockup(_config) {}
3203 
3204 	function __initStakeOnProperty(
3205 		address _property,
3206 		address _user,
3207 		uint256 _cInterestPrice
3208 	) public onlyOwner {
3209 		require(
3210 			getStorageLastStakedInterestPrice(_property, _user) !=
3211 				_cInterestPrice,
3212 			"ALREADY EXISTS"
3213 		);
3214 		setStorageLastStakedInterestPrice(_property, _user, _cInterestPrice);
3215 	}
3216 
3217 	function __initLastStakeOnProperty(
3218 		address _property,
3219 		uint256 _cHoldersAmountPerProperty,
3220 		uint256 _cHoldersPrice
3221 	) public onlyOwner {
3222 		require(
3223 			getStorageLastCumulativeHoldersRewardAmountPerProperty(_property) !=
3224 				_cHoldersAmountPerProperty ||
3225 				getStorageLastCumulativeHoldersRewardPricePerProperty(
3226 					_property
3227 				) !=
3228 				_cHoldersPrice,
3229 			"ALREADY EXISTS"
3230 		);
3231 		setStorageLastCumulativeHoldersRewardAmountPerProperty(
3232 			_property,
3233 			_cHoldersAmountPerProperty
3234 		);
3235 		setStorageLastCumulativeHoldersRewardPricePerProperty(
3236 			_property,
3237 			_cHoldersPrice
3238 		);
3239 	}
3240 
3241 	function __initLastStake(
3242 		uint256 _cReward,
3243 		uint256 _cInterestPrice,
3244 		uint256 _cHoldersPrice
3245 	) public onlyOwner {
3246 		require(
3247 			getStorageLastStakesChangedCumulativeReward() != _cReward ||
3248 				getStorageLastCumulativeHoldersRewardPrice() !=
3249 				_cHoldersPrice ||
3250 				getStorageLastCumulativeInterestPrice() != _cInterestPrice,
3251 			"ALREADY EXISTS"
3252 		);
3253 		setStorageLastStakesChangedCumulativeReward(_cReward);
3254 		setStorageLastCumulativeHoldersRewardPrice(_cHoldersPrice);
3255 		setStorageLastCumulativeInterestPrice(_cInterestPrice);
3256 	}
3257 }