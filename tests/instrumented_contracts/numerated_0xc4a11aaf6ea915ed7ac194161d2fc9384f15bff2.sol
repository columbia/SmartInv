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
110 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
269 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 /**
274  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
275  * the optional functions; to access them see {ERC20Detailed}.
276  */
277 interface IERC20 {
278     /**
279      * @dev Returns the amount of tokens in existence.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     /**
284      * @dev Returns the amount of tokens owned by `account`.
285      */
286     function balanceOf(address account) external view returns (uint256);
287 
288     /**
289      * @dev Moves `amount` tokens from the caller's account to `recipient`.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transfer(address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Returns the remaining number of tokens that `spender` will be
299      * allowed to spend on behalf of `owner` through {transferFrom}. This is
300      * zero by default.
301      *
302      * This value changes when {approve} or {transferFrom} are called.
303      */
304     function allowance(address owner, address spender) external view returns (uint256);
305 
306     /**
307      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * IMPORTANT: Beware that changing an allowance with this method brings the risk
312      * that someone may use both the old and the new allowance by unfortunate
313      * transaction ordering. One possible solution to mitigate this race
314      * condition is to first reduce the spender's allowance to 0 and set the
315      * desired value afterwards:
316      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address spender, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Moves `amount` tokens from `sender` to `recipient` using the
324      * allowance mechanism. `amount` is then deducted from the caller's
325      * allowance.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Emitted when `value` tokens are moved from one account (`from`) to
335      * another (`to`).
336      *
337      * Note that `value` may be zero.
338      */
339     event Transfer(address indexed from, address indexed to, uint256 value);
340 
341     /**
342      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
343      * a call to {approve}. `value` is the new allowance.
344      */
345     event Approval(address indexed owner, address indexed spender, uint256 value);
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
691 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
692 
693 pragma solidity ^0.5.0;
694 
695 
696 
697 /**
698  * @dev Extension of {ERC20} that allows token holders to destroy both their own
699  * tokens and those that they have an allowance for, in a way that can be
700  * recognized off-chain (via event analysis).
701  */
702 contract ERC20Burnable is Context, ERC20 {
703     /**
704      * @dev Destroys `amount` tokens from the caller.
705      *
706      * See {ERC20-_burn}.
707      */
708     function burn(uint256 amount) public {
709         _burn(_msgSender(), amount);
710     }
711 
712     /**
713      * @dev See {ERC20-_burnFrom}.
714      */
715     function burnFrom(address account, uint256 amount) public {
716         _burnFrom(account, amount);
717     }
718 }
719 
720 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
721 
722 pragma solidity ^0.5.0;
723 
724 
725 /**
726  * @dev Optional functions from the ERC20 standard.
727  */
728 contract ERC20Detailed is IERC20 {
729     string private _name;
730     string private _symbol;
731     uint8 private _decimals;
732 
733     /**
734      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
735      * these values are immutable: they can only be set once during
736      * construction.
737      */
738     constructor (string memory name, string memory symbol, uint8 decimals) public {
739         _name = name;
740         _symbol = symbol;
741         _decimals = decimals;
742     }
743 
744     /**
745      * @dev Returns the name of the token.
746      */
747     function name() public view returns (string memory) {
748         return _name;
749     }
750 
751     /**
752      * @dev Returns the symbol of the token, usually a shorter version of the
753      * name.
754      */
755     function symbol() public view returns (string memory) {
756         return _symbol;
757     }
758 
759     /**
760      * @dev Returns the number of decimals used to get its user representation.
761      * For example, if `decimals` equals `2`, a balance of `505` tokens should
762      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
763      *
764      * Tokens usually opt for a value of 18, imitating the relationship between
765      * Ether and Wei.
766      *
767      * NOTE: This information is only used for _display_ purposes: it in
768      * no way affects any of the arithmetic of the contract, including
769      * {IERC20-balanceOf} and {IERC20-transfer}.
770      */
771     function decimals() public view returns (uint8) {
772         return _decimals;
773     }
774 }
775 
776 // File: openzeppelin-solidity/contracts/utils/Address.sol
777 
778 pragma solidity ^0.5.5;
779 
780 /**
781  * @dev Collection of functions related to the address type
782  */
783 library Address {
784     /**
785      * @dev Returns true if `account` is a contract.
786      *
787      * [IMPORTANT]
788      * ====
789      * It is unsafe to assume that an address for which this function returns
790      * false is an externally-owned account (EOA) and not a contract.
791      *
792      * Among others, `isContract` will return false for the following 
793      * types of addresses:
794      *
795      *  - an externally-owned account
796      *  - a contract in construction
797      *  - an address where a contract will be created
798      *  - an address where a contract lived, but was destroyed
799      * ====
800      */
801     function isContract(address account) internal view returns (bool) {
802         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
803         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
804         // for accounts without code, i.e. `keccak256('')`
805         bytes32 codehash;
806         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
807         // solhint-disable-next-line no-inline-assembly
808         assembly { codehash := extcodehash(account) }
809         return (codehash != accountHash && codehash != 0x0);
810     }
811 
812     /**
813      * @dev Converts an `address` into `address payable`. Note that this is
814      * simply a type cast: the actual underlying value is not changed.
815      *
816      * _Available since v2.4.0._
817      */
818     function toPayable(address account) internal pure returns (address payable) {
819         return address(uint160(account));
820     }
821 
822     /**
823      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
824      * `recipient`, forwarding all available gas and reverting on errors.
825      *
826      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
827      * of certain opcodes, possibly making contracts go over the 2300 gas limit
828      * imposed by `transfer`, making them unable to receive funds via
829      * `transfer`. {sendValue} removes this limitation.
830      *
831      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
832      *
833      * IMPORTANT: because control is transferred to `recipient`, care must be
834      * taken to not create reentrancy vulnerabilities. Consider using
835      * {ReentrancyGuard} or the
836      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
837      *
838      * _Available since v2.4.0._
839      */
840     function sendValue(address payable recipient, uint256 amount) internal {
841         require(address(this).balance >= amount, "Address: insufficient balance");
842 
843         // solhint-disable-next-line avoid-call-value
844         (bool success, ) = recipient.call.value(amount)("");
845         require(success, "Address: unable to send value, recipient may have reverted");
846     }
847 }
848 
849 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
850 
851 pragma solidity ^0.5.0;
852 
853 
854 
855 
856 /**
857  * @title SafeERC20
858  * @dev Wrappers around ERC20 operations that throw on failure (when the token
859  * contract returns false). Tokens that return no value (and instead revert or
860  * throw on failure) are also supported, non-reverting calls are assumed to be
861  * successful.
862  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
863  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
864  */
865 library SafeERC20 {
866     using SafeMath for uint256;
867     using Address for address;
868 
869     function safeTransfer(IERC20 token, address to, uint256 value) internal {
870         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
871     }
872 
873     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
874         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
875     }
876 
877     function safeApprove(IERC20 token, address spender, uint256 value) internal {
878         // safeApprove should only be called when setting an initial allowance,
879         // or when resetting it to zero. To increase and decrease it, use
880         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
881         // solhint-disable-next-line max-line-length
882         require((value == 0) || (token.allowance(address(this), spender) == 0),
883             "SafeERC20: approve from non-zero to non-zero allowance"
884         );
885         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
886     }
887 
888     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
889         uint256 newAllowance = token.allowance(address(this), spender).add(value);
890         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
891     }
892 
893     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
894         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
895         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
896     }
897 
898     /**
899      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
900      * on the return value: the return value is optional (but if data is returned, it must not be false).
901      * @param token The token targeted by the call.
902      * @param data The call data (encoded using abi.encode or one of its variants).
903      */
904     function callOptionalReturn(IERC20 token, bytes memory data) private {
905         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
906         // we're implementing it ourselves.
907 
908         // A Solidity high level call has three parts:
909         //  1. The target address is checked to verify it contains contract code
910         //  2. The call itself is made, and success asserted
911         //  3. The return value is decoded, which in turn checks the size of the returned data.
912         // solhint-disable-next-line max-line-length
913         require(address(token).isContract(), "SafeERC20: call to non-contract");
914 
915         // solhint-disable-next-line avoid-low-level-calls
916         (bool success, bytes memory returndata) = address(token).call(data);
917         require(success, "SafeERC20: low-level call failed");
918 
919         if (returndata.length > 0) { // Return data is optional
920             // solhint-disable-next-line max-line-length
921             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
922         }
923     }
924 }
925 
926 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
927 
928 pragma solidity ^0.5.0;
929 
930 /**
931  * @dev Contract module that helps prevent reentrant calls to a function.
932  *
933  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
934  * available, which can be applied to functions to make sure there are no nested
935  * (reentrant) calls to them.
936  *
937  * Note that because there is a single `nonReentrant` guard, functions marked as
938  * `nonReentrant` may not call one another. This can be worked around by making
939  * those functions `private`, and then adding `external` `nonReentrant` entry
940  * points to them.
941  *
942  * TIP: If you would like to learn more about reentrancy and alternative ways
943  * to protect against it, check out our blog post
944  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
945  *
946  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
947  * metering changes introduced in the Istanbul hardfork.
948  */
949 contract ReentrancyGuard {
950     bool private _notEntered;
951 
952     constructor () internal {
953         // Storing an initial non-zero value makes deployment a bit more
954         // expensive, but in exchange the refund on every call to nonReentrant
955         // will be lower in amount. Since refunds are capped to a percetange of
956         // the total transaction's gas, it is best to keep them low in cases
957         // like this one, to increase the likelihood of the full refund coming
958         // into effect.
959         _notEntered = true;
960     }
961 
962     /**
963      * @dev Prevents a contract from calling itself, directly or indirectly.
964      * Calling a `nonReentrant` function from another `nonReentrant`
965      * function is not supported. It is possible to prevent this from happening
966      * by making the `nonReentrant` function external, and make it call a
967      * `private` function that does the actual work.
968      */
969     modifier nonReentrant() {
970         // On the first call to nonReentrant, _notEntered will be true
971         require(_notEntered, "ReentrancyGuard: reentrant call");
972 
973         // Any calls to nonReentrant after this point will fail
974         _notEntered = false;
975 
976         _;
977 
978         // By storing the original value once again, a refund is triggered (see
979         // https://eips.ethereum.org/EIPS/eip-2200)
980         _notEntered = true;
981     }
982 }
983 
984 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
985 
986 pragma solidity ^0.5.0;
987 
988 /**
989  * @dev Interface of the ERC165 standard, as defined in the
990  * https://eips.ethereum.org/EIPS/eip-165[EIP].
991  *
992  * Implementers can declare support of contract interfaces, which can then be
993  * queried by others ({ERC165Checker}).
994  *
995  * For an implementation, see {ERC165}.
996  */
997 interface IERC165 {
998     /**
999      * @dev Returns true if this contract implements the interface defined by
1000      * `interfaceId`. See the corresponding
1001      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1002      * to learn more about how these ids are created.
1003      *
1004      * This function call must use less than 30 000 gas.
1005      */
1006     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1007 }
1008 
1009 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
1010 
1011 pragma solidity ^0.5.0;
1012 
1013 
1014 /**
1015  * @dev Implementation of the {IERC165} interface.
1016  *
1017  * Contracts may inherit from this and call {_registerInterface} to declare
1018  * their support of an interface.
1019  */
1020 contract ERC165 is IERC165 {
1021     /*
1022      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1023      */
1024     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1025 
1026     /**
1027      * @dev Mapping of interface ids to whether or not it's supported.
1028      */
1029     mapping(bytes4 => bool) private _supportedInterfaces;
1030 
1031     constructor () internal {
1032         // Derived contracts need only register support for their own interfaces,
1033         // we register support for ERC165 itself here
1034         _registerInterface(_INTERFACE_ID_ERC165);
1035     }
1036 
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      *
1040      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1041      */
1042     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1043         return _supportedInterfaces[interfaceId];
1044     }
1045 
1046     /**
1047      * @dev Registers the contract as an implementer of the interface defined by
1048      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1049      * registering its interface id is not required.
1050      *
1051      * See {IERC165-supportsInterface}.
1052      *
1053      * Requirements:
1054      *
1055      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1056      */
1057     function _registerInterface(bytes4 interfaceId) internal {
1058         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1059         _supportedInterfaces[interfaceId] = true;
1060     }
1061 }
1062 
1063 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
1064 
1065 pragma solidity ^0.5.10;
1066 
1067 /**
1068  * @dev Library used to query support of an interface declared via {IERC165}.
1069  *
1070  * Note that these functions return the actual result of the query: they do not
1071  * `revert` if an interface is not supported. It is up to the caller to decide
1072  * what to do in these cases.
1073  */
1074 library ERC165Checker {
1075     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1076     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1077 
1078     /*
1079      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1080      */
1081     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1082 
1083     /**
1084      * @dev Returns true if `account` supports the {IERC165} interface,
1085      */
1086     function _supportsERC165(address account) internal view returns (bool) {
1087         // Any contract that implements ERC165 must explicitly indicate support of
1088         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1089         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1090             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1091     }
1092 
1093     /**
1094      * @dev Returns true if `account` supports the interface defined by
1095      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1096      *
1097      * See {IERC165-supportsInterface}.
1098      */
1099     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1100         // query support of both ERC165 as per the spec and support of _interfaceId
1101         return _supportsERC165(account) &&
1102             _supportsERC165Interface(account, interfaceId);
1103     }
1104 
1105     /**
1106      * @dev Returns true if `account` supports all the interfaces defined in
1107      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1108      *
1109      * Batch-querying can lead to gas savings by skipping repeated checks for
1110      * {IERC165} support.
1111      *
1112      * See {IERC165-supportsInterface}.
1113      */
1114     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1115         // query support of ERC165 itself
1116         if (!_supportsERC165(account)) {
1117             return false;
1118         }
1119 
1120         // query support of each interface in _interfaceIds
1121         for (uint256 i = 0; i < interfaceIds.length; i++) {
1122             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1123                 return false;
1124             }
1125         }
1126 
1127         // all interfaces supported
1128         return true;
1129     }
1130 
1131     /**
1132      * @notice Query if a contract implements an interface, does not check ERC165 support
1133      * @param account The address of the contract to query for support of an interface
1134      * @param interfaceId The interface identifier, as specified in ERC-165
1135      * @return true if the contract at account indicates support of the interface with
1136      * identifier interfaceId, false otherwise
1137      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1138      * the behavior of this method is undefined. This precondition can be checked
1139      * with the `supportsERC165` method in this library.
1140      * Interface identification is specified in ERC-165.
1141      */
1142     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1143         // success determines whether the staticcall succeeded and result determines
1144         // whether the contract at account indicates support of _interfaceId
1145         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1146 
1147         return (success && result);
1148     }
1149 
1150     /**
1151      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1152      * @param account The address of the contract to query for support of an interface
1153      * @param interfaceId The interface identifier, as specified in ERC-165
1154      * @return success true if the STATICCALL succeeded, false otherwise
1155      * @return result true if the STATICCALL succeeded and the contract at account
1156      * indicates support of the interface with identifier interfaceId, false otherwise
1157      */
1158     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1159         private
1160         view
1161         returns (bool, bool)
1162     {
1163         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1164         (bool success, bytes memory result) = account.staticcall.gas(30000)(encodedParams);
1165         if (result.length < 32) return (false, false);
1166         return (success, abi.decode(result, (bool)));
1167     }
1168 }
1169 
1170 // File: coinage-token/contracts/lib/DSMath.sol
1171 
1172 // https://github.com/dapphub/ds-math/blob/de45767/src/math.sol
1173 /// math.sol -- mixin for inline numerical wizardry
1174 
1175 // This program is free software: you can redistribute it and/or modify
1176 // it under the terms of the GNU General Public License as published by
1177 // the Free Software Foundation, either version 3 of the License, or
1178 // (at your option) any later version.
1179 
1180 // This program is distributed in the hope that it will be useful,
1181 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1182 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1183 // GNU General Public License for more details.
1184 
1185 // You should have received a copy of the GNU General Public License
1186 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1187 
1188 pragma solidity >0.4.13;
1189 
1190 contract DSMath {
1191   function add(uint x, uint y) internal pure returns (uint z) {
1192     require((z = x + y) >= x, "ds-math-add-overflow");
1193   }
1194   function sub(uint x, uint y) internal pure returns (uint z) {
1195     require((z = x - y) <= x, "ds-math-sub-underflow");
1196   }
1197   function mul(uint x, uint y) internal pure returns (uint z) {
1198     require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
1199   }
1200 
1201   function min(uint x, uint y) internal pure returns (uint z) {
1202     return x <= y ? x : y;
1203   }
1204   function max(uint x, uint y) internal pure returns (uint z) {
1205     return x >= y ? x : y;
1206   }
1207   function imin(int x, int y) internal pure returns (int z) {
1208     return x <= y ? x : y;
1209   }
1210   function imax(int x, int y) internal pure returns (int z) {
1211     return x >= y ? x : y;
1212   }
1213 
1214   uint constant WAD = 10 ** 18;
1215   uint constant RAY = 10 ** 27;
1216 
1217   function wmul(uint x, uint y) internal pure returns (uint z) {
1218     z = add(mul(x, y), WAD / 2) / WAD;
1219   }
1220   function rmul(uint x, uint y) internal pure returns (uint z) {
1221     z = add(mul(x, y), RAY / 2) / RAY;
1222   }
1223   function wdiv(uint x, uint y) internal pure returns (uint z) {
1224     z = add(mul(x, WAD), y / 2) / y;
1225   }
1226   function rdiv(uint x, uint y) internal pure returns (uint z) {
1227     z = add(mul(x, RAY), y / 2) / y;
1228   }
1229 
1230   // This famous algorithm is called "exponentiation by squaring"
1231   // and calculates x^n with x as fixed-point and n as regular unsigned.
1232   //
1233   // It's O(log n), instead of O(n) for naive repeated multiplication.
1234   //
1235   // These facts are why it works:
1236   //
1237   //  If n is even, then x^n = (x^2)^(n/2).
1238   //  If n is odd,  then x^n = x * x^(n-1),
1239   //   and applying the equation for even x gives
1240   //  x^n = x * (x^2)^((n-1) / 2).
1241   //
1242   //  Also, EVM division is flooring and
1243   //  floor[(n-1) / 2] = floor[n / 2].
1244   //
1245   function wpow(uint x, uint n) internal pure returns (uint z) {
1246     z = n % 2 != 0 ? x : WAD;
1247 
1248     for (n /= 2; n != 0; n /= 2) {
1249       x = wmul(x, x);
1250 
1251       if (n % 2 != 0) {
1252         z = wmul(z, x);
1253       }
1254     }
1255   }
1256 
1257   function rpow(uint x, uint n) internal pure returns (uint z) {
1258     z = n % 2 != 0 ? x : RAY;
1259 
1260     for (n /= 2; n != 0; n /= 2) {
1261       x = rmul(x, x);
1262 
1263       if (n % 2 != 0) {
1264         z = rmul(z, x);
1265       }
1266     }
1267   }
1268 }
1269 
1270 // File: contracts/stake/interfaces/SeigManagerI.sol
1271 
1272 pragma solidity ^0.5.12;
1273 
1274 
1275 interface SeigManagerI {
1276   function registry() external view returns (address);
1277   function depositManager() external view returns (address);
1278   function ton() external view returns (address);
1279   function wton() external view returns (address);
1280   function powerton() external view returns (address);
1281   function tot() external view returns (address);
1282   function coinages(address layer2) external view returns (address);
1283   function commissionRates(address layer2) external view returns (uint256);
1284 
1285   function lastCommitBlock(address layer2) external view returns (uint256);
1286   function seigPerBlock() external view returns (uint256);
1287   function lastSeigBlock() external view returns (uint256);
1288   function pausedBlock() external view returns (uint256);
1289   function unpausedBlock() external view returns (uint256);
1290   function DEFAULT_FACTOR() external view returns (uint256);
1291 
1292   function deployCoinage(address layer2) external returns (bool);
1293   function setCommissionRate(address layer2, uint256 commission, bool isCommissionRateNegative) external returns (bool);
1294 
1295   function uncomittedStakeOf(address layer2, address account) external view returns (uint256);
1296   function stakeOf(address layer2, address account) external view returns (uint256);
1297   function additionalTotBurnAmount(address layer2, address account, uint256 amount) external view returns (uint256 totAmount);
1298 
1299   function onTransfer(address sender, address recipient, uint256 amount) external returns (bool);
1300   function updateSeigniorage() external returns (bool);
1301   function onDeposit(address layer2, address account, uint256 amount) external returns (bool);
1302   function onWithdraw(address layer2, address account, uint256 amount) external returns (bool);
1303 
1304 }
1305 
1306 // File: contracts/stake/tokens/OnApprove.sol
1307 
1308 pragma solidity ^0.5.12;
1309 
1310 
1311 contract OnApprove is ERC165 {
1312   constructor() public {
1313     _registerInterface(OnApprove(this).onApprove.selector);
1314   }
1315 
1316   function onApprove(address owner, address spender, uint256 amount, bytes calldata data) external returns (bool);
1317 }
1318 
1319 // File: contracts/stake/tokens/ERC20OnApprove.sol
1320 
1321 pragma solidity ^0.5.12;
1322 
1323 
1324 
1325 
1326 
1327 contract ERC20OnApprove is ERC20 {
1328   function approveAndCall(address spender, uint256 amount, bytes memory data) public returns (bool) {
1329     require(approve(spender, amount));
1330     _callOnApprove(msg.sender, spender, amount, data);
1331     return true;
1332   }
1333 
1334   function _callOnApprove(address owner, address spender, uint256 amount, bytes memory data) internal {
1335     bytes4 onApproveSelector = OnApprove(spender).onApprove.selector;
1336 
1337     require(ERC165Checker._supportsInterface(spender, onApproveSelector),
1338       "ERC20OnApprove: spender doesn't support onApprove");
1339 
1340     (bool ok, bytes memory res) = spender.call(
1341       abi.encodeWithSelector(
1342         onApproveSelector,
1343         owner,
1344         spender,
1345         amount,
1346         data
1347       )
1348     );
1349 
1350     // check if low-level call reverted or not
1351     require(ok, string(res));
1352 
1353     assembly {
1354       ok := mload(add(res, 0x20))
1355     }
1356 
1357     // check if OnApprove.onApprove returns true or false
1358     require(ok, "ERC20OnApprove: failed to call onApprove");
1359   }
1360 
1361 }
1362 
1363 // File: contracts/stake/tokens/AuthController.sol
1364 
1365 pragma solidity ^0.5.12;
1366 
1367 
1368 
1369 interface MinterRoleRenounceTarget {
1370   function renounceMinter() external;
1371 }
1372 
1373 interface PauserRoleRenounceTarget {
1374   function renouncePauser() external;
1375 }
1376 
1377 interface OwnableTarget {
1378   function renounceOwnership() external;
1379   function transferOwnership(address newOwner) external;
1380 }
1381 
1382 contract AuthController is Ownable {
1383   function renounceMinter(address target) public onlyOwner {
1384     MinterRoleRenounceTarget(target).renounceMinter();
1385   }
1386 
1387   function renouncePauser(address target) public onlyOwner {
1388     PauserRoleRenounceTarget(target).renouncePauser();
1389   }
1390 
1391   function renounceOwnership(address target) public onlyOwner {
1392     OwnableTarget(target).renounceOwnership();
1393   }
1394 
1395   function transferOwnership(address target, address newOwner) public onlyOwner {
1396     OwnableTarget(target).transferOwnership(newOwner);
1397   }
1398 }
1399 
1400 // File: contracts/stake/tokens/SeigToken.sol
1401 
1402 pragma solidity ^0.5.12;
1403 
1404 
1405 
1406 
1407 
1408 
1409 
1410 contract SeigToken is ERC20, Ownable, ERC20OnApprove, AuthController {
1411   SeigManagerI public seigManager;
1412   bool public callbackEnabled;
1413 
1414   function enableCallback(bool _callbackEnabled) external onlyOwner {
1415     callbackEnabled = _callbackEnabled;
1416   }
1417 
1418   function setSeigManager(SeigManagerI _seigManager) external onlyOwner {
1419     seigManager = _seigManager;
1420   }
1421 
1422   //////////////////////
1423   // Override ERC20 functions
1424   //////////////////////
1425 
1426   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1427     return super.transferFrom(sender, recipient, amount);
1428   }
1429 
1430   function _transfer(address sender, address recipient, uint256 amount) internal {
1431     super._transfer(sender, recipient, amount);
1432     if (callbackEnabled && address(seigManager) != address(0)) {
1433       require(seigManager.onTransfer(sender, recipient, amount));
1434     }
1435   }
1436 
1437   function _mint(address account, uint256 amount) internal {
1438     super._mint(account, amount);
1439     if (callbackEnabled && address(seigManager) != address(0)) {
1440       require(seigManager.onTransfer(address(0), account, amount));
1441     }
1442   }
1443 
1444   function _burn(address account, uint256 amount) internal {
1445     super._burn(account, amount);
1446     if (callbackEnabled && address(seigManager) != address(0)) {
1447       require(seigManager.onTransfer(account, address(0), amount));
1448     }
1449   }
1450 }
1451 
1452 // File: contracts/stake/tokens/WTON.sol
1453 
1454 pragma solidity ^0.5.12;
1455 
1456 
1457 
1458 
1459 
1460 
1461 
1462 
1463 
1464 
1465 
1466 
1467 
1468 
1469 
1470 
1471 
1472 contract WTON is DSMath, ReentrancyGuard, Ownable, ERC20Mintable, ERC20Burnable, ERC20Detailed, SeigToken, OnApprove {
1473   using SafeERC20 for ERC20Mintable;
1474 
1475   ERC20Mintable public ton;
1476 
1477   constructor (
1478     ERC20Mintable _ton
1479   )
1480     public
1481     ERC20Detailed("Wrapped TON", "WTON", 27)
1482   {
1483     require(ERC20Detailed(address(_ton)).decimals() == 18, "WTON: decimals of TON must be 18");
1484     ton = _ton;
1485   }
1486 
1487   //////////////////////
1488   // TON Approve callback
1489   //////////////////////
1490 
1491   function onApprove(
1492     address owner,
1493     address spender,
1494     uint256 tonAmount,
1495     bytes calldata data
1496   ) external returns (bool) {
1497     require(msg.sender == address(ton), "WTON: only accept TON approve callback");
1498 
1499     // swap owner's TON to WTON
1500     _swapFromTON(owner, owner, tonAmount);
1501 
1502     uint256 wtonAmount = _toRAY(tonAmount);
1503     (address depositManager, address layer2) = _decodeTONApproveData(data);
1504 
1505     // approve WTON to DepositManager
1506     _approve(owner, depositManager, wtonAmount);
1507 
1508     // call DepositManager.onApprove to deposit WTON
1509     bytes memory depositManagerOnApproveData = _encodeDepositManagerOnApproveData(layer2);
1510     _callOnApprove(owner, depositManager, wtonAmount, depositManagerOnApproveData);
1511 
1512     return true;
1513   }
1514 
1515   /**
1516    * @dev data is 64 bytes of 2 addresses in left-padded 32 bytes
1517    */
1518   function _decodeTONApproveData(
1519     bytes memory data
1520   ) internal pure returns (address depositManager, address layer2) {
1521     require(data.length == 0x40);
1522 
1523     assembly {
1524       depositManager := mload(add(data, 0x20))
1525       layer2 := mload(add(data, 0x40))
1526     }
1527   }
1528 
1529   function _encodeDepositManagerOnApproveData(
1530     address layer2
1531   ) internal pure returns (bytes memory data) {
1532     data = new bytes(0x20);
1533 
1534     assembly {
1535       mstore(add(data, 0x20), layer2)
1536     }
1537   }
1538 
1539 
1540   //////////////////////
1541   // Override ERC20 functions
1542   //////////////////////
1543 
1544   function burnFrom(address account, uint256 amount) public {
1545     if (isMinter(msg.sender)) {
1546       _burn(account, amount);
1547       return;
1548     }
1549 
1550     super.burnFrom(account, amount);
1551   }
1552 
1553   //////////////////////
1554   // Swap functions
1555   //////////////////////
1556 
1557   /**
1558    * @dev swap WTON to TON
1559    */
1560   function swapToTON(uint256 wtonAmount) public nonReentrant returns (bool) {
1561     return _swapToTON(msg.sender, msg.sender, wtonAmount);
1562   }
1563 
1564   /**
1565    * @dev swap TON to WTON
1566    */
1567   function swapFromTON(uint256 tonAmount) public nonReentrant returns (bool) {
1568     return _swapFromTON(msg.sender, msg.sender, tonAmount);
1569   }
1570 
1571   /**
1572    * @dev swap WTON to TON, and transfer TON
1573    * NOTE: TON's transfer event's `from` argument is not `msg.sender` but `WTON` address.
1574    */
1575   function swapToTONAndTransfer(address to, uint256 wtonAmount) public nonReentrant returns (bool) {
1576     return _swapToTON(to, msg.sender, wtonAmount);
1577   }
1578 
1579   /**
1580    * @dev swap TON to WTON, and transfer WTON
1581    */
1582   function swapFromTONAndTransfer(address to, uint256 tonAmount) public nonReentrant returns (bool) {
1583     return _swapFromTON(msg.sender, to, tonAmount);
1584   }
1585 
1586   function renounceTonMinter() external onlyOwner {
1587     ton.renounceMinter();
1588   }
1589 
1590   //////////////////////
1591   // Internal functions
1592   //////////////////////
1593 
1594   function _swapToTON(address tonAccount, address wtonAccount, uint256 wtonAmount) internal returns (bool) {
1595     _burn(wtonAccount, wtonAmount);
1596 
1597     // mint TON if WTON contract has not enough TON to transfer
1598     uint256 tonAmount = _toWAD(wtonAmount);
1599     uint256 tonBalance = ton.balanceOf(address(this));
1600     if (tonBalance < tonAmount) {
1601       ton.mint(address(this), tonAmount.sub(tonBalance));
1602     }
1603 
1604     ton.safeTransfer(tonAccount, tonAmount);
1605     return true;
1606   }
1607 
1608   function _swapFromTON(address tonAccount, address wtonAccount, uint256 tonAmount) internal returns (bool) {
1609     _mint(wtonAccount, _toRAY(tonAmount));
1610     ton.safeTransferFrom(tonAccount, address(this), tonAmount);
1611     return true;
1612   }
1613 
1614   /**
1615    * @dev transform WAD to RAY
1616    */
1617   function _toRAY(uint256 v) internal pure returns (uint256) {
1618     return v * 10 ** 9;
1619   }
1620 
1621   /**
1622    * @dev transform RAY to WAD
1623    */
1624   function _toWAD(uint256 v) internal pure returns (uint256) {
1625     return v / 10 ** 9;
1626   }
1627 }