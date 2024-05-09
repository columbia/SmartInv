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
110 // File: @openzeppelin/contracts/ownership/Ownable.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor () internal {
132         address msgSender = _msgSender();
133         _owner = msgSender;
134         emit OwnershipTransferred(address(0), msgSender);
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(isOwner(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Returns true if the caller is the current owner.
154      */
155     function isOwner() public view returns (bool) {
156         return _msgSender() == _owner;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public onlyOwner {
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      */
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 /**
195  * @dev Optional functions from the ERC20 standard.
196  */
197 contract ERC20Detailed is IERC20 {
198     string private _name;
199     string private _symbol;
200     uint8 private _decimals;
201 
202     /**
203      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
204      * these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor (string memory name, string memory symbol, uint8 decimals) public {
208         _name = name;
209         _symbol = symbol;
210         _decimals = decimals;
211     }
212 
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view returns (string memory) {
217         return _name;
218     }
219 
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view returns (string memory) {
225         return _symbol;
226     }
227 
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei.
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view returns (uint8) {
241         return _decimals;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/math/SafeMath.sol
246 
247 pragma solidity ^0.5.0;
248 
249 /**
250  * @dev Wrappers over Solidity's arithmetic operations with added overflow
251  * checks.
252  *
253  * Arithmetic operations in Solidity wrap on overflow. This can easily result
254  * in bugs, because programmers usually assume that an overflow raises an
255  * error, which is the standard behavior in high level programming languages.
256  * `SafeMath` restores this intuition by reverting the transaction when an
257  * operation overflows.
258  *
259  * Using this library instead of the unchecked operations eliminates an entire
260  * class of bugs, so it's recommended to use it always.
261  */
262 library SafeMath {
263     /**
264      * @dev Returns the addition of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `+` operator.
268      *
269      * Requirements:
270      * - Addition cannot overflow.
271      */
272     function add(uint256 a, uint256 b) internal pure returns (uint256) {
273         uint256 c = a + b;
274         require(c >= a, "SafeMath: addition overflow");
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting on
281      * overflow (when the result is negative).
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      * - Subtraction cannot overflow.
287      */
288     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289         return sub(a, b, "SafeMath: subtraction overflow");
290     }
291 
292     /**
293      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
294      * overflow (when the result is negative).
295      *
296      * Counterpart to Solidity's `-` operator.
297      *
298      * Requirements:
299      * - Subtraction cannot overflow.
300      *
301      * _Available since v2.4.0._
302      */
303     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b <= a, errorMessage);
305         uint256 c = a - b;
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the multiplication of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `*` operator.
315      *
316      * Requirements:
317      * - Multiplication cannot overflow.
318      */
319     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
321         // benefit is lost if 'b' is also tested.
322         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
323         if (a == 0) {
324             return 0;
325         }
326 
327         uint256 c = a * b;
328         require(c / a == b, "SafeMath: multiplication overflow");
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the integer division of two unsigned integers. Reverts on
335      * division by zero. The result is rounded towards zero.
336      *
337      * Counterpart to Solidity's `/` operator. Note: this function uses a
338      * `revert` opcode (which leaves remaining gas untouched) while Solidity
339      * uses an invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      * - The divisor cannot be zero.
343      */
344     function div(uint256 a, uint256 b) internal pure returns (uint256) {
345         return div(a, b, "SafeMath: division by zero");
346     }
347 
348     /**
349      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
350      * division by zero. The result is rounded towards zero.
351      *
352      * Counterpart to Solidity's `/` operator. Note: this function uses a
353      * `revert` opcode (which leaves remaining gas untouched) while Solidity
354      * uses an invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      * - The divisor cannot be zero.
358      *
359      * _Available since v2.4.0._
360      */
361     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
362         // Solidity only automatically asserts when dividing by 0
363         require(b > 0, errorMessage);
364         uint256 c = a / b;
365         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
372      * Reverts when dividing by zero.
373      *
374      * Counterpart to Solidity's `%` operator. This function uses a `revert`
375      * opcode (which leaves remaining gas untouched) while Solidity uses an
376      * invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      * - The divisor cannot be zero.
380      */
381     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
382         return mod(a, b, "SafeMath: modulo by zero");
383     }
384 
385     /**
386      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
387      * Reverts with custom message when dividing by zero.
388      *
389      * Counterpart to Solidity's `%` operator. This function uses a `revert`
390      * opcode (which leaves remaining gas untouched) while Solidity uses an
391      * invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      * - The divisor cannot be zero.
395      *
396      * _Available since v2.4.0._
397      */
398     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
399         require(b != 0, errorMessage);
400         return a % b;
401     }
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
405 
406 pragma solidity ^0.5.0;
407 
408 
409 
410 
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20Mintable}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin guidelines: functions revert instead
423  * of returning `false` on failure. This behavior is nonetheless conventional
424  * and does not conflict with the expectations of ERC20 applications.
425  *
426  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
427  * This allows applications to reconstruct the allowance for all accounts just
428  * by listening to said events. Other implementations of the EIP may not emit
429  * these events, as it isn't required by the specification.
430  *
431  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
432  * functions have been added to mitigate the well-known issues around setting
433  * allowances. See {IERC20-approve}.
434  */
435 contract ERC20 is Context, IERC20 {
436     using SafeMath for uint256;
437 
438     mapping (address => uint256) private _balances;
439 
440     mapping (address => mapping (address => uint256)) private _allowances;
441 
442     uint256 private _totalSupply;
443 
444     /**
445      * @dev See {IERC20-totalSupply}.
446      */
447     function totalSupply() public view returns (uint256) {
448         return _totalSupply;
449     }
450 
451     /**
452      * @dev See {IERC20-balanceOf}.
453      */
454     function balanceOf(address account) public view returns (uint256) {
455         return _balances[account];
456     }
457 
458     /**
459      * @dev See {IERC20-transfer}.
460      *
461      * Requirements:
462      *
463      * - `recipient` cannot be the zero address.
464      * - the caller must have a balance of at least `amount`.
465      */
466     function transfer(address recipient, uint256 amount) public returns (bool) {
467         _transfer(_msgSender(), recipient, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-allowance}.
473      */
474     function allowance(address owner, address spender) public view returns (uint256) {
475         return _allowances[owner][spender];
476     }
477 
478     /**
479      * @dev See {IERC20-approve}.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      */
485     function approve(address spender, uint256 amount) public returns (bool) {
486         _approve(_msgSender(), spender, amount);
487         return true;
488     }
489 
490     /**
491      * @dev See {IERC20-transferFrom}.
492      *
493      * Emits an {Approval} event indicating the updated allowance. This is not
494      * required by the EIP. See the note at the beginning of {ERC20};
495      *
496      * Requirements:
497      * - `sender` and `recipient` cannot be the zero address.
498      * - `sender` must have a balance of at least `amount`.
499      * - the caller must have allowance for `sender`'s tokens of at least
500      * `amount`.
501      */
502     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
503         _transfer(sender, recipient, amount);
504         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
505         return true;
506     }
507 
508     /**
509      * @dev Atomically increases the allowance granted to `spender` by the caller.
510      *
511      * This is an alternative to {approve} that can be used as a mitigation for
512      * problems described in {IERC20-approve}.
513      *
514      * Emits an {Approval} event indicating the updated allowance.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      */
520     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
522         return true;
523     }
524 
525     /**
526      * @dev Atomically decreases the allowance granted to `spender` by the caller.
527      *
528      * This is an alternative to {approve} that can be used as a mitigation for
529      * problems described in {IERC20-approve}.
530      *
531      * Emits an {Approval} event indicating the updated allowance.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      * - `spender` must have allowance for the caller of at least
537      * `subtractedValue`.
538      */
539     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
540         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
541         return true;
542     }
543 
544     /**
545      * @dev Moves tokens `amount` from `sender` to `recipient`.
546      *
547      * This is internal function is equivalent to {transfer}, and can be used to
548      * e.g. implement automatic token fees, slashing mechanisms, etc.
549      *
550      * Emits a {Transfer} event.
551      *
552      * Requirements:
553      *
554      * - `sender` cannot be the zero address.
555      * - `recipient` cannot be the zero address.
556      * - `sender` must have a balance of at least `amount`.
557      */
558     function _transfer(address sender, address recipient, uint256 amount) internal {
559         require(sender != address(0), "ERC20: transfer from the zero address");
560         require(recipient != address(0), "ERC20: transfer to the zero address");
561 
562         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
563         _balances[recipient] = _balances[recipient].add(amount);
564         emit Transfer(sender, recipient, amount);
565     }
566 
567     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
568      * the total supply.
569      *
570      * Emits a {Transfer} event with `from` set to the zero address.
571      *
572      * Requirements
573      *
574      * - `to` cannot be the zero address.
575      */
576     function _mint(address account, uint256 amount) internal {
577         require(account != address(0), "ERC20: mint to the zero address");
578 
579         _totalSupply = _totalSupply.add(amount);
580         _balances[account] = _balances[account].add(amount);
581         emit Transfer(address(0), account, amount);
582     }
583 
584     /**
585      * @dev Destroys `amount` tokens from `account`, reducing the
586      * total supply.
587      *
588      * Emits a {Transfer} event with `to` set to the zero address.
589      *
590      * Requirements
591      *
592      * - `account` cannot be the zero address.
593      * - `account` must have at least `amount` tokens.
594      */
595     function _burn(address account, uint256 amount) internal {
596         require(account != address(0), "ERC20: burn from the zero address");
597 
598         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
599         _totalSupply = _totalSupply.sub(amount);
600         emit Transfer(account, address(0), amount);
601     }
602 
603     /**
604      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
605      *
606      * This is internal function is equivalent to `approve`, and can be used to
607      * e.g. set automatic allowances for certain subsystems, etc.
608      *
609      * Emits an {Approval} event.
610      *
611      * Requirements:
612      *
613      * - `owner` cannot be the zero address.
614      * - `spender` cannot be the zero address.
615      */
616     function _approve(address owner, address spender, uint256 amount) internal {
617         require(owner != address(0), "ERC20: approve from the zero address");
618         require(spender != address(0), "ERC20: approve to the zero address");
619 
620         _allowances[owner][spender] = amount;
621         emit Approval(owner, spender, amount);
622     }
623 
624     /**
625      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
626      * from the caller's allowance.
627      *
628      * See {_burn} and {_approve}.
629      */
630     function _burnFrom(address account, uint256 amount) internal {
631         _burn(account, amount);
632         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
633     }
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
637 
638 pragma solidity ^0.5.0;
639 
640 
641 
642 /**
643  * @dev Extension of {ERC20} that allows token holders to destroy both their own
644  * tokens and those that they have an allowance for, in a way that can be
645  * recognized off-chain (via event analysis).
646  */
647 contract ERC20Burnable is Context, ERC20 {
648     /**
649      * @dev Destroys `amount` tokens from the caller.
650      *
651      * See {ERC20-_burn}.
652      */
653     function burn(uint256 amount) public {
654         _burn(_msgSender(), amount);
655     }
656 
657     /**
658      * @dev See {ERC20-_burnFrom}.
659      */
660     function burnFrom(address account, uint256 amount) public {
661         _burnFrom(account, amount);
662     }
663 }
664 
665 // File: @openzeppelin/contracts/access/Roles.sol
666 
667 pragma solidity ^0.5.0;
668 
669 /**
670  * @title Roles
671  * @dev Library for managing addresses assigned to a Role.
672  */
673 library Roles {
674     struct Role {
675         mapping (address => bool) bearer;
676     }
677 
678     /**
679      * @dev Give an account access to this role.
680      */
681     function add(Role storage role, address account) internal {
682         require(!has(role, account), "Roles: account already has role");
683         role.bearer[account] = true;
684     }
685 
686     /**
687      * @dev Remove an account's access to this role.
688      */
689     function remove(Role storage role, address account) internal {
690         require(has(role, account), "Roles: account does not have role");
691         role.bearer[account] = false;
692     }
693 
694     /**
695      * @dev Check if an account has this role.
696      * @return bool
697      */
698     function has(Role storage role, address account) internal view returns (bool) {
699         require(account != address(0), "Roles: account is the zero address");
700         return role.bearer[account];
701     }
702 }
703 
704 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
705 
706 pragma solidity ^0.5.0;
707 
708 
709 
710 contract MinterRole is Context {
711     using Roles for Roles.Role;
712 
713     event MinterAdded(address indexed account);
714     event MinterRemoved(address indexed account);
715 
716     Roles.Role private _minters;
717 
718     constructor () internal {
719         _addMinter(_msgSender());
720     }
721 
722     modifier onlyMinter() {
723         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
724         _;
725     }
726 
727     function isMinter(address account) public view returns (bool) {
728         return _minters.has(account);
729     }
730 
731     function addMinter(address account) public onlyMinter {
732         _addMinter(account);
733     }
734 
735     function renounceMinter() public {
736         _removeMinter(_msgSender());
737     }
738 
739     function _addMinter(address account) internal {
740         _minters.add(account);
741         emit MinterAdded(account);
742     }
743 
744     function _removeMinter(address account) internal {
745         _minters.remove(account);
746         emit MinterRemoved(account);
747     }
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
751 
752 pragma solidity ^0.5.0;
753 
754 
755 
756 /**
757  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
758  * which have permission to mint (create) new tokens as they see fit.
759  *
760  * At construction, the deployer of the contract is the only minter.
761  */
762 contract ERC20Mintable is ERC20, MinterRole {
763     /**
764      * @dev See {ERC20-_mint}.
765      *
766      * Requirements:
767      *
768      * - the caller must have the {MinterRole}.
769      */
770     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
771         _mint(account, amount);
772         return true;
773     }
774 }
775 
776 // File: contracts/lib/BridgedToken.sol
777 
778 pragma solidity 0.5.17;
779 
780 
781 
782 
783 contract BridgedToken is ERC20Burnable, ERC20Detailed, ERC20Mintable {
784     address public ethTokenAddr;
785     constructor(
786         address _ethTokenAddr,
787         string memory name,
788         string memory symbol,
789         uint8 decimals
790     ) public ERC20Detailed(name, symbol, decimals) {
791         ethTokenAddr = _ethTokenAddr;
792     }
793 }
794 
795 // File: contracts/lib/TokenManager.sol
796 
797 pragma solidity 0.5.17;
798 
799 
800 
801 
802 contract TokenManager is Ownable {
803     // ethtoken to onetoken mapping
804     mapping(address => address) public mappedTokens;
805 
806     event TokenMapAck(address indexed tokenReq, address indexed tokenAck);
807 
808     mapping(address => uint256) public wards;
809 
810     function rely(address guy) external onlyOwner {
811         wards[guy] = 1;
812     }
813 
814     function deny(address guy) external onlyOwner {
815         require(guy != owner(), "TokenManager/cannot deny the owner");
816         wards[guy] = 0;
817     }
818 
819     // both owner and admin must approve
820     modifier auth {
821         require(wards[msg.sender] == 1, "TokenManager/not-authorized");
822         _;
823     }
824 
825     /**
826      * @dev map ethereum token to harmony token and emit mintAddress
827      * @param ethTokenAddr address of the ethereum token
828      * @return mintAddress of the mapped token
829      */
830     function addToken(
831         address ethTokenAddr,
832         string memory name,
833         string memory symbol,
834         uint8 decimals
835     ) public auth returns (address) {
836         require(
837             ethTokenAddr != address(0),
838             "TokenManager/ethToken is a zero address"
839         );
840         require(
841             mappedTokens[ethTokenAddr] == address(0),
842             "TokenManager/ethToken already mapped"
843         );
844 
845         BridgedToken bridgedToken = new BridgedToken(
846             ethTokenAddr,
847             name,
848             symbol,
849             decimals
850         );
851         address bridgedTokenAddr = address(bridgedToken);
852 
853         // store the mapping and created address
854         mappedTokens[ethTokenAddr] = bridgedTokenAddr;
855 
856         // assign minter role to the caller
857         bridgedToken.addMinter(msg.sender);
858 
859         emit TokenMapAck(ethTokenAddr, bridgedTokenAddr);
860         return bridgedTokenAddr;
861     }
862 
863     /**
864      * @dev register an ethereum token to harmony token mapping
865      * @param ethTokenAddr address of the ethereum token
866      * @return oneToken of the mapped harmony token
867      */
868     function registerToken(address ethTokenAddr, address oneTokenAddr)
869         public
870         auth
871         returns (bool)
872     {
873         require(
874             ethTokenAddr != address(0),
875             "TokenManager/ethTokenAddr is a zero address"
876         );
877         require(
878             mappedTokens[ethTokenAddr] == address(0),
879             "TokenManager/ethTokenAddr already mapped"
880         );
881 
882         // store the mapping and created address
883         mappedTokens[ethTokenAddr] = oneTokenAddr;
884     }
885 
886     /**
887      * @dev remove an existing token mapping
888      * @param ethTokenAddr address of the ethereum token
889      * @param supply only allow removing mapping when supply, e.g., zero or 10**27
890      */
891     function removeToken(address ethTokenAddr, uint256 supply) public auth {
892         require(
893             mappedTokens[ethTokenAddr] != address(0),
894             "TokenManager/ethToken mapping does not exists"
895         );
896         IERC20 oneToken = IERC20(mappedTokens[ethTokenAddr]);
897         require(
898             oneToken.totalSupply() == supply,
899             "TokenManager/remove has non-zero supply"
900         );
901         delete mappedTokens[ethTokenAddr];
902     }
903 }
904 
905 // File: contracts/hrc20/HRC20EthManager.sol
906 
907 pragma solidity 0.5.17;
908 
909 
910 
911 interface MintableToken {
912     function mint(address beneficiary, uint256 amount) external returns (bool);
913 }
914 
915 interface BurnableToken {
916     function burnFrom(address account, uint256 amount) external;
917 }
918 
919 contract HRC20EthManager {
920     mapping(bytes32 => bool) public usedEvents_;
921     mapping(address => address) public mappings;
922 
923     event Burned(
924         address indexed token,
925         address indexed sender,
926         uint256 amount,
927         address recipient
928     );
929 
930     event Minted(
931         address ethToken,
932         uint256 amount,
933         address recipient,
934         bytes32 receiptId
935     );
936 
937     address public wallet;
938     modifier onlyWallet {
939         require(msg.sender == wallet, "EthManager/not-authorized");
940         _;
941     }
942 
943     /**
944      * @dev constructor
945      * @param _wallet is the multisig wallet
946      */
947     constructor(address _wallet) public {
948         wallet = _wallet;
949     }
950 
951     /**
952      * @dev map an harmony token to ethereum
953      * @param tokenManager address to token manager
954      * @param hmyTokenAddr harmony token address to map
955      * @param name of the harmony token
956      * @param symbol of the harmony token
957      * @param decimals of the harmony token
958      */
959     function addToken(
960         address tokenManager,
961         address hmyTokenAddr,
962         string memory name,
963         string memory symbol,
964         uint8 decimals
965     ) public {
966         address ethTokenAddr = TokenManager(tokenManager).addToken(
967             hmyTokenAddr,
968             name,
969             symbol,
970             decimals
971         );
972         mappings[hmyTokenAddr] = ethTokenAddr;
973     }
974 
975     /**
976      * @dev deregister token mapping in the token manager
977      * @param tokenManager address to token manager
978      * @param hmyTokenAddr address to remove token
979      */
980     function removeToken(address tokenManager, address hmyTokenAddr) public {
981         TokenManager(tokenManager).removeToken(hmyTokenAddr, 0);
982     }
983 
984     /**
985      * @dev burns tokens on ethereum to be unlocked on harmony
986      * @param ethToken ethereum token address
987      * @param amount amount of tokens to burn
988      * @param recipient recipient of the unlock tokens on ethereum
989      */
990     function burnToken(
991         address ethToken,
992         uint256 amount,
993         address recipient
994     ) public {
995         BurnableToken(ethToken).burnFrom(msg.sender, amount);
996         emit Burned(ethToken, msg.sender, amount, recipient);
997     }
998 
999     /**
1000      * @dev mints tokens corresponding to the tokens locked in the harmony chain
1001      * @param ethToken is the token address for minting
1002      * @param amount amount of tokens for minting
1003      * @param recipient recipient of the minted tokens (ethereum address)
1004      * @param receiptId transaction hash of the lock event on harmony chain
1005      */
1006     function mintToken(
1007         address ethToken,
1008         uint256 amount,
1009         address recipient,
1010         bytes32 receiptId
1011     ) public onlyWallet {
1012         require(
1013             !usedEvents_[receiptId],
1014             "EthManager/The lock event cannot be reused"
1015         );
1016         usedEvents_[receiptId] = true;
1017         MintableToken(ethToken).mint(recipient, amount);
1018         emit Minted(ethToken, amount, recipient, receiptId);
1019     }
1020 }