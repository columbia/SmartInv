1 pragma solidity 0.5.11;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
31  * the optional functions; to access them see {ERC20Detailed}.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      * - Subtraction cannot overflow.
155      *
156      * _Available since v2.4.0._
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      *
214      * _Available since v2.4.0._
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      *
251      * _Available since v2.4.0._
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 /**
260  * @title Roles
261  * @dev Library for managing addresses assigned to a Role.
262  */
263 library Roles {
264     struct Role {
265         mapping (address => bool) bearer;
266     }
267 
268     /**
269      * @dev Give an account access to this role.
270      */
271     function add(Role storage role, address account) internal {
272         require(!has(role, account), "Roles: account already has role");
273         role.bearer[account] = true;
274     }
275 
276     /**
277      * @dev Remove an account's access to this role.
278      */
279     function remove(Role storage role, address account) internal {
280         require(has(role, account), "Roles: account does not have role");
281         role.bearer[account] = false;
282     }
283 
284     /**
285      * @dev Check if an account has this role.
286      * @return bool
287      */
288     function has(Role storage role, address account) internal view returns (bool) {
289         require(account != address(0), "Roles: account is the zero address");
290         return role.bearer[account];
291     }
292 }
293 
294 contract MinterRole is Context {
295     using Roles for Roles.Role;
296 
297     event MinterAdded(address indexed account);
298     event MinterRemoved(address indexed account);
299 
300     Roles.Role private _minters;
301 
302     constructor () internal {
303         _addMinter(_msgSender());
304     }
305 
306     modifier onlyMinter() {
307         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
308         _;
309     }
310 
311     function isMinter(address account) public view returns (bool) {
312         return _minters.has(account);
313     }
314 
315     function addMinter(address account) public onlyMinter {
316         _addMinter(account);
317     }
318 
319     function renounceMinter() public {
320         _removeMinter(_msgSender());
321     }
322 
323     function _addMinter(address account) internal {
324         _minters.add(account);
325         emit MinterAdded(account);
326     }
327 
328     function _removeMinter(address account) internal {
329         _minters.remove(account);
330         emit MinterRemoved(account);
331     }
332 }
333 
334 
335 /**
336  * @dev Implementation of the {IERC20} interface.
337  *
338  * This implementation is agnostic to the way tokens are created. This means
339  * that a supply mechanism has to be added in a derived contract using {_mint}.
340  * For a generic mechanism see {ERC20Mintable}.
341  *
342  * TIP: For a detailed writeup see our guide
343  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
344  * to implement supply mechanisms].
345  *
346  * We have followed general OpenZeppelin guidelines: functions revert instead
347  * of returning `false` on failure. This behavior is nonetheless conventional
348  * and does not conflict with the expectations of ERC20 applications.
349  *
350  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
351  * This allows applications to reconstruct the allowance for all accounts just
352  * by listening to said events. Other implementations of the EIP may not emit
353  * these events, as it isn't required by the specification.
354  *
355  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
356  * functions have been added to mitigate the well-known issues around setting
357  * allowances. See {IERC20-approve}.
358  */
359 contract ERC20 is Context, IERC20 {
360     using SafeMath for uint256;
361 
362     mapping (address => uint256) private _balances;
363 
364     mapping (address => mapping (address => uint256)) private _allowances;
365 
366     uint256 private _totalSupply;
367 
368     /**
369      * @dev See {IERC20-totalSupply}.
370      */
371     function totalSupply() public view returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See {IERC20-balanceOf}.
377      */
378     function balanceOf(address account) public view returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See {IERC20-transfer}.
384      *
385      * Requirements:
386      *
387      * - `recipient` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address recipient, uint256 amount) public returns (bool) {
391         _transfer(_msgSender(), recipient, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-allowance}.
397      */
398     function allowance(address owner, address spender) public view returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See {IERC20-approve}.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 amount) public returns (bool) {
410         _approve(_msgSender(), spender, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-transferFrom}.
416      *
417      * Emits an {Approval} event indicating the updated allowance. This is not
418      * required by the EIP. See the note at the beginning of {ERC20};
419      *
420      * Requirements:
421      * - `sender` and `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      * - the caller must have allowance for `sender`'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically increases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to {approve} that can be used as a mitigation for
453      * problems described in {IERC20-approve}.
454      *
455      * Emits an {Approval} event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
465         return true;
466     }
467 
468     /**
469      * @dev Moves tokens `amount` from `sender` to `recipient`.
470      *
471      * This is internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(address sender, address recipient, uint256 amount) internal {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
487         _balances[recipient] = _balances[recipient].add(amount);
488         emit Transfer(sender, recipient, amount);
489     }
490 
491     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492      * the total supply.
493      *
494      * Emits a {Transfer} event with `from` set to the zero address.
495      *
496      * Requirements
497      *
498      * - `to` cannot be the zero address.
499      */
500     function _mint(address account, uint256 amount) internal {
501         require(account != address(0), "ERC20: mint to the zero address");
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
523         _totalSupply = _totalSupply.sub(amount);
524         emit Transfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
529      *
530      * This is internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(address owner, address spender, uint256 amount) internal {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
550      * from the caller's allowance.
551      *
552      * See {_burn} and {_approve}.
553      */
554     function _burnFrom(address account, uint256 amount) internal {
555         _burn(account, amount);
556         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
557     }
558 }
559 
560 /**
561  * @dev Optional functions from the ERC20 standard.
562  */
563 contract ERC20Detailed is IERC20 {
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567 
568     /**
569      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
570      * these values are immutable: they can only be set once during
571      * construction.
572      */
573     constructor (string memory name, string memory symbol, uint8 decimals) public {
574         _name = name;
575         _symbol = symbol;
576         _decimals = decimals;
577     }
578 
579     /**
580      * @dev Returns the name of the token.
581      */
582     function name() public view returns (string memory) {
583         return _name;
584     }
585 
586     /**
587      * @dev Returns the symbol of the token, usually a shorter version of the
588      * name.
589      */
590     function symbol() public view returns (string memory) {
591         return _symbol;
592     }
593 
594     /**
595      * @dev Returns the number of decimals used to get its user representation.
596      * For example, if `decimals` equals `2`, a balance of `505` tokens should
597      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
598      *
599      * Tokens usually opt for a value of 18, imitating the relationship between
600      * Ether and Wei.
601      *
602      * NOTE: This information is only used for _display_ purposes: it in
603      * no way affects any of the arithmetic of the contract, including
604      * {IERC20-balanceOf} and {IERC20-transfer}.
605      */
606     function decimals() public view returns (uint8) {
607         return _decimals;
608     }
609 }
610 
611 /**
612  * @dev Contract module which provides a basic access control mechanism, where
613  * there is an account (an owner) that can be granted exclusive access to
614  * specific functions.
615  *
616  * This module is used through inheritance. It will make available the modifier
617  * `onlyOwner`, which can be applied to your functions to restrict their use to
618  * the owner.
619  */
620 contract Ownable is Context {
621     address private _owner;
622 
623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
624 
625     /**
626      * @dev Initializes the contract setting the deployer as the initial owner.
627      */
628     constructor () internal {
629         address msgSender = _msgSender();
630         _owner = msgSender;
631         emit OwnershipTransferred(address(0), msgSender);
632     }
633 
634     /**
635      * @dev Returns the address of the current owner.
636      */
637     function owner() public view returns (address) {
638         return _owner;
639     }
640 
641     /**
642      * @dev Throws if called by any account other than the owner.
643      */
644     modifier onlyOwner() {
645         require(isOwner(), "Ownable: caller is not the owner");
646         _;
647     }
648 
649     /**
650      * @dev Returns true if the caller is the current owner.
651      */
652     function isOwner() public view returns (bool) {
653         return _msgSender() == _owner;
654     }
655 
656     /**
657      * @dev Leaves the contract without owner. It will not be possible to call
658      * `onlyOwner` functions anymore. Can only be called by the current owner.
659      *
660      * NOTE: Renouncing ownership will leave the contract without an owner,
661      * thereby removing any functionality that is only available to the owner.
662      */
663     function renounceOwnership() public onlyOwner {
664         emit OwnershipTransferred(_owner, address(0));
665         _owner = address(0);
666     }
667 
668     /**
669      * @dev Transfers ownership of the contract to a new account (`newOwner`).
670      * Can only be called by the current owner.
671      */
672     function transferOwnership(address newOwner) public onlyOwner {
673         _transferOwnership(newOwner);
674     }
675 
676     /**
677      * @dev Transfers ownership of the contract to a new account (`newOwner`).
678      */
679     function _transferOwnership(address newOwner) internal {
680         require(newOwner != address(0), "Ownable: new owner is the zero address");
681         emit OwnershipTransferred(_owner, newOwner);
682         _owner = newOwner;
683     }
684 }
685 
686 /**
687  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
688  * which have permission to mint (create) new tokens as they see fit.
689  *
690  * At construction, the deployer of the contract is the only minter.
691  */
692 contract ERC20Mintable is ERC20, MinterRole {
693     /**
694      * @dev See {ERC20-_mint}.
695      *
696      * Requirements:
697      *
698      * - the caller must have the {MinterRole}.
699      */
700     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
701         _mint(account, amount);
702         return true;
703     }
704 }
705 
706 /**
707  * @dev Extension of {ERC20} that allows token holders to destroy both their own
708  * tokens and those that they have an allowance for, in a way that can be
709  * recognized off-chain (via event analysis).
710  */
711 contract ERC20Burnable is Context, ERC20 {
712     /**
713      * @dev Destroys `amount` tokens from the caller.
714      *
715      * See {ERC20-_burn}.
716      */
717     function burn(uint256 amount) public {
718         _burn(_msgSender(), amount);
719     }
720 
721     /**
722      * @dev See {ERC20-_burnFrom}.
723      */
724     function burnFrom(address account, uint256 amount) public {
725         _burnFrom(account, amount);
726     }
727 }
728 
729 /**
730  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
731  */
732 contract ERC20Capped is ERC20Mintable {
733     uint256 private _cap;
734 
735     /**
736      * @dev Sets the value of the `cap`. This value is immutable, it can only be
737      * set once during construction.
738      */
739     constructor (uint256 cap) public {
740         require(cap > 0, "ERC20Capped: cap is 0");
741         _cap = cap;
742     }
743 
744     /**
745      * @dev Returns the cap on the token's total supply.
746      */
747     function cap() public view returns (uint256) {
748         return _cap;
749     }
750 
751     /**
752      * @dev See {ERC20Mintable-mint}.
753      *
754      * Requirements:
755      *
756      * - `value` must not cause the total supply to go over the cap.
757      */
758     function _mint(address account, uint256 value) internal {
759         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
760         super._mint(account, value);
761     }
762 }
763 
764 contract GIVToken is ERC20Detailed, ERC20Capped, ERC20Burnable, Ownable {
765     constructor () 
766         public 
767         ERC20Detailed("GIVToken", "GIV", 8)
768         ERC20Capped((10 ** 9) * (10 ** 8))
769     {
770         _mint(_msgSender(), 500000000 * (10 ** 8));
771     }
772 }