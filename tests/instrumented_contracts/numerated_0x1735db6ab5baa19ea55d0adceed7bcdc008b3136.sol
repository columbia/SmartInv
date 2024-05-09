1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 pragma solidity ^0.8.0;
82 
83 /*
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
100         return msg.data;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
105 
106 
107 pragma solidity ^0.8.0;
108 
109 
110 
111 /**
112  * @dev Implementation of the {IERC20} interface.
113  *
114  * This implementation is agnostic to the way tokens are created. This means
115  * that a supply mechanism has to be added in a derived contract using {_mint}.
116  * For a generic mechanism see {ERC20PresetMinterPauser}.
117  *
118  * TIP: For a detailed writeup see our guide
119  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
120  * to implement supply mechanisms].
121  *
122  * We have followed general OpenZeppelin guidelines: functions revert instead
123  * of returning `false` on failure. This behavior is nonetheless conventional
124  * and does not conflict with the expectations of ERC20 applications.
125  *
126  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
127  * This allows applications to reconstruct the allowance for all accounts just
128  * by listening to said events. Other implementations of the EIP may not emit
129  * these events, as it isn't required by the specification.
130  *
131  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
132  * functions have been added to mitigate the well-known issues around setting
133  * allowances. See {IERC20-approve}.
134  */
135 contract ERC20 is Context, IERC20 {
136     mapping (address => uint256) private _balances;
137 
138     mapping (address => mapping (address => uint256)) private _allowances;
139 
140     uint256 private _totalSupply;
141 
142     string private _name;
143     string private _symbol;
144 
145     /**
146      * @dev Sets the values for {name} and {symbol}.
147      *
148      * The defaut value of {decimals} is 18. To select a different value for
149      * {decimals} you should overload it.
150      *
151      * All three of these values are immutable: they can only be set once during
152      * construction.
153      */
154     constructor (string memory name_, string memory symbol_) {
155         _name = name_;
156         _symbol = symbol_;
157     }
158 
159     /**
160      * @dev Returns the name of the token.
161      */
162     function name() public view virtual returns (string memory) {
163         return _name;
164     }
165 
166     /**
167      * @dev Returns the symbol of the token, usually a shorter version of the
168      * name.
169      */
170     function symbol() public view virtual returns (string memory) {
171         return _symbol;
172     }
173 
174     /**
175      * @dev Returns the number of decimals used to get its user representation.
176      * For example, if `decimals` equals `2`, a balance of `505` tokens should
177      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
178      *
179      * Tokens usually opt for a value of 18, imitating the relationship between
180      * Ether and Wei. This is the value {ERC20} uses, unless this function is
181      * overloaded;
182      *
183      * NOTE: This information is only used for _display_ purposes: it in
184      * no way affects any of the arithmetic of the contract, including
185      * {IERC20-balanceOf} and {IERC20-transfer}.
186      */
187     function decimals() public view virtual returns (uint8) {
188         return 18;
189     }
190 
191     /**
192      * @dev See {IERC20-totalSupply}.
193      */
194     function totalSupply() public view virtual override returns (uint256) {
195         return _totalSupply;
196     }
197 
198     /**
199      * @dev See {IERC20-balanceOf}.
200      */
201     function balanceOf(address account) public view virtual override returns (uint256) {
202         return _balances[account];
203     }
204 
205     /**
206      * @dev See {IERC20-transfer}.
207      *
208      * Requirements:
209      *
210      * - `recipient` cannot be the zero address.
211      * - the caller must have a balance of at least `amount`.
212      */
213     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
214         _transfer(_msgSender(), recipient, amount);
215         return true;
216     }
217 
218     /**
219      * @dev See {IERC20-allowance}.
220      */
221     function allowance(address owner, address spender) public view virtual override returns (uint256) {
222         return _allowances[owner][spender];
223     }
224 
225     /**
226      * @dev See {IERC20-approve}.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      */
232     function approve(address spender, uint256 amount) public virtual override returns (bool) {
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236 
237     /**
238      * @dev See {IERC20-transferFrom}.
239      *
240      * Emits an {Approval} event indicating the updated allowance. This is not
241      * required by the EIP. See the note at the beginning of {ERC20}.
242      *
243      * Requirements:
244      *
245      * - `sender` and `recipient` cannot be the zero address.
246      * - `sender` must have a balance of at least `amount`.
247      * - the caller must have allowance for ``sender``'s tokens of at least
248      * `amount`.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
251         _transfer(sender, recipient, amount);
252 
253         uint256 currentAllowance = _allowances[sender][_msgSender()];
254         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
255         _approve(sender, _msgSender(), currentAllowance - amount);
256 
257         return true;
258     }
259 
260     /**
261      * @dev Atomically increases the allowance granted to `spender` by the caller.
262      *
263      * This is an alternative to {approve} that can be used as a mitigation for
264      * problems described in {IERC20-approve}.
265      *
266      * Emits an {Approval} event indicating the updated allowance.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
273         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
274         return true;
275     }
276 
277     /**
278      * @dev Atomically decreases the allowance granted to `spender` by the caller.
279      *
280      * This is an alternative to {approve} that can be used as a mitigation for
281      * problems described in {IERC20-approve}.
282      *
283      * Emits an {Approval} event indicating the updated allowance.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      * - `spender` must have allowance for the caller of at least
289      * `subtractedValue`.
290      */
291     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
292         uint256 currentAllowance = _allowances[_msgSender()][spender];
293         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
294         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
295 
296         return true;
297     }
298 
299     /**
300      * @dev Moves tokens `amount` from `sender` to `recipient`.
301      *
302      * This is internal function is equivalent to {transfer}, and can be used to
303      * e.g. implement automatic token fees, slashing mechanisms, etc.
304      *
305      * Emits a {Transfer} event.
306      *
307      * Requirements:
308      *
309      * - `sender` cannot be the zero address.
310      * - `recipient` cannot be the zero address.
311      * - `sender` must have a balance of at least `amount`.
312      */
313     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
314         require(sender != address(0), "ERC20: transfer from the zero address");
315         require(recipient != address(0), "ERC20: transfer to the zero address");
316 
317         _beforeTokenTransfer(sender, recipient, amount);
318 
319         uint256 senderBalance = _balances[sender];
320         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
321         _balances[sender] = senderBalance - amount;
322         _balances[recipient] += amount;
323 
324         emit Transfer(sender, recipient, amount);
325     }
326 
327     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
328      * the total supply.
329      *
330      * Emits a {Transfer} event with `from` set to the zero address.
331      *
332      * Requirements:
333      *
334      * - `to` cannot be the zero address.
335      */
336     function _mint(address account, uint256 amount) internal virtual {
337         require(account != address(0), "ERC20: mint to the zero address");
338 
339         _beforeTokenTransfer(address(0), account, amount);
340 
341         _totalSupply += amount;
342         _balances[account] += amount;
343         emit Transfer(address(0), account, amount);
344     }
345 
346     /**
347      * @dev Destroys `amount` tokens from `account`, reducing the
348      * total supply.
349      *
350      * Emits a {Transfer} event with `to` set to the zero address.
351      *
352      * Requirements:
353      *
354      * - `account` cannot be the zero address.
355      * - `account` must have at least `amount` tokens.
356      */
357     function _burn(address account, uint256 amount) internal virtual {
358         require(account != address(0), "ERC20: burn from the zero address");
359 
360         _beforeTokenTransfer(account, address(0), amount);
361 
362         uint256 accountBalance = _balances[account];
363         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
364         _balances[account] = accountBalance - amount;
365         _totalSupply -= amount;
366 
367         emit Transfer(account, address(0), amount);
368     }
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
372      *
373      * This internal function is equivalent to `approve`, and can be used to
374      * e.g. set automatic allowances for certain subsystems, etc.
375      *
376      * Emits an {Approval} event.
377      *
378      * Requirements:
379      *
380      * - `owner` cannot be the zero address.
381      * - `spender` cannot be the zero address.
382      */
383     function _approve(address owner, address spender, uint256 amount) internal virtual {
384         require(owner != address(0), "ERC20: approve from the zero address");
385         require(spender != address(0), "ERC20: approve to the zero address");
386 
387         _allowances[owner][spender] = amount;
388         emit Approval(owner, spender, amount);
389     }
390 
391     /**
392      * @dev Hook that is called before any transfer of tokens. This includes
393      * minting and burning.
394      *
395      * Calling conditions:
396      *
397      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
398      * will be to transferred to `to`.
399      * - when `from` is zero, `amount` tokens will be minted for `to`.
400      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
401      * - `from` and `to` are never both zero.
402      *
403      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
404      */
405     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
406 }
407 
408 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev Library for managing
414  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
415  * types.
416  *
417  * Sets have the following properties:
418  *
419  * - Elements are added, removed, and checked for existence in constant time
420  * (O(1)).
421  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
422  *
423  * ```
424  * contract Example {
425  *     // Add the library methods
426  *     using EnumerableSet for EnumerableSet.AddressSet;
427  *
428  *     // Declare a set state variable
429  *     EnumerableSet.AddressSet private mySet;
430  * }
431  * ```
432  *
433  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
434  * and `uint256` (`UintSet`) are supported.
435  */
436 library EnumerableSet {
437     // To implement this library for multiple types with as little code
438     // repetition as possible, we write it in terms of a generic Set type with
439     // bytes32 values.
440     // The Set implementation uses private functions, and user-facing
441     // implementations (such as AddressSet) are just wrappers around the
442     // underlying Set.
443     // This means that we can only create new EnumerableSets for types that fit
444     // in bytes32.
445 
446     struct Set {
447         // Storage of set values
448         bytes32[] _values;
449 
450         // Position of the value in the `values` array, plus 1 because index 0
451         // means a value is not in the set.
452         mapping (bytes32 => uint256) _indexes;
453     }
454 
455     /**
456      * @dev Add a value to a set. O(1).
457      *
458      * Returns true if the value was added to the set, that is if it was not
459      * already present.
460      */
461     function _add(Set storage set, bytes32 value) private returns (bool) {
462         if (!_contains(set, value)) {
463             set._values.push(value);
464             // The value is stored at length-1, but we add 1 to all indexes
465             // and use 0 as a sentinel value
466             set._indexes[value] = set._values.length;
467             return true;
468         } else {
469             return false;
470         }
471     }
472 
473     /**
474      * @dev Removes a value from a set. O(1).
475      *
476      * Returns true if the value was removed from the set, that is if it was
477      * present.
478      */
479     function _remove(Set storage set, bytes32 value) private returns (bool) {
480         // We read and store the value's index to prevent multiple reads from the same storage slot
481         uint256 valueIndex = set._indexes[value];
482 
483         if (valueIndex != 0) { // Equivalent to contains(set, value)
484             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
485             // the array, and then remove the last element (sometimes called as 'swap and pop').
486             // This modifies the order of the array, as noted in {at}.
487 
488             uint256 toDeleteIndex = valueIndex - 1;
489             uint256 lastIndex = set._values.length - 1;
490 
491             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
492             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
493 
494             bytes32 lastvalue = set._values[lastIndex];
495 
496             // Move the last value to the index where the value to delete is
497             set._values[toDeleteIndex] = lastvalue;
498             // Update the index for the moved value
499             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
500 
501             // Delete the slot where the moved value was stored
502             set._values.pop();
503 
504             // Delete the index for the deleted slot
505             delete set._indexes[value];
506 
507             return true;
508         } else {
509             return false;
510         }
511     }
512 
513     /**
514      * @dev Returns true if the value is in the set. O(1).
515      */
516     function _contains(Set storage set, bytes32 value) private view returns (bool) {
517         return set._indexes[value] != 0;
518     }
519 
520     /**
521      * @dev Returns the number of values on the set. O(1).
522      */
523     function _length(Set storage set) private view returns (uint256) {
524         return set._values.length;
525     }
526 
527    /**
528     * @dev Returns the value stored at position `index` in the set. O(1).
529     *
530     * Note that there are no guarantees on the ordering of values inside the
531     * array, and it may change when more values are added or removed.
532     *
533     * Requirements:
534     *
535     * - `index` must be strictly less than {length}.
536     */
537     function _at(Set storage set, uint256 index) private view returns (bytes32) {
538         require(set._values.length > index, "EnumerableSet: index out of bounds");
539         return set._values[index];
540     }
541 
542     // Bytes32Set
543 
544     struct Bytes32Set {
545         Set _inner;
546     }
547 
548     /**
549      * @dev Add a value to a set. O(1).
550      *
551      * Returns true if the value was added to the set, that is if it was not
552      * already present.
553      */
554     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
555         return _add(set._inner, value);
556     }
557 
558     /**
559      * @dev Removes a value from a set. O(1).
560      *
561      * Returns true if the value was removed from the set, that is if it was
562      * present.
563      */
564     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
565         return _remove(set._inner, value);
566     }
567 
568     /**
569      * @dev Returns true if the value is in the set. O(1).
570      */
571     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
572         return _contains(set._inner, value);
573     }
574 
575     /**
576      * @dev Returns the number of values in the set. O(1).
577      */
578     function length(Bytes32Set storage set) internal view returns (uint256) {
579         return _length(set._inner);
580     }
581 
582    /**
583     * @dev Returns the value stored at position `index` in the set. O(1).
584     *
585     * Note that there are no guarantees on the ordering of values inside the
586     * array, and it may change when more values are added or removed.
587     *
588     * Requirements:
589     *
590     * - `index` must be strictly less than {length}.
591     */
592     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
593         return _at(set._inner, index);
594     }
595 
596     // AddressSet
597 
598     struct AddressSet {
599         Set _inner;
600     }
601 
602     /**
603      * @dev Add a value to a set. O(1).
604      *
605      * Returns true if the value was added to the set, that is if it was not
606      * already present.
607      */
608     function add(AddressSet storage set, address value) internal returns (bool) {
609         return _add(set._inner, bytes32(uint256(uint160(value))));
610     }
611 
612     /**
613      * @dev Removes a value from a set. O(1).
614      *
615      * Returns true if the value was removed from the set, that is if it was
616      * present.
617      */
618     function remove(AddressSet storage set, address value) internal returns (bool) {
619         return _remove(set._inner, bytes32(uint256(uint160(value))));
620     }
621 
622     /**
623      * @dev Returns true if the value is in the set. O(1).
624      */
625     function contains(AddressSet storage set, address value) internal view returns (bool) {
626         return _contains(set._inner, bytes32(uint256(uint160(value))));
627     }
628 
629     /**
630      * @dev Returns the number of values in the set. O(1).
631      */
632     function length(AddressSet storage set) internal view returns (uint256) {
633         return _length(set._inner);
634     }
635 
636    /**
637     * @dev Returns the value stored at position `index` in the set. O(1).
638     *
639     * Note that there are no guarantees on the ordering of values inside the
640     * array, and it may change when more values are added or removed.
641     *
642     * Requirements:
643     *
644     * - `index` must be strictly less than {length}.
645     */
646     function at(AddressSet storage set, uint256 index) internal view returns (address) {
647         return address(uint160(uint256(_at(set._inner, index))));
648     }
649 
650 
651     // UintSet
652 
653     struct UintSet {
654         Set _inner;
655     }
656 
657     /**
658      * @dev Add a value to a set. O(1).
659      *
660      * Returns true if the value was added to the set, that is if it was not
661      * already present.
662      */
663     function add(UintSet storage set, uint256 value) internal returns (bool) {
664         return _add(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Removes a value from a set. O(1).
669      *
670      * Returns true if the value was removed from the set, that is if it was
671      * present.
672      */
673     function remove(UintSet storage set, uint256 value) internal returns (bool) {
674         return _remove(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Returns true if the value is in the set. O(1).
679      */
680     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
681         return _contains(set._inner, bytes32(value));
682     }
683 
684     /**
685      * @dev Returns the number of values on the set. O(1).
686      */
687     function length(UintSet storage set) internal view returns (uint256) {
688         return _length(set._inner);
689     }
690 
691    /**
692     * @dev Returns the value stored at position `index` in the set. O(1).
693     *
694     * Note that there are no guarantees on the ordering of values inside the
695     * array, and it may change when more values are added or removed.
696     *
697     * Requirements:
698     *
699     * - `index` must be strictly less than {length}.
700     */
701     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
702         return uint256(_at(set._inner, index));
703     }
704 }
705 
706 // File: contracts/OwnershipAgreement.sol
707 
708 pragma solidity >=0.7.0 <0.9.0;
709 
710 
711 /// @title Creates an Ownership Agreement, with an optional Operator role
712 /// @author Dr. Jonathan Shahen at UREEQA
713 /// @notice TODO
714 /// @dev Maximum number of Owners is set to 255 (unit8.MAX_VALUE)
715 contract OwnershipAgreement {
716     /*
717      * Storage
718      */
719     enum ResolutionType {
720         None, // This indicates that the resolution hasn't been set (default value)
721         AddOwner,
722         RemoveOwner,
723         ReplaceOwner,
724         AddOperator,
725         RemoveOperator,
726         ReplaceOperator,
727         UpdateThreshold,
728         UpdateTransactionLimit,
729         Pause,
730         Unpause,
731         Custom
732     }
733     struct Resolution {
734         // Has the resolution already been passed
735         bool passed;
736         // The type of resolution
737         ResolutionType resType;
738         // The old address, can be address(0). oldAddress and newAddress cannot both equal address(0).
739         address oldAddress;
740         // The new address, can be address(0). oldAddress and newAddress cannot both equal address(0).
741         address newAddress;
742     }
743     using EnumerableSet for EnumerableSet.AddressSet;
744     // Set of owners
745     // NOTE: we utilize a set, so we can enumerate the owners and so that the list only contains one instance of an account
746     // NOTE: address(0) is not a valid owner
747     EnumerableSet.AddressSet private _owners;
748     // Value to indicate if the smart contract is paused
749     bool private _paused;
750     // An address, usually controlled by a computer, that performs regular/automated operations within the smart contract
751     // NOTE: address(0) is not a valid operator
752     EnumerableSet.AddressSet private _operators;
753     // Limit the number of operators
754     uint160 public operatorLimit = 1;
755     // The number of owners it takes to come to an agreement
756     uint160 public ownerAgreementThreshold = 1;
757     // Limit per Transaction to impose
758     // A limit of zero means no limit imposed
759     uint256 public transactionLimit = 0;
760     // Stores each vote for each resolution number (int)
761     mapping(address => mapping(uint256 => bool)) public ownerVotes;
762     // The next available resolution number
763     uint256 public nextResolution = 1;
764     mapping(address => uint256) lastOwnerResolutionNumber;
765     // Stores the resolutions
766     mapping(uint256 => Resolution) public resolutions;
767 
768     // ////////////////////////////////////////////////////
769     // EVENTS
770     // ////////////////////////////////////////////////////
771     event OwnerAddition(address owner);
772     event OwnerRemoval(address owner);
773     event OwnerReplacement(address oldOwner, address newOwner);
774 
775     event OperatorAddition(address newOperator);
776     event OperatorRemoval(address oldOperator);
777     event OperatorReplacement(address oldOperator, address newOperator);
778 
779     event UpdateThreshold(uint160 newThreshold);
780     event UpdateNumberOfOperators(uint160 newOperators);
781     event UpdateTransactionLimit(uint256 newLimit);
782     /// @dev Emitted when the pause is triggered by `account`.
783     event Paused(address account);
784     /// @dev Emitted when the pause is lifted by `account`.
785     event Unpaused(address account);
786 
787     // ////////////////////////////////////////////////////
788     // MODIFIERS
789     // ////////////////////////////////////////////////////
790     function isValidAddress(address newAddr) public pure {
791         require(newAddr != address(0), "Invaild Address");
792     }
793 
794     modifier onlyOperators() {
795         isValidAddress(msg.sender);
796         require(
797             EnumerableSet.contains(_operators, msg.sender) == true,
798             "Only the operator can run this function."
799         );
800         _;
801     }
802     modifier onlyOwners() {
803         isValidAddress(msg.sender);
804         require(
805             EnumerableSet.contains(_owners, msg.sender) == true,
806             "Only an owner can run this function."
807         );
808         _;
809     }
810 
811     modifier onlyOwnersOrOperator() {
812         isValidAddress(msg.sender);
813         require(
814             EnumerableSet.contains(_operators, msg.sender) == true || 
815             EnumerableSet.contains(_owners, msg.sender) == true,
816             "Only an owner or the operator can run this function."
817         );
818         _;
819     }
820 
821     modifier ownerExists(address owner) {
822         require(
823             EnumerableSet.contains(_owners, owner) == true,
824             "Owner does not exists."
825         );
826         _;
827     }
828 
829     /**
830      * @dev Modifier to make a function callable only when the contract is not paused.
831      * Requirements: The contract must not be paused.
832      */
833     modifier whenNotPaused() {
834         require(!_paused, "Smart Contract is paused");
835         _;
836     }
837 
838     /**
839      * @dev Modifier to make a function callable only when the contract is paused.
840      * Requirements: The contract must be paused.
841      */
842     modifier whenPaused() {
843         require(_paused, "Smart Contract is not paused");
844         _;
845     }
846 
847     /// @dev Modifier to make a function callable only when the amount is within the transaction limit
848     modifier withinLimit(uint256 amount) {
849         require(transactionLimit == 0 || amount <= transactionLimit, "Amount is over the transaction limit");
850         _;
851     }
852 
853     // ////////////////////////////////////////////////////
854     // CONSTRUCTOR
855     // ////////////////////////////////////////////////////
856     constructor() {
857         _addOwner(msg.sender);
858         _paused = false;
859     }
860 
861     // ////////////////////////////////////////////////////
862     // VIEW FUNCTIONS
863     // ////////////////////////////////////////////////////
864 
865     /// @dev Returns list of owners.
866     /// @return List of owner addresses.
867     function getOwners() public view returns (address[] memory) {
868         uint256 len = EnumerableSet.length(_owners);
869         address[] memory o = new address[](len);
870 
871         for (uint256 i = 0; i < len; i++) {
872             o[i] = EnumerableSet.at(_owners, i);
873         }
874 
875         return o;
876     }
877 
878     /// @dev Returns the number of owners.
879     /// @return Number of owners.
880     function getNumberOfOwners() public view returns (uint8) {
881         return uint8(EnumerableSet.length(_owners));
882     }
883 
884     /// @dev Returns list of owners.
885     /// @return List of owner addresses.
886     function getOperators() public view returns (address[] memory) {
887         uint256 len = EnumerableSet.length(_operators);
888         address[] memory o = new address[](len);
889 
890         for (uint256 i = 0; i < len; i++) {
891             o[i] = EnumerableSet.at(_operators, i);
892         }
893 
894         return o;
895     }
896 
897     /// @dev Returns the number of operators.
898     /// @return Number of operators.
899     function getNumberOfOperators() public view returns (uint8) {
900         return uint8(EnumerableSet.length(_operators));
901     }
902 
903     /// @dev How many owners does it take to approve a resolution
904     /// @return minimum number of owner votes
905     function getVoteThreshold() public view returns (uint160) {
906         return ownerAgreementThreshold;
907     }
908 
909     /// @dev Returns the maximum amount a transaction can contain
910     /// @return maximum amount or zero is no limit
911     function getTransactionLimit() public view returns (uint256) {
912         return transactionLimit;
913     }
914 
915     /// @dev Returns the next available resolution.
916     /// @return The next available resolution number
917     function getNextResolutionNumber() public view returns (uint256) {
918         return nextResolution;
919     }
920 
921     /// @dev Returns the next available resolution.
922     /// @return The next available resolution number
923     function getLastOwnerResolutionNumber(address owner) public view returns (uint256) {
924         return lastOwnerResolutionNumber[owner];
925     }
926 
927     /// @dev Returns true if the contract is paused, and false otherwise.
928     function paused() public view returns (bool) {
929         return _paused;
930     }
931 
932     /// @dev Helper function to fail if resolution number is already in use.
933     function resolutionAlreadyUsed(uint256 resNum) public view {
934         require(
935             // atleast one of the address must not be equal to address(0)
936             !(resolutions[resNum].oldAddress != address(0) ||
937                 resolutions[resNum].newAddress != address(0)),
938             "Resolution is already in use."
939         );
940     }
941 
942     function isResolutionPassed(uint256 resNum) public view returns (bool) {
943         return resolutions[resNum].passed;
944     }
945 
946     function canResolutionPass(uint256 resNum) public view returns (bool) {
947         uint256 voteCount = 0;
948         uint256 len = EnumerableSet.length(_owners);
949 
950         for (uint256 i = 0; i < len; i++) {
951             if (ownerVotes[EnumerableSet.at(_owners, i)][resNum] == true) {
952                 voteCount++;
953             }
954         }
955 
956         return voteCount >= ownerAgreementThreshold;
957     }
958 
959     // ////////////////////////////////////////////////////
960     // PUBLIC FUNCTIONS
961     // ////////////////////////////////////////////////////
962 
963     /// @notice Vote Yes on a Resolution.
964     /// @dev The owner who tips the agreement threshold will pay the gas for performing the resolution.
965     /// @return TRUE if the resolution passed
966     function voteResolution(uint256 resNum) public onlyOwners() returns (bool) {
967         ownerVotes[msg.sender][resNum] = true;
968 
969         // If the reolution has already passed, then do nothing
970         if (isResolutionPassed(resNum)) {
971             return true;
972         }
973 
974         // If the resolution can now be passed, then do so
975         if (canResolutionPass(resNum)) {
976             _performResolution(resNum);
977             return true;
978         }
979 
980         // The resolution cannot be passed yet
981         return false;
982     }
983 
984     /// @dev Create a resolution to add an owner. Performs addition if threshold is 1 or zero.
985     function createResolutionAddOwner(address newOwner) public onlyOwners() {
986         isValidAddress(newOwner);
987         require(!EnumerableSet.contains(_owners, newOwner),"newOwner already exists.");
988 
989         createResolution(ResolutionType.AddOwner, address(0), newOwner);
990     }
991 
992     /// @dev Create a resolution to remove an owner. Performs removal if threshold is 1 or zero.
993     /// @dev Updates the threshold to keep it less than or equal to the number of new owners
994     function createResolutionRemoveOwner(address owner) public onlyOwners() {
995         isValidAddress(owner);
996         require(getNumberOfOwners() > 1, "Must always be one owner");
997         require(EnumerableSet.contains(_owners, owner),"owner is not an owner.");
998 
999         createResolution(ResolutionType.RemoveOwner, owner, address(0));
1000     }
1001 
1002     /// @dev Create a resolution to repalce an owner. Performs replacement if threshold is 1 or zero.
1003     function createResolutionReplaceOwner(address oldOwner, address newOwner)
1004         public
1005         onlyOwners()
1006     {
1007         isValidAddress(oldOwner);
1008         isValidAddress(newOwner);
1009         require(EnumerableSet.contains(_owners, oldOwner),"oldOwner is not an owner.");
1010         require(!EnumerableSet.contains(_owners, newOwner),"newOwner already exists.");
1011 
1012         createResolution(ResolutionType.ReplaceOwner, oldOwner, newOwner);
1013     }
1014 
1015     /// @dev Create a resolution to add an operator. Performs addition if threshold is 1 or zero.
1016     function createResolutionAddOperator(address newOperator) public onlyOwners() {
1017         isValidAddress(newOperator);
1018         require(!EnumerableSet.contains(_operators, newOperator),"newOperator already exists.");
1019 
1020         createResolution(ResolutionType.AddOperator, address(0), newOperator);
1021     }
1022 
1023     /// @dev Create a resolution to remove the operator. Performs removal if threshold is 1 or zero.
1024     function createResolutionRemoveOperator(address operator) public onlyOwners() {
1025         require(EnumerableSet.contains(_operators, operator),"operator is not an Operator.");
1026         createResolution(ResolutionType.RemoveOperator, operator, address(0));
1027     }
1028 
1029     /// @dev Create a resolution to replace the operator account. Performs replacement if threshold is 1 or zero.
1030     function createResolutionReplaceOperator(address oldOperator, address newOperator)
1031         public
1032         onlyOwners()
1033     {
1034         isValidAddress(oldOperator);
1035         isValidAddress(newOperator);
1036         require(EnumerableSet.contains(_operators, oldOperator),"oldOperator is not an Operator.");
1037         require(!EnumerableSet.contains(_operators, newOperator),"newOperator already exists.");
1038 
1039         createResolution(ResolutionType.ReplaceOperator, oldOperator, newOperator);
1040     }
1041 
1042     /// @dev Create a resolution to update the transaction limit. Performs update if threshold is 1 or zero.
1043     function createResolutionUpdateTransactionLimit(uint160 newLimit)
1044         public
1045         onlyOwners()
1046     {
1047         createResolution(ResolutionType.UpdateTransactionLimit, address(0), address(newLimit));
1048     }
1049 
1050     /// @dev Create a resolution to update the owner agreement threshold. Performs update if threshold is 1 or zero.
1051     function createResolutionUpdateThreshold(uint160 threshold)
1052         public
1053         onlyOwners()
1054     {
1055         createResolution(ResolutionType.UpdateThreshold, address(0), address(threshold));
1056     }
1057 
1058     /// @dev Pause the contract. Does not require owner agreement.
1059     function pause() public onlyOwners() {
1060         _pause();
1061     }
1062 
1063     /// @dev Create a resolution to unpause the contract. Performs update if threshold is 1 or zero.
1064     function createResolutionUnpause() public onlyOwners() {
1065         createResolution(ResolutionType.Unpause, address(1), address(1));
1066     }
1067 
1068     // ////////////////////////////////////////////////////
1069     // INTERNAL FUNCTIONS
1070     // ////////////////////////////////////////////////////
1071     /// @dev Create a resolution and check if we can call perofrm the resolution with 1 vote.
1072     function createResolution(ResolutionType resType, address oldAddress, address newAddress) internal {
1073         uint256 resNum = nextResolution;
1074         nextResolution++;
1075         resolutionAlreadyUsed(resNum);
1076 
1077         resolutions[resNum].resType = resType;
1078         resolutions[resNum].oldAddress = oldAddress;
1079         resolutions[resNum].newAddress = newAddress;
1080 
1081         ownerVotes[msg.sender][resNum] = true;
1082         lastOwnerResolutionNumber[msg.sender] = resNum;
1083 
1084         // Check if agreement is already reached
1085         if (ownerAgreementThreshold <= 1) {
1086             _performResolution(resNum);
1087         }
1088     }
1089 
1090     /// @dev Performs the resolution and then marks it as passed. No checks prevent it from performing the resolutions.
1091     function _performResolution(uint256 resNum) internal {
1092         if (resolutions[resNum].resType == ResolutionType.AddOwner) {
1093             _addOwner(resolutions[resNum].newAddress);
1094         } else if (resolutions[resNum].resType == ResolutionType.RemoveOwner) {
1095             _removeOwner(resolutions[resNum].oldAddress);
1096         } else if (resolutions[resNum].resType == ResolutionType.ReplaceOwner) {
1097             _replaceOwner(
1098                 resolutions[resNum].oldAddress,
1099                 resolutions[resNum].newAddress
1100             );
1101         } else if (
1102             resolutions[resNum].resType == ResolutionType.AddOperator
1103         ) {
1104             _addOperator(resolutions[resNum].newAddress);
1105         } else if (
1106             resolutions[resNum].resType == ResolutionType.RemoveOperator
1107         ) {
1108             _removeOperator(resolutions[resNum].oldAddress);
1109         } else if (
1110             resolutions[resNum].resType == ResolutionType.ReplaceOperator
1111         ) {
1112             _replaceOperator(resolutions[resNum].oldAddress,resolutions[resNum].newAddress);
1113         } else if (
1114             resolutions[resNum].resType == ResolutionType.UpdateTransactionLimit
1115         ) {
1116             _updateTransactionLimit(uint160(resolutions[resNum].newAddress));
1117         } else if (
1118             resolutions[resNum].resType == ResolutionType.UpdateThreshold
1119         ) {
1120             _updateThreshold(uint160(resolutions[resNum].newAddress));
1121         } else if (
1122             resolutions[resNum].resType == ResolutionType.Pause
1123         ) {
1124             _pause();
1125         } else if (
1126             resolutions[resNum].resType == ResolutionType.Unpause
1127         ) {
1128             _unpause();
1129         }
1130 
1131         resolutions[resNum].passed = true;
1132     }
1133 
1134     /// @dev
1135     function _addOwner(address owner) internal {
1136         EnumerableSet.add(_owners, owner);
1137         emit OwnerAddition(owner);
1138     }
1139 
1140     /// @dev
1141     function _removeOwner(address owner) internal {
1142         EnumerableSet.remove(_owners, owner);
1143         emit OwnerRemoval(owner);
1144 
1145         uint8 numOwners = getNumberOfOwners();
1146         if(ownerAgreementThreshold > numOwners) {
1147             _updateThreshold(numOwners);
1148         }
1149     }
1150 
1151     /// @dev
1152     function _replaceOwner(address oldOwner, address newOwner) internal {
1153         EnumerableSet.remove(_owners, oldOwner);
1154         EnumerableSet.add(_owners, newOwner);
1155         emit OwnerReplacement(oldOwner, newOwner);
1156     }
1157 
1158     /// @dev
1159     function _addOperator(address operator) internal {
1160         EnumerableSet.add(_operators, operator);
1161         emit OperatorAddition(operator);
1162     }
1163 
1164     /// @dev
1165     function _removeOperator(address operator) internal {
1166         EnumerableSet.remove(_operators, operator);
1167         emit OperatorRemoval(operator);
1168     }
1169 
1170     /// @dev
1171     function _replaceOperator(address oldOperator, address newOperator) internal {
1172         emit OperatorReplacement(oldOperator, newOperator);
1173         EnumerableSet.remove(_operators, oldOperator);
1174         EnumerableSet.add(_operators, newOperator);
1175     }
1176 
1177     /// @dev Internal function to update and emit the new transaction limit
1178     function _updateTransactionLimit(uint256 newLimit) internal {
1179         emit UpdateTransactionLimit(newLimit);
1180         transactionLimit = newLimit;
1181     }
1182 
1183     /// @dev Internal function to update and emit the new voting threshold
1184     function _updateThreshold(uint160 threshold) internal {
1185         require(threshold <= getNumberOfOwners(), "Unable to set threshold above the number of owners");
1186         emit UpdateThreshold(threshold);
1187         ownerAgreementThreshold = threshold;
1188     }
1189 
1190     /// @dev Internal function to update and emit the new voting threshold
1191     function _updateNumberOfOperators(uint160 numOperators) internal {
1192         require(numOperators >= getNumberOfOperators(), "Unable to set number of Operators below the number of operators");
1193         emit UpdateNumberOfOperators(numOperators);
1194         operatorLimit = numOperators;
1195     }
1196 
1197 
1198     /**
1199      * @dev Triggers stopped state.
1200      *
1201      * Requirements: The contract must not be paused.
1202      */
1203     function _pause() internal virtual whenNotPaused {
1204         _paused = true;
1205         emit Paused(msg.sender);
1206     }
1207 
1208     /**
1209      * @dev Returns to normal state.
1210      *
1211      * Requirements: The contract must be paused.
1212      */
1213     function _unpause() internal virtual whenPaused {
1214         _paused = false;
1215         emit Unpaused(msg.sender);
1216     }
1217 }
1218 
1219 // File: contracts/URQAToken.sol
1220 
1221 pragma solidity >=0.7.0 <0.9.0;
1222 
1223 
1224 
1225 /// @title UREEQA's URQA Token
1226 /// @author Dr. Jonathan Shahen at UREEQA
1227 contract URQAToken is OwnershipAgreement, ERC20 {
1228 
1229     constructor() ERC20("UREEQA Token", "URQA") {
1230         // Total Supply: 100 million
1231         _mint(msg.sender, 100_000_000e18);
1232     }
1233 
1234     /**
1235      * @dev Batch transfer to reduce gas fees. Utilizes SafeMath and self.transfer
1236      *
1237      * Requirements:
1238      *
1239      * - `recipients` cannot contain the zero address.
1240      * - the caller must have a balance of at least SUM `amounts`.
1241      */
1242     function batchTransfer(address[] memory recipients, uint256[] memory amounts) public returns (bool) {
1243         for(uint256 i=0; i< amounts.length; i++) {
1244             transfer(recipients[i], amounts[i]);
1245         }
1246         return true;
1247     }
1248 
1249     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1250         super._beforeTokenTransfer(from, to, amount);
1251 
1252         require(!paused(), "Cannot complete token transfer while Contract is Paused");
1253     }
1254 }