1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
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
104 
105 
106 pragma solidity >=0.6.0 <0.8.0;
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
319 
320 pragma solidity >=0.6.0 <0.8.0;
321 
322 
323 /**
324  * @dev Implementation of the {IERC20} interface.
325  *
326  * This implementation is agnostic to the way tokens are created. This means
327  * that a supply mechanism has to be added in a derived contract using {_mint}.
328  * For a generic mechanism see {ERC20PresetMinterPauser}.
329  *
330  * TIP: For a detailed writeup see our guide
331  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
332  * to implement supply mechanisms].
333  *
334  * We have followed general OpenZeppelin guidelines: functions revert instead
335  * of returning `false` on failure. This behavior is nonetheless conventional
336  * and does not conflict with the expectations of ERC20 applications.
337  *
338  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
339  * This allows applications to reconstruct the allowance for all accounts just
340  * by listening to said events. Other implementations of the EIP may not emit
341  * these events, as it isn't required by the specification.
342  *
343  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
344  * functions have been added to mitigate the well-known issues around setting
345  * allowances. See {IERC20-approve}.
346  */
347 contract ERC20 is Context, IERC20 {
348     using SafeMath for uint256;
349 
350     mapping (address => uint256) internal _balances;
351 
352     mapping (address => mapping (address => uint256)) internal _allowances;
353 
354     uint256 private _totalSupply;
355 
356     string private _name;
357     string private _symbol;
358     uint8 private _decimals;
359 
360     /**
361      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
362      * a default value of 18.
363      *
364      * To select a different value for {decimals}, use {_setupDecimals}.
365      *
366      * All three of these values are immutable: they can only be set once during
367      * construction.
368      */
369     constructor (string memory name_, string memory symbol_) public {
370         _name = name_;
371         _symbol = symbol_;
372         _decimals = 18;
373     }
374 
375     /**
376      * @dev Returns the name of the token.
377      */
378     function name() public view virtual returns (string memory) {
379         return _name;
380     }
381 
382     /**
383      * @dev Returns the symbol of the token, usually a shorter version of the
384      * name.
385      */
386     function symbol() public view virtual returns (string memory) {
387         return _symbol;
388     }
389 
390     /**
391      * @dev Returns the number of decimals used to get its user representation.
392      * For example, if `decimals` equals `2`, a balance of `505` tokens should
393      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
394      *
395      * Tokens usually opt for a value of 18, imitating the relationship between
396      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
397      * called.
398      *
399      * NOTE: This information is only used for _display_ purposes: it in
400      * no way affects any of the arithmetic of the contract, including
401      * {IERC20-balanceOf} and {IERC20-transfer}.
402      */
403     function decimals() public view virtual returns (uint8) {
404         return _decimals;
405     }
406 
407     /**
408      * @dev See {IERC20-totalSupply}.
409      */
410     function totalSupply() public view virtual override returns (uint256) {
411         return _totalSupply;
412     }
413 
414     /**
415      * @dev See {IERC20-balanceOf}.
416      */
417     function balanceOf(address account) public view virtual override returns (uint256) {
418         return _balances[account];
419     }
420 
421     /**
422      * @dev See {IERC20-transfer}.
423      *
424      * Requirements:
425      *
426      * - `recipient` cannot be the zero address.
427      * - the caller must have a balance of at least `amount`.
428      */
429     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
430         _transfer(_msgSender(), recipient, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-allowance}.
436      */
437     function allowance(address owner, address spender) public view virtual override returns (uint256) {
438         return _allowances[owner][spender];
439     }
440 
441     /**
442      * @dev See {IERC20-approve}.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      */
448     function approve(address spender, uint256 amount) public virtual override returns (bool) {
449         _approve(_msgSender(), spender, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-transferFrom}.
455      *
456      * Emits an {Approval} event indicating the updated allowance. This is not
457      * required by the EIP. See the note at the beginning of {ERC20}.
458      *
459      * Requirements:
460      *
461      * - `sender` and `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `amount`.
463      * - the caller must have allowance for ``sender``'s tokens of at least
464      * `amount`.
465      */
466     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
467         _transfer(sender, recipient, amount);
468         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
469         return true;
470     }
471 
472     /**
473      * @dev Atomically increases the allowance granted to `spender` by the caller.
474      *
475      * This is an alternative to {approve} that can be used as a mitigation for
476      * problems described in {IERC20-approve}.
477      *
478      * Emits an {Approval} event indicating the updated allowance.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      */
484     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
486         return true;
487     }
488 
489     /**
490      * @dev Atomically decreases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to {approve} that can be used as a mitigation for
493      * problems described in {IERC20-approve}.
494      *
495      * Emits an {Approval} event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      * - `spender` must have allowance for the caller of at least
501      * `subtractedValue`.
502      */
503     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
505         return true;
506     }
507 
508     /**
509      * @dev Moves tokens `amount` from `sender` to `recipient`.
510      *
511      * This is internal function is equivalent to {transfer}, and can be used to
512      * e.g. implement automatic token fees, slashing mechanisms, etc.
513      *
514      * Emits a {Transfer} event.
515      *
516      * Requirements:
517      *
518      * - `sender` cannot be the zero address.
519      * - `recipient` cannot be the zero address.
520      * - `sender` must have a balance of at least `amount`.
521      */
522     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525 
526         _beforeTokenTransfer(sender, recipient, amount);
527 
528         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
529         _balances[recipient] = _balances[recipient].add(amount);
530         emit Transfer(sender, recipient, amount);
531     }
532 
533     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534      * the total supply.
535      *
536      * Emits a {Transfer} event with `from` set to the zero address.
537      *
538      * Requirements:
539      *
540      * - `to` cannot be the zero address.
541      */
542     function _mint(address account, uint256 amount) internal virtual {
543         require(account != address(0), "ERC20: mint to the zero address");
544 
545         _beforeTokenTransfer(address(0), account, amount);
546 
547         _totalSupply = _totalSupply.add(amount);
548         _balances[account] = _balances[account].add(amount);
549         emit Transfer(address(0), account, amount);
550     }
551 
552     /**
553      * @dev Destroys `amount` tokens from `account`, reducing the
554      * total supply.
555      *
556      * Emits a {Transfer} event with `to` set to the zero address.
557      *
558      * Requirements:
559      *
560      * - `account` cannot be the zero address.
561      * - `account` must have at least `amount` tokens.
562      */
563     function _burn(address account, uint256 amount) internal virtual {
564         require(account != address(0), "ERC20: burn from the zero address");
565 
566         _beforeTokenTransfer(account, address(0), amount);
567 
568         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
569         _totalSupply = _totalSupply.sub(amount);
570         emit Transfer(account, address(0), amount);
571     }
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
575      *
576      * This internal function is equivalent to `approve`, and can be used to
577      * e.g. set automatic allowances for certain subsystems, etc.
578      *
579      * Emits an {Approval} event.
580      *
581      * Requirements:
582      *
583      * - `owner` cannot be the zero address.
584      * - `spender` cannot be the zero address.
585      */
586     function _approve(address owner, address spender, uint256 amount) internal virtual {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593 
594     /**
595      * @dev Sets {decimals} to a value other than the default one of 18.
596      *
597      * WARNING: This function should only be called from the constructor. Most
598      * applications that interact with token contracts will not expect
599      * {decimals} to ever change, and may work incorrectly if it does.
600      */
601     function _setupDecimals(uint8 decimals_) internal virtual {
602         _decimals = decimals_;
603     }
604 
605     /**
606      * @dev Hook that is called before any transfer of tokens. This includes
607      * minting and burning.
608      *
609      * Calling conditions:
610      *
611      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
612      * will be to transferred to `to`.
613      * - when `from` is zero, `amount` tokens will be minted for `to`.
614      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
615      * - `from` and `to` are never both zero.
616      *
617      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
618      */
619     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
620 }
621 
622 
623 
624 pragma solidity >=0.6.0 <0.8.0;
625 
626 /**
627  * @dev Library for managing
628  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
629  * types.
630  *
631  * Sets have the following properties:
632  *
633  * - Elements are added, removed, and checked for existence in constant time
634  * (O(1)).
635  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
636  *
637  * ```
638  * contract Example {
639  *     // Add the library methods
640  *     using EnumerableSet for EnumerableSet.AddressSet;
641  *
642  *     // Declare a set state variable
643  *     EnumerableSet.AddressSet private mySet;
644  * }
645  * ```
646  *
647  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
648  * and `uint256` (`UintSet`) are supported.
649  */
650 library EnumerableSet {
651     // To implement this library for multiple types with as little code
652     // repetition as possible, we write it in terms of a generic Set type with
653     // bytes32 values.
654     // The Set implementation uses private functions, and user-facing
655     // implementations (such as AddressSet) are just wrappers around the
656     // underlying Set.
657     // This means that we can only create new EnumerableSets for types that fit
658     // in bytes32.
659 
660     struct Set {
661         // Storage of set values
662         bytes32[] _values;
663 
664         // Position of the value in the `values` array, plus 1 because index 0
665         // means a value is not in the set.
666         mapping (bytes32 => uint256) _indexes;
667     }
668 
669     /**
670      * @dev Add a value to a set. O(1).
671      *
672      * Returns true if the value was added to the set, that is if it was not
673      * already present.
674      */
675     function _add(Set storage set, bytes32 value) private returns (bool) {
676         if (!_contains(set, value)) {
677             set._values.push(value);
678             // The value is stored at length-1, but we add 1 to all indexes
679             // and use 0 as a sentinel value
680             set._indexes[value] = set._values.length;
681             return true;
682         } else {
683             return false;
684         }
685     }
686 
687     /**
688      * @dev Removes a value from a set. O(1).
689      *
690      * Returns true if the value was removed from the set, that is if it was
691      * present.
692      */
693     function _remove(Set storage set, bytes32 value) private returns (bool) {
694         // We read and store the value's index to prevent multiple reads from the same storage slot
695         uint256 valueIndex = set._indexes[value];
696 
697         if (valueIndex != 0) { // Equivalent to contains(set, value)
698             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
699             // the array, and then remove the last element (sometimes called as 'swap and pop').
700             // This modifies the order of the array, as noted in {at}.
701 
702             uint256 toDeleteIndex = valueIndex - 1;
703             uint256 lastIndex = set._values.length - 1;
704 
705             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
706             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
707 
708             bytes32 lastvalue = set._values[lastIndex];
709 
710             // Move the last value to the index where the value to delete is
711             set._values[toDeleteIndex] = lastvalue;
712             // Update the index for the moved value
713             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
714 
715             // Delete the slot where the moved value was stored
716             set._values.pop();
717 
718             // Delete the index for the deleted slot
719             delete set._indexes[value];
720 
721             return true;
722         } else {
723             return false;
724         }
725     }
726 
727     /**
728      * @dev Returns true if the value is in the set. O(1).
729      */
730     function _contains(Set storage set, bytes32 value) private view returns (bool) {
731         return set._indexes[value] != 0;
732     }
733 
734     /**
735      * @dev Returns the number of values on the set. O(1).
736      */
737     function _length(Set storage set) private view returns (uint256) {
738         return set._values.length;
739     }
740 
741    /**
742     * @dev Returns the value stored at position `index` in the set. O(1).
743     *
744     * Note that there are no guarantees on the ordering of values inside the
745     * array, and it may change when more values are added or removed.
746     *
747     * Requirements:
748     *
749     * - `index` must be strictly less than {length}.
750     */
751     function _at(Set storage set, uint256 index) private view returns (bytes32) {
752         require(set._values.length > index, "EnumerableSet: index out of bounds");
753         return set._values[index];
754     }
755 
756     // Bytes32Set
757 
758     struct Bytes32Set {
759         Set _inner;
760     }
761 
762     /**
763      * @dev Add a value to a set. O(1).
764      *
765      * Returns true if the value was added to the set, that is if it was not
766      * already present.
767      */
768     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
769         return _add(set._inner, value);
770     }
771 
772     /**
773      * @dev Removes a value from a set. O(1).
774      *
775      * Returns true if the value was removed from the set, that is if it was
776      * present.
777      */
778     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
779         return _remove(set._inner, value);
780     }
781 
782     /**
783      * @dev Returns true if the value is in the set. O(1).
784      */
785     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
786         return _contains(set._inner, value);
787     }
788 
789     /**
790      * @dev Returns the number of values in the set. O(1).
791      */
792     function length(Bytes32Set storage set) internal view returns (uint256) {
793         return _length(set._inner);
794     }
795 
796    /**
797     * @dev Returns the value stored at position `index` in the set. O(1).
798     *
799     * Note that there are no guarantees on the ordering of values inside the
800     * array, and it may change when more values are added or removed.
801     *
802     * Requirements:
803     *
804     * - `index` must be strictly less than {length}.
805     */
806     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
807         return _at(set._inner, index);
808     }
809 
810     // AddressSet
811 
812     struct AddressSet {
813         Set _inner;
814     }
815 
816     /**
817      * @dev Add a value to a set. O(1).
818      *
819      * Returns true if the value was added to the set, that is if it was not
820      * already present.
821      */
822     function add(AddressSet storage set, address value) internal returns (bool) {
823         return _add(set._inner, bytes32(uint256(uint160(value))));
824     }
825 
826     /**
827      * @dev Removes a value from a set. O(1).
828      *
829      * Returns true if the value was removed from the set, that is if it was
830      * present.
831      */
832     function remove(AddressSet storage set, address value) internal returns (bool) {
833         return _remove(set._inner, bytes32(uint256(uint160(value))));
834     }
835 
836     /**
837      * @dev Returns true if the value is in the set. O(1).
838      */
839     function contains(AddressSet storage set, address value) internal view returns (bool) {
840         return _contains(set._inner, bytes32(uint256(uint160(value))));
841     }
842 
843     /**
844      * @dev Returns the number of values in the set. O(1).
845      */
846     function length(AddressSet storage set) internal view returns (uint256) {
847         return _length(set._inner);
848     }
849 
850    /**
851     * @dev Returns the value stored at position `index` in the set. O(1).
852     *
853     * Note that there are no guarantees on the ordering of values inside the
854     * array, and it may change when more values are added or removed.
855     *
856     * Requirements:
857     *
858     * - `index` must be strictly less than {length}.
859     */
860     function at(AddressSet storage set, uint256 index) internal view returns (address) {
861         return address(uint160(uint256(_at(set._inner, index))));
862     }
863 
864 
865     // UintSet
866 
867     struct UintSet {
868         Set _inner;
869     }
870 
871     /**
872      * @dev Add a value to a set. O(1).
873      *
874      * Returns true if the value was added to the set, that is if it was not
875      * already present.
876      */
877     function add(UintSet storage set, uint256 value) internal returns (bool) {
878         return _add(set._inner, bytes32(value));
879     }
880 
881     /**
882      * @dev Removes a value from a set. O(1).
883      *
884      * Returns true if the value was removed from the set, that is if it was
885      * present.
886      */
887     function remove(UintSet storage set, uint256 value) internal returns (bool) {
888         return _remove(set._inner, bytes32(value));
889     }
890 
891     /**
892      * @dev Returns true if the value is in the set. O(1).
893      */
894     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
895         return _contains(set._inner, bytes32(value));
896     }
897 
898     /**
899      * @dev Returns the number of values on the set. O(1).
900      */
901     function length(UintSet storage set) internal view returns (uint256) {
902         return _length(set._inner);
903     }
904 
905    /**
906     * @dev Returns the value stored at position `index` in the set. O(1).
907     *
908     * Note that there are no guarantees on the ordering of values inside the
909     * array, and it may change when more values are added or removed.
910     *
911     * Requirements:
912     *
913     * - `index` must be strictly less than {length}.
914     */
915     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
916         return uint256(_at(set._inner, index));
917     }
918 }
919 
920 
921 pragma solidity >=0.6.2 <0.8.0;
922 
923 /**
924  * @dev Collection of functions related to the address type
925  */
926 library Address {
927     /**
928      * @dev Returns true if `account` is a contract.
929      *
930      * [IMPORTANT]
931      * ====
932      * It is unsafe to assume that an address for which this function returns
933      * false is an externally-owned account (EOA) and not a contract.
934      *
935      * Among others, `isContract` will return false for the following
936      * types of addresses:
937      *
938      *  - an externally-owned account
939      *  - a contract in construction
940      *  - an address where a contract will be created
941      *  - an address where a contract lived, but was destroyed
942      * ====
943      */
944     function isContract(address account) internal view returns (bool) {
945         // This method relies on extcodesize, which returns 0 for contracts in
946         // construction, since the code is only stored at the end of the
947         // constructor execution.
948 
949         uint256 size;
950         // solhint-disable-next-line no-inline-assembly
951         assembly { size := extcodesize(account) }
952         return size > 0;
953     }
954 
955     /**
956      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
957      * `recipient`, forwarding all available gas and reverting on errors.
958      *
959      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
960      * of certain opcodes, possibly making contracts go over the 2300 gas limit
961      * imposed by `transfer`, making them unable to receive funds via
962      * `transfer`. {sendValue} removes this limitation.
963      *
964      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
965      *
966      * IMPORTANT: because control is transferred to `recipient`, care must be
967      * taken to not create reentrancy vulnerabilities. Consider using
968      * {ReentrancyGuard} or the
969      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
970      */
971     function sendValue(address payable recipient, uint256 amount) internal {
972         require(address(this).balance >= amount, "Address: insufficient balance");
973 
974         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
975         (bool success, ) = recipient.call{ value: amount }("");
976         require(success, "Address: unable to send value, recipient may have reverted");
977     }
978 
979     /**
980      * @dev Performs a Solidity function call using a low level `call`. A
981      * plain`call` is an unsafe replacement for a function call: use this
982      * function instead.
983      *
984      * If `target` reverts with a revert reason, it is bubbled up by this
985      * function (like regular Solidity function calls).
986      *
987      * Returns the raw returned data. To convert to the expected return value,
988      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
989      *
990      * Requirements:
991      *
992      * - `target` must be a contract.
993      * - calling `target` with `data` must not revert.
994      *
995      * _Available since v3.1._
996      */
997     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
998       return functionCall(target, data, "Address: low-level call failed");
999     }
1000 
1001     /**
1002      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1003      * `errorMessage` as a fallback revert reason when `target` reverts.
1004      *
1005      * _Available since v3.1._
1006      */
1007     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1008         return functionCallWithValue(target, data, 0, errorMessage);
1009     }
1010 
1011     /**
1012      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1013      * but also transferring `value` wei to `target`.
1014      *
1015      * Requirements:
1016      *
1017      * - the calling contract must have an ETH balance of at least `value`.
1018      * - the called Solidity function must be `payable`.
1019      *
1020      * _Available since v3.1._
1021      */
1022     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1023         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1024     }
1025 
1026     /**
1027      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1028      * with `errorMessage` as a fallback revert reason when `target` reverts.
1029      *
1030      * _Available since v3.1._
1031      */
1032     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1033         require(address(this).balance >= value, "Address: insufficient balance for call");
1034         require(isContract(target), "Address: call to non-contract");
1035 
1036         // solhint-disable-next-line avoid-low-level-calls
1037         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1038         return _verifyCallResult(success, returndata, errorMessage);
1039     }
1040 
1041     /**
1042      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1043      * but performing a static call.
1044      *
1045      * _Available since v3.3._
1046      */
1047     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1048         return functionStaticCall(target, data, "Address: low-level static call failed");
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1053      * but performing a static call.
1054      *
1055      * _Available since v3.3._
1056      */
1057     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1058         require(isContract(target), "Address: static call to non-contract");
1059 
1060         // solhint-disable-next-line avoid-low-level-calls
1061         (bool success, bytes memory returndata) = target.staticcall(data);
1062         return _verifyCallResult(success, returndata, errorMessage);
1063     }
1064 
1065     /**
1066      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1067      * but performing a delegate call.
1068      *
1069      * _Available since v3.4._
1070      */
1071     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1072         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1073     }
1074 
1075     /**
1076      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1077      * but performing a delegate call.
1078      *
1079      * _Available since v3.4._
1080      */
1081     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1082         require(isContract(target), "Address: delegate call to non-contract");
1083 
1084         // solhint-disable-next-line avoid-low-level-calls
1085         (bool success, bytes memory returndata) = target.delegatecall(data);
1086         return _verifyCallResult(success, returndata, errorMessage);
1087     }
1088 
1089     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1090         if (success) {
1091             return returndata;
1092         } else {
1093             // Look for revert reason and bubble it up if present
1094             if (returndata.length > 0) {
1095                 // The easiest way to bubble the revert reason is using memory via assembly
1096 
1097                 // solhint-disable-next-line no-inline-assembly
1098                 assembly {
1099                     let returndata_size := mload(returndata)
1100                     revert(add(32, returndata), returndata_size)
1101                 }
1102             } else {
1103                 revert(errorMessage);
1104             }
1105         }
1106     }
1107 }
1108 
1109 
1110 
1111 pragma solidity >=0.6.0 <0.8.0;
1112 
1113 
1114 
1115 /**
1116  * @dev Contract module that allows children to implement role-based access
1117  * control mechanisms.
1118  *
1119  * Roles are referred to by their `bytes32` identifier. These should be exposed
1120  * in the external API and be unique. The best way to achieve this is by
1121  * using `public constant` hash digests:
1122  *
1123  * ```
1124  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1125  * ```
1126  *
1127  * Roles can be used to represent a set of permissions. To restrict access to a
1128  * function call, use {hasRole}:
1129  *
1130  * ```
1131  * function foo() public {
1132  *     require(hasRole(MY_ROLE, msg.sender));
1133  *     ...
1134  * }
1135  * ```
1136  *
1137  * Roles can be granted and revoked dynamically via the {grantRole} and
1138  * {revokeRole} functions. Each role has an associated admin role, and only
1139  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1140  *
1141  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1142  * that only accounts with this role will be able to grant or revoke other
1143  * roles. More complex role relationships can be created by using
1144  * {_setRoleAdmin}.
1145  *
1146  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1147  * grant and revoke this role. Extra precautions should be taken to secure
1148  * accounts that have been granted it.
1149  */
1150 abstract contract AccessControl is Context {
1151     using EnumerableSet for EnumerableSet.AddressSet;
1152     using Address for address;
1153 
1154     struct RoleData {
1155         EnumerableSet.AddressSet members;
1156         bytes32 adminRole;
1157     }
1158 
1159     mapping (bytes32 => RoleData) private _roles;
1160 
1161     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1162 
1163     /**
1164      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1165      *
1166      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1167      * {RoleAdminChanged} not being emitted signaling this.
1168      *
1169      * _Available since v3.1._
1170      */
1171     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1172 
1173     /**
1174      * @dev Emitted when `account` is granted `role`.
1175      *
1176      * `sender` is the account that originated the contract call, an admin role
1177      * bearer except when using {_setupRole}.
1178      */
1179     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1180 
1181     /**
1182      * @dev Emitted when `account` is revoked `role`.
1183      *
1184      * `sender` is the account that originated the contract call:
1185      *   - if using `revokeRole`, it is the admin role bearer
1186      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1187      */
1188     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1189 
1190     /**
1191      * @dev Returns `true` if `account` has been granted `role`.
1192      */
1193     function hasRole(bytes32 role, address account) public view returns (bool) {
1194         return _roles[role].members.contains(account);
1195     }
1196 
1197     /**
1198      * @dev Returns the number of accounts that have `role`. Can be used
1199      * together with {getRoleMember} to enumerate all bearers of a role.
1200      */
1201     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1202         return _roles[role].members.length();
1203     }
1204 
1205     /**
1206      * @dev Returns one of the accounts that have `role`. `index` must be a
1207      * value between 0 and {getRoleMemberCount}, non-inclusive.
1208      *
1209      * Role bearers are not sorted in any particular way, and their ordering may
1210      * change at any point.
1211      *
1212      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1213      * you perform all queries on the same block. See the following
1214      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1215      * for more information.
1216      */
1217     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1218         return _roles[role].members.at(index);
1219     }
1220 
1221     /**
1222      * @dev Returns the admin role that controls `role`. See {grantRole} and
1223      * {revokeRole}.
1224      *
1225      * To change a role's admin, use {_setRoleAdmin}.
1226      */
1227     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1228         return _roles[role].adminRole;
1229     }
1230 
1231     /**
1232      * @dev Grants `role` to `account`.
1233      *
1234      * If `account` had not been already granted `role`, emits a {RoleGranted}
1235      * event.
1236      *
1237      * Requirements:
1238      *
1239      * - the caller must have ``role``'s admin role.
1240      */
1241     function grantRole(bytes32 role, address account) public virtual {
1242         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1243 
1244         _grantRole(role, account);
1245     }
1246 
1247     /**
1248      * @dev Revokes `role` from `account`.
1249      *
1250      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1251      *
1252      * Requirements:
1253      *
1254      * - the caller must have ``role``'s admin role.
1255      */
1256     function revokeRole(bytes32 role, address account) public virtual {
1257         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1258 
1259         _revokeRole(role, account);
1260     }
1261 
1262     /**
1263      * @dev Revokes `role` from the calling account.
1264      *
1265      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1266      * purpose is to provide a mechanism for accounts to lose their privileges
1267      * if they are compromised (such as when a trusted device is misplaced).
1268      *
1269      * If the calling account had been granted `role`, emits a {RoleRevoked}
1270      * event.
1271      *
1272      * Requirements:
1273      *
1274      * - the caller must be `account`.
1275      */
1276     function renounceRole(bytes32 role, address account) public virtual {
1277         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1278 
1279         _revokeRole(role, account);
1280     }
1281 
1282     /**
1283      * @dev Grants `role` to `account`.
1284      *
1285      * If `account` had not been already granted `role`, emits a {RoleGranted}
1286      * event. Note that unlike {grantRole}, this function doesn't perform any
1287      * checks on the calling account.
1288      *
1289      * [WARNING]
1290      * ====
1291      * This function should only be called from the constructor when setting
1292      * up the initial roles for the system.
1293      *
1294      * Using this function in any other way is effectively circumventing the admin
1295      * system imposed by {AccessControl}.
1296      * ====
1297      */
1298     function _setupRole(bytes32 role, address account) internal virtual {
1299         _grantRole(role, account);
1300     }
1301 
1302     /**
1303      * @dev Sets `adminRole` as ``role``'s admin role.
1304      *
1305      * Emits a {RoleAdminChanged} event.
1306      */
1307     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1308         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1309         _roles[role].adminRole = adminRole;
1310     }
1311 
1312     function _grantRole(bytes32 role, address account) private {
1313         if (_roles[role].members.add(account)) {
1314             emit RoleGranted(role, account, _msgSender());
1315         }
1316     }
1317 
1318     function _revokeRole(bytes32 role, address account) private {
1319         if (_roles[role].members.remove(account)) {
1320             emit RoleRevoked(role, account, _msgSender());
1321         }
1322     }
1323 }
1324 
1325 
1326 pragma solidity ^0.6.12;
1327 
1328 
1329 contract DAOVCGovToken is ERC20, AccessControl {
1330     using SafeMath for uint256;
1331     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
1332     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1333     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1334     bytes32 public constant SERVICE_ROLE = keccak256("SERVICE_ROLE");
1335 
1336     struct Delegation {
1337         uint256 votesDelegated;
1338         uint64 voting;
1339         address delegatee;
1340     }
1341 
1342     uint256 private votePercent;
1343     uint256 private _totalSupply;
1344 
1345     mapping(address => Delegation[]) delegates;
1346     mapping(address => bool) whiteList;
1347 
1348     mapping(address => uint256) private _freezings;
1349 
1350     event VotesDelegated(
1351         address indexed delegator,
1352         address indexed delegatee,
1353         uint256 votesAmount,
1354         uint256 time,
1355         uint64 voting
1356     );
1357     event DelegateEnded(address indexed delegator, uint256 time);
1358 
1359     constructor(
1360         string memory name,
1361         string memory symbol,
1362         uint256 initialSupply,
1363         uint256 _votePercent
1364     ) public ERC20(name, symbol) {
1365         // Grant the contract deployer the default admin role: it will be able
1366         // to grant and revoke any roles
1367         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1368         _setupRole(ADMIN_ROLE, msg.sender);
1369         _setupRole(MINTER_ROLE, msg.sender);
1370         _setupRole(BURNER_ROLE, msg.sender);
1371         _setupRole(SERVICE_ROLE, msg.sender);
1372         // Sets `DEFAULT_ADMIN_ROLE` as ``ADMIN_ROLE``'s admin role.
1373         _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
1374         // Sets `ADMIN_ROLE` as ``MINTER_ROLE, BURNER_ROLE``'s admin role.
1375         _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
1376         _setRoleAdmin(BURNER_ROLE, ADMIN_ROLE);
1377         _setRoleAdmin(SERVICE_ROLE, ADMIN_ROLE);
1378 
1379         _mint(msg.sender, initialSupply);
1380         votePercent = _votePercent;
1381     }
1382 
1383     function delegate(
1384         address delegatee,
1385         uint256 _amount,
1386         uint64 _voting
1387     ) public {
1388         require(
1389             _amount <= balanceOf(msg.sender),
1390             "Can't delegate more than balance"
1391         );
1392         uint256 maximumVotes = totalSupply().mul(votePercent).div(100);
1393         uint256 countOfVotesDelegated = 0;
1394 
1395         for (uint256 i = 0; i < delegates[msg.sender].length; i++) {
1396             countOfVotesDelegated = countOfVotesDelegated.add(
1397                 delegates[msg.sender][i].votesDelegated
1398             );
1399         }
1400         if (!whiteList[msg.sender]) {
1401             require(
1402                 _amount + countOfVotesDelegated < maximumVotes,
1403                 "Too much votes to delegate"
1404             );
1405         }
1406 
1407         delegates[msg.sender].push(Delegation(_amount, _voting, delegatee));
1408 
1409         emit VotesDelegated(
1410             msg.sender,
1411             delegatee,
1412             _amount,
1413             block.timestamp,
1414             _voting
1415         );
1416     }
1417 
1418     function transfer(address _to, uint256 _amount)
1419         public
1420         override
1421         returns (bool)
1422     {
1423         require(
1424             _amount + getDelegatedBy(msg.sender) <= balanceOf(msg.sender),
1425             "Amount and delegated tokens exceeds balance"
1426         );
1427         _transfer(msg.sender, _to, _amount);
1428         return true;
1429     }
1430 
1431     function transferFrom(
1432         address _from,
1433         address _to,
1434         uint256 _amount
1435     ) public override returns (bool) {
1436         require(
1437             _amount + getDelegatedBy(_from) <= balanceOf(_from),
1438             "Amount and delegated tokens exceeds balance"
1439         );
1440         _transfer(_from, _to, _amount);
1441         _approve(
1442             _from,
1443             _msgSender(),
1444             _allowances[_from][_msgSender()].sub(
1445                 _amount,
1446                 "ERC20: transfer amount exceeds allowance"
1447             )
1448         );
1449         return true;
1450     }
1451 
1452     function getDelegatedBy(address _delegator) public view returns (uint256) {
1453         uint256 delegated = 0;
1454         for (uint256 i = 0; i < delegates[_delegator].length; i++) {
1455             delegated = delegated.add(delegates[_delegator][i].votesDelegated);
1456         }
1457         return delegated;
1458     }
1459 
1460     function getDelegatedTo(
1461         address _delegator,
1462         address _delegatee,
1463         uint64 _voting
1464     ) public view returns (uint256) {
1465         uint256 delegated = 0;
1466         for (uint256 i = 0; i < delegates[_delegator].length; i++) {
1467             if (
1468                 delegates[_delegator][i].delegatee == _delegatee &&
1469                 delegates[_delegator][i].voting == _voting
1470             ) {
1471                 delegated = delegated.add(
1472                     delegates[_delegator][i].votesDelegated
1473                 );
1474             }
1475         }
1476         return delegated;
1477     }
1478 
1479     function removeDelegation(address _delegatee, uint64 _voting) public {
1480         for (uint256 i = 0; i < delegates[msg.sender].length; i++) {
1481             if (
1482                 delegates[msg.sender][i].delegatee == _delegatee &&
1483                 delegates[msg.sender][i].voting == _voting
1484             ) {
1485                 delete delegates[msg.sender][i];
1486                 i--;
1487             }
1488         }
1489     }
1490 
1491     function addToWhiteList(address _user) public {
1492         require(hasRole(SERVICE_ROLE, msg.sender), "Caller is not a service");
1493         whiteList[_user] = true;
1494     }
1495 
1496     function deleteFromWhiteList(address _user) public {
1497         require(hasRole(SERVICE_ROLE, msg.sender), "Caller is not a service");
1498         whiteList[_user] = false;
1499     }
1500 
1501     function mint(address _to, uint256 _amount) public {
1502         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1503         _mint(_to, _amount);
1504     }
1505 
1506     function burn(address _from, uint256 _amount) external {
1507         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
1508         _burn(_from, _amount);
1509     }
1510 
1511     function _beforeTokenTransfer(
1512         address _from,
1513         address _to,
1514         uint256 _amount
1515     ) internal override(ERC20) {
1516         super._beforeTokenTransfer(_from, _to, _amount);
1517     }
1518 }