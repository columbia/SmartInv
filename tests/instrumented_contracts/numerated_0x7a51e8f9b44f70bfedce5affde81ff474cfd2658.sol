1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
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
31 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
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
110 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
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
269 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
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
501 // File: @openzeppelin\contracts\access\Roles.sol
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
540 // File: @openzeppelin\contracts\ownership\Ownable.sol
541 
542 pragma solidity ^0.5.0;
543 
544 /**
545  * @dev Contract module which provides a basic access control mechanism, where
546  * there is an account (an owner) that can be granted exclusive access to
547  * specific functions.
548  *
549  * This module is used through inheritance. It will make available the modifier
550  * `onlyOwner`, which can be applied to your functions to restrict their use to
551  * the owner.
552  */
553 contract Ownable is Context {
554     address private _owner;
555 
556     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
557 
558     /**
559      * @dev Initializes the contract setting the deployer as the initial owner.
560      */
561     constructor () internal {
562         address msgSender = _msgSender();
563         _owner = msgSender;
564         emit OwnershipTransferred(address(0), msgSender);
565     }
566 
567     /**
568      * @dev Returns the address of the current owner.
569      */
570     function owner() public view returns (address) {
571         return _owner;
572     }
573 
574     /**
575      * @dev Throws if called by any account other than the owner.
576      */
577     modifier onlyOwner() {
578         require(isOwner(), "Ownable: caller is not the owner");
579         _;
580     }
581 
582     /**
583      * @dev Returns true if the caller is the current owner.
584      */
585     function isOwner() public view returns (bool) {
586         return _msgSender() == _owner;
587     }
588 
589     /**
590      * @dev Leaves the contract without owner. It will not be possible to call
591      * `onlyOwner` functions anymore. Can only be called by the current owner.
592      *
593      * NOTE: Renouncing ownership will leave the contract without an owner,
594      * thereby removing any functionality that is only available to the owner.
595      */
596     function renounceOwnership() public onlyOwner {
597         emit OwnershipTransferred(_owner, address(0));
598         _owner = address(0);
599     }
600 
601     /**
602      * @dev Transfers ownership of the contract to a new account (`newOwner`).
603      * Can only be called by the current owner.
604      */
605     function transferOwnership(address newOwner) public onlyOwner {
606         _transferOwnership(newOwner);
607     }
608 
609     /**
610      * @dev Transfers ownership of the contract to a new account (`newOwner`).
611      */
612     function _transferOwnership(address newOwner) internal {
613         require(newOwner != address(0), "Ownable: new owner is the zero address");
614         emit OwnershipTransferred(_owner, newOwner);
615         _owner = newOwner;
616     }
617 }
618 
619 // File: contracts\ControlledMinterRole.sol
620 
621 pragma solidity ^0.5.0;
622 
623 
624 
625 contract ControlledMinterRole is Ownable {
626     using Roles for Roles.Role;
627 
628     event MinterAdded(address indexed account);
629     event MinterRemoved(address indexed account);
630 
631     Roles.Role private _minters;
632 
633     constructor () internal {
634         _addMinter(_msgSender());
635     }
636 
637     modifier onlyMinter() {
638         require(isMinter(_msgSender()), "ControlledMinterRole: caller does not have the Minter role");
639         _;
640     }
641 
642     function isMinter(address account) public view returns (bool) {
643         return _minters.has(account);
644     }
645 
646     // onlyMinter -> onlyOwner
647     function addMinter(address account) public onlyOwner {
648         _addMinter(account);
649     }
650 
651     // Add require()
652     function renounceMinter() public {
653         require(!isOwner(), "ControlledMinterRole: owner cannot renounce MinterRole");
654         _removeMinter(_msgSender());
655     }
656 
657     // new function
658     function revokeMinter(address account) public onlyOwner {
659         require(account != owner(), "ControlledMinterRole: owner cannot renounce MinterRole");
660         _removeMinter(account);
661     }
662 
663     function _addMinter(address account) internal {
664         _minters.add(account);
665         emit MinterAdded(account);
666     }
667 
668     function _removeMinter(address account) internal {
669         _minters.remove(account);
670         emit MinterRemoved(account);
671     }
672 }
673 
674 // File: contracts\ControlledERC20Mintable.sol
675 
676 pragma solidity ^0.5.0;
677 
678 
679 
680 /**
681  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
682  * which have permission to mint (create) new tokens as they see fit.
683  *
684  * At construction, the deployer of the contract is the only minter.
685  */
686 contract ControlledERC20Mintable is ERC20, ControlledMinterRole {
687     /**
688      * @dev See {ERC20-_mint}.
689      *
690      * Requirements:
691      *
692      * - the caller must have the {MinterRole}.
693      */
694     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
695         _mint(account, amount);
696         return true;
697     }
698 }
699 
700 // File: contracts\USDRTether.sol
701 
702 pragma solidity ^0.5.0;
703 
704 
705 contract USDRTether is ControlledERC20Mintable {
706     using SafeMath for uint256;
707 
708     string public constant name = "USDR Tether";
709     string public constant symbol = "USDRT";
710     uint8  public constant decimals = 18;
711 
712     uint256 public constant INITIAL_SUPPLY  =    50000000 * (10 ** uint256(decimals));
713     uint256 public constant MAXIMUM_SUPPLY  = 10000000000 * (10 ** uint256(decimals));
714     uint256 public constant SUPPLY_MULTIPLE =    30000000 * (10 ** uint256(decimals));
715 
716     constructor()
717         public
718     {
719         _mint(_msgSender(), INITIAL_SUPPLY);
720     }
721 
722     function mint(address _account, uint256 _amount)
723         public
724         onlyMinter
725         returns (bool)
726     {
727         require(_account != address(0));
728         require(_amount > 0);
729         require(_amount.mod(SUPPLY_MULTIPLE) == 0, "Minting is only possible as a multiple of the SUPPLY_MULTIPLE variable.");
730         require(totalSupply() != MAXIMUM_SUPPLY, "Can't mint more than MAXIMUM_SUPPLY.");
731 
732         if(totalSupply().add(_amount) > MAXIMUM_SUPPLY) {
733             _amount = MAXIMUM_SUPPLY.sub(totalSupply());
734         }
735 
736         super.mint(_account, _amount);
737         return true;
738     }
739 
740     function mint(uint256 _amount)
741         public
742         onlyMinter
743         returns (bool)
744     {
745         require(_amount > 0);
746         require(_amount.mod(SUPPLY_MULTIPLE) == 0, "Minting is only possible as a multiple of the SUPPLY_MULTIPLE variable.");
747         require(totalSupply() != MAXIMUM_SUPPLY, "Can't mint more than MAXIMUM_SUPPLY.");
748 
749         if(totalSupply().add(_amount) > MAXIMUM_SUPPLY) {
750             _amount = MAXIMUM_SUPPLY.sub(totalSupply());
751         }
752 
753         super.mint(owner(), _amount);
754         return true;
755     }
756 
757     function mint()
758         public
759         onlyMinter
760         returns (bool)
761     {
762         require(totalSupply() != MAXIMUM_SUPPLY, "Can't mint more than MAXIMUM_SUPPLY.");
763 
764         uint256 _amount = SUPPLY_MULTIPLE;
765         if(totalSupply().add(_amount) > MAXIMUM_SUPPLY) {
766             _amount = MAXIMUM_SUPPLY.sub(totalSupply());
767         }
768 
769         super.mint(owner(), _amount);
770         return true;
771     }
772 
773     function renounceOwnership()
774         public
775         onlyOwner
776     {
777         revert("The owner cannot release ownership.");
778     }
779 
780     function transferOwnership(address newOwner)
781         public
782         onlyOwner
783     {
784         require(newOwner != address(0));
785         require(newOwner != owner());
786 
787         addMinter(newOwner);
788         super.transferOwnership(newOwner);
789         renounceMinter();
790     }
791 }