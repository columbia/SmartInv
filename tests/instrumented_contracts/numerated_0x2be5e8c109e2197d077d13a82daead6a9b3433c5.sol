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
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
116  * the optional functions; to access them see {ERC20Detailed}.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      *
245      * _Available since v2.4.0._
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      *
303      * _Available since v2.4.0._
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         // Solidity only automatically asserts when dividing by 0
307         require(b > 0, errorMessage);
308         uint256 c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      * - The divisor cannot be zero.
339      *
340      * _Available since v2.4.0._
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
349 
350 pragma solidity ^0.5.0;
351 
352 
353 
354 
355 /**
356  * @dev Implementation of the {IERC20} interface.
357  *
358  * This implementation is agnostic to the way tokens are created. This means
359  * that a supply mechanism has to be added in a derived contract using {_mint}.
360  * For a generic mechanism see {ERC20Mintable}.
361  *
362  * TIP: For a detailed writeup see our guide
363  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
364  * to implement supply mechanisms].
365  *
366  * We have followed general OpenZeppelin guidelines: functions revert instead
367  * of returning `false` on failure. This behavior is nonetheless conventional
368  * and does not conflict with the expectations of ERC20 applications.
369  *
370  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
371  * This allows applications to reconstruct the allowance for all accounts just
372  * by listening to said events. Other implementations of the EIP may not emit
373  * these events, as it isn't required by the specification.
374  *
375  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
376  * functions have been added to mitigate the well-known issues around setting
377  * allowances. See {IERC20-approve}.
378  */
379 contract ERC20 is Context, IERC20 {
380     using SafeMath for uint256;
381 
382     mapping (address => uint256) private _balances;
383 
384     mapping (address => mapping (address => uint256)) private _allowances;
385 
386     uint256 private _totalSupply;
387 
388     /**
389      * @dev See {IERC20-totalSupply}.
390      */
391     function totalSupply() public view returns (uint256) {
392         return _totalSupply;
393     }
394 
395     /**
396      * @dev See {IERC20-balanceOf}.
397      */
398     function balanceOf(address account) public view returns (uint256) {
399         return _balances[account];
400     }
401 
402     /**
403      * @dev See {IERC20-transfer}.
404      *
405      * Requirements:
406      *
407      * - `recipient` cannot be the zero address.
408      * - the caller must have a balance of at least `amount`.
409      */
410     function transfer(address recipient, uint256 amount) public returns (bool) {
411         _transfer(_msgSender(), recipient, amount);
412         return true;
413     }
414 
415     /**
416      * @dev See {IERC20-allowance}.
417      */
418     function allowance(address owner, address spender) public view returns (uint256) {
419         return _allowances[owner][spender];
420     }
421 
422     /**
423      * @dev See {IERC20-approve}.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function approve(address spender, uint256 amount) public returns (bool) {
430         _approve(_msgSender(), spender, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-transferFrom}.
436      *
437      * Emits an {Approval} event indicating the updated allowance. This is not
438      * required by the EIP. See the note at the beginning of {ERC20};
439      *
440      * Requirements:
441      * - `sender` and `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      * - the caller must have allowance for `sender`'s tokens of at least
444      * `amount`.
445      */
446     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
447         _transfer(sender, recipient, amount);
448         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
449         return true;
450     }
451 
452     /**
453      * @dev Atomically increases the allowance granted to `spender` by the caller.
454      *
455      * This is an alternative to {approve} that can be used as a mitigation for
456      * problems described in {IERC20-approve}.
457      *
458      * Emits an {Approval} event indicating the updated allowance.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
465         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
466         return true;
467     }
468 
469     /**
470      * @dev Atomically decreases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      * - `spender` must have allowance for the caller of at least
481      * `subtractedValue`.
482      */
483     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
484         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
485         return true;
486     }
487 
488     /**
489      * @dev Moves tokens `amount` from `sender` to `recipient`.
490      *
491      * This is internal function is equivalent to {transfer}, and can be used to
492      * e.g. implement automatic token fees, slashing mechanisms, etc.
493      *
494      * Emits a {Transfer} event.
495      *
496      * Requirements:
497      *
498      * - `sender` cannot be the zero address.
499      * - `recipient` cannot be the zero address.
500      * - `sender` must have a balance of at least `amount`.
501      */
502     function _transfer(address sender, address recipient, uint256 amount) internal {
503         require(sender != address(0), "ERC20: transfer from the zero address");
504         require(recipient != address(0), "ERC20: transfer to the zero address");
505 
506         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
507         _balances[recipient] = _balances[recipient].add(amount);
508         emit Transfer(sender, recipient, amount);
509     }
510 
511     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
512      * the total supply.
513      *
514      * Emits a {Transfer} event with `from` set to the zero address.
515      *
516      * Requirements
517      *
518      * - `to` cannot be the zero address.
519      */
520     function _mint(address account, uint256 amount) internal {
521         require(account != address(0), "ERC20: mint to the zero address");
522 
523         _totalSupply = _totalSupply.add(amount);
524         _balances[account] = _balances[account].add(amount);
525         emit Transfer(address(0), account, amount);
526     }
527 
528     /**
529      * @dev Destroys `amount` tokens from `account`, reducing the
530      * total supply.
531      *
532      * Emits a {Transfer} event with `to` set to the zero address.
533      *
534      * Requirements
535      *
536      * - `account` cannot be the zero address.
537      * - `account` must have at least `amount` tokens.
538      */
539     function _burn(address account, uint256 amount) internal {
540         require(account != address(0), "ERC20: burn from the zero address");
541 
542         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
543         _totalSupply = _totalSupply.sub(amount);
544         emit Transfer(account, address(0), amount);
545     }
546 
547     /**
548      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
549      *
550      * This is internal function is equivalent to `approve`, and can be used to
551      * e.g. set automatic allowances for certain subsystems, etc.
552      *
553      * Emits an {Approval} event.
554      *
555      * Requirements:
556      *
557      * - `owner` cannot be the zero address.
558      * - `spender` cannot be the zero address.
559      */
560     function _approve(address owner, address spender, uint256 amount) internal {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563 
564         _allowances[owner][spender] = amount;
565         emit Approval(owner, spender, amount);
566     }
567 
568     /**
569      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
570      * from the caller's allowance.
571      *
572      * See {_burn} and {_approve}.
573      */
574     function _burnFrom(address account, uint256 amount) internal {
575         _burn(account, amount);
576         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
577     }
578 }
579 
580 // File: openzeppelin-solidity/contracts/access/Roles.sol
581 
582 pragma solidity ^0.5.0;
583 
584 /**
585  * @title Roles
586  * @dev Library for managing addresses assigned to a Role.
587  */
588 library Roles {
589     struct Role {
590         mapping (address => bool) bearer;
591     }
592 
593     /**
594      * @dev Give an account access to this role.
595      */
596     function add(Role storage role, address account) internal {
597         require(!has(role, account), "Roles: account already has role");
598         role.bearer[account] = true;
599     }
600 
601     /**
602      * @dev Remove an account's access to this role.
603      */
604     function remove(Role storage role, address account) internal {
605         require(has(role, account), "Roles: account does not have role");
606         role.bearer[account] = false;
607     }
608 
609     /**
610      * @dev Check if an account has this role.
611      * @return bool
612      */
613     function has(Role storage role, address account) internal view returns (bool) {
614         require(account != address(0), "Roles: account is the zero address");
615         return role.bearer[account];
616     }
617 }
618 
619 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
620 
621 pragma solidity ^0.5.0;
622 
623 
624 
625 contract MinterRole is Context {
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
638         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
639         _;
640     }
641 
642     function isMinter(address account) public view returns (bool) {
643         return _minters.has(account);
644     }
645 
646     function addMinter(address account) public onlyMinter {
647         _addMinter(account);
648     }
649 
650     function renounceMinter() public {
651         _removeMinter(_msgSender());
652     }
653 
654     function _addMinter(address account) internal {
655         _minters.add(account);
656         emit MinterAdded(account);
657     }
658 
659     function _removeMinter(address account) internal {
660         _minters.remove(account);
661         emit MinterRemoved(account);
662     }
663 }
664 
665 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
666 
667 pragma solidity ^0.5.0;
668 
669 
670 
671 /**
672  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
673  * which have permission to mint (create) new tokens as they see fit.
674  *
675  * At construction, the deployer of the contract is the only minter.
676  */
677 contract ERC20Mintable is ERC20, MinterRole {
678     /**
679      * @dev See {ERC20-_mint}.
680      *
681      * Requirements:
682      *
683      * - the caller must have the {MinterRole}.
684      */
685     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
686         _mint(account, amount);
687         return true;
688     }
689 }
690 
691 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
692 
693 pragma solidity ^0.5.0;
694 
695 
696 /**
697  * @dev Optional functions from the ERC20 standard.
698  */
699 contract ERC20Detailed is IERC20 {
700     string private _name;
701     string private _symbol;
702     uint8 private _decimals;
703 
704     /**
705      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
706      * these values are immutable: they can only be set once during
707      * construction.
708      */
709     constructor (string memory name, string memory symbol, uint8 decimals) public {
710         _name = name;
711         _symbol = symbol;
712         _decimals = decimals;
713     }
714 
715     /**
716      * @dev Returns the name of the token.
717      */
718     function name() public view returns (string memory) {
719         return _name;
720     }
721 
722     /**
723      * @dev Returns the symbol of the token, usually a shorter version of the
724      * name.
725      */
726     function symbol() public view returns (string memory) {
727         return _symbol;
728     }
729 
730     /**
731      * @dev Returns the number of decimals used to get its user representation.
732      * For example, if `decimals` equals `2`, a balance of `505` tokens should
733      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
734      *
735      * Tokens usually opt for a value of 18, imitating the relationship between
736      * Ether and Wei.
737      *
738      * NOTE: This information is only used for _display_ purposes: it in
739      * no way affects any of the arithmetic of the contract, including
740      * {IERC20-balanceOf} and {IERC20-transfer}.
741      */
742     function decimals() public view returns (uint8) {
743         return _decimals;
744     }
745 }
746 
747 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
748 
749 pragma solidity ^0.5.10;
750 
751 /**
752  * @dev Library used to query support of an interface declared via {IERC165}.
753  *
754  * Note that these functions return the actual result of the query: they do not
755  * `revert` if an interface is not supported. It is up to the caller to decide
756  * what to do in these cases.
757  */
758 library ERC165Checker {
759     // As per the EIP-165 spec, no interface should ever match 0xffffffff
760     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
761 
762     /*
763      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
764      */
765     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
766 
767     /**
768      * @dev Returns true if `account` supports the {IERC165} interface,
769      */
770     function _supportsERC165(address account) internal view returns (bool) {
771         // Any contract that implements ERC165 must explicitly indicate support of
772         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
773         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
774             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
775     }
776 
777     /**
778      * @dev Returns true if `account` supports the interface defined by
779      * `interfaceId`. Support for {IERC165} itself is queried automatically.
780      *
781      * See {IERC165-supportsInterface}.
782      */
783     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
784         // query support of both ERC165 as per the spec and support of _interfaceId
785         return _supportsERC165(account) &&
786             _supportsERC165Interface(account, interfaceId);
787     }
788 
789     /**
790      * @dev Returns true if `account` supports all the interfaces defined in
791      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
792      *
793      * Batch-querying can lead to gas savings by skipping repeated checks for
794      * {IERC165} support.
795      *
796      * See {IERC165-supportsInterface}.
797      */
798     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
799         // query support of ERC165 itself
800         if (!_supportsERC165(account)) {
801             return false;
802         }
803 
804         // query support of each interface in _interfaceIds
805         for (uint256 i = 0; i < interfaceIds.length; i++) {
806             if (!_supportsERC165Interface(account, interfaceIds[i])) {
807                 return false;
808             }
809         }
810 
811         // all interfaces supported
812         return true;
813     }
814 
815     /**
816      * @notice Query if a contract implements an interface, does not check ERC165 support
817      * @param account The address of the contract to query for support of an interface
818      * @param interfaceId The interface identifier, as specified in ERC-165
819      * @return true if the contract at account indicates support of the interface with
820      * identifier interfaceId, false otherwise
821      * @dev Assumes that account contains a contract that supports ERC165, otherwise
822      * the behavior of this method is undefined. This precondition can be checked
823      * with the `supportsERC165` method in this library.
824      * Interface identification is specified in ERC-165.
825      */
826     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
827         // success determines whether the staticcall succeeded and result determines
828         // whether the contract at account indicates support of _interfaceId
829         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
830 
831         return (success && result);
832     }
833 
834     /**
835      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
836      * @param account The address of the contract to query for support of an interface
837      * @param interfaceId The interface identifier, as specified in ERC-165
838      * @return success true if the STATICCALL succeeded, false otherwise
839      * @return result true if the STATICCALL succeeded and the contract at account
840      * indicates support of the interface with identifier interfaceId, false otherwise
841      */
842     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
843         private
844         view
845         returns (bool, bool)
846     {
847         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
848         (bool success, bytes memory result) = account.staticcall.gas(30000)(encodedParams);
849         if (result.length < 32) return (false, false);
850         return (success, abi.decode(result, (bool)));
851     }
852 }
853 
854 // File: contracts/stake/interfaces/SeigManagerI.sol
855 
856 pragma solidity ^0.5.12;
857 
858 
859 interface SeigManagerI {
860   function registry() external view returns (address);
861   function depositManager() external view returns (address);
862   function ton() external view returns (address);
863   function wton() external view returns (address);
864   function powerton() external view returns (address);
865   function tot() external view returns (address);
866   function coinages(address rootchain) external view returns (address);
867   function commissionRates(address rootchain) external view returns (uint256);
868 
869   function lastCommitBlock(address rootchain) external view returns (uint256);
870   function seigPerBlock() external view returns (uint256);
871   function lastSeigBlock() external view returns (uint256);
872   function pausedBlock() external view returns (uint256);
873   function unpausedBlock() external view returns (uint256);
874   function DEFAULT_FACTOR() external view returns (uint256);
875 
876   function deployCoinage(address rootchain) external returns (bool);
877   function setCommissionRate(address rootchain, uint256 commission, bool isCommissionRateNegative) external returns (bool);
878 
879   function uncomittedStakeOf(address rootchain, address account) external view returns (uint256);
880   function stakeOf(address rootchain, address account) external view returns (uint256);
881   function additionalTotBurnAmount(address rootchain, address account, uint256 amount) external view returns (uint256 totAmount);
882 
883   function onTransfer(address sender, address recipient, uint256 amount) external returns (bool);
884   function onCommit() external returns (bool);
885   function onDeposit(address rootchain, address account, uint256 amount) external returns (bool);
886   function onWithdraw(address rootchain, address account, uint256 amount) external returns (bool);
887 
888 }
889 
890 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
891 
892 pragma solidity ^0.5.0;
893 
894 /**
895  * @dev Interface of the ERC165 standard, as defined in the
896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
897  *
898  * Implementers can declare support of contract interfaces, which can then be
899  * queried by others ({ERC165Checker}).
900  *
901  * For an implementation, see {ERC165}.
902  */
903 interface IERC165 {
904     /**
905      * @dev Returns true if this contract implements the interface defined by
906      * `interfaceId`. See the corresponding
907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
908      * to learn more about how these ids are created.
909      *
910      * This function call must use less than 30 000 gas.
911      */
912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
913 }
914 
915 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
916 
917 pragma solidity ^0.5.0;
918 
919 
920 /**
921  * @dev Implementation of the {IERC165} interface.
922  *
923  * Contracts may inherit from this and call {_registerInterface} to declare
924  * their support of an interface.
925  */
926 contract ERC165 is IERC165 {
927     /*
928      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
929      */
930     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
931 
932     /**
933      * @dev Mapping of interface ids to whether or not it's supported.
934      */
935     mapping(bytes4 => bool) private _supportedInterfaces;
936 
937     constructor () internal {
938         // Derived contracts need only register support for their own interfaces,
939         // we register support for ERC165 itself here
940         _registerInterface(_INTERFACE_ID_ERC165);
941     }
942 
943     /**
944      * @dev See {IERC165-supportsInterface}.
945      *
946      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
947      */
948     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
949         return _supportedInterfaces[interfaceId];
950     }
951 
952     /**
953      * @dev Registers the contract as an implementer of the interface defined by
954      * `interfaceId`. Support of the actual ERC165 interface is automatic and
955      * registering its interface id is not required.
956      *
957      * See {IERC165-supportsInterface}.
958      *
959      * Requirements:
960      *
961      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
962      */
963     function _registerInterface(bytes4 interfaceId) internal {
964         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
965         _supportedInterfaces[interfaceId] = true;
966     }
967 }
968 
969 // File: contracts/stake/tokens/OnApprove.sol
970 
971 pragma solidity ^0.5.12;
972 
973 
974 contract OnApprove is ERC165 {
975   constructor() public {
976     _registerInterface(OnApprove(this).onApprove.selector);
977   }
978 
979   function onApprove(address owner, address spender, uint256 amount, bytes calldata data) external returns (bool);
980 }
981 
982 // File: contracts/stake/tokens/ERC20OnApprove.sol
983 
984 pragma solidity ^0.5.12;
985 
986 
987 
988 
989 
990 contract ERC20OnApprove is ERC20 {
991   function approveAndCall(address spender, uint256 amount, bytes memory data) public returns (bool) {
992     require(approve(spender, amount));
993     _callOnApprove(msg.sender, spender, amount, data);
994     return true;
995   }
996 
997   function _callOnApprove(address owner, address spender, uint256 amount, bytes memory data) internal {
998     bytes4 onApproveSelector = OnApprove(spender).onApprove.selector;
999 
1000     require(ERC165Checker._supportsInterface(spender, onApproveSelector),
1001       "ERC20OnApprove: spender doesn't support onApprove");
1002 
1003     (bool ok, bytes memory res) = spender.call(
1004       abi.encodeWithSelector(
1005         onApproveSelector,
1006         owner,
1007         spender,
1008         amount,
1009         data
1010       )
1011     );
1012 
1013     // check if low-level call reverted or not
1014     require(ok, string(res));
1015 
1016     assembly {
1017       ok := mload(add(res, 0x20))
1018     }
1019 
1020     // check if OnApprove.onApprove returns true or false
1021     require(ok, "ERC20OnApprove: failed to call onApprove");
1022   }
1023 
1024 }
1025 
1026 // File: contracts/stake/tokens/AuthController.sol
1027 
1028 pragma solidity ^0.5.12;
1029 
1030 
1031 
1032 interface MinterRoleRenounceTarget {
1033   function renounceMinter() external;
1034 }
1035 
1036 interface PauserRoleRenounceTarget {
1037   function renouncePauser() external;
1038 }
1039 
1040 interface OwnableTarget {
1041   function renounceOwnership() external;
1042   function transferOwnership(address newOwner) external;
1043 }
1044 
1045 contract AuthController is Ownable {
1046   function renounceMinter(address target) public onlyOwner {
1047     MinterRoleRenounceTarget(target).renounceMinter();
1048   }
1049 
1050   function renouncePauser(address target) public onlyOwner {
1051     PauserRoleRenounceTarget(target).renouncePauser();
1052   }
1053 
1054   function renounceOwnership(address target) public onlyOwner {
1055     OwnableTarget(target).renounceOwnership();
1056   }
1057 
1058   function transferOwnership(address target, address newOwner) public onlyOwner {
1059     OwnableTarget(target).transferOwnership(newOwner);
1060   }
1061 }
1062 
1063 // File: contracts/stake/tokens/SeigToken.sol
1064 
1065 pragma solidity ^0.5.12;
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 contract SeigToken is ERC20, Ownable, ERC20OnApprove, AuthController {
1074   SeigManagerI public seigManager;
1075   bool public callbackEnabled;
1076 
1077   function enableCallback(bool _callbackEnabled) external onlyOwner {
1078     callbackEnabled = _callbackEnabled;
1079   }
1080 
1081   function setSeigManager(SeigManagerI _seigManager) external onlyOwner {
1082     seigManager = _seigManager;
1083   }
1084 
1085   //////////////////////
1086   // Override ERC20 functions
1087   //////////////////////
1088 
1089   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1090     require(msg.sender == sender || msg.sender == recipient, "SeigToken: only sender or recipient can transfer");
1091     return super.transferFrom(sender, recipient, amount);
1092   }
1093 
1094   function _transfer(address sender, address recipient, uint256 amount) internal {
1095     super._transfer(sender, recipient, amount);
1096     if (callbackEnabled && address(seigManager) != address(0)) {
1097       require(seigManager.onTransfer(sender, recipient, amount));
1098     }
1099   }
1100 
1101   function _mint(address account, uint256 amount) internal {
1102     super._mint(account, amount);
1103     if (callbackEnabled && address(seigManager) != address(0)) {
1104       require(seigManager.onTransfer(address(0), account, amount));
1105     }
1106   }
1107 
1108   function _burn(address account, uint256 amount) internal {
1109     super._burn(account, amount);
1110     if (callbackEnabled && address(seigManager) != address(0)) {
1111       require(seigManager.onTransfer(account, address(0), amount));
1112     }
1113   }
1114 }
1115 
1116 // File: contracts/stake/tokens/TON.sol
1117 
1118 pragma solidity ^0.5.12;
1119 
1120 
1121 
1122 
1123 
1124 
1125 
1126 
1127 /**
1128  * @dev Current implementations is just for testing seigniorage manager.
1129  */
1130 contract TON is Ownable, ERC20Mintable, ERC20Detailed, SeigToken {
1131   constructor() public ERC20Detailed("Tokamak Network Token", "TON", 18) {}
1132 
1133   function setSeigManager(SeigManagerI _seigManager) external {
1134     revert("TON: TON doesn't allow setSeigManager");
1135   }
1136 }