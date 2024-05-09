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
612 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
613 
614 pragma solidity ^0.5.0;
615 
616 
617 /**
618  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
619  */
620 contract ERC20Capped is ERC20Mintable {
621     uint256 private _cap;
622 
623     /**
624      * @dev Sets the value of the `cap`. This value is immutable, it can only be
625      * set once during construction.
626      */
627     constructor (uint256 cap) public {
628         require(cap > 0, "ERC20Capped: cap is 0");
629         _cap = cap;
630     }
631 
632     /**
633      * @dev Returns the cap on the token's total supply.
634      */
635     function cap() public view returns (uint256) {
636         return _cap;
637     }
638 
639     /**
640      * @dev See {ERC20Mintable-mint}.
641      *
642      * Requirements:
643      *
644      * - `value` must not cause the total supply to go over the cap.
645      */
646     function _mint(address account, uint256 value) internal {
647         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
648         super._mint(account, value);
649     }
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
653 
654 pragma solidity ^0.5.0;
655 
656 
657 /**
658  * @dev Optional functions from the ERC20 standard.
659  */
660 contract ERC20Detailed is IERC20 {
661     string private _name;
662     string private _symbol;
663     uint8 private _decimals;
664 
665     /**
666      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
667      * these values are immutable: they can only be set once during
668      * construction.
669      */
670     constructor (string memory name, string memory symbol, uint8 decimals) public {
671         _name = name;
672         _symbol = symbol;
673         _decimals = decimals;
674     }
675 
676     /**
677      * @dev Returns the name of the token.
678      */
679     function name() public view returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev Returns the symbol of the token, usually a shorter version of the
685      * name.
686      */
687     function symbol() public view returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev Returns the number of decimals used to get its user representation.
693      * For example, if `decimals` equals `2`, a balance of `505` tokens should
694      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
695      *
696      * Tokens usually opt for a value of 18, imitating the relationship between
697      * Ether and Wei.
698      *
699      * NOTE: This information is only used for _display_ purposes: it in
700      * no way affects any of the arithmetic of the contract, including
701      * {IERC20-balanceOf} and {IERC20-transfer}.
702      */
703     function decimals() public view returns (uint8) {
704         return _decimals;
705     }
706 }
707 
708 // File: @openzeppelin/contracts/utils/Address.sol
709 
710 pragma solidity ^0.5.5;
711 
712 /**
713  * @dev Collection of functions related to the address type
714  */
715 library Address {
716     /**
717      * @dev Returns true if `account` is a contract.
718      *
719      * [IMPORTANT]
720      * ====
721      * It is unsafe to assume that an address for which this function returns
722      * false is an externally-owned account (EOA) and not a contract.
723      *
724      * Among others, `isContract` will return false for the following 
725      * types of addresses:
726      *
727      *  - an externally-owned account
728      *  - a contract in construction
729      *  - an address where a contract will be created
730      *  - an address where a contract lived, but was destroyed
731      * ====
732      */
733     function isContract(address account) internal view returns (bool) {
734         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
735         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
736         // for accounts without code, i.e. `keccak256('')`
737         bytes32 codehash;
738         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
739         // solhint-disable-next-line no-inline-assembly
740         assembly { codehash := extcodehash(account) }
741         return (codehash != accountHash && codehash != 0x0);
742     }
743 
744     /**
745      * @dev Converts an `address` into `address payable`. Note that this is
746      * simply a type cast: the actual underlying value is not changed.
747      *
748      * _Available since v2.4.0._
749      */
750     function toPayable(address account) internal pure returns (address payable) {
751         return address(uint160(account));
752     }
753 
754     /**
755      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
756      * `recipient`, forwarding all available gas and reverting on errors.
757      *
758      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
759      * of certain opcodes, possibly making contracts go over the 2300 gas limit
760      * imposed by `transfer`, making them unable to receive funds via
761      * `transfer`. {sendValue} removes this limitation.
762      *
763      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
764      *
765      * IMPORTANT: because control is transferred to `recipient`, care must be
766      * taken to not create reentrancy vulnerabilities. Consider using
767      * {ReentrancyGuard} or the
768      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
769      *
770      * _Available since v2.4.0._
771      */
772     function sendValue(address payable recipient, uint256 amount) internal {
773         require(address(this).balance >= amount, "Address: insufficient balance");
774 
775         // solhint-disable-next-line avoid-call-value
776         (bool success, ) = recipient.call.value(amount)("");
777         require(success, "Address: unable to send value, recipient may have reverted");
778     }
779 }
780 
781 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
782 
783 pragma solidity ^0.5.0;
784 
785 
786 
787 
788 /**
789  * @title SafeERC20
790  * @dev Wrappers around ERC20 operations that throw on failure (when the token
791  * contract returns false). Tokens that return no value (and instead revert or
792  * throw on failure) are also supported, non-reverting calls are assumed to be
793  * successful.
794  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
795  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
796  */
797 library SafeERC20 {
798     using SafeMath for uint256;
799     using Address for address;
800 
801     function safeTransfer(IERC20 token, address to, uint256 value) internal {
802         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
803     }
804 
805     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
806         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
807     }
808 
809     function safeApprove(IERC20 token, address spender, uint256 value) internal {
810         // safeApprove should only be called when setting an initial allowance,
811         // or when resetting it to zero. To increase and decrease it, use
812         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
813         // solhint-disable-next-line max-line-length
814         require((value == 0) || (token.allowance(address(this), spender) == 0),
815             "SafeERC20: approve from non-zero to non-zero allowance"
816         );
817         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
818     }
819 
820     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
821         uint256 newAllowance = token.allowance(address(this), spender).add(value);
822         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
823     }
824 
825     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
826         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
827         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
828     }
829 
830     /**
831      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
832      * on the return value: the return value is optional (but if data is returned, it must not be false).
833      * @param token The token targeted by the call.
834      * @param data The call data (encoded using abi.encode or one of its variants).
835      */
836     function callOptionalReturn(IERC20 token, bytes memory data) private {
837         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
838         // we're implementing it ourselves.
839 
840         // A Solidity high level call has three parts:
841         //  1. The target address is checked to verify it contains contract code
842         //  2. The call itself is made, and success asserted
843         //  3. The return value is decoded, which in turn checks the size of the returned data.
844         // solhint-disable-next-line max-line-length
845         require(address(token).isContract(), "SafeERC20: call to non-contract");
846 
847         // solhint-disable-next-line avoid-low-level-calls
848         (bool success, bytes memory returndata) = address(token).call(data);
849         require(success, "SafeERC20: low-level call failed");
850 
851         if (returndata.length > 0) { // Return data is optional
852             // solhint-disable-next-line max-line-length
853             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
854         }
855     }
856 }
857 
858 // File: @openzeppelin/contracts/ownership/Ownable.sol
859 
860 pragma solidity ^0.5.0;
861 
862 /**
863  * @dev Contract module which provides a basic access control mechanism, where
864  * there is an account (an owner) that can be granted exclusive access to
865  * specific functions.
866  *
867  * This module is used through inheritance. It will make available the modifier
868  * `onlyOwner`, which can be applied to your functions to restrict their use to
869  * the owner.
870  */
871 contract Ownable is Context {
872     address private _owner;
873 
874     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
875 
876     /**
877      * @dev Initializes the contract setting the deployer as the initial owner.
878      */
879     constructor () internal {
880         address msgSender = _msgSender();
881         _owner = msgSender;
882         emit OwnershipTransferred(address(0), msgSender);
883     }
884 
885     /**
886      * @dev Returns the address of the current owner.
887      */
888     function owner() public view returns (address) {
889         return _owner;
890     }
891 
892     /**
893      * @dev Throws if called by any account other than the owner.
894      */
895     modifier onlyOwner() {
896         require(isOwner(), "Ownable: caller is not the owner");
897         _;
898     }
899 
900     /**
901      * @dev Returns true if the caller is the current owner.
902      */
903     function isOwner() public view returns (bool) {
904         return _msgSender() == _owner;
905     }
906 
907     /**
908      * @dev Leaves the contract without owner. It will not be possible to call
909      * `onlyOwner` functions anymore. Can only be called by the current owner.
910      *
911      * NOTE: Renouncing ownership will leave the contract without an owner,
912      * thereby removing any functionality that is only available to the owner.
913      */
914     function renounceOwnership() public onlyOwner {
915         emit OwnershipTransferred(_owner, address(0));
916         _owner = address(0);
917     }
918 
919     /**
920      * @dev Transfers ownership of the contract to a new account (`newOwner`).
921      * Can only be called by the current owner.
922      */
923     function transferOwnership(address newOwner) public onlyOwner {
924         _transferOwnership(newOwner);
925     }
926 
927     /**
928      * @dev Transfers ownership of the contract to a new account (`newOwner`).
929      */
930     function _transferOwnership(address newOwner) internal {
931         require(newOwner != address(0), "Ownable: new owner is the zero address");
932         emit OwnershipTransferred(_owner, newOwner);
933         _owner = newOwner;
934     }
935 }
936 
937 // File: contracts/TokenVesting.sol
938 
939 // Token Vesting Contract
940 // Copyright (C) 2019  NYM Technologies SA
941 //
942 // This program is free software: you can redistribute it and/or modify
943 // it under the terms of the GNU Affero General Public License as
944 // published by the Free Software Foundation, either version 3 of the
945 // License, or (at your option) any later version.
946 //
947 // This program is distributed in the hope that it will be useful,
948 // but WITHOUT ANY WARRANTY; without even the implied warranty of
949 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
950 // GNU Affero General Public License for more details.
951 //
952 // You should have received a copy of the GNU Affero General Public License
953 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
954 
955 pragma solidity 0.5.17;
956 
957 
958 
959 
960 
961 /**
962  * @title Nym Token Vesting Contract
963  * @notice Contract to manage the vesting of tokens and their release for a given set of beneficiaries.
964  */
965 contract TokenVesting is Ownable {
966   using SafeMath for uint256;
967   using SafeERC20 for IERC20;
968 
969   // Address of the token contract used in the vesting
970   address internal mTokenContract;
971   // Number of release periods
972   uint256 internal mPeriodsCount;
973   // Amount of vested tokens overall
974   uint256 internal mTotalVested;
975   // Amount of tokens currently vested (which have not been released)
976   uint256 internal mCurrentVested;
977   // Indicates if beneficiaries are locked (true) or can still be modified (false)
978   bool internal mBeneficiariesLocked;
979   // Indicates if the vested tokens are locked (true) or can still be withdrawn (false)
980   bool internal mTokensLocked;
981   // List of release dates for each period in order
982   uint256[] internal mReleaseDates;
983 
984   // Period count mapped to release timestamp
985   mapping(uint256 => uint256) internal mVestReleaseDate;
986   // Beneficiary mapped to per period release amount
987   mapping(address => uint256) internal mVestReleaseAmount;
988   // Already executed claims
989   mapping(address => mapping(uint256 => bool)) internal mVestingClaims;
990 
991   /**
992    * @notice Indicate the addition of a new beneficiary to the vesting
993    * @param beneficiary Address of the new beneficiary
994    * @param releaseAmount Number of tokens to be release at each period for the beneficiary
995    */
996   event BeneficiaryAdded(address indexed beneficiary, uint256 releaseAmount);
997   /**
998    * @notice Indicate the removal of an existing beneficiary to the vesting
999    * @param beneficiary Address of the former beneficiary
1000    * @param releaseAmount Number of tokens which would have been released at each period for the beneficiary
1001    */
1002   event BeneficiaryRemoved(address indexed beneficiary, uint256 releaseAmount);
1003   /**
1004    * @notice Indicate the claim of tokens by a beneficiary
1005    * @param owner Address of the beneficiary which now the owner of the tokens
1006    * @param amount Number of tokens claimed this instance by the beneficiary
1007    */
1008   event TokensClaimed(address indexed owner, uint256 amount);
1009 
1010   /**
1011    * @notice Constructor to create a vesting schedule for a given token
1012    * @param _tokenContract Address of the token used for the vesting
1013    * @param _releaseDates List of timestamps representing the release time of each vesting period
1014    */
1015   constructor(address _tokenContract, uint256[] memory _releaseDates) public {
1016     require(_releaseDates.length > 0, "There must be at least 1 release date");
1017     require(_releaseDates[0] > block.timestamp + 3600, "Release dates must be at least 1h the future");
1018 
1019     mTokenContract = _tokenContract;
1020     mPeriodsCount = _releaseDates.length;
1021 
1022     mVestReleaseDate[0] = _releaseDates[0];
1023     for (uint256 i = 1; i < _releaseDates.length; i++) {
1024       require(
1025         _releaseDates[i] > _releaseDates[i - 1],
1026         "Release dates should be in strictly ascending order"
1027       );
1028       mVestReleaseDate[i] = _releaseDates[i];
1029     }
1030     mReleaseDates = _releaseDates;
1031     mTotalVested = 0;
1032     mCurrentVested = 0;
1033     mBeneficiariesLocked = false;
1034     mTokensLocked = false;
1035   }
1036 
1037   /**
1038    * @notice Token contract used in the vesting
1039    * @return Address of the token contract
1040    */
1041   function tokenContract() external view returns (address) {
1042     return mTokenContract;
1043   }
1044 
1045   /**
1046    * @notice Number of release periods
1047    * @return Number of release periods
1048    */
1049   function periodsCount() external view returns (uint256) {
1050     return mPeriodsCount;
1051   }
1052 
1053   /**
1054    * @notice Quantity of vested tokens overall
1055    * @return Amount of vested tokens
1056    */
1057   function totalVested() external view returns (uint256) {
1058     return mTotalVested;
1059   }
1060 
1061   /**
1062    * @notice Quantity of tokens currently vested (which have not been released)
1063    * @return Amount of currently vested tokens
1064    */
1065   function currentVested() external view returns (uint256) {
1066     return mCurrentVested;
1067   }
1068 
1069   /**
1070    * @notice Indicates if beneficiaries are locked or can still be modified
1071    * @return True if beneficiaries are locked, false if they are unlocked
1072    */
1073   function beneficiariesLocked() external view returns (bool) {
1074     return mBeneficiariesLocked;
1075   }
1076 
1077   /**
1078    * @notice Indicates if the vested tokens are locked or can still be withdrawn
1079    * @return True if tokens are locked, false if they are unlocked
1080    */
1081   function tokensLocked() external view returns (bool) {
1082     return mTokensLocked;
1083   }
1084 
1085   /**
1086    * @notice List of release dates for each period in order
1087    * @return Array of release dates, as number of seconds since January 1, 1970, 00:00:00 UTC
1088    */
1089   function releaseDates() external view returns (uint256[] memory) {
1090     return mReleaseDates;
1091   }
1092 
1093   /**
1094    * @notice Get the release date of a period
1095    * @param _period Period number (zero-based indexing)
1096    * @return Release date as a timestamp
1097    */
1098   function releaseDate(uint256 _period) external view returns (uint256) {
1099     return mVestReleaseDate[_period];
1100   }
1101 
1102   /**
1103    * @notice Get the amount released per period for the given beneficiary
1104    * @param _beneficiary Address of the beneficiary
1105    * @return Amount of tokens released for the beneficiary for each period
1106    */
1107   function releaseAmount(address _beneficiary) external view returns (uint256) {
1108     return mVestReleaseAmount[_beneficiary];
1109   }
1110 
1111   /**
1112    * @notice Get the release status for a given beneficiary and period
1113    * @param _beneficiary Address of the beneficiary
1114    * @param _period Period number (zero-based indexing)
1115    * @return True if the tokens were claimed by the beneficiary, false otherwise
1116    */
1117   function isReleased(address _beneficiary, uint256 _period) external view returns (bool) {
1118     return mVestingClaims[_beneficiary][_period];
1119   }
1120 
1121   /**
1122    * @notice Locks beneficiaries in place
1123    * @dev Once this function is called, beneficiaries cannot be added or removed. This cannot be undone.
1124    * This function can only be called once. It must be called before calling the lockTokens() function,
1125    * and before the first release period.
1126    */
1127   function lockBeneficiaries() external onlyOwner {
1128     require(!mBeneficiariesLocked, "Already locked");
1129     require(block.timestamp < mReleaseDates[0], "Cannot lock beneficiaries late");
1130     require(mTotalVested > 0, "No beneficiaries present");
1131     mBeneficiariesLocked = true;
1132   }
1133 
1134   /**
1135    * @notice Locks vested tokens in the contract
1136    * @dev Once this function is called, the amount of vested tokens cannot be transferred. This cannot be undone.
1137    * This function can only be called once. It must be called after calling the lockTokens() function,
1138    * and before the first release period. Excess tokens can be withdrawn at any time. The contract must have a balance
1139    * of at least as much as totalVested for this function to succeed.
1140    */
1141   function lockTokens() external onlyOwner {
1142     require(!mTokensLocked, "Already locked");
1143     require(mBeneficiariesLocked, "Beneficiaries are not locked");
1144     require(block.timestamp < mReleaseDates[0], "Cannot lock tokens late");
1145     uint256 balance = IERC20(mTokenContract).balanceOf(address(this));
1146     require(balance >= mTotalVested, "Balance must equal to or greater than the total vested amount");
1147     mCurrentVested = mTotalVested;
1148     mTokensLocked = true;
1149   }
1150 
1151   /**
1152    * @notice Add a beneficiary
1153    * @param _beneficiary The address who will eventually receive the tokens
1154    * @param _releaseAmount The amount of tokens released for each period, which can be claimed by the beneficiary
1155    * @dev This function will revert if called after startVesting() was called
1156    */
1157   function addBeneficiary(address _beneficiary, uint256 _releaseAmount) external onlyOwner {
1158     require(_beneficiary != address(0), "Beneficiary cannot be the zero-address");
1159     require(_beneficiary != address(this), "Beneficiary cannot be this vesting contract");
1160     require(_beneficiary != mTokenContract, "Beneficiary cannot be the token contract");
1161     require(mVestReleaseAmount[_beneficiary] == 0, "Beneficiary already exists");
1162     require(_releaseAmount != 0, "Vesting amount cannot be zero");
1163     require(!mBeneficiariesLocked, "Beneficiaries locked, cannot be added");
1164 
1165     mVestReleaseAmount[_beneficiary] = _releaseAmount;
1166     mTotalVested = mTotalVested.add(_releaseAmount.mul(mPeriodsCount));
1167 
1168     emit BeneficiaryAdded(_beneficiary, _releaseAmount);
1169   }
1170 
1171   /**
1172   * @notice Remove a beneficiary
1173   * @param _beneficiary The address of the beneficiary to remove
1174   * @dev This function will revert if called after startVesting() was called
1175   */
1176   function removeBeneficiary(address _beneficiary) external onlyOwner {
1177     require(_beneficiary != address(0), "Beneficiary cannot be the zero-address");
1178     require(_beneficiary != address(this), "Beneficiary cannot be this vesting contract");
1179     require(_beneficiary != mTokenContract, "Beneficiary cannot be the token contract");
1180     require(mVestReleaseAmount[_beneficiary] != 0, "Not a beneficiary");
1181     require(!mBeneficiariesLocked, "Beneficiaries locked, cannot be removed");
1182 
1183     uint256 beneficiaryReleaseAmount = mVestReleaseAmount[_beneficiary];
1184     mTotalVested = mTotalVested.sub(beneficiaryReleaseAmount.mul(mPeriodsCount));
1185     mVestReleaseAmount[_beneficiary] = 0;
1186 
1187     emit BeneficiaryRemoved(_beneficiary, beneficiaryReleaseAmount);
1188   }
1189 
1190   /**
1191    * @notice Allows the owner to withdraw uncommitted tokens (anything in excess of currentVested)
1192    * @param _amount Amount to withdraw
1193    */
1194   function withdraw(uint256 _amount) external onlyOwner {
1195     uint256 balance = IERC20(mTokenContract).balanceOf(address(this));
1196     uint256 freeBalance = balance.sub(mCurrentVested);
1197     require(_amount <= freeBalance, "Insufficient balance of non-vested tokens");
1198     IERC20(mTokenContract).safeTransfer(owner(), _amount);
1199   }
1200 
1201   /**
1202    * @notice Withdraw other tokens the contract may hold, such as tokens from airdrops
1203    * @param _tokenContract Address of the token contract to transfer
1204    * @param _dumpSite Address where to dump the tokens
1205    * @param _amount Amount of tokens to drain
1206    */
1207   function withdrawNonTokens(address _tokenContract, address _dumpSite, uint256 _amount) external onlyOwner {
1208     require(_tokenContract != mTokenContract, "Cannot withdraw vested tokens");
1209     IERC20(_tokenContract).safeTransfer(_dumpSite, _amount);
1210   }
1211 
1212   /**
1213    * @notice Withdraw any ether this contract may hold
1214    * @param _dumpSite Address where to transfer the ether
1215    * @param _amount Amount to transfer, in wei
1216    */
1217   function withdrawETH(address payable _dumpSite, uint256 _amount) external onlyOwner {
1218     _dumpSite.transfer(_amount);
1219   }
1220 
1221   /**
1222    * @notice Claim and transfer tokens on behalf of a beneficiary
1223    * @param _beneficiary Address of the beneficiary (which will receive the tokens)
1224    * @param _period Period number (zero-based indexing) for which to claim the tokens
1225    */
1226   function adminSendTokens(address _beneficiary, uint256 _period) external onlyOwner {
1227     processTokenClaim(_beneficiary, _period);
1228   }
1229 
1230   /**
1231    * @notice Directly claim tokens as a beneficiary from the contract
1232    * @param _period Period number (zero-based indexing) for which to claim the tokens
1233    */
1234   function claimTokens(uint256 _period) external {
1235     processTokenClaim(msg.sender, _period);
1236   }
1237 
1238   /**
1239    * @notice Process a claim to send tokens to the given beneficiary for the given period.
1240    * @param _beneficiary The address for which to process the claim
1241    * @param _period The period of the claim to process
1242    * @dev Internal function to be used every time a claim needs to be processed.
1243    * The lockBeneficiaries() & lockTokens() functions must be called once first for claims to be processed.
1244    * Only tokensLocked is checked, not beneficiariesLocked as for tokensLocked to be true, beneficiariesLocked also
1245    * has to be true.
1246    */
1247   function processTokenClaim(address _beneficiary, uint256 _period) internal {
1248     require(mTokensLocked, "Vesting has not started");
1249     require(mVestReleaseDate[_period] > 0, "Period does not exist");
1250     require(
1251       mVestReleaseDate[_period] < block.timestamp,
1252       "Release date of given period has not been reached yet."
1253       );
1254     require(mVestingClaims[_beneficiary][_period] == false, "Vesting has already been claimed");
1255 
1256     mVestingClaims[_beneficiary][_period] = true;
1257 
1258     mCurrentVested = mCurrentVested.sub(mVestReleaseAmount[_beneficiary]);
1259     IERC20(mTokenContract).safeTransfer(_beneficiary, mVestReleaseAmount[_beneficiary]);
1260 
1261     emit TokensClaimed(_beneficiary, mVestReleaseAmount[_beneficiary]);
1262   }
1263 
1264 }
1265 
1266 // File: contracts/NymToken.sol
1267 
1268 // NYM Token Contract
1269 // Copyright (C) 2019  NYM Technologies SA
1270 //
1271 // This program is free software: you can redistribute it and/or modify
1272 // it under the terms of the GNU Affero General Public License as
1273 // published by the Free Software Foundation, either version 3 of the
1274 // License, or (at your option) any later version.
1275 //
1276 // This program is distributed in the hope that it will be useful,
1277 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1278 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1279 // GNU Affero General Public License for more details.
1280 //
1281 // You should have received a copy of the GNU Affero General Public License
1282 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
1283 
1284 pragma solidity ^0.5.17;
1285 
1286 
1287 
1288 
1289 /**
1290  * @title Nym Token (NYM)
1291  * @notice Implementation of OpenZepplin's ERC20Capped and ERC20Detailed Token with custom burn.
1292  */
1293 contract NymToken is ERC20Capped, ERC20Detailed {
1294     constructor ()
1295     public
1296     ERC20Capped(1000000000*10**18)
1297     ERC20Detailed("Nym Token", "NYMPH", 18)
1298     {
1299         // solhint-disable-previous-line no-empty-blocks
1300     }
1301 
1302     /**
1303      * @notice Overload OpenZepplin internal _transfer() function to add extra require statement preventing
1304      * transferring tokens to the contract address
1305      * @param _sender The senders address
1306      * @param _recipient The recipients address
1307      * @param _amount Amount of tokens to transfer (in wei units)
1308      * @dev Moves tokens `amount` from `sender` to `recipient`.
1309      *
1310      * Additional requirements:
1311      *
1312      * - `_recipient` cannot be the token contract address.
1313      */
1314     function _transfer(address _sender, address _recipient, uint256 _amount) internal {
1315         require(_recipient != address(this), "NymToken: transfer to token contract address");
1316         super._transfer(_sender, _recipient, _amount);
1317     }
1318 
1319     /**
1320      * @notice Overload OpenZepplin internal _mint() function to add extra require statement preventing
1321      * minting tokens to the contract address
1322      * @param _account The address for which to mint tokens (must be MinterRolle)
1323      * @param _amount Amount of tokens to mint (in wei units)
1324      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1325      * the total supply.
1326      *
1327      * Additional requirements:
1328      *
1329      * - `_account` cannot be the token contract address.
1330      */
1331     function _mint(address _account, uint256 _amount) internal {
1332         require(_account != address(this), "NymToken: mint to token contract address");
1333         super._mint(_account, _amount);
1334     }
1335 
1336     /**
1337      * @notice Mint the necessary amount of tokens for a vesting contract.
1338      * @param _vestingContract Address fo the vesting contract for which to mint the tokens
1339      * @dev Only a minter can call this function. It must be called between locking the beneficiaries and the tokens.
1340      * If there are many vesting contracts and/or many beneficiaries with large vested amounts, which result overall
1341      * in a vested amount greater than the cap of the token, minting for vesting contracts may fail.
1342      * Checking currentVested is not needed as this function can only successfully be called between locking
1343      * beneficiaries and locking tokens. At this stage, currentVested is 0, and beneficiaries cannot withdraw any
1344      * tokens.
1345      */
1346     function mintForVesting(TokenVesting _vestingContract) public onlyMinter {
1347         require(_vestingContract.beneficiariesLocked(), "Beneficiaries are unlocked");
1348         require(!_vestingContract.tokensLocked(), "Tokens are locked");
1349         uint256 balance = balanceOf(address (_vestingContract));
1350         uint256 totalVested = _vestingContract.totalVested();
1351         uint256 mintAmount = totalVested.sub(balance);
1352         require(mintAmount > 0, "No vesting tokens to be minted");
1353         _mint(address(_vestingContract), mintAmount);
1354     }
1355 
1356     /**
1357      * @notice Burn the nessecary amount of tokens.
1358      * @param _amount Amount of tokens (in wei units)
1359      * @dev Destroys `amount` tokens from the caller. Only a minter can call this function.
1360      *
1361      * See {ERC20-_burn}.
1362      */
1363     function burn(uint256 _amount) public onlyMinter {
1364         _burn(msg.sender, _amount);
1365     }
1366 }