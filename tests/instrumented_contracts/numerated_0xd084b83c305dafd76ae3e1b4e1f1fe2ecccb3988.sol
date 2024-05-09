1 pragma solidity ^0.6.0;
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
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 // SPDX-License-Identifier: MIT
24 
25 
26 
27 
28 // SPDX-License-Identifier: MIT
29 
30 
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
106 // SPDX-License-Identifier: MIT
107 
108 
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 
267 /**
268  * @dev Implementation of the {IERC20} interface.
269  *
270  * This implementation is agnostic to the way tokens are created. This means
271  * that a supply mechanism has to be added in a derived contract using {_mint}.
272  * For a generic mechanism see {ERC20PresetMinterPauser}.
273  *
274  * TIP: For a detailed writeup see our guide
275  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
276  * to implement supply mechanisms].
277  *
278  * We have followed general OpenZeppelin guidelines: functions revert instead
279  * of returning `false` on failure. This behavior is nonetheless conventional
280  * and does not conflict with the expectations of ERC20 applications.
281  *
282  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
283  * This allows applications to reconstruct the allowance for all accounts just
284  * by listening to said events. Other implementations of the EIP may not emit
285  * these events, as it isn't required by the specification.
286  *
287  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
288  * functions have been added to mitigate the well-known issues around setting
289  * allowances. See {IERC20-approve}.
290  */
291 contract ERC20 is Context, IERC20 {
292     using SafeMath for uint256;
293 
294     mapping (address => uint256) private _balances;
295 
296     mapping (address => mapping (address => uint256)) private _allowances;
297 
298     uint256 private _totalSupply;
299 
300     string private _name;
301     string private _symbol;
302     uint8 private _decimals;
303 
304     /**
305      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
306      * a default value of 18.
307      *
308      * To select a different value for {decimals}, use {_setupDecimals}.
309      *
310      * All three of these values are immutable: they can only be set once during
311      * construction.
312      */
313     constructor (string memory name_, string memory symbol_) public {
314         _name = name_;
315         _symbol = symbol_;
316         _decimals = 18;
317     }
318 
319     /**
320      * @dev Returns the name of the token.
321      */
322     function name() public view returns (string memory) {
323         return _name;
324     }
325 
326     /**
327      * @dev Returns the symbol of the token, usually a shorter version of the
328      * name.
329      */
330     function symbol() public view returns (string memory) {
331         return _symbol;
332     }
333 
334     /**
335      * @dev Returns the number of decimals used to get its user representation.
336      * For example, if `decimals` equals `2`, a balance of `505` tokens should
337      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
338      *
339      * Tokens usually opt for a value of 18, imitating the relationship between
340      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
341      * called.
342      *
343      * NOTE: This information is only used for _display_ purposes: it in
344      * no way affects any of the arithmetic of the contract, including
345      * {IERC20-balanceOf} and {IERC20-transfer}.
346      */
347     function decimals() public view returns (uint8) {
348         return _decimals;
349     }
350 
351     /**
352      * @dev See {IERC20-totalSupply}.
353      */
354     function totalSupply() public view override returns (uint256) {
355         return _totalSupply;
356     }
357 
358     /**
359      * @dev See {IERC20-balanceOf}.
360      */
361     function balanceOf(address account) public view override returns (uint256) {
362         return _balances[account];
363     }
364 
365     /**
366      * @dev See {IERC20-transfer}.
367      *
368      * Requirements:
369      *
370      * - `recipient` cannot be the zero address.
371      * - the caller must have a balance of at least `amount`.
372      */
373     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
374         _transfer(_msgSender(), recipient, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-allowance}.
380      */
381     function allowance(address owner, address spender) public view virtual override returns (uint256) {
382         return _allowances[owner][spender];
383     }
384 
385     /**
386      * @dev See {IERC20-approve}.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function approve(address spender, uint256 amount) public virtual override returns (bool) {
393         _approve(_msgSender(), spender, amount);
394         return true;
395     }
396 
397     /**
398      * @dev See {IERC20-transferFrom}.
399      *
400      * Emits an {Approval} event indicating the updated allowance. This is not
401      * required by the EIP. See the note at the beginning of {ERC20}.
402      *
403      * Requirements:
404      *
405      * - `sender` and `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      * - the caller must have allowance for ``sender``'s tokens of at least
408      * `amount`.
409      */
410     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
411         _transfer(sender, recipient, amount);
412         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
413         return true;
414     }
415 
416     /**
417      * @dev Atomically increases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      */
428     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
430         return true;
431     }
432 
433     /**
434      * @dev Atomically decreases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      * - `spender` must have allowance for the caller of at least
445      * `subtractedValue`.
446      */
447     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
448         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
449         return true;
450     }
451 
452     /**
453      * @dev Moves tokens `amount` from `sender` to `recipient`.
454      *
455      * This is internal function is equivalent to {transfer}, and can be used to
456      * e.g. implement automatic token fees, slashing mechanisms, etc.
457      *
458      * Emits a {Transfer} event.
459      *
460      * Requirements:
461      *
462      * - `sender` cannot be the zero address.
463      * - `recipient` cannot be the zero address.
464      * - `sender` must have a balance of at least `amount`.
465      */
466     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _beforeTokenTransfer(sender, recipient, amount);
471 
472         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
473         _balances[recipient] = _balances[recipient].add(amount);
474         emit Transfer(sender, recipient, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `to` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply = _totalSupply.add(amount);
492         _balances[account] = _balances[account].add(amount);
493         emit Transfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _beforeTokenTransfer(account, address(0), amount);
511 
512         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
513         _totalSupply = _totalSupply.sub(amount);
514         emit Transfer(account, address(0), amount);
515     }
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
519      *
520      * This internal function is equivalent to `approve`, and can be used to
521      * e.g. set automatic allowances for certain subsystems, etc.
522      *
523      * Emits an {Approval} event.
524      *
525      * Requirements:
526      *
527      * - `owner` cannot be the zero address.
528      * - `spender` cannot be the zero address.
529      */
530     function _approve(address owner, address spender, uint256 amount) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533 
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @dev Sets {decimals} to a value other than the default one of 18.
540      *
541      * WARNING: This function should only be called from the constructor. Most
542      * applications that interact with token contracts will not expect
543      * {decimals} to ever change, and may work incorrectly if it does.
544      */
545     function _setupDecimals(uint8 decimals_) internal {
546         _decimals = decimals_;
547     }
548 
549     /**
550      * @dev Hook that is called before any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * will be to transferred to `to`.
557      * - when `from` is zero, `amount` tokens will be minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
564 }
565 
566 
567 // SPDX-License-Identifier: MIT
568 
569 
570 
571 // SPDX-License-Identifier: MIT
572 
573 
574 
575 // SPDX-License-Identifier: MIT
576 
577 
578 
579 /**
580  * @dev Library for managing
581  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
582  * types.
583  *
584  * Sets have the following properties:
585  *
586  * - Elements are added, removed, and checked for existence in constant time
587  * (O(1)).
588  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
589  *
590  * ```
591  * contract Example {
592  *     // Add the library methods
593  *     using EnumerableSet for EnumerableSet.AddressSet;
594  *
595  *     // Declare a set state variable
596  *     EnumerableSet.AddressSet private mySet;
597  * }
598  * ```
599  *
600  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
601  * and `uint256` (`UintSet`) are supported.
602  */
603 library EnumerableSet {
604     // To implement this library for multiple types with as little code
605     // repetition as possible, we write it in terms of a generic Set type with
606     // bytes32 values.
607     // The Set implementation uses private functions, and user-facing
608     // implementations (such as AddressSet) are just wrappers around the
609     // underlying Set.
610     // This means that we can only create new EnumerableSets for types that fit
611     // in bytes32.
612 
613     struct Set {
614         // Storage of set values
615         bytes32[] _values;
616 
617         // Position of the value in the `values` array, plus 1 because index 0
618         // means a value is not in the set.
619         mapping (bytes32 => uint256) _indexes;
620     }
621 
622     /**
623      * @dev Add a value to a set. O(1).
624      *
625      * Returns true if the value was added to the set, that is if it was not
626      * already present.
627      */
628     function _add(Set storage set, bytes32 value) private returns (bool) {
629         if (!_contains(set, value)) {
630             set._values.push(value);
631             // The value is stored at length-1, but we add 1 to all indexes
632             // and use 0 as a sentinel value
633             set._indexes[value] = set._values.length;
634             return true;
635         } else {
636             return false;
637         }
638     }
639 
640     /**
641      * @dev Removes a value from a set. O(1).
642      *
643      * Returns true if the value was removed from the set, that is if it was
644      * present.
645      */
646     function _remove(Set storage set, bytes32 value) private returns (bool) {
647         // We read and store the value's index to prevent multiple reads from the same storage slot
648         uint256 valueIndex = set._indexes[value];
649 
650         if (valueIndex != 0) { // Equivalent to contains(set, value)
651             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
652             // the array, and then remove the last element (sometimes called as 'swap and pop').
653             // This modifies the order of the array, as noted in {at}.
654 
655             uint256 toDeleteIndex = valueIndex - 1;
656             uint256 lastIndex = set._values.length - 1;
657 
658             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
659             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
660 
661             bytes32 lastvalue = set._values[lastIndex];
662 
663             // Move the last value to the index where the value to delete is
664             set._values[toDeleteIndex] = lastvalue;
665             // Update the index for the moved value
666             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
667 
668             // Delete the slot where the moved value was stored
669             set._values.pop();
670 
671             // Delete the index for the deleted slot
672             delete set._indexes[value];
673 
674             return true;
675         } else {
676             return false;
677         }
678     }
679 
680     /**
681      * @dev Returns true if the value is in the set. O(1).
682      */
683     function _contains(Set storage set, bytes32 value) private view returns (bool) {
684         return set._indexes[value] != 0;
685     }
686 
687     /**
688      * @dev Returns the number of values on the set. O(1).
689      */
690     function _length(Set storage set) private view returns (uint256) {
691         return set._values.length;
692     }
693 
694    /**
695     * @dev Returns the value stored at position `index` in the set. O(1).
696     *
697     * Note that there are no guarantees on the ordering of values inside the
698     * array, and it may change when more values are added or removed.
699     *
700     * Requirements:
701     *
702     * - `index` must be strictly less than {length}.
703     */
704     function _at(Set storage set, uint256 index) private view returns (bytes32) {
705         require(set._values.length > index, "EnumerableSet: index out of bounds");
706         return set._values[index];
707     }
708 
709     // Bytes32Set
710 
711     struct Bytes32Set {
712         Set _inner;
713     }
714 
715     /**
716      * @dev Add a value to a set. O(1).
717      *
718      * Returns true if the value was added to the set, that is if it was not
719      * already present.
720      */
721     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
722         return _add(set._inner, value);
723     }
724 
725     /**
726      * @dev Removes a value from a set. O(1).
727      *
728      * Returns true if the value was removed from the set, that is if it was
729      * present.
730      */
731     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
732         return _remove(set._inner, value);
733     }
734 
735     /**
736      * @dev Returns true if the value is in the set. O(1).
737      */
738     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
739         return _contains(set._inner, value);
740     }
741 
742     /**
743      * @dev Returns the number of values in the set. O(1).
744      */
745     function length(Bytes32Set storage set) internal view returns (uint256) {
746         return _length(set._inner);
747     }
748 
749    /**
750     * @dev Returns the value stored at position `index` in the set. O(1).
751     *
752     * Note that there are no guarantees on the ordering of values inside the
753     * array, and it may change when more values are added or removed.
754     *
755     * Requirements:
756     *
757     * - `index` must be strictly less than {length}.
758     */
759     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
760         return _at(set._inner, index);
761     }
762 
763     // AddressSet
764 
765     struct AddressSet {
766         Set _inner;
767     }
768 
769     /**
770      * @dev Add a value to a set. O(1).
771      *
772      * Returns true if the value was added to the set, that is if it was not
773      * already present.
774      */
775     function add(AddressSet storage set, address value) internal returns (bool) {
776         return _add(set._inner, bytes32(uint256(value)));
777     }
778 
779     /**
780      * @dev Removes a value from a set. O(1).
781      *
782      * Returns true if the value was removed from the set, that is if it was
783      * present.
784      */
785     function remove(AddressSet storage set, address value) internal returns (bool) {
786         return _remove(set._inner, bytes32(uint256(value)));
787     }
788 
789     /**
790      * @dev Returns true if the value is in the set. O(1).
791      */
792     function contains(AddressSet storage set, address value) internal view returns (bool) {
793         return _contains(set._inner, bytes32(uint256(value)));
794     }
795 
796     /**
797      * @dev Returns the number of values in the set. O(1).
798      */
799     function length(AddressSet storage set) internal view returns (uint256) {
800         return _length(set._inner);
801     }
802 
803    /**
804     * @dev Returns the value stored at position `index` in the set. O(1).
805     *
806     * Note that there are no guarantees on the ordering of values inside the
807     * array, and it may change when more values are added or removed.
808     *
809     * Requirements:
810     *
811     * - `index` must be strictly less than {length}.
812     */
813     function at(AddressSet storage set, uint256 index) internal view returns (address) {
814         return address(uint256(_at(set._inner, index)));
815     }
816 
817 
818     // UintSet
819 
820     struct UintSet {
821         Set _inner;
822     }
823 
824     /**
825      * @dev Add a value to a set. O(1).
826      *
827      * Returns true if the value was added to the set, that is if it was not
828      * already present.
829      */
830     function add(UintSet storage set, uint256 value) internal returns (bool) {
831         return _add(set._inner, bytes32(value));
832     }
833 
834     /**
835      * @dev Removes a value from a set. O(1).
836      *
837      * Returns true if the value was removed from the set, that is if it was
838      * present.
839      */
840     function remove(UintSet storage set, uint256 value) internal returns (bool) {
841         return _remove(set._inner, bytes32(value));
842     }
843 
844     /**
845      * @dev Returns true if the value is in the set. O(1).
846      */
847     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
848         return _contains(set._inner, bytes32(value));
849     }
850 
851     /**
852      * @dev Returns the number of values on the set. O(1).
853      */
854     function length(UintSet storage set) internal view returns (uint256) {
855         return _length(set._inner);
856     }
857 
858    /**
859     * @dev Returns the value stored at position `index` in the set. O(1).
860     *
861     * Note that there are no guarantees on the ordering of values inside the
862     * array, and it may change when more values are added or removed.
863     *
864     * Requirements:
865     *
866     * - `index` must be strictly less than {length}.
867     */
868     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
869         return uint256(_at(set._inner, index));
870     }
871 }
872 
873 // SPDX-License-Identifier: MIT
874 
875 
876 
877 /**
878  * @dev Collection of functions related to the address type
879  */
880 library Address {
881     /**
882      * @dev Returns true if `account` is a contract.
883      *
884      * [IMPORTANT]
885      * ====
886      * It is unsafe to assume that an address for which this function returns
887      * false is an externally-owned account (EOA) and not a contract.
888      *
889      * Among others, `isContract` will return false for the following
890      * types of addresses:
891      *
892      *  - an externally-owned account
893      *  - a contract in construction
894      *  - an address where a contract will be created
895      *  - an address where a contract lived, but was destroyed
896      * ====
897      */
898     function isContract(address account) internal view returns (bool) {
899         // This method relies on extcodesize, which returns 0 for contracts in
900         // construction, since the code is only stored at the end of the
901         // constructor execution.
902 
903         uint256 size;
904         // solhint-disable-next-line no-inline-assembly
905         assembly { size := extcodesize(account) }
906         return size > 0;
907     }
908 
909     /**
910      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
911      * `recipient`, forwarding all available gas and reverting on errors.
912      *
913      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
914      * of certain opcodes, possibly making contracts go over the 2300 gas limit
915      * imposed by `transfer`, making them unable to receive funds via
916      * `transfer`. {sendValue} removes this limitation.
917      *
918      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
919      *
920      * IMPORTANT: because control is transferred to `recipient`, care must be
921      * taken to not create reentrancy vulnerabilities. Consider using
922      * {ReentrancyGuard} or the
923      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
924      */
925     function sendValue(address payable recipient, uint256 amount) internal {
926         require(address(this).balance >= amount, "Address: insufficient balance");
927 
928         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
929         (bool success, ) = recipient.call{ value: amount }("");
930         require(success, "Address: unable to send value, recipient may have reverted");
931     }
932 
933     /**
934      * @dev Performs a Solidity function call using a low level `call`. A
935      * plain`call` is an unsafe replacement for a function call: use this
936      * function instead.
937      *
938      * If `target` reverts with a revert reason, it is bubbled up by this
939      * function (like regular Solidity function calls).
940      *
941      * Returns the raw returned data. To convert to the expected return value,
942      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
943      *
944      * Requirements:
945      *
946      * - `target` must be a contract.
947      * - calling `target` with `data` must not revert.
948      *
949      * _Available since v3.1._
950      */
951     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
952       return functionCall(target, data, "Address: low-level call failed");
953     }
954 
955     /**
956      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
957      * `errorMessage` as a fallback revert reason when `target` reverts.
958      *
959      * _Available since v3.1._
960      */
961     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
962         return functionCallWithValue(target, data, 0, errorMessage);
963     }
964 
965     /**
966      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
967      * but also transferring `value` wei to `target`.
968      *
969      * Requirements:
970      *
971      * - the calling contract must have an ETH balance of at least `value`.
972      * - the called Solidity function must be `payable`.
973      *
974      * _Available since v3.1._
975      */
976     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
977         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
978     }
979 
980     /**
981      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
982      * with `errorMessage` as a fallback revert reason when `target` reverts.
983      *
984      * _Available since v3.1._
985      */
986     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
987         require(address(this).balance >= value, "Address: insufficient balance for call");
988         require(isContract(target), "Address: call to non-contract");
989 
990         // solhint-disable-next-line avoid-low-level-calls
991         (bool success, bytes memory returndata) = target.call{ value: value }(data);
992         return _verifyCallResult(success, returndata, errorMessage);
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
997      * but performing a static call.
998      *
999      * _Available since v3.3._
1000      */
1001     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1002         return functionStaticCall(target, data, "Address: low-level static call failed");
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1007      * but performing a static call.
1008      *
1009      * _Available since v3.3._
1010      */
1011     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1012         require(isContract(target), "Address: static call to non-contract");
1013 
1014         // solhint-disable-next-line avoid-low-level-calls
1015         (bool success, bytes memory returndata) = target.staticcall(data);
1016         return _verifyCallResult(success, returndata, errorMessage);
1017     }
1018 
1019     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1020         if (success) {
1021             return returndata;
1022         } else {
1023             // Look for revert reason and bubble it up if present
1024             if (returndata.length > 0) {
1025                 // The easiest way to bubble the revert reason is using memory via assembly
1026 
1027                 // solhint-disable-next-line no-inline-assembly
1028                 assembly {
1029                     let returndata_size := mload(returndata)
1030                     revert(add(32, returndata), returndata_size)
1031                 }
1032             } else {
1033                 revert(errorMessage);
1034             }
1035         }
1036     }
1037 }
1038 
1039 
1040 
1041 /**
1042  * @dev Contract module that allows children to implement role-based access
1043  * control mechanisms.
1044  *
1045  * Roles are referred to by their `bytes32` identifier. These should be exposed
1046  * in the external API and be unique. The best way to achieve this is by
1047  * using `public constant` hash digests:
1048  *
1049  * ```
1050  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1051  * ```
1052  *
1053  * Roles can be used to represent a set of permissions. To restrict access to a
1054  * function call, use {hasRole}:
1055  *
1056  * ```
1057  * function foo() public {
1058  *     require(hasRole(MY_ROLE, msg.sender));
1059  *     ...
1060  * }
1061  * ```
1062  *
1063  * Roles can be granted and revoked dynamically via the {grantRole} and
1064  * {revokeRole} functions. Each role has an associated admin role, and only
1065  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1066  *
1067  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1068  * that only accounts with this role will be able to grant or revoke other
1069  * roles. More complex role relationships can be created by using
1070  * {_setRoleAdmin}.
1071  *
1072  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1073  * grant and revoke this role. Extra precautions should be taken to secure
1074  * accounts that have been granted it.
1075  */
1076 abstract contract AccessControl is Context {
1077     using EnumerableSet for EnumerableSet.AddressSet;
1078     using Address for address;
1079 
1080     struct RoleData {
1081         EnumerableSet.AddressSet members;
1082         bytes32 adminRole;
1083     }
1084 
1085     mapping (bytes32 => RoleData) private _roles;
1086 
1087     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1088 
1089     /**
1090      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1091      *
1092      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1093      * {RoleAdminChanged} not being emitted signaling this.
1094      *
1095      * _Available since v3.1._
1096      */
1097     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1098 
1099     /**
1100      * @dev Emitted when `account` is granted `role`.
1101      *
1102      * `sender` is the account that originated the contract call, an admin role
1103      * bearer except when using {_setupRole}.
1104      */
1105     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1106 
1107     /**
1108      * @dev Emitted when `account` is revoked `role`.
1109      *
1110      * `sender` is the account that originated the contract call:
1111      *   - if using `revokeRole`, it is the admin role bearer
1112      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1113      */
1114     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1115 
1116     /**
1117      * @dev Returns `true` if `account` has been granted `role`.
1118      */
1119     function hasRole(bytes32 role, address account) public view returns (bool) {
1120         return _roles[role].members.contains(account);
1121     }
1122 
1123     /**
1124      * @dev Returns the number of accounts that have `role`. Can be used
1125      * together with {getRoleMember} to enumerate all bearers of a role.
1126      */
1127     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1128         return _roles[role].members.length();
1129     }
1130 
1131     /**
1132      * @dev Returns one of the accounts that have `role`. `index` must be a
1133      * value between 0 and {getRoleMemberCount}, non-inclusive.
1134      *
1135      * Role bearers are not sorted in any particular way, and their ordering may
1136      * change at any point.
1137      *
1138      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1139      * you perform all queries on the same block. See the following
1140      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1141      * for more information.
1142      */
1143     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1144         return _roles[role].members.at(index);
1145     }
1146 
1147     /**
1148      * @dev Returns the admin role that controls `role`. See {grantRole} and
1149      * {revokeRole}.
1150      *
1151      * To change a role's admin, use {_setRoleAdmin}.
1152      */
1153     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1154         return _roles[role].adminRole;
1155     }
1156 
1157     /**
1158      * @dev Grants `role` to `account`.
1159      *
1160      * If `account` had not been already granted `role`, emits a {RoleGranted}
1161      * event.
1162      *
1163      * Requirements:
1164      *
1165      * - the caller must have ``role``'s admin role.
1166      */
1167     function grantRole(bytes32 role, address account) public virtual {
1168         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1169 
1170         _grantRole(role, account);
1171     }
1172 
1173     /**
1174      * @dev Revokes `role` from `account`.
1175      *
1176      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1177      *
1178      * Requirements:
1179      *
1180      * - the caller must have ``role``'s admin role.
1181      */
1182     function revokeRole(bytes32 role, address account) public virtual {
1183         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1184 
1185         _revokeRole(role, account);
1186     }
1187 
1188     /**
1189      * @dev Revokes `role` from the calling account.
1190      *
1191      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1192      * purpose is to provide a mechanism for accounts to lose their privileges
1193      * if they are compromised (such as when a trusted device is misplaced).
1194      *
1195      * If the calling account had been granted `role`, emits a {RoleRevoked}
1196      * event.
1197      *
1198      * Requirements:
1199      *
1200      * - the caller must be `account`.
1201      */
1202     function renounceRole(bytes32 role, address account) public virtual {
1203         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1204 
1205         _revokeRole(role, account);
1206     }
1207 
1208     /**
1209      * @dev Grants `role` to `account`.
1210      *
1211      * If `account` had not been already granted `role`, emits a {RoleGranted}
1212      * event. Note that unlike {grantRole}, this function doesn't perform any
1213      * checks on the calling account.
1214      *
1215      * [WARNING]
1216      * ====
1217      * This function should only be called from the constructor when setting
1218      * up the initial roles for the system.
1219      *
1220      * Using this function in any other way is effectively circumventing the admin
1221      * system imposed by {AccessControl}.
1222      * ====
1223      */
1224     function _setupRole(bytes32 role, address account) internal virtual {
1225         _grantRole(role, account);
1226     }
1227 
1228     /**
1229      * @dev Sets `adminRole` as ``role``'s admin role.
1230      *
1231      * Emits a {RoleAdminChanged} event.
1232      */
1233     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1234         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1235         _roles[role].adminRole = adminRole;
1236     }
1237 
1238     function _grantRole(bytes32 role, address account) private {
1239         if (_roles[role].members.add(account)) {
1240             emit RoleGranted(role, account, _msgSender());
1241         }
1242     }
1243 
1244     function _revokeRole(bytes32 role, address account) private {
1245         if (_roles[role].members.remove(account)) {
1246             emit RoleRevoked(role, account, _msgSender());
1247         }
1248     }
1249 }
1250 
1251 
1252 
1253 // SPDX-License-Identifier: MIT
1254 
1255 
1256 
1257 
1258 
1259 
1260 /**
1261  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1262  * tokens and those that they have an allowance for, in a way that can be
1263  * recognized off-chain (via event analysis).
1264  */
1265 abstract contract ERC20Burnable is Context, ERC20 {
1266     using SafeMath for uint256;
1267 
1268     /**
1269      * @dev Destroys `amount` tokens from the caller.
1270      *
1271      * See {ERC20-_burn}.
1272      */
1273     function burn(uint256 amount) public virtual {
1274         _burn(_msgSender(), amount);
1275     }
1276 
1277     /**
1278      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1279      * allowance.
1280      *
1281      * See {ERC20-_burn} and {ERC20-allowance}.
1282      *
1283      * Requirements:
1284      *
1285      * - the caller must have allowance for ``accounts``'s tokens of at least
1286      * `amount`.
1287      */
1288     function burnFrom(address account, uint256 amount) public virtual {
1289         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1290 
1291         _approve(account, _msgSender(), decreasedAllowance);
1292         _burn(account, amount);
1293     }
1294 }
1295 
1296 // SPDX-License-Identifier: MIT
1297 
1298 
1299 
1300 
1301 // SPDX-License-Identifier: MIT
1302 
1303 
1304 
1305 
1306 
1307 /**
1308  * @dev Contract module which allows children to implement an emergency stop
1309  * mechanism that can be triggered by an authorized account.
1310  *
1311  * This module is used through inheritance. It will make available the
1312  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1313  * the functions of your contract. Note that they will not be pausable by
1314  * simply including this module, only once the modifiers are put in place.
1315  */
1316 abstract contract Pausable is Context {
1317     /**
1318      * @dev Emitted when the pause is triggered by `account`.
1319      */
1320     event Paused(address account);
1321 
1322     /**
1323      * @dev Emitted when the pause is lifted by `account`.
1324      */
1325     event Unpaused(address account);
1326 
1327     bool private _paused;
1328 
1329     /**
1330      * @dev Initializes the contract in unpaused state.
1331      */
1332     constructor () internal {
1333         _paused = false;
1334     }
1335 
1336     /**
1337      * @dev Returns true if the contract is paused, and false otherwise.
1338      */
1339     function paused() public view returns (bool) {
1340         return _paused;
1341     }
1342 
1343     /**
1344      * @dev Modifier to make a function callable only when the contract is not paused.
1345      *
1346      * Requirements:
1347      *
1348      * - The contract must not be paused.
1349      */
1350     modifier whenNotPaused() {
1351         require(!_paused, "Pausable: paused");
1352         _;
1353     }
1354 
1355     /**
1356      * @dev Modifier to make a function callable only when the contract is paused.
1357      *
1358      * Requirements:
1359      *
1360      * - The contract must be paused.
1361      */
1362     modifier whenPaused() {
1363         require(_paused, "Pausable: not paused");
1364         _;
1365     }
1366 
1367     /**
1368      * @dev Triggers stopped state.
1369      *
1370      * Requirements:
1371      *
1372      * - The contract must not be paused.
1373      */
1374     function _pause() internal virtual whenNotPaused {
1375         _paused = true;
1376         emit Paused(_msgSender());
1377     }
1378 
1379     /**
1380      * @dev Returns to normal state.
1381      *
1382      * Requirements:
1383      *
1384      * - The contract must be paused.
1385      */
1386     function _unpause() internal virtual whenPaused {
1387         _paused = false;
1388         emit Unpaused(_msgSender());
1389     }
1390 }
1391 
1392 
1393 /**
1394  * @dev ERC20 token with pausable token transfers, minting and burning.
1395  *
1396  * Useful for scenarios such as preventing trades until the end of an evaluation
1397  * period, or having an emergency switch for freezing all token transfers in the
1398  * event of a large bug.
1399  */
1400 abstract contract ERC20Pausable is ERC20, Pausable {
1401     /**
1402      * @dev See {ERC20-_beforeTokenTransfer}.
1403      *
1404      * Requirements:
1405      *
1406      * - the contract must not be paused.
1407      */
1408     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1409         super._beforeTokenTransfer(from, to, amount);
1410 
1411         require(!paused(), "ERC20Pausable: token transfer while paused");
1412     }
1413 }
1414 
1415 
1416 /**
1417  * @dev {ERC20} token, including:
1418  *
1419  *  - ability for holders to burn (destroy) their tokens
1420  *  - a minter role that allows for token minting (creation)
1421  *  - a pauser role that allows to stop all token transfers
1422  *
1423  * This contract uses {AccessControl} to lock permissioned functions using the
1424  * different roles - head to its documentation for details.
1425  *
1426  * The account that deploys the contract will be granted the minter and pauser
1427  * roles, as well as the default admin role, which will let it grant both minter
1428  * and pauser roles to other accounts.
1429  */
1430 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1431     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1432     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1433 
1434     /**
1435      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1436      * account that deploys the contract.
1437      *
1438      * See {ERC20-constructor}.
1439      */
1440     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1441         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1442 
1443         _setupRole(MINTER_ROLE, _msgSender());
1444         _setupRole(PAUSER_ROLE, _msgSender());
1445     }
1446 
1447     /**
1448      * @dev Creates `amount` new tokens for `to`.
1449      *
1450      * See {ERC20-_mint}.
1451      *
1452      * Requirements:
1453      *
1454      * - the caller must have the `MINTER_ROLE`.
1455      */
1456     function mint(address to, uint256 amount) public virtual {
1457         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1458         _mint(to, amount);
1459     }
1460 
1461     /**
1462      * @dev Pauses all token transfers.
1463      *
1464      * See {ERC20Pausable} and {Pausable-_pause}.
1465      *
1466      * Requirements:
1467      *
1468      * - the caller must have the `PAUSER_ROLE`.
1469      */
1470     function pause() public virtual {
1471         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1472         _pause();
1473     }
1474 
1475     /**
1476      * @dev Unpauses all token transfers.
1477      *
1478      * See {ERC20Pausable} and {Pausable-_unpause}.
1479      *
1480      * Requirements:
1481      *
1482      * - the caller must have the `PAUSER_ROLE`.
1483      */
1484     function unpause() public virtual {
1485         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1486         _unpause();
1487     }
1488 
1489     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1490         super._beforeTokenTransfer(from, to, amount);
1491     }
1492 }
1493 
1494 // SPDX-License-Identifier: MIT
1495 
1496 
1497 
1498 
1499 
1500 /**
1501  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1502  */
1503 abstract contract ERC20Capped is ERC20 {
1504     using SafeMath for uint256;
1505 
1506     uint256 private _cap;
1507 
1508     /**
1509      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1510      * set once during construction.
1511      */
1512     constructor (uint256 cap_) internal {
1513         require(cap_ > 0, "ERC20Capped: cap is 0");
1514         _cap = cap_;
1515     }
1516 
1517     /**
1518      * @dev Returns the cap on the token's total supply.
1519      */
1520     function cap() public view returns (uint256) {
1521         return _cap;
1522     }
1523 
1524     /**
1525      * @dev See {ERC20-_beforeTokenTransfer}.
1526      *
1527      * Requirements:
1528      *
1529      * - minted tokens must not cause the total supply to go over the cap.
1530      */
1531     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1532         super._beforeTokenTransfer(from, to, amount);
1533 
1534         if (from == address(0)) { // When minting tokens
1535             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1536         }
1537     }
1538 }
1539 
1540 
1541 contract KolectToken is ERC20PresetMinterPauser, ERC20Capped{
1542     using SafeMath for uint256;
1543 
1544     constructor(string memory tokenName, string memory tokenSymbol, uint256 supply, address beneficiary) public ERC20PresetMinterPauser(tokenName,tokenSymbol) ERC20Capped(SafeMath.mul(supply,1 ether)) {
1545         _mint(beneficiary, SafeMath.mul(supply,1 ether));
1546     }
1547 
1548     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20PresetMinterPauser, ERC20Capped) {
1549         super._beforeTokenTransfer(from, to, amount);
1550     }
1551 }