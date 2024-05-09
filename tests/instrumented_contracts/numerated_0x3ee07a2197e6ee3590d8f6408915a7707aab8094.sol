1 pragma solidity >=0.5.12;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 contract Context {
170     // Empty internal constructor, to prevent people from mistakenly deploying
171     // an instance of this contract, which should be used via inheritance.
172     constructor () internal { }
173     // solhint-disable-previous-line no-empty-blocks
174 
175     function _msgSender() internal view returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 /**
186  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
187  * the optional functions; to access them see {ERC20Detailed}.
188  */
189 interface IERC20 {
190     /**
191      * @dev Returns the amount of tokens in existence.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transfer(address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through {transferFrom}. This is
212      * zero by default.
213      *
214      * This value changes when {approve} or {transferFrom} are called.
215      */
216     function allowance(address owner, address spender) external view returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to {approve}. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 /**
261  * @dev Implementation of the {IERC20} interface.
262  *
263  * This implementation is agnostic to the way tokens are created. This means
264  * that a supply mechanism has to be added in a derived contract using {_mint}.
265  * For a generic mechanism see {ERC20Mintable}.
266  *
267  * TIP: For a detailed writeup see our guide
268  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
269  * to implement supply mechanisms].
270  *
271  * We have followed general OpenZeppelin guidelines: functions revert instead
272  * of returning `false` on failure. This behavior is nonetheless conventional
273  * and does not conflict with the expectations of ERC20 applications.
274  *
275  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
276  * This allows applications to reconstruct the allowance for all accounts just
277  * by listening to said events. Other implementations of the EIP may not emit
278  * these events, as it isn't required by the specification.
279  *
280  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
281  * functions have been added to mitigate the well-known issues around setting
282  * allowances. See {IERC20-approve}.
283  */
284 contract ERC20 is Context, IERC20 {
285     using SafeMath for uint256;
286 
287     mapping (address => uint256) private _balances;
288 
289     mapping (address => mapping (address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount) public returns (bool) {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-allowance}.
322      */
323     function allowance(address owner, address spender) public view returns (uint256) {
324         return _allowances[owner][spender];
325     }
326 
327     /**
328      * @dev See {IERC20-approve}.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public returns (bool) {
335         _approve(_msgSender(), spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20};
344      *
345      * Requirements:
346      * - `sender` and `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      * - the caller must have allowance for `sender`'s tokens of at least
349      * `amount`.
350      */
351     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
352         _transfer(sender, recipient, amount);
353         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
371         return true;
372     }
373 
374     /**
375      * @dev Atomically decreases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      * - `spender` must have allowance for the caller of at least
386      * `subtractedValue`.
387      */
388     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
389         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
390         return true;
391     }
392 
393     /**
394      * @dev Moves tokens `amount` from `sender` to `recipient`.
395      *
396      * This is internal function is equivalent to {transfer}, and can be used to
397      * e.g. implement automatic token fees, slashing mechanisms, etc.
398      *
399      * Emits a {Transfer} event.
400      *
401      * Requirements:
402      *
403      * - `sender` cannot be the zero address.
404      * - `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      */
407     function _transfer(address sender, address recipient, uint256 amount) internal {
408         require(sender != address(0), "ERC20: transfer from the zero address");
409         require(recipient != address(0), "ERC20: transfer to the zero address");
410 
411         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
412         _balances[recipient] = _balances[recipient].add(amount);
413         emit Transfer(sender, recipient, amount);
414     }
415 
416     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
417      * the total supply.
418      *
419      * Emits a {Transfer} event with `from` set to the zero address.
420      *
421      * Requirements
422      *
423      * - `to` cannot be the zero address.
424      */
425     function _mint(address account, uint256 amount) internal {
426         require(account != address(0), "ERC20: mint to the zero address");
427 
428         _totalSupply = _totalSupply.add(amount);
429         _balances[account] = _balances[account].add(amount);
430         emit Transfer(address(0), account, amount);
431     }
432 
433     /**
434      * @dev Destroys `amount` tokens from `account`, reducing the
435      * total supply.
436      *
437      * Emits a {Transfer} event with `to` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `account` cannot be the zero address.
442      * - `account` must have at least `amount` tokens.
443      */
444     function _burn(address account, uint256 amount) internal {
445         require(account != address(0), "ERC20: burn from the zero address");
446 
447         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
448         _totalSupply = _totalSupply.sub(amount);
449         emit Transfer(account, address(0), amount);
450     }
451 
452     /**
453      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
454      *
455      * This is internal function is equivalent to `approve`, and can be used to
456      * e.g. set automatic allowances for certain subsystems, etc.
457      *
458      * Emits an {Approval} event.
459      *
460      * Requirements:
461      *
462      * - `owner` cannot be the zero address.
463      * - `spender` cannot be the zero address.
464      */
465     function _approve(address owner, address spender, uint256 amount) internal {
466         require(owner != address(0), "ERC20: approve from the zero address");
467         require(spender != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[owner][spender] = amount;
470         emit Approval(owner, spender, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
475      * from the caller's allowance.
476      *
477      * See {_burn} and {_approve}.
478      */
479     function _burnFrom(address account, uint256 amount) internal {
480         _burn(account, amount);
481         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
482     }
483 }
484 
485 /**
486  * @dev Optional functions from the ERC20 standard.
487  */
488 contract ERC20Detailed is IERC20 {
489     string private _name;
490     string private _symbol;
491     uint8 private _decimals;
492 
493     /**
494      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
495      * these values are immutable: they can only be set once during
496      * construction.
497      */
498     constructor (string memory name, string memory symbol, uint8 decimals) public {
499         _name = name;
500         _symbol = symbol;
501         _decimals = decimals;
502     }
503 
504     /**
505      * @dev Returns the name of the token.
506      */
507     function name() public view returns (string memory) {
508         return _name;
509     }
510 
511     /**
512      * @dev Returns the symbol of the token, usually a shorter version of the
513      * name.
514      */
515     function symbol() public view returns (string memory) {
516         return _symbol;
517     }
518 
519     /**
520      * @dev Returns the number of decimals used to get its user representation.
521      * For example, if `decimals` equals `2`, a balance of `505` tokens should
522      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
523      *
524      * Tokens usually opt for a value of 18, imitating the relationship between
525      * Ether and Wei.
526      *
527      * NOTE: This information is only used for _display_ purposes: it in
528      * no way affects any of the arithmetic of the contract, including
529      * {IERC20-balanceOf} and {IERC20-transfer}.
530      */
531     function decimals() public view returns (uint8) {
532         return _decimals;
533     }
534 }
535 
536 /**
537  * @title Roles
538  * @dev Library for managing addresses assigned to a Role.
539  */
540 library Roles {
541     struct Role {
542         mapping (address => bool) bearer;
543     }
544 
545     /**
546      * @dev Give an account access to this role.
547      */
548     function add(Role storage role, address account) internal {
549         require(!has(role, account), "Roles: account already has role");
550         role.bearer[account] = true;
551     }
552 
553     /**
554      * @dev Remove an account's access to this role.
555      */
556     function remove(Role storage role, address account) internal {
557         require(has(role, account), "Roles: account does not have role");
558         role.bearer[account] = false;
559     }
560 
561     /**
562      * @dev Check if an account has this role.
563      * @return bool
564      */
565     function has(Role storage role, address account) internal view returns (bool) {
566         require(account != address(0), "Roles: account is the zero address");
567         return role.bearer[account];
568     }
569 }
570 
571 contract MinterRole is Context {
572     using Roles for Roles.Role;
573 
574     event MinterAdded(address indexed account);
575     event MinterRemoved(address indexed account);
576 
577     Roles.Role private _minters;
578 
579     constructor () internal {
580         _addMinter(_msgSender());
581     }
582 
583     modifier onlyMinter() {
584         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
585         _;
586     }
587 
588     function isMinter(address account) public view returns (bool) {
589         return _minters.has(account);
590     }
591 
592     function addMinter(address account) public onlyMinter {
593         _addMinter(account);
594     }
595 
596     function renounceMinter() public {
597         _removeMinter(_msgSender());
598     }
599 
600     function _addMinter(address account) internal {
601         _minters.add(account);
602         emit MinterAdded(account);
603     }
604 
605     function _removeMinter(address account) internal {
606         _minters.remove(account);
607         emit MinterRemoved(account);
608     }
609 }
610 
611 /**
612  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
613  * which have permission to mint (create) new tokens as they see fit.
614  *
615  * At construction, the deployer of the contract is the only minter.
616  */
617 contract ERC20Mintable is ERC20, MinterRole {
618     /**
619      * @dev See {ERC20-_mint}.
620      *
621      * Requirements:
622      *
623      * - the caller must have the {MinterRole}.
624      */
625     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
626         _mint(account, amount);
627         return true;
628     }
629 }
630 
631 /**
632  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
633  */
634 contract ERC20Capped is ERC20Mintable {
635     uint256 private _cap;
636 
637     /**
638      * @dev Sets the value of the `cap`. This value is immutable, it can only be
639      * set once during construction.
640      */
641     constructor (uint256 cap) public {
642         require(cap > 0, "ERC20Capped: cap is 0");
643         _cap = cap;
644     }
645 
646     /**
647      * @dev Returns the cap on the token's total supply.
648      */
649     function cap() public view returns (uint256) {
650         return _cap;
651     }
652 
653     /**
654      * @dev See {ERC20Mintable-mint}.
655      *
656      * Requirements:
657      *
658      * - `value` must not cause the total supply to go over the cap.
659      */
660     function _mint(address account, uint256 value) internal {
661         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
662         super._mint(account, value);
663     }
664 }
665 
666 /**
667  * @dev Contract module which provides a basic access control mechanism, where
668  * there is an account (an owner) that can be granted exclusive access to
669  * specific functions.
670  *
671  * This module is used through inheritance. It will make available the modifier
672  * `onlyOwner`, which can be applied to your functions to restrict their use to
673  * the owner.
674  */
675 contract Ownable is Context {
676     address private _owner;
677 
678     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
679 
680     /**
681      * @dev Initializes the contract setting the deployer as the initial owner.
682      */
683     constructor () internal {
684         address msgSender = _msgSender();
685         _owner = msgSender;
686         emit OwnershipTransferred(address(0), msgSender);
687     }
688 
689     /**
690      * @dev Returns the address of the current owner.
691      */
692     function owner() public view returns (address) {
693         return _owner;
694     }
695 
696     /**
697      * @dev Throws if called by any account other than the owner.
698      */
699     modifier onlyOwner() {
700         require(isOwner(), "Ownable: caller is not the owner");
701         _;
702     }
703 
704     /**
705      * @dev Returns true if the caller is the current owner.
706      */
707     function isOwner() public view returns (bool) {
708         return _msgSender() == _owner;
709     }
710 
711     /**
712      * @dev Leaves the contract without owner. It will not be possible to call
713      * `onlyOwner` functions anymore. Can only be called by the current owner.
714      *
715      * NOTE: Renouncing ownership will leave the contract without an owner,
716      * thereby removing any functionality that is only available to the owner.
717      */
718     function renounceOwnership() public onlyOwner {
719         emit OwnershipTransferred(_owner, address(0));
720         _owner = address(0);
721     }
722 
723     /**
724      * @dev Transfers ownership of the contract to a new account (`newOwner`).
725      * Can only be called by the current owner.
726      */
727     function transferOwnership(address newOwner) public onlyOwner {
728         _transferOwnership(newOwner);
729     }
730 
731     /**
732      * @dev Transfers ownership of the contract to a new account (`newOwner`).
733      */
734     function _transferOwnership(address newOwner) internal {
735         require(newOwner != address(0), "Ownable: new owner is the zero address");
736         emit OwnershipTransferred(_owner, newOwner);
737         _owner = newOwner;
738     }
739 }
740 
741 contract MatterToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Capped, Ownable {
742 	/// @notice The daily allowed MTR to be minted
743 	uint256 public mintableDaily;
744 
745 	constructor() public ERC20Detailed("Matter", "MTR", 18) ERC20Capped(433494437 * 1e18) {
746 		mintableDaily = 1000 * 1e18;
747 	}
748 
749 	function removeMinter(address account) public onlyOwner {
750 		_removeMinter(account);
751 	}
752 }
753 
754 contract MatterMinter {
755 	using SafeMath for uint256;
756 
757 	/// @notice More than this much time must pass between mint operations.
758 	uint256 public minMintTimeIntervalSec;
759 
760 	/// @notice Block timestamp of last mint operation
761 	uint256 public lastMintTimestampSec;
762 
763 	/// @notice The mint window begins this many seconds into the minMintTimeInterval period.
764 	uint256 public mintWindowOffsetSec;
765 
766 	/// @notice The length of the time window where a mint operation is allowed to execute, in seconds.
767 	uint256 public mintWindowLengthSec;
768 
769 	/// @notice The number of mint cycles since inception
770 	uint256 public epoch;
771 
772 	/// @notice The address to mint new tokens
773 	address public mintAddress;
774 
775 	/// @notice The MTR token address
776 	address public mtrAddress;
777 
778 	/// @notice The DEN Multisig
779 	address public denMultiSig;
780 
781 	event Mint(uint256 epoch, uint256 amount);
782 
783 	constructor(
784 		uint256 _firstIssuedTimeStamp,
785 		address _mtrAddress,
786 		address _mintAddress
787 	) public {
788 		lastMintTimestampSec = _firstIssuedTimeStamp;
789 		mtrAddress = _mtrAddress;
790 		mintAddress = _mintAddress;
791 		denMultiSig = msg.sender;
792 		minMintTimeIntervalSec = 24 hours;
793 		mintWindowOffsetSec = 0; // 12 AM UTC mint
794 		mintWindowLengthSec = 3 * 60 * 60; // 180 minutes
795 	}
796 
797 	modifier onlyDenMultiSig {
798 		require(msg.sender == denMultiSig, "not owner");
799 		_;
800 	}
801 
802 	/*
803 	 * @notice Get last minted block timestamp
804 	 */
805 	function lastMinted() public view returns (uint256) {
806 		return lastMintTimestampSec;
807 	}
808 
809 	/*
810 	 * @notice set mint address
811 	 * @notice must be den multisig
812 	 * @param _address The new mint address where freshly minted MTR will be sent
813 	 */
814 	function setMintAddress(address _address) public onlyDenMultiSig {
815 		mintAddress = _address;
816 	}
817 
818 	/**
819 	 * @return If the latest block timestamp is within the mint time window it, returns true.
820 	 *         Otherwise, returns false.
821 	 */
822 	function inMintWindow() public view returns (bool) {
823 		_inMintWindow();
824 		return true;
825 	}
826 
827 	function _inMintWindow() internal view {
828 		require(now.mod(minMintTimeIntervalSec) >= mintWindowOffsetSec, "too early");
829 		require(now.mod(minMintTimeIntervalSec) < (mintWindowOffsetSec.add(mintWindowLengthSec)), "too late");
830 	}
831 
832 	/*
833 	 * @notice Time-based function that only allows callers to mint if a certain amount of time has passed
834 	 * @notice and only if the transaction was created in the valid mint window
835 	 */
836 	function mint() public {
837 		// ensure minting at correct time
838 		_inMintWindow();
839 
840 		// This comparison also ensures there is no reentrancy.
841 		require(lastMintTimestampSec.add(minMintTimeIntervalSec) < now);
842 
843 		uint256 previousMintTimestampSec = lastMintTimestampSec;
844 		// Snap the mint time to the start of this window.
845 		lastMintTimestampSec = now.sub(now.mod(minMintTimeIntervalSec)).add(mintWindowOffsetSec);
846 
847 		uint256 mintMultiplier = lastMintTimestampSec.sub(previousMintTimestampSec) / 1 days;
848 		epoch = epoch.add(mintMultiplier);
849 
850 		MatterToken mtr = MatterToken(mtrAddress);
851 		uint256 mintAmount = mtr.mintableDaily().mul(mintMultiplier);
852 		bool minted = mtr.mint(mintAddress, mintAmount);
853 		require(minted, "error occurred while minting");
854 		emit Mint(epoch, mintAmount);
855 	}
856 
857 	function changeMultiSig(address _denMultiSig) external onlyDenMultiSig {
858 		denMultiSig = _denMultiSig;
859 	}
860 }