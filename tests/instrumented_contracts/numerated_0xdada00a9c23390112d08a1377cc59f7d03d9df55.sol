1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Context
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC20
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeMath
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         uint256 c = a + b;
129         if (c < a) return (false, 0);
130         return (true, c);
131     }
132 
133     /**
134      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
135      *
136      * _Available since v3.4._
137      */
138     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b > a) return (false, 0);
140         return (true, a - b);
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) return (true, 0);
153         uint256 c = a * b;
154         if (c / a != b) return (false, 0);
155         return (true, c);
156     }
157 
158     /**
159      * @dev Returns the division of two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         if (b == 0) return (false, 0);
165         return (true, a / b);
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b == 0) return (false, 0);
175         return (true, a % b);
176     }
177 
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191         return c;
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         require(b <= a, "SafeMath: subtraction overflow");
206         return a - b;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      *
217      * - Multiplication cannot overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         if (a == 0) return 0;
221         uint256 c = a * b;
222         require(c / a == b, "SafeMath: multiplication overflow");
223         return c;
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers, reverting on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         require(b > 0, "SafeMath: division by zero");
240         return a / b;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * reverting when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b > 0, "SafeMath: modulo by zero");
257         return a % b;
258     }
259 
260     /**
261      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
262      * overflow (when the result is negative).
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {trySub}.
266      *
267      * Counterpart to Solidity's `-` operator.
268      *
269      * Requirements:
270      *
271      * - Subtraction cannot overflow.
272      */
273     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         return a - b;
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
280      * division by zero. The result is rounded towards zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryDiv}.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a / b;
296     }
297 
298     /**
299      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
300      * reverting with custom message when dividing by zero.
301      *
302      * CAUTION: This function is deprecated because it requires allocating memory for the error
303      * message unnecessarily. For custom revert reasons use {tryMod}.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b > 0, errorMessage);
315         return a % b;
316     }
317 }
318 
319 // Part: Roles
320 
321 /**
322  * @title Roles
323  * @dev Library for managing addresses assigned to a Role.
324  */
325 library Roles {
326     struct Role {
327         mapping (address => bool) bearer;
328     }
329 
330     /**
331      * @dev give an account access to this role
332      */
333     function add(Role storage role, address account) internal {
334         require(account != address(0));
335         require(!has(role, account));
336 
337         role.bearer[account] = true;
338     }
339 
340     /**
341      * @dev remove an account's access to this role
342      */
343     function remove(Role storage role, address account) internal {
344         require(account != address(0));
345         require(has(role, account));
346 
347         role.bearer[account] = false;
348     }
349 
350     /**
351      * @dev check if an account has this role
352      * @return bool
353      */
354     function has(Role storage role, address account) internal view returns (bool) {
355         require(account != address(0));
356         return role.bearer[account];
357     }
358 }
359 
360 // Part: MinterRole
361 
362 contract MinterRole  {
363     using Roles for Roles.Role;
364 
365     event MinterAdded(address indexed account);
366     event MinterRemoved(address indexed account);
367 
368     Roles.Role private _minters;
369 
370     constructor(address sender) public  {
371         if (!isMinter(sender)) {
372             _addMinter(sender);
373         }
374     }
375 
376     modifier onlyMinter() {
377         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
378         _;
379     }
380 
381     function isMinter(address account) public view returns (bool) {
382         return _minters.has(account);
383     }
384 
385     function addMinter(address account) public onlyMinter {
386         _addMinter(account);
387     }
388 
389     function renounceMinter() public {
390         _removeMinter(msg.sender);
391     }
392 
393     function _addMinter(address account) internal {
394         _minters.add(account);
395         emit MinterAdded(account);
396     }
397 
398     function _removeMinter(address account) internal {
399         _minters.remove(account);
400         emit MinterRemoved(account);
401     }
402 
403 }
404 
405 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC20
406 
407 /**
408  * @dev Implementation of the {IERC20} interface.
409  *
410  * This implementation is agnostic to the way tokens are created. This means
411  * that a supply mechanism has to be added in a derived contract using {_mint}.
412  * For a generic mechanism see {ERC20PresetMinterPauser}.
413  *
414  * TIP: For a detailed writeup see our guide
415  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
416  * to implement supply mechanisms].
417  *
418  * We have followed general OpenZeppelin guidelines: functions revert instead
419  * of returning `false` on failure. This behavior is nonetheless conventional
420  * and does not conflict with the expectations of ERC20 applications.
421  *
422  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
423  * This allows applications to reconstruct the allowance for all accounts just
424  * by listening to said events. Other implementations of the EIP may not emit
425  * these events, as it isn't required by the specification.
426  *
427  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
428  * functions have been added to mitigate the well-known issues around setting
429  * allowances. See {IERC20-approve}.
430  */
431 contract ERC20 is Context, IERC20 {
432     using SafeMath for uint256;
433 
434     mapping (address => uint256) private _balances;
435 
436     mapping (address => mapping (address => uint256)) private _allowances;
437 
438     uint256 private _totalSupply;
439 
440     string private _name;
441     string private _symbol;
442     uint8 private _decimals;
443 
444     /**
445      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
446      * a default value of 18.
447      *
448      * To select a different value for {decimals}, use {_setupDecimals}.
449      *
450      * All three of these values are immutable: they can only be set once during
451      * construction.
452      */
453     constructor (string memory name_, string memory symbol_) public {
454         _name = name_;
455         _symbol = symbol_;
456         _decimals = 18;
457     }
458 
459     /**
460      * @dev Returns the name of the token.
461      */
462     function name() public view virtual returns (string memory) {
463         return _name;
464     }
465 
466     /**
467      * @dev Returns the symbol of the token, usually a shorter version of the
468      * name.
469      */
470     function symbol() public view virtual returns (string memory) {
471         return _symbol;
472     }
473 
474     /**
475      * @dev Returns the number of decimals used to get its user representation.
476      * For example, if `decimals` equals `2`, a balance of `505` tokens should
477      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
478      *
479      * Tokens usually opt for a value of 18, imitating the relationship between
480      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
481      * called.
482      *
483      * NOTE: This information is only used for _display_ purposes: it in
484      * no way affects any of the arithmetic of the contract, including
485      * {IERC20-balanceOf} and {IERC20-transfer}.
486      */
487     function decimals() public view virtual returns (uint8) {
488         return _decimals;
489     }
490 
491     /**
492      * @dev See {IERC20-totalSupply}.
493      */
494     function totalSupply() public view virtual override returns (uint256) {
495         return _totalSupply;
496     }
497 
498     /**
499      * @dev See {IERC20-balanceOf}.
500      */
501     function balanceOf(address account) public view virtual override returns (uint256) {
502         return _balances[account];
503     }
504 
505     /**
506      * @dev See {IERC20-transfer}.
507      *
508      * Requirements:
509      *
510      * - `recipient` cannot be the zero address.
511      * - the caller must have a balance of at least `amount`.
512      */
513     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
514         _transfer(_msgSender(), recipient, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-allowance}.
520      */
521     function allowance(address owner, address spender) public view virtual override returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     /**
526      * @dev See {IERC20-approve}.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function approve(address spender, uint256 amount) public virtual override returns (bool) {
533         _approve(_msgSender(), spender, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-transferFrom}.
539      *
540      * Emits an {Approval} event indicating the updated allowance. This is not
541      * required by the EIP. See the note at the beginning of {ERC20}.
542      *
543      * Requirements:
544      *
545      * - `sender` and `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      * - the caller must have allowance for ``sender``'s tokens of at least
548      * `amount`.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(sender, recipient, amount);
552         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
553         return true;
554     }
555 
556     /**
557      * @dev Atomically increases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically decreases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      * - `spender` must have allowance for the caller of at least
585      * `subtractedValue`.
586      */
587     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
588         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
589         return true;
590     }
591 
592     /**
593      * @dev Moves tokens `amount` from `sender` to `recipient`.
594      *
595      * This is internal function is equivalent to {transfer}, and can be used to
596      * e.g. implement automatic token fees, slashing mechanisms, etc.
597      *
598      * Emits a {Transfer} event.
599      *
600      * Requirements:
601      *
602      * - `sender` cannot be the zero address.
603      * - `recipient` cannot be the zero address.
604      * - `sender` must have a balance of at least `amount`.
605      */
606     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
607         require(sender != address(0), "ERC20: transfer from the zero address");
608         require(recipient != address(0), "ERC20: transfer to the zero address");
609 
610         _beforeTokenTransfer(sender, recipient, amount);
611 
612         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
613         _balances[recipient] = _balances[recipient].add(amount);
614         emit Transfer(sender, recipient, amount);
615     }
616 
617     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
618      * the total supply.
619      *
620      * Emits a {Transfer} event with `from` set to the zero address.
621      *
622      * Requirements:
623      *
624      * - `to` cannot be the zero address.
625      */
626     function _mint(address account, uint256 amount) internal virtual {
627         require(account != address(0), "ERC20: mint to the zero address");
628 
629         _beforeTokenTransfer(address(0), account, amount);
630 
631         _totalSupply = _totalSupply.add(amount);
632         _balances[account] = _balances[account].add(amount);
633         emit Transfer(address(0), account, amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, reducing the
638      * total supply.
639      *
640      * Emits a {Transfer} event with `to` set to the zero address.
641      *
642      * Requirements:
643      *
644      * - `account` cannot be the zero address.
645      * - `account` must have at least `amount` tokens.
646      */
647     function _burn(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: burn from the zero address");
649 
650         _beforeTokenTransfer(account, address(0), amount);
651 
652         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
653         _totalSupply = _totalSupply.sub(amount);
654         emit Transfer(account, address(0), amount);
655     }
656 
657     /**
658      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
659      *
660      * This internal function is equivalent to `approve`, and can be used to
661      * e.g. set automatic allowances for certain subsystems, etc.
662      *
663      * Emits an {Approval} event.
664      *
665      * Requirements:
666      *
667      * - `owner` cannot be the zero address.
668      * - `spender` cannot be the zero address.
669      */
670     function _approve(address owner, address spender, uint256 amount) internal virtual {
671         require(owner != address(0), "ERC20: approve from the zero address");
672         require(spender != address(0), "ERC20: approve to the zero address");
673 
674         _allowances[owner][spender] = amount;
675         emit Approval(owner, spender, amount);
676     }
677 
678     /**
679      * @dev Sets {decimals} to a value other than the default one of 18.
680      *
681      * WARNING: This function should only be called from the constructor. Most
682      * applications that interact with token contracts will not expect
683      * {decimals} to ever change, and may work incorrectly if it does.
684      */
685     function _setupDecimals(uint8 decimals_) internal virtual {
686         _decimals = decimals_;
687     }
688 
689     /**
690      * @dev Hook that is called before any transfer of tokens. This includes
691      * minting and burning.
692      *
693      * Calling conditions:
694      *
695      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
696      * will be to transferred to `to`.
697      * - when `from` is zero, `amount` tokens will be minted for `to`.
698      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
699      * - `from` and `to` are never both zero.
700      *
701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
702      */
703     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
704 }
705 
706 // File: DungERC20.sol
707 
708 contract Dung is ERC20, MinterRole {
709 	using SafeMath for uint256;
710 
711     uint256 public constant INITIAL_MINT = 1000000e33;
712 
713     constructor()
714         ERC20("Degen$ Farm Dung", "DUNG")
715         MinterRole(address(0x39b550e389F20ba42a76eC083F0DE75b40531598))
716     {
717         _mint(address(0x39b550e389F20ba42a76eC083F0DE75b40531598), INITIAL_MINT);
718     }
719 
720     function mint(address to, uint256 amount) external onlyMinter {
721         _mint(to, amount);
722     }
723 
724     function burn(uint256 amount) external {
725         _burn(msg.sender, amount);
726     }
727 
728      /**
729      * @dev Owner can claim any tokens that transfered
730      * to this contract address
731      */
732     function reclaimToken(ERC20 token) external onlyMinter {
733         require(address(token) != address(0));
734         uint256 balance = token.balanceOf(address(this));
735         token.transfer(msg.sender, balance);
736     }
737 
738     /**
739      * @dev This function implement proxy for befor transfer hook form OpenZeppelin ERC20.
740      *
741      * It use interface for call checker function from external (or this) contract  defined
742      * defined by owner.
743      */
744     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
745         require(to != address(this), "This contract not accept tokens" );
746     }
747 
748 }
