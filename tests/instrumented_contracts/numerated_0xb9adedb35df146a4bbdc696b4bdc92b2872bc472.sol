1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 // SPDX-License-Identifier: MIT
111 
112 pragma solidity >=0.6.0 <0.8.0;
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
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 // SPDX-License-Identifier: MIT
328 
329 pragma solidity >=0.6.0 <0.8.0;
330 
331 
332 
333 
334 /**
335  * @dev Implementation of the {IERC20} interface.
336  *
337  * This implementation is agnostic to the way tokens are created. This means
338  * that a supply mechanism has to be added in a derived contract using {_mint}.
339  * For a generic mechanism see {ERC20PresetMinterPauser}.
340  *
341  * TIP: For a detailed writeup see our guide
342  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
343  * to implement supply mechanisms].
344  *
345  * We have followed general OpenZeppelin guidelines: functions revert instead
346  * of returning `false` on failure. This behavior is nonetheless conventional
347  * and does not conflict with the expectations of ERC20 applications.
348  *
349  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
350  * This allows applications to reconstruct the allowance for all accounts just
351  * by listening to said events. Other implementations of the EIP may not emit
352  * these events, as it isn't required by the specification.
353  *
354  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
355  * functions have been added to mitigate the well-known issues around setting
356  * allowances. See {IERC20-approve}.
357  */
358 contract ERC20 is Context, IERC20 {
359     using SafeMath for uint256;
360 
361     mapping (address => uint256) private _balances;
362 
363     mapping (address => mapping (address => uint256)) private _allowances;
364 
365     uint256 private _totalSupply;
366 
367     string private _name;
368     string private _symbol;
369     uint8 private _decimals;
370 
371     /**
372      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
373      * a default value of 18.
374      *
375      * To select a different value for {decimals}, use {_setupDecimals}.
376      *
377      * All three of these values are immutable: they can only be set once during
378      * construction.
379      */
380     constructor (string memory name_, string memory symbol_) public {
381         _name = name_;
382         _symbol = symbol_;
383         _decimals = 18;
384     }
385 
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() public view virtual returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @dev Returns the symbol of the token, usually a shorter version of the
395      * name.
396      */
397     function symbol() public view virtual returns (string memory) {
398         return _symbol;
399     }
400 
401     /**
402      * @dev Returns the number of decimals used to get its user representation.
403      * For example, if `decimals` equals `2`, a balance of `505` tokens should
404      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
405      *
406      * Tokens usually opt for a value of 18, imitating the relationship between
407      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
408      * called.
409      *
410      * NOTE: This information is only used for _display_ purposes: it in
411      * no way affects any of the arithmetic of the contract, including
412      * {IERC20-balanceOf} and {IERC20-transfer}.
413      */
414     function decimals() public view virtual returns (uint8) {
415         return _decimals;
416     }
417 
418     /**
419      * @dev See {IERC20-totalSupply}.
420      */
421     function totalSupply() public view virtual override returns (uint256) {
422         return _totalSupply;
423     }
424 
425     /**
426      * @dev See {IERC20-balanceOf}.
427      */
428     function balanceOf(address account) public view virtual override returns (uint256) {
429         return _balances[account];
430     }
431 
432     /**
433      * @dev See {IERC20-transfer}.
434      *
435      * Requirements:
436      *
437      * - `recipient` cannot be the zero address.
438      * - the caller must have a balance of at least `amount`.
439      */
440     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     /**
446      * @dev See {IERC20-allowance}.
447      */
448     function allowance(address owner, address spender) public view virtual override returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     /**
453      * @dev See {IERC20-approve}.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      */
459     function approve(address spender, uint256 amount) public virtual override returns (bool) {
460         _approve(_msgSender(), spender, amount);
461         return true;
462     }
463 
464     /**
465      * @dev See {IERC20-transferFrom}.
466      *
467      * Emits an {Approval} event indicating the updated allowance. This is not
468      * required by the EIP. See the note at the beginning of {ERC20}.
469      *
470      * Requirements:
471      *
472      * - `sender` and `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      * - the caller must have allowance for ``sender``'s tokens of at least
475      * `amount`.
476      */
477     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
478         _transfer(sender, recipient, amount);
479         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
480         return true;
481     }
482 
483     /**
484      * @dev Atomically increases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      */
495     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
497         return true;
498     }
499 
500     /**
501      * @dev Atomically decreases the allowance granted to `spender` by the caller.
502      *
503      * This is an alternative to {approve} that can be used as a mitigation for
504      * problems described in {IERC20-approve}.
505      *
506      * Emits an {Approval} event indicating the updated allowance.
507      *
508      * Requirements:
509      *
510      * - `spender` cannot be the zero address.
511      * - `spender` must have allowance for the caller of at least
512      * `subtractedValue`.
513      */
514     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
516         return true;
517     }
518 
519     /**
520      * @dev Moves tokens `amount` from `sender` to `recipient`.
521      *
522      * This is internal function is equivalent to {transfer}, and can be used to
523      * e.g. implement automatic token fees, slashing mechanisms, etc.
524      *
525      * Emits a {Transfer} event.
526      *
527      * Requirements:
528      *
529      * - `sender` cannot be the zero address.
530      * - `recipient` cannot be the zero address.
531      * - `sender` must have a balance of at least `amount`.
532      */
533     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
534         require(sender != address(0), "ERC20: transfer from the zero address");
535         require(recipient != address(0), "ERC20: transfer to the zero address");
536 
537         _beforeTokenTransfer(sender, recipient, amount);
538 
539         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
540         _balances[recipient] = _balances[recipient].add(amount);
541         emit Transfer(sender, recipient, amount);
542     }
543 
544     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
545      * the total supply.
546      *
547      * Emits a {Transfer} event with `from` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `to` cannot be the zero address.
552      */
553     function _mint(address account, uint256 amount) internal virtual {
554         require(account != address(0), "ERC20: mint to the zero address");
555 
556         _beforeTokenTransfer(address(0), account, amount);
557 
558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, reducing the
565      * total supply.
566      *
567      * Emits a {Transfer} event with `to` set to the zero address.
568      *
569      * Requirements:
570      *
571      * - `account` cannot be the zero address.
572      * - `account` must have at least `amount` tokens.
573      */
574     function _burn(address account, uint256 amount) internal virtual {
575         require(account != address(0), "ERC20: burn from the zero address");
576 
577         _beforeTokenTransfer(account, address(0), amount);
578 
579         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
580         _totalSupply = _totalSupply.sub(amount);
581         emit Transfer(account, address(0), amount);
582     }
583 
584     /**
585      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
586      *
587      * This internal function is equivalent to `approve`, and can be used to
588      * e.g. set automatic allowances for certain subsystems, etc.
589      *
590      * Emits an {Approval} event.
591      *
592      * Requirements:
593      *
594      * - `owner` cannot be the zero address.
595      * - `spender` cannot be the zero address.
596      */
597     function _approve(address owner, address spender, uint256 amount) internal virtual {
598         require(owner != address(0), "ERC20: approve from the zero address");
599         require(spender != address(0), "ERC20: approve to the zero address");
600 
601         _allowances[owner][spender] = amount;
602         emit Approval(owner, spender, amount);
603     }
604 
605     /**
606      * @dev Sets {decimals} to a value other than the default one of 18.
607      *
608      * WARNING: This function should only be called from the constructor. Most
609      * applications that interact with token contracts will not expect
610      * {decimals} to ever change, and may work incorrectly if it does.
611      */
612     function _setupDecimals(uint8 decimals_) internal virtual {
613         _decimals = decimals_;
614     }
615 
616     /**
617      * @dev Hook that is called before any transfer of tokens. This includes
618      * minting and burning.
619      *
620      * Calling conditions:
621      *
622      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
623      * will be to transferred to `to`.
624      * - when `from` is zero, `amount` tokens will be minted for `to`.
625      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
631 }
632 
633 // File: @openzeppelin/contracts/access/Ownable.sol
634 
635 // SPDX-License-Identifier: MIT
636 
637 pragma solidity >=0.6.0 <0.8.0;
638 
639 /**
640  * @dev Contract module which provides a basic access control mechanism, where
641  * there is an account (an owner) that can be granted exclusive access to
642  * specific functions.
643  *
644  * By default, the owner account will be the one that deploys the contract. This
645  * can later be changed with {transferOwnership}.
646  *
647  * This module is used through inheritance. It will make available the modifier
648  * `onlyOwner`, which can be applied to your functions to restrict their use to
649  * the owner.
650  */
651 abstract contract Ownable is Context {
652     address private _owner;
653 
654     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
655 
656     /**
657      * @dev Initializes the contract setting the deployer as the initial owner.
658      */
659     constructor () internal {
660         address msgSender = _msgSender();
661         _owner = msgSender;
662         emit OwnershipTransferred(address(0), msgSender);
663     }
664 
665     /**
666      * @dev Returns the address of the current owner.
667      */
668     function owner() public view virtual returns (address) {
669         return _owner;
670     }
671 
672     /**
673      * @dev Throws if called by any account other than the owner.
674      */
675     modifier onlyOwner() {
676         require(owner() == _msgSender(), "Ownable: caller is not the owner");
677         _;
678     }
679 
680     /**
681      * @dev Leaves the contract without owner. It will not be possible to call
682      * `onlyOwner` functions anymore. Can only be called by the current owner.
683      *
684      * NOTE: Renouncing ownership will leave the contract without an owner,
685      * thereby removing any functionality that is only available to the owner.
686      */
687     function renounceOwnership() public virtual onlyOwner {
688         emit OwnershipTransferred(_owner, address(0));
689         _owner = address(0);
690     }
691 
692     /**
693      * @dev Transfers ownership of the contract to a new account (`newOwner`).
694      * Can only be called by the current owner.
695      */
696     function transferOwnership(address newOwner) public virtual onlyOwner {
697         require(newOwner != address(0), "Ownable: new owner is the zero address");
698         emit OwnershipTransferred(_owner, newOwner);
699         _owner = newOwner;
700     }
701 }
702 
703 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
704 
705 // SPDX-License-Identifier: MIT
706 
707 pragma solidity >=0.6.0 <0.8.0;
708 
709 /**
710  * @dev Library for managing
711  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
712  * types.
713  *
714  * Sets have the following properties:
715  *
716  * - Elements are added, removed, and checked for existence in constant time
717  * (O(1)).
718  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
719  *
720  * ```
721  * contract Example {
722  *     // Add the library methods
723  *     using EnumerableSet for EnumerableSet.AddressSet;
724  *
725  *     // Declare a set state variable
726  *     EnumerableSet.AddressSet private mySet;
727  * }
728  * ```
729  *
730  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
731  * and `uint256` (`UintSet`) are supported.
732  */
733 library EnumerableSet {
734     // To implement this library for multiple types with as little code
735     // repetition as possible, we write it in terms of a generic Set type with
736     // bytes32 values.
737     // The Set implementation uses private functions, and user-facing
738     // implementations (such as AddressSet) are just wrappers around the
739     // underlying Set.
740     // This means that we can only create new EnumerableSets for types that fit
741     // in bytes32.
742 
743     struct Set {
744         // Storage of set values
745         bytes32[] _values;
746 
747         // Position of the value in the `values` array, plus 1 because index 0
748         // means a value is not in the set.
749         mapping (bytes32 => uint256) _indexes;
750     }
751 
752     /**
753      * @dev Add a value to a set. O(1).
754      *
755      * Returns true if the value was added to the set, that is if it was not
756      * already present.
757      */
758     function _add(Set storage set, bytes32 value) private returns (bool) {
759         if (!_contains(set, value)) {
760             set._values.push(value);
761             // The value is stored at length-1, but we add 1 to all indexes
762             // and use 0 as a sentinel value
763             set._indexes[value] = set._values.length;
764             return true;
765         } else {
766             return false;
767         }
768     }
769 
770     /**
771      * @dev Removes a value from a set. O(1).
772      *
773      * Returns true if the value was removed from the set, that is if it was
774      * present.
775      */
776     function _remove(Set storage set, bytes32 value) private returns (bool) {
777         // We read and store the value's index to prevent multiple reads from the same storage slot
778         uint256 valueIndex = set._indexes[value];
779 
780         if (valueIndex != 0) { // Equivalent to contains(set, value)
781             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
782             // the array, and then remove the last element (sometimes called as 'swap and pop').
783             // This modifies the order of the array, as noted in {at}.
784 
785             uint256 toDeleteIndex = valueIndex - 1;
786             uint256 lastIndex = set._values.length - 1;
787 
788             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
789             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
790 
791             bytes32 lastvalue = set._values[lastIndex];
792 
793             // Move the last value to the index where the value to delete is
794             set._values[toDeleteIndex] = lastvalue;
795             // Update the index for the moved value
796             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
797 
798             // Delete the slot where the moved value was stored
799             set._values.pop();
800 
801             // Delete the index for the deleted slot
802             delete set._indexes[value];
803 
804             return true;
805         } else {
806             return false;
807         }
808     }
809 
810     /**
811      * @dev Returns true if the value is in the set. O(1).
812      */
813     function _contains(Set storage set, bytes32 value) private view returns (bool) {
814         return set._indexes[value] != 0;
815     }
816 
817     /**
818      * @dev Returns the number of values on the set. O(1).
819      */
820     function _length(Set storage set) private view returns (uint256) {
821         return set._values.length;
822     }
823 
824    /**
825     * @dev Returns the value stored at position `index` in the set. O(1).
826     *
827     * Note that there are no guarantees on the ordering of values inside the
828     * array, and it may change when more values are added or removed.
829     *
830     * Requirements:
831     *
832     * - `index` must be strictly less than {length}.
833     */
834     function _at(Set storage set, uint256 index) private view returns (bytes32) {
835         require(set._values.length > index, "EnumerableSet: index out of bounds");
836         return set._values[index];
837     }
838 
839     // Bytes32Set
840 
841     struct Bytes32Set {
842         Set _inner;
843     }
844 
845     /**
846      * @dev Add a value to a set. O(1).
847      *
848      * Returns true if the value was added to the set, that is if it was not
849      * already present.
850      */
851     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
852         return _add(set._inner, value);
853     }
854 
855     /**
856      * @dev Removes a value from a set. O(1).
857      *
858      * Returns true if the value was removed from the set, that is if it was
859      * present.
860      */
861     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
862         return _remove(set._inner, value);
863     }
864 
865     /**
866      * @dev Returns true if the value is in the set. O(1).
867      */
868     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
869         return _contains(set._inner, value);
870     }
871 
872     /**
873      * @dev Returns the number of values in the set. O(1).
874      */
875     function length(Bytes32Set storage set) internal view returns (uint256) {
876         return _length(set._inner);
877     }
878 
879    /**
880     * @dev Returns the value stored at position `index` in the set. O(1).
881     *
882     * Note that there are no guarantees on the ordering of values inside the
883     * array, and it may change when more values are added or removed.
884     *
885     * Requirements:
886     *
887     * - `index` must be strictly less than {length}.
888     */
889     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
890         return _at(set._inner, index);
891     }
892 
893     // AddressSet
894 
895     struct AddressSet {
896         Set _inner;
897     }
898 
899     /**
900      * @dev Add a value to a set. O(1).
901      *
902      * Returns true if the value was added to the set, that is if it was not
903      * already present.
904      */
905     function add(AddressSet storage set, address value) internal returns (bool) {
906         return _add(set._inner, bytes32(uint256(uint160(value))));
907     }
908 
909     /**
910      * @dev Removes a value from a set. O(1).
911      *
912      * Returns true if the value was removed from the set, that is if it was
913      * present.
914      */
915     function remove(AddressSet storage set, address value) internal returns (bool) {
916         return _remove(set._inner, bytes32(uint256(uint160(value))));
917     }
918 
919     /**
920      * @dev Returns true if the value is in the set. O(1).
921      */
922     function contains(AddressSet storage set, address value) internal view returns (bool) {
923         return _contains(set._inner, bytes32(uint256(uint160(value))));
924     }
925 
926     /**
927      * @dev Returns the number of values in the set. O(1).
928      */
929     function length(AddressSet storage set) internal view returns (uint256) {
930         return _length(set._inner);
931     }
932 
933    /**
934     * @dev Returns the value stored at position `index` in the set. O(1).
935     *
936     * Note that there are no guarantees on the ordering of values inside the
937     * array, and it may change when more values are added or removed.
938     *
939     * Requirements:
940     *
941     * - `index` must be strictly less than {length}.
942     */
943     function at(AddressSet storage set, uint256 index) internal view returns (address) {
944         return address(uint160(uint256(_at(set._inner, index))));
945     }
946 
947 
948     // UintSet
949 
950     struct UintSet {
951         Set _inner;
952     }
953 
954     /**
955      * @dev Add a value to a set. O(1).
956      *
957      * Returns true if the value was added to the set, that is if it was not
958      * already present.
959      */
960     function add(UintSet storage set, uint256 value) internal returns (bool) {
961         return _add(set._inner, bytes32(value));
962     }
963 
964     /**
965      * @dev Removes a value from a set. O(1).
966      *
967      * Returns true if the value was removed from the set, that is if it was
968      * present.
969      */
970     function remove(UintSet storage set, uint256 value) internal returns (bool) {
971         return _remove(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
978         return _contains(set._inner, bytes32(value));
979     }
980 
981     /**
982      * @dev Returns the number of values on the set. O(1).
983      */
984     function length(UintSet storage set) internal view returns (uint256) {
985         return _length(set._inner);
986     }
987 
988    /**
989     * @dev Returns the value stored at position `index` in the set. O(1).
990     *
991     * Note that there are no guarantees on the ordering of values inside the
992     * array, and it may change when more values are added or removed.
993     *
994     * Requirements:
995     *
996     * - `index` must be strictly less than {length}.
997     */
998     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
999         return uint256(_at(set._inner, index));
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/utils/Address.sol
1004 
1005 // SPDX-License-Identifier: MIT
1006 
1007 pragma solidity >=0.6.2 <0.8.0;
1008 
1009 /**
1010  * @dev Collection of functions related to the address type
1011  */
1012 library Address {
1013     /**
1014      * @dev Returns true if `account` is a contract.
1015      *
1016      * [IMPORTANT]
1017      * ====
1018      * It is unsafe to assume that an address for which this function returns
1019      * false is an externally-owned account (EOA) and not a contract.
1020      *
1021      * Among others, `isContract` will return false for the following
1022      * types of addresses:
1023      *
1024      *  - an externally-owned account
1025      *  - a contract in construction
1026      *  - an address where a contract will be created
1027      *  - an address where a contract lived, but was destroyed
1028      * ====
1029      */
1030     function isContract(address account) internal view returns (bool) {
1031         // This method relies on extcodesize, which returns 0 for contracts in
1032         // construction, since the code is only stored at the end of the
1033         // constructor execution.
1034 
1035         uint256 size;
1036         // solhint-disable-next-line no-inline-assembly
1037         assembly { size := extcodesize(account) }
1038         return size > 0;
1039     }
1040 
1041     /**
1042      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1043      * `recipient`, forwarding all available gas and reverting on errors.
1044      *
1045      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1046      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1047      * imposed by `transfer`, making them unable to receive funds via
1048      * `transfer`. {sendValue} removes this limitation.
1049      *
1050      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1051      *
1052      * IMPORTANT: because control is transferred to `recipient`, care must be
1053      * taken to not create reentrancy vulnerabilities. Consider using
1054      * {ReentrancyGuard} or the
1055      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1056      */
1057     function sendValue(address payable recipient, uint256 amount) internal {
1058         require(address(this).balance >= amount, "Address: insufficient balance");
1059 
1060         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1061         (bool success, ) = recipient.call{ value: amount }("");
1062         require(success, "Address: unable to send value, recipient may have reverted");
1063     }
1064 
1065     /**
1066      * @dev Performs a Solidity function call using a low level `call`. A
1067      * plain`call` is an unsafe replacement for a function call: use this
1068      * function instead.
1069      *
1070      * If `target` reverts with a revert reason, it is bubbled up by this
1071      * function (like regular Solidity function calls).
1072      *
1073      * Returns the raw returned data. To convert to the expected return value,
1074      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1075      *
1076      * Requirements:
1077      *
1078      * - `target` must be a contract.
1079      * - calling `target` with `data` must not revert.
1080      *
1081      * _Available since v3.1._
1082      */
1083     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1084       return functionCall(target, data, "Address: low-level call failed");
1085     }
1086 
1087     /**
1088      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1089      * `errorMessage` as a fallback revert reason when `target` reverts.
1090      *
1091      * _Available since v3.1._
1092      */
1093     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1094         return functionCallWithValue(target, data, 0, errorMessage);
1095     }
1096 
1097     /**
1098      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1099      * but also transferring `value` wei to `target`.
1100      *
1101      * Requirements:
1102      *
1103      * - the calling contract must have an ETH balance of at least `value`.
1104      * - the called Solidity function must be `payable`.
1105      *
1106      * _Available since v3.1._
1107      */
1108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1114      * with `errorMessage` as a fallback revert reason when `target` reverts.
1115      *
1116      * _Available since v3.1._
1117      */
1118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1119         require(address(this).balance >= value, "Address: insufficient balance for call");
1120         require(isContract(target), "Address: call to non-contract");
1121 
1122         // solhint-disable-next-line avoid-low-level-calls
1123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1124         return _verifyCallResult(success, returndata, errorMessage);
1125     }
1126 
1127     /**
1128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1129      * but performing a static call.
1130      *
1131      * _Available since v3.3._
1132      */
1133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1134         return functionStaticCall(target, data, "Address: low-level static call failed");
1135     }
1136 
1137     /**
1138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1139      * but performing a static call.
1140      *
1141      * _Available since v3.3._
1142      */
1143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1144         require(isContract(target), "Address: static call to non-contract");
1145 
1146         // solhint-disable-next-line avoid-low-level-calls
1147         (bool success, bytes memory returndata) = target.staticcall(data);
1148         return _verifyCallResult(success, returndata, errorMessage);
1149     }
1150 
1151     /**
1152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1153      * but performing a delegate call.
1154      *
1155      * _Available since v3.4._
1156      */
1157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1159     }
1160 
1161     /**
1162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1163      * but performing a delegate call.
1164      *
1165      * _Available since v3.4._
1166      */
1167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1168         require(isContract(target), "Address: delegate call to non-contract");
1169 
1170         // solhint-disable-next-line avoid-low-level-calls
1171         (bool success, bytes memory returndata) = target.delegatecall(data);
1172         return _verifyCallResult(success, returndata, errorMessage);
1173     }
1174 
1175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1176         if (success) {
1177             return returndata;
1178         } else {
1179             // Look for revert reason and bubble it up if present
1180             if (returndata.length > 0) {
1181                 // The easiest way to bubble the revert reason is using memory via assembly
1182 
1183                 // solhint-disable-next-line no-inline-assembly
1184                 assembly {
1185                     let returndata_size := mload(returndata)
1186                     revert(add(32, returndata), returndata_size)
1187                 }
1188             } else {
1189                 revert(errorMessage);
1190             }
1191         }
1192     }
1193 }
1194 
1195 pragma solidity ^0.6.0;
1196 
1197 /**
1198  * @title Pausable
1199  * @dev Base contract which allows children to implement an emergency stop mechanism.
1200  */
1201 contract Pausable is Ownable {
1202     event Pause();
1203     event Unpause();
1204     event NotPausable();
1205 
1206     bool public paused = false;
1207     bool public canPause = true;
1208 
1209 
1210     /**
1211     * @dev Modifier to make a function callable only when the contract is not paused.
1212     */
1213     modifier whenNotPaused() {
1214         require(!paused);
1215         _;
1216     }
1217 
1218     /**
1219      * @dev Modifier to make a function callable only when the contract is paused.
1220      */
1221     modifier whenPaused() {
1222         require(paused);
1223         _;
1224     }
1225 
1226     /**
1227      * @dev called by the owner to pause, triggers stopped state
1228      */
1229     function pause() public onlyOwner whenNotPaused {
1230         paused = true;
1231         emit Pause();
1232     }
1233 
1234     /**
1235      * @dev called by the owner to unpause, returns to normal state
1236      */
1237     function unpause() public onlyOwner whenPaused {
1238         paused = false;
1239         emit Unpause();
1240     }
1241     
1242       /**
1243      * @dev Prevent the token from ever being paused again
1244      **/
1245     function notPausable() onlyOwner public{
1246         paused = false;
1247         canPause = false;
1248         emit NotPausable();
1249     }
1250     
1251 }
1252 
1253 // File: @openzeppelin/contracts/access/AccessControl.sol
1254 
1255 // SPDX-License-Identifier: MIT
1256 
1257 pragma solidity >=0.6.0 <0.8.0;
1258 
1259 
1260 
1261 
1262 /**
1263  * @dev Contract module that allows children to implement role-based access
1264  * control mechanisms.
1265  *
1266  * Roles are referred to by their `bytes32` identifier. These should be exposed
1267  * in the external API and be unique. The best way to achieve this is by
1268  * using `public constant` hash digests:
1269  *
1270  * ```
1271  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1272  * ```
1273  *
1274  * Roles can be used to represent a set of permissions. To restrict access to a
1275  * function call, use {hasRole}:
1276  *
1277  * ```
1278  * function foo() public {
1279  *     require(hasRole(MY_ROLE, msg.sender));
1280  *     ...
1281  * }
1282  * ```
1283  *
1284  * Roles can be granted and revoked dynamically via the {grantRole} and
1285  * {revokeRole} functions. Each role has an associated admin role, and only
1286  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1287  *
1288  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1289  * that only accounts with this role will be able to grant or revoke other
1290  * roles. More complex role relationships can be created by using
1291  * {_setRoleAdmin}.
1292  *
1293  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1294  * grant and revoke this role. Extra precautions should be taken to secure
1295  * accounts that have been granted it.
1296  */
1297 abstract contract AccessControl is Context {
1298     using EnumerableSet for EnumerableSet.AddressSet;
1299     using Address for address;
1300 
1301     struct RoleData {
1302         EnumerableSet.AddressSet members;
1303         bytes32 adminRole;
1304     }
1305 
1306     mapping (bytes32 => RoleData) private _roles;
1307 
1308     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1309 
1310     /**
1311      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1312      *
1313      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1314      * {RoleAdminChanged} not being emitted signaling this.
1315      *
1316      * _Available since v3.1._
1317      */
1318     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1319 
1320     /**
1321      * @dev Emitted when `account` is granted `role`.
1322      *
1323      * `sender` is the account that originated the contract call, an admin role
1324      * bearer except when using {_setupRole}.
1325      */
1326     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1327 
1328     /**
1329      * @dev Emitted when `account` is revoked `role`.
1330      *
1331      * `sender` is the account that originated the contract call:
1332      *   - if using `revokeRole`, it is the admin role bearer
1333      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1334      */
1335     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1336 
1337     /**
1338      * @dev Returns `true` if `account` has been granted `role`.
1339      */
1340     function hasRole(bytes32 role, address account) public view returns (bool) {
1341         return _roles[role].members.contains(account);
1342     }
1343 
1344     /**
1345      * @dev Returns the number of accounts that have `role`. Can be used
1346      * together with {getRoleMember} to enumerate all bearers of a role.
1347      */
1348     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1349         return _roles[role].members.length();
1350     }
1351 
1352     /**
1353      * @dev Returns one of the accounts that have `role`. `index` must be a
1354      * value between 0 and {getRoleMemberCount}, non-inclusive.
1355      *
1356      * Role bearers are not sorted in any particular way, and their ordering may
1357      * change at any point.
1358      *
1359      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1360      * you perform all queries on the same block. See the following
1361      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1362      * for more information.
1363      */
1364     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1365         return _roles[role].members.at(index);
1366     }
1367 
1368     /**
1369      * @dev Returns the admin role that controls `role`. See {grantRole} and
1370      * {revokeRole}.
1371      *
1372      * To change a role's admin, use {_setRoleAdmin}.
1373      */
1374     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1375         return _roles[role].adminRole;
1376     }
1377 
1378     /**
1379      * @dev Grants `role` to `account`.
1380      *
1381      * If `account` had not been already granted `role`, emits a {RoleGranted}
1382      * event.
1383      *
1384      * Requirements:
1385      *
1386      * - the caller must have ``role``'s admin role.
1387      */
1388     function grantRole(bytes32 role, address account) public virtual {
1389         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1390 
1391         _grantRole(role, account);
1392     }
1393 
1394     /**
1395      * @dev Revokes `role` from `account`.
1396      *
1397      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1398      *
1399      * Requirements:
1400      *
1401      * - the caller must have ``role``'s admin role.
1402      */
1403     function revokeRole(bytes32 role, address account) public virtual {
1404         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1405 
1406         _revokeRole(role, account);
1407     }
1408 
1409     /**
1410      * @dev Revokes `role` from the calling account.
1411      *
1412      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1413      * purpose is to provide a mechanism for accounts to lose their privileges
1414      * if they are compromised (such as when a trusted device is misplaced).
1415      *
1416      * If the calling account had been granted `role`, emits a {RoleRevoked}
1417      * event.
1418      *
1419      * Requirements:
1420      *
1421      * - the caller must be `account`.
1422      */
1423     function renounceRole(bytes32 role, address account) public virtual {
1424         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1425 
1426         _revokeRole(role, account);
1427     }
1428 
1429     /**
1430      * @dev Grants `role` to `account`.
1431      *
1432      * If `account` had not been already granted `role`, emits a {RoleGranted}
1433      * event. Note that unlike {grantRole}, this function doesn't perform any
1434      * checks on the calling account.
1435      *
1436      * [WARNING]
1437      * ====
1438      * This function should only be called from the constructor when setting
1439      * up the initial roles for the system.
1440      *
1441      * Using this function in any other way is effectively circumventing the admin
1442      * system imposed by {AccessControl}.
1443      * ====
1444      */
1445     function _setupRole(bytes32 role, address account) internal virtual {
1446         _grantRole(role, account);
1447     }
1448 
1449     /**
1450      * @dev Sets `adminRole` as ``role``'s admin role.
1451      *
1452      * Emits a {RoleAdminChanged} event.
1453      */
1454     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1455         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1456         _roles[role].adminRole = adminRole;
1457     }
1458 
1459     function _grantRole(bytes32 role, address account) private {
1460         if (_roles[role].members.add(account)) {
1461             emit RoleGranted(role, account, _msgSender());
1462         }
1463     }
1464 
1465     function _revokeRole(bytes32 role, address account) private {
1466         if (_roles[role].members.remove(account)) {
1467             emit RoleRevoked(role, account, _msgSender());
1468         }
1469     }
1470 }
1471 
1472 // File: contracts/PreEtherlite.sol
1473 
1474 // SPDX-License-Identifier: MIT
1475 pragma solidity ^0.6.0;
1476 
1477 
1478 contract PreEtherlite is ERC20, Ownable, AccessControl, Pausable {
1479 
1480     address payable receipientAddress;
1481     IERC20 tokenAddresses;
1482     uint public minInvest = 500000000000000000000000;
1483     address[] public tokenAddress;
1484     mapping(address => bool) public allowTokenAddress;
1485     bytes32 private DOMAIN_SEPERATOR;
1486     uint256 public referralFee = 10;
1487     mapping(address => address) public ownerToReferral;
1488     mapping(address => address[]) public referralToreferee;
1489 
1490     bytes32 private constant INVITE_ONLY = keccak256("INVITE_ONLY"); 
1491 
1492     event TokenBoughtWithETH(address indexed buyerAddress, address admin, address indexed referralAddress, uint256 value, uint256 amount);
1493     event TokenBoughtWithToken(address indexed buyerAddress, address admin, address indexed referralAddress, uint256 value, uint256 amount, address tokenAddress);
1494     
1495     constructor(uint256 initialSupply, bytes32 key, address payable _receipientAddress) public ERC20("Pre-EtherLite", "xETL") {
1496         _mint(address(this), initialSupply);
1497         receipientAddress = _receipientAddress;
1498         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1499         _setupRole(INVITE_ONLY, _msgSender());
1500         _setupRole(INVITE_ONLY, _receipientAddress);
1501         DOMAIN_SEPERATOR = key;
1502     }
1503     
1504     modifier authorisedSignatory(bytes32 signature){
1505         bytes32 authKey = keccak256(
1506             abi.encodePacked(
1507                 INVITE_ONLY,
1508                 keccak256(abi.encodePacked(DOMAIN_SEPERATOR, _msgSender()))
1509             )
1510         );
1511         require(signature == authKey, "Invalid Transaction");
1512         _;
1513     }
1514     
1515     function changeMin(uint _minInvest) public onlyOwner returns(bool){
1516         minInvest = _minInvest;
1517     }
1518     
1519     function changeReferralFee(uint _referralFee) public onlyOwner returns(bool){
1520         referralFee = _referralFee;
1521     }
1522 
1523     function mint(address to, uint256 amount) public onlyOwner{
1524         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a minter");
1525         _mint(to, amount);
1526     }
1527 
1528     function whiteListAddress(address _to, uint _isWhitelist) public onlyOwner{
1529         if(_isWhitelist == 1) _setupRole(INVITE_ONLY, _to);
1530         if(_isWhitelist == 0) revokeRole(INVITE_ONLY, _to);
1531     }
1532 
1533     function whiteListTokenAddress(address[] memory _tokenAddress) public onlyOwner returns(bool){
1534         tokenAddress = _tokenAddress;
1535         for(uint256 i=0; i < tokenAddress.length; i++){
1536             allowTokenAddress[tokenAddress[i]] = true;
1537         }
1538         return true;
1539     }
1540     
1541     function isReferralvalid(address _referralAddress) public view returns (bool){
1542        return hasRole(INVITE_ONLY, _referralAddress);
1543     }
1544     
1545     function buyToken(address _buyerAddress, address _referralAddress, uint256 _amount, bytes32 _signature) public payable authorisedSignatory(_signature) whenNotPaused returns(uint256) {
1546         require(hasRole(INVITE_ONLY, _referralAddress), "Caller is not allow to buy token");
1547         require(_buyerAddress != address(0));
1548         require(_amount >= minInvest, "Require Minimum investment");
1549         require(msg.value > 0, "ETH value to small");
1550         tokenAddresses = IERC20(address(this));
1551         uint256 referralAmount = _amount.mul(referralFee).div(100);
1552         require(tokenAddresses.transfer(_buyerAddress, _amount));
1553         require(tokenAddresses.transfer(_referralAddress, referralAmount));
1554         receipientAddress.transfer(msg.value);
1555         _setupRole(INVITE_ONLY, _buyerAddress);
1556         ownerToReferral[_buyerAddress] = _referralAddress;
1557         referralToreferee[_referralAddress].push(_buyerAddress);
1558         TokenBoughtWithETH(_buyerAddress, receipientAddress, _referralAddress, msg.value, _amount);
1559         return _amount;
1560     }
1561 
1562     function buyTokenWithToken(address _buyerAddress, address _referralAddress, address _tokenAddress, uint _value, uint _amount, bytes32 _signature) public authorisedSignatory(_signature) whenNotPaused returns(uint256) {
1563         require(hasRole(INVITE_ONLY, _referralAddress), "Caller is not allow to buy token");
1564         require(allowTokenAddress[_tokenAddress], "Token Address is invalid");
1565         require(_buyerAddress != address(0));
1566         require(_amount >= minInvest, "Sent Token Amount is too small");
1567         require(_value > 0, "Receive value to small");
1568         tokenAddresses = IERC20(address(this));
1569         uint256 referralAmount = _amount.mul(referralFee).div(100);
1570         require(tokenAddresses.transfer(_buyerAddress, _amount));
1571         require(tokenAddresses.transfer(_referralAddress, referralAmount));
1572         tokenAddresses = IERC20(_tokenAddress);
1573         require(tokenAddresses.transferFrom(_buyerAddress, address(this), _value));
1574         require(tokenAddresses.transfer(receipientAddress, _value));
1575         _setupRole(INVITE_ONLY, _buyerAddress);
1576         ownerToReferral[_buyerAddress] = _referralAddress;
1577         referralToreferee[_referralAddress].push(_buyerAddress);
1578         TokenBoughtWithToken(_buyerAddress, receipientAddress, _referralAddress, _value, _amount, _tokenAddress);
1579         return _amount;
1580     }
1581     
1582     function getReferral(address _referralAddress) public view returns(address[] memory) {
1583         return referralToreferee[_referralAddress];
1584     }
1585 
1586     // Allow transfer of accidentally sent ERC20 tokens
1587     function withdrawTokens(address _recipient, address _token) public onlyOwner {
1588         IERC20 token = IERC20(_token);
1589         uint256 balance = token.balanceOf(address(this));
1590         require(token.transfer(_recipient, balance));
1591     }
1592 
1593     function withdrawETH() public onlyOwner {
1594          receipientAddress.transfer(address(this).balance);
1595     }
1596 
1597 }