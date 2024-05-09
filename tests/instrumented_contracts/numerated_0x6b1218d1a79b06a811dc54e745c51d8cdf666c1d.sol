1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
138 
139 
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin guidelines: functions revert instead
158  * of returning `false` on failure. This behavior is nonetheless conventional
159  * and does not conflict with the expectations of ERC20 applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The defaut value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor (string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         _approve(sender, _msgSender(), currentAllowance - amount);
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(sender, recipient, amount);
353 
354         uint256 senderBalance = _balances[sender];
355         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
356         _balances[sender] = senderBalance - amount;
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `to` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         _balances[account] = accountBalance - amount;
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Hook that is called before any transfer of tokens. This includes
428      * minting and burning.
429      *
430      * Calling conditions:
431      *
432      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
433      * will be to transferred to `to`.
434      * - when `from` is zero, `amount` tokens will be minted for `to`.
435      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
436      * - `from` and `to` are never both zero.
437      *
438      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
439      */
440     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
441 }
442 
443 // File: @openzeppelin\contracts\access\Ownable.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Contract module which provides a basic access control mechanism, where
451  * there is an account (an owner) that can be granted exclusive access to
452  * specific functions.
453  *
454  * By default, the owner account will be the one that deploys the contract. This
455  * can later be changed with {transferOwnership}.
456  *
457  * This module is used through inheritance. It will make available the modifier
458  * `onlyOwner`, which can be applied to your functions to restrict their use to
459  * the owner.
460  */
461 abstract contract Ownable is Context {
462     address private _owner;
463 
464     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
465 
466     /**
467      * @dev Initializes the contract setting the deployer as the initial owner.
468      */
469     constructor () {
470         address msgSender = _msgSender();
471         _owner = msgSender;
472         emit OwnershipTransferred(address(0), msgSender);
473     }
474 
475     /**
476      * @dev Returns the address of the current owner.
477      */
478     function owner() public view virtual returns (address) {
479         return _owner;
480     }
481 
482     /**
483      * @dev Throws if called by any account other than the owner.
484      */
485     modifier onlyOwner() {
486         require(owner() == _msgSender(), "Ownable: caller is not the owner");
487         _;
488     }
489 
490     /**
491      * @dev Leaves the contract without owner. It will not be possible to call
492      * `onlyOwner` functions anymore. Can only be called by the current owner.
493      *
494      * NOTE: Renouncing ownership will leave the contract without an owner,
495      * thereby removing any functionality that is only available to the owner.
496      */
497     function renounceOwnership() public virtual onlyOwner {
498         emit OwnershipTransferred(_owner, address(0));
499         _owner = address(0);
500     }
501 
502     /**
503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
504      * Can only be called by the current owner.
505      */
506     function transferOwnership(address newOwner) public virtual onlyOwner {
507         require(newOwner != address(0), "Ownable: new owner is the zero address");
508         emit OwnershipTransferred(_owner, newOwner);
509         _owner = newOwner;
510     }
511 }
512 
513 // File: @openzeppelin\contracts\utils\structs\EnumerableSet.sol
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Library for managing
521  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
522  * types.
523  *
524  * Sets have the following properties:
525  *
526  * - Elements are added, removed, and checked for existence in constant time
527  * (O(1)).
528  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
529  *
530  * ```
531  * contract Example {
532  *     // Add the library methods
533  *     using EnumerableSet for EnumerableSet.AddressSet;
534  *
535  *     // Declare a set state variable
536  *     EnumerableSet.AddressSet private mySet;
537  * }
538  * ```
539  *
540  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
541  * and `uint256` (`UintSet`) are supported.
542  */
543 library EnumerableSet {
544     // To implement this library for multiple types with as little code
545     // repetition as possible, we write it in terms of a generic Set type with
546     // bytes32 values.
547     // The Set implementation uses private functions, and user-facing
548     // implementations (such as AddressSet) are just wrappers around the
549     // underlying Set.
550     // This means that we can only create new EnumerableSets for types that fit
551     // in bytes32.
552 
553     struct Set {
554         // Storage of set values
555         bytes32[] _values;
556 
557         // Position of the value in the `values` array, plus 1 because index 0
558         // means a value is not in the set.
559         mapping (bytes32 => uint256) _indexes;
560     }
561 
562     /**
563      * @dev Add a value to a set. O(1).
564      *
565      * Returns true if the value was added to the set, that is if it was not
566      * already present.
567      */
568     function _add(Set storage set, bytes32 value) private returns (bool) {
569         if (!_contains(set, value)) {
570             set._values.push(value);
571             // The value is stored at length-1, but we add 1 to all indexes
572             // and use 0 as a sentinel value
573             set._indexes[value] = set._values.length;
574             return true;
575         } else {
576             return false;
577         }
578     }
579 
580     /**
581      * @dev Removes a value from a set. O(1).
582      *
583      * Returns true if the value was removed from the set, that is if it was
584      * present.
585      */
586     function _remove(Set storage set, bytes32 value) private returns (bool) {
587         // We read and store the value's index to prevent multiple reads from the same storage slot
588         uint256 valueIndex = set._indexes[value];
589 
590         if (valueIndex != 0) { // Equivalent to contains(set, value)
591             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
592             // the array, and then remove the last element (sometimes called as 'swap and pop').
593             // This modifies the order of the array, as noted in {at}.
594 
595             uint256 toDeleteIndex = valueIndex - 1;
596             uint256 lastIndex = set._values.length - 1;
597 
598             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
599             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
600 
601             bytes32 lastvalue = set._values[lastIndex];
602 
603             // Move the last value to the index where the value to delete is
604             set._values[toDeleteIndex] = lastvalue;
605             // Update the index for the moved value
606             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
607 
608             // Delete the slot where the moved value was stored
609             set._values.pop();
610 
611             // Delete the index for the deleted slot
612             delete set._indexes[value];
613 
614             return true;
615         } else {
616             return false;
617         }
618     }
619 
620     /**
621      * @dev Returns true if the value is in the set. O(1).
622      */
623     function _contains(Set storage set, bytes32 value) private view returns (bool) {
624         return set._indexes[value] != 0;
625     }
626 
627     /**
628      * @dev Returns the number of values on the set. O(1).
629      */
630     function _length(Set storage set) private view returns (uint256) {
631         return set._values.length;
632     }
633 
634    /**
635     * @dev Returns the value stored at position `index` in the set. O(1).
636     *
637     * Note that there are no guarantees on the ordering of values inside the
638     * array, and it may change when more values are added or removed.
639     *
640     * Requirements:
641     *
642     * - `index` must be strictly less than {length}.
643     */
644     function _at(Set storage set, uint256 index) private view returns (bytes32) {
645         require(set._values.length > index, "EnumerableSet: index out of bounds");
646         return set._values[index];
647     }
648 
649     // Bytes32Set
650 
651     struct Bytes32Set {
652         Set _inner;
653     }
654 
655     /**
656      * @dev Add a value to a set. O(1).
657      *
658      * Returns true if the value was added to the set, that is if it was not
659      * already present.
660      */
661     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
662         return _add(set._inner, value);
663     }
664 
665     /**
666      * @dev Removes a value from a set. O(1).
667      *
668      * Returns true if the value was removed from the set, that is if it was
669      * present.
670      */
671     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
672         return _remove(set._inner, value);
673     }
674 
675     /**
676      * @dev Returns true if the value is in the set. O(1).
677      */
678     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
679         return _contains(set._inner, value);
680     }
681 
682     /**
683      * @dev Returns the number of values in the set. O(1).
684      */
685     function length(Bytes32Set storage set) internal view returns (uint256) {
686         return _length(set._inner);
687     }
688 
689    /**
690     * @dev Returns the value stored at position `index` in the set. O(1).
691     *
692     * Note that there are no guarantees on the ordering of values inside the
693     * array, and it may change when more values are added or removed.
694     *
695     * Requirements:
696     *
697     * - `index` must be strictly less than {length}.
698     */
699     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
700         return _at(set._inner, index);
701     }
702 
703     // AddressSet
704 
705     struct AddressSet {
706         Set _inner;
707     }
708 
709     /**
710      * @dev Add a value to a set. O(1).
711      *
712      * Returns true if the value was added to the set, that is if it was not
713      * already present.
714      */
715     function add(AddressSet storage set, address value) internal returns (bool) {
716         return _add(set._inner, bytes32(uint256(uint160(value))));
717     }
718 
719     /**
720      * @dev Removes a value from a set. O(1).
721      *
722      * Returns true if the value was removed from the set, that is if it was
723      * present.
724      */
725     function remove(AddressSet storage set, address value) internal returns (bool) {
726         return _remove(set._inner, bytes32(uint256(uint160(value))));
727     }
728 
729     /**
730      * @dev Returns true if the value is in the set. O(1).
731      */
732     function contains(AddressSet storage set, address value) internal view returns (bool) {
733         return _contains(set._inner, bytes32(uint256(uint160(value))));
734     }
735 
736     /**
737      * @dev Returns the number of values in the set. O(1).
738      */
739     function length(AddressSet storage set) internal view returns (uint256) {
740         return _length(set._inner);
741     }
742 
743    /**
744     * @dev Returns the value stored at position `index` in the set. O(1).
745     *
746     * Note that there are no guarantees on the ordering of values inside the
747     * array, and it may change when more values are added or removed.
748     *
749     * Requirements:
750     *
751     * - `index` must be strictly less than {length}.
752     */
753     function at(AddressSet storage set, uint256 index) internal view returns (address) {
754         return address(uint160(uint256(_at(set._inner, index))));
755     }
756 
757 
758     // UintSet
759 
760     struct UintSet {
761         Set _inner;
762     }
763 
764     /**
765      * @dev Add a value to a set. O(1).
766      *
767      * Returns true if the value was added to the set, that is if it was not
768      * already present.
769      */
770     function add(UintSet storage set, uint256 value) internal returns (bool) {
771         return _add(set._inner, bytes32(value));
772     }
773 
774     /**
775      * @dev Removes a value from a set. O(1).
776      *
777      * Returns true if the value was removed from the set, that is if it was
778      * present.
779      */
780     function remove(UintSet storage set, uint256 value) internal returns (bool) {
781         return _remove(set._inner, bytes32(value));
782     }
783 
784     /**
785      * @dev Returns true if the value is in the set. O(1).
786      */
787     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
788         return _contains(set._inner, bytes32(value));
789     }
790 
791     /**
792      * @dev Returns the number of values on the set. O(1).
793      */
794     function length(UintSet storage set) internal view returns (uint256) {
795         return _length(set._inner);
796     }
797 
798    /**
799     * @dev Returns the value stored at position `index` in the set. O(1).
800     *
801     * Note that there are no guarantees on the ordering of values inside the
802     * array, and it may change when more values are added or removed.
803     *
804     * Requirements:
805     *
806     * - `index` must be strictly less than {length}.
807     */
808     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
809         return uint256(_at(set._inner, index));
810     }
811 }
812 
813 // File: contracts\token\NERA.sol
814 
815 
816 
817 pragma solidity ^0.8.0;
818 
819 
820 
821 
822 /**
823  * @title Interface for other's contracts use
824  * @dev This functions will be called by other's contracts
825  */
826 interface INERA {
827     /**
828      * @dev Mining for NERA tokens.
829      *
830      */
831     function mint(address to, uint256 amount) external returns (bool);
832 }
833 
834 
835 contract NERA is ERC20, Ownable, INERA {
836 
837     // community
838     uint256 private constant communitySupply    = 120000000 * 1e18;
839     
840     using EnumerableSet for EnumerableSet.AddressSet;
841     EnumerableSet.AddressSet private _minters;
842 
843     constructor() ERC20("NERA Token", "NERA")
844     {
845         _mint(msg.sender, communitySupply);
846     }
847     
848     /**
849      * @dev See {INERA-mint}. 
850      * Mining for NERA tokens.
851      */
852     function mint(address to, uint256 amount) 
853         public 
854         virtual
855         override
856         onlyMinter 
857         returns (bool) 
858     {
859         _mint(to, amount);
860         return true;
861     }
862 
863     function burn(uint256 amount) 
864         public 
865         onlyOwner
866         returns (bool)  
867     {
868         _burn(msg.sender, amount);
869         return true;
870     }
871 
872     function addMinter(address miner) 
873         public 
874         onlyOwner 
875         returns (bool)
876     {
877         require(miner != address(0), "NERA: miner is the zero address");
878         return _minters.add(miner);
879     }
880 
881     function delMinter(address _delMinter)
882         public
883         onlyOwner 
884         returns (bool)
885     {
886         require(_delMinter != address(0), "NERA: _delMinter is the zero address");
887         return _minters.remove(_delMinter);
888     }
889 
890     function getMinterLength() 
891         public 
892         view 
893         returns (uint256)
894     {
895         return _minters.length();
896     }
897 
898     function isMinter(address account)
899         public
900         view
901         returns (bool)
902     {
903         return _minters.contains(account);
904     }
905 
906     function getMinter(uint256 idx)
907         public
908         view
909         onlyOwner
910         returns (address)
911     {
912         require(idx < getMinterLength(), "NERA: index out of bounds");
913         return _minters.at(idx);
914     }
915 
916     modifier onlyMinter() 
917     {
918         require(isMinter(msg.sender), "NERA: caller is not the minter");
919         _;
920     }
921 }