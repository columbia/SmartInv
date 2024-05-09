1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // Sources flattened with hardhat v2.9.3 https://hardhat.org
3 
4 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 
118 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 
145 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
146 
147 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
165  * instead returning `false` on failure. This behavior is nonetheless
166  * conventional and does not conflict with the expectations of ERC20
167  * applications.
168  *
169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
170  * This allows applications to reconstruct the allowance for all accounts just
171  * by listening to said events. Other implementations of the EIP may not emit
172  * these events, as it isn't required by the specification.
173  *
174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
175  * functions have been added to mitigate the well-known issues around setting
176  * allowances. See {IERC20-approve}.
177  */
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 18;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `to` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address to, uint256 amount) public virtual override returns (bool) {
257         address owner = _msgSender();
258         _transfer(owner, to, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-allowance}.
264      */
265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
266         return _allowances[owner][spender];
267     }
268 
269     /**
270      * @dev See {IERC20-approve}.
271      *
272      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
273      * `transferFrom`. This is semantically equivalent to an infinite approval.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         address owner = _msgSender();
281         _approve(owner, spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * NOTE: Does not update the allowance if the current allowance
292      * is the maximum `uint256`.
293      *
294      * Requirements:
295      *
296      * - `from` and `to` cannot be the zero address.
297      * - `from` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``from``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         address spender = _msgSender();
307         _spendAllowance(from, spender, amount);
308         _transfer(from, to, amount);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         address owner = _msgSender();
326         _approve(owner, spender, _allowances[owner][spender] + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         address owner = _msgSender();
346         uint256 currentAllowance = _allowances[owner][spender];
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(owner, spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `sender` to `recipient`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {
374         require(from != address(0), "ERC20: transfer from the zero address");
375         require(to != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(from, to, amount);
378 
379         uint256 fromBalance = _balances[from];
380         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[from] = fromBalance - amount;
383         }
384         _balances[to] += amount;
385 
386         emit Transfer(from, to, amount);
387 
388         _afterTokenTransfer(from, to, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412     /**
413      * @dev Destroys `amount` tokens from `account`, reducing the
414      * total supply.
415      *
416      * Emits a {Transfer} event with `to` set to the zero address.
417      *
418      * Requirements:
419      *
420      * - `account` cannot be the zero address.
421      * - `account` must have at least `amount` tokens.
422      */
423     function _burn(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: burn from the zero address");
425 
426         _beforeTokenTransfer(account, address(0), amount);
427 
428         uint256 accountBalance = _balances[account];
429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
430         unchecked {
431             _balances[account] = accountBalance - amount;
432         }
433         _totalSupply -= amount;
434 
435         emit Transfer(account, address(0), amount);
436 
437         _afterTokenTransfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
442      *
443      * This internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
467      *
468      * Does not update the allowance amount in case of infinite allowance.
469      * Revert if not enough allowance is available.
470      *
471      * Might emit an {Approval} event.
472      */
473     function _spendAllowance(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         uint256 currentAllowance = allowance(owner, spender);
479         if (currentAllowance != type(uint256).max) {
480             require(currentAllowance >= amount, "ERC20: insufficient allowance");
481             unchecked {
482                 _approve(owner, spender, currentAllowance - amount);
483             }
484         }
485     }
486 
487     /**
488      * @dev Hook that is called before any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * will be transferred to `to`.
495      * - when `from` is zero, `amount` tokens will be minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _beforeTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 
507     /**
508      * @dev Hook that is called after any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * has been transferred to `to`.
515      * - when `from` is zero, `amount` tokens have been minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _afterTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 }
527 
528 
529 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.5.0
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Library for managing
537  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
538  * types.
539  *
540  * Sets have the following properties:
541  *
542  * - Elements are added, removed, and checked for existence in constant time
543  * (O(1)).
544  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
545  *
546  * ```
547  * contract Example {
548  *     // Add the library methods
549  *     using EnumerableSet for EnumerableSet.AddressSet;
550  *
551  *     // Declare a set state variable
552  *     EnumerableSet.AddressSet private mySet;
553  * }
554  * ```
555  *
556  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
557  * and `uint256` (`UintSet`) are supported.
558  */
559 library EnumerableSet {
560     // To implement this library for multiple types with as little code
561     // repetition as possible, we write it in terms of a generic Set type with
562     // bytes32 values.
563     // The Set implementation uses private functions, and user-facing
564     // implementations (such as AddressSet) are just wrappers around the
565     // underlying Set.
566     // This means that we can only create new EnumerableSets for types that fit
567     // in bytes32.
568 
569     struct Set {
570         // Storage of set values
571         bytes32[] _values;
572         // Position of the value in the `values` array, plus 1 because index 0
573         // means a value is not in the set.
574         mapping(bytes32 => uint256) _indexes;
575     }
576 
577     /**
578      * @dev Add a value to a set. O(1).
579      *
580      * Returns true if the value was added to the set, that is if it was not
581      * already present.
582      */
583     function _add(Set storage set, bytes32 value) private returns (bool) {
584         if (!_contains(set, value)) {
585             set._values.push(value);
586             // The value is stored at length-1, but we add 1 to all indexes
587             // and use 0 as a sentinel value
588             set._indexes[value] = set._values.length;
589             return true;
590         } else {
591             return false;
592         }
593     }
594 
595     /**
596      * @dev Removes a value from a set. O(1).
597      *
598      * Returns true if the value was removed from the set, that is if it was
599      * present.
600      */
601     function _remove(Set storage set, bytes32 value) private returns (bool) {
602         // We read and store the value's index to prevent multiple reads from the same storage slot
603         uint256 valueIndex = set._indexes[value];
604 
605         if (valueIndex != 0) {
606             // Equivalent to contains(set, value)
607             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
608             // the array, and then remove the last element (sometimes called as 'swap and pop').
609             // This modifies the order of the array, as noted in {at}.
610 
611             uint256 toDeleteIndex = valueIndex - 1;
612             uint256 lastIndex = set._values.length - 1;
613 
614             if (lastIndex != toDeleteIndex) {
615                 bytes32 lastvalue = set._values[lastIndex];
616 
617                 // Move the last value to the index where the value to delete is
618                 set._values[toDeleteIndex] = lastvalue;
619                 // Update the index for the moved value
620                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
621             }
622 
623             // Delete the slot where the moved value was stored
624             set._values.pop();
625 
626             // Delete the index for the deleted slot
627             delete set._indexes[value];
628 
629             return true;
630         } else {
631             return false;
632         }
633     }
634 
635     /**
636      * @dev Returns true if the value is in the set. O(1).
637      */
638     function _contains(Set storage set, bytes32 value) private view returns (bool) {
639         return set._indexes[value] != 0;
640     }
641 
642     /**
643      * @dev Returns the number of values on the set. O(1).
644      */
645     function _length(Set storage set) private view returns (uint256) {
646         return set._values.length;
647     }
648 
649     /**
650      * @dev Returns the value stored at position `index` in the set. O(1).
651      *
652      * Note that there are no guarantees on the ordering of values inside the
653      * array, and it may change when more values are added or removed.
654      *
655      * Requirements:
656      *
657      * - `index` must be strictly less than {length}.
658      */
659     function _at(Set storage set, uint256 index) private view returns (bytes32) {
660         return set._values[index];
661     }
662 
663     /**
664      * @dev Return the entire set in an array
665      *
666      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
667      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
668      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
669      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
670      */
671     function _values(Set storage set) private view returns (bytes32[] memory) {
672         return set._values;
673     }
674 
675     // Bytes32Set
676 
677     struct Bytes32Set {
678         Set _inner;
679     }
680 
681     /**
682      * @dev Add a value to a set. O(1).
683      *
684      * Returns true if the value was added to the set, that is if it was not
685      * already present.
686      */
687     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
688         return _add(set._inner, value);
689     }
690 
691     /**
692      * @dev Removes a value from a set. O(1).
693      *
694      * Returns true if the value was removed from the set, that is if it was
695      * present.
696      */
697     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
698         return _remove(set._inner, value);
699     }
700 
701     /**
702      * @dev Returns true if the value is in the set. O(1).
703      */
704     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
705         return _contains(set._inner, value);
706     }
707 
708     /**
709      * @dev Returns the number of values in the set. O(1).
710      */
711     function length(Bytes32Set storage set) internal view returns (uint256) {
712         return _length(set._inner);
713     }
714 
715     /**
716      * @dev Returns the value stored at position `index` in the set. O(1).
717      *
718      * Note that there are no guarantees on the ordering of values inside the
719      * array, and it may change when more values are added or removed.
720      *
721      * Requirements:
722      *
723      * - `index` must be strictly less than {length}.
724      */
725     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
726         return _at(set._inner, index);
727     }
728 
729     /**
730      * @dev Return the entire set in an array
731      *
732      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
733      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
734      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
735      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
736      */
737     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
738         return _values(set._inner);
739     }
740 
741     // AddressSet
742 
743     struct AddressSet {
744         Set _inner;
745     }
746 
747     /**
748      * @dev Add a value to a set. O(1).
749      *
750      * Returns true if the value was added to the set, that is if it was not
751      * already present.
752      */
753     function add(AddressSet storage set, address value) internal returns (bool) {
754         return _add(set._inner, bytes32(uint256(uint160(value))));
755     }
756 
757     /**
758      * @dev Removes a value from a set. O(1).
759      *
760      * Returns true if the value was removed from the set, that is if it was
761      * present.
762      */
763     function remove(AddressSet storage set, address value) internal returns (bool) {
764         return _remove(set._inner, bytes32(uint256(uint160(value))));
765     }
766 
767     /**
768      * @dev Returns true if the value is in the set. O(1).
769      */
770     function contains(AddressSet storage set, address value) internal view returns (bool) {
771         return _contains(set._inner, bytes32(uint256(uint160(value))));
772     }
773 
774     /**
775      * @dev Returns the number of values in the set. O(1).
776      */
777     function length(AddressSet storage set) internal view returns (uint256) {
778         return _length(set._inner);
779     }
780 
781     /**
782      * @dev Returns the value stored at position `index` in the set. O(1).
783      *
784      * Note that there are no guarantees on the ordering of values inside the
785      * array, and it may change when more values are added or removed.
786      *
787      * Requirements:
788      *
789      * - `index` must be strictly less than {length}.
790      */
791     function at(AddressSet storage set, uint256 index) internal view returns (address) {
792         return address(uint160(uint256(_at(set._inner, index))));
793     }
794 
795     /**
796      * @dev Return the entire set in an array
797      *
798      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
799      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
800      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
801      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
802      */
803     function values(AddressSet storage set) internal view returns (address[] memory) {
804         bytes32[] memory store = _values(set._inner);
805         address[] memory result;
806 
807         assembly {
808             result := store
809         }
810 
811         return result;
812     }
813 
814     // UintSet
815 
816     struct UintSet {
817         Set _inner;
818     }
819 
820     /**
821      * @dev Add a value to a set. O(1).
822      *
823      * Returns true if the value was added to the set, that is if it was not
824      * already present.
825      */
826     function add(UintSet storage set, uint256 value) internal returns (bool) {
827         return _add(set._inner, bytes32(value));
828     }
829 
830     /**
831      * @dev Removes a value from a set. O(1).
832      *
833      * Returns true if the value was removed from the set, that is if it was
834      * present.
835      */
836     function remove(UintSet storage set, uint256 value) internal returns (bool) {
837         return _remove(set._inner, bytes32(value));
838     }
839 
840     /**
841      * @dev Returns true if the value is in the set. O(1).
842      */
843     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
844         return _contains(set._inner, bytes32(value));
845     }
846 
847     /**
848      * @dev Returns the number of values on the set. O(1).
849      */
850     function length(UintSet storage set) internal view returns (uint256) {
851         return _length(set._inner);
852     }
853 
854     /**
855      * @dev Returns the value stored at position `index` in the set. O(1).
856      *
857      * Note that there are no guarantees on the ordering of values inside the
858      * array, and it may change when more values are added or removed.
859      *
860      * Requirements:
861      *
862      * - `index` must be strictly less than {length}.
863      */
864     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
865         return uint256(_at(set._inner, index));
866     }
867 
868     /**
869      * @dev Return the entire set in an array
870      *
871      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
872      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
873      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
874      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
875      */
876     function values(UintSet storage set) internal view returns (uint256[] memory) {
877         bytes32[] memory store = _values(set._inner);
878         uint256[] memory result;
879 
880         assembly {
881             result := store
882         }
883 
884         return result;
885     }
886 }
887 
888 
889 // File libraries/ScaledMath.sol
890 
891 pragma solidity ^0.8.13;
892 
893 library ScaledMath {
894     uint256 internal constant DECIMALS = 18;
895     uint256 internal constant ONE = 10**DECIMALS;
896 
897     function mulDown(uint256 a, uint256 b) internal pure returns (uint256) {
898         return (a * b) / ONE;
899     }
900 
901     function divDown(uint256 a, uint256 b) internal pure returns (uint256) {
902         return (a * ONE) / b;
903     }
904 }
905 
906 
907 // File interfaces/tokenomics/ICNCToken.sol
908 
909 pragma solidity ^0.8.13;
910 
911 interface ICNCToken is IERC20 {
912     event MinterAdded(address minter);
913     event MinterRemoved(address minter);
914     event InitialDistributionMinted(uint256 amount);
915     event AirdropMinted(uint256 amount);
916     event AMMRewardsMinted(uint256 amount);
917     event TreasuryRewardsMinted(uint256 amount);
918     event SeedShareMinted(uint256 amount);
919 
920     /// @notice mints the initial distribution amount to the distribution contract
921     function mintInitialDistribution(address distribution) external;
922 
923     /// @notice mints the airdrop amount to the airdrop contract
924     function mintAirdrop(address airdropHandler) external;
925 
926     /// @notice mints the amm rewards
927     function mintAMMRewards(address ammGauge) external;
928 
929     /// @notice mints `amount` to `account`
930     function mint(address account, uint256 amount) external returns (uint256);
931 
932     /// @notice returns a list of all authorized minters
933     function listMinters() external view returns (address[] memory);
934 
935     /// @notice returns the ratio of inflation already minted
936     function inflationMintedRatio() external view returns (uint256);
937 }
938 
939 
940 // File contracts/tokenomics/CNCToken.sol
941 
942 pragma solidity ^0.8.13;
943 
944 
945 
946 /// @notice the deployer will initially have minting rights
947 /// The process will be to premint `PRE_MINT_RATIO` of `MAX_TOTAL_SUPPLY`
948 /// to the initial distribution address, grant the minting rights to the inflation manager
949 /// and renounce its minting rights
950 contract CNCToken is ICNCToken, ERC20 {
951     using EnumerableSet for EnumerableSet.AddressSet;
952     using ScaledMath for uint256;
953 
954     uint256 public constant PRE_MINT_RATIO = 0.3e18;
955     uint256 public constant AIRDROP_MINT_RATIO = 0.1e18;
956     uint256 public constant AMM_REWARDS_RATIO = 0.1e18;
957     uint256 public constant TREASURY_REWARDS_RATIO = 0.05e18;
958     uint256 public constant TREASURY_SEED_RATIO = 0.01e18;
959     uint256 public constant INFLATION_RATIO =
960         1e18 -
961             AMM_REWARDS_RATIO -
962             AIRDROP_MINT_RATIO -
963             PRE_MINT_RATIO -
964             TREASURY_REWARDS_RATIO -
965             TREASURY_SEED_RATIO;
966     uint256 public constant MAX_TOTAL_SUPPLY = 10_000_000e18;
967 
968     EnumerableSet.AddressSet internal authorizedMinters;
969 
970     bool public initialDistributionMintDone;
971     bool public airdropMintDone;
972     bool public ammGaugeMintDone;
973     bool public treasuryMintDone;
974     bool public seedShareMintDone;
975 
976     modifier onlyMinter() {
977         require(authorizedMinters.contains(msg.sender), "not authorized");
978         _;
979     }
980 
981     constructor() ERC20("Conic Finance Token", "CNC") {
982         authorizedMinters.add(msg.sender);
983         emit MinterAdded(msg.sender);
984     }
985 
986     function addMinter(address newMinter) external onlyMinter {
987         if (authorizedMinters.add(newMinter)) {
988             emit MinterAdded(newMinter);
989         }
990     }
991 
992     function renounceMinterRights() external onlyMinter {
993         authorizedMinters.remove(msg.sender);
994         emit MinterRemoved(msg.sender);
995     }
996 
997     function mintInitialDistribution(address distribution) external onlyMinter {
998         require(!initialDistributionMintDone, "premint already done");
999         uint256 mintAmount = MAX_TOTAL_SUPPLY.mulDown(PRE_MINT_RATIO);
1000         _mint(distribution, mintAmount);
1001         initialDistributionMintDone = true;
1002         emit InitialDistributionMinted(mintAmount);
1003     }
1004 
1005     function mintAirdrop(address airdropHandler) external onlyMinter {
1006         require(!airdropMintDone, "airdrop already done");
1007         uint256 mintAmount = MAX_TOTAL_SUPPLY.mulDown(AIRDROP_MINT_RATIO);
1008         _mint(airdropHandler, mintAmount);
1009         airdropMintDone = true;
1010         emit AirdropMinted(mintAmount);
1011     }
1012 
1013     function mintAMMRewards(address ammGauge) external onlyMinter {
1014         require(!ammGaugeMintDone, "amm rewards already minted");
1015         uint256 mintAmount = MAX_TOTAL_SUPPLY.mulDown(AMM_REWARDS_RATIO);
1016         _mint(ammGauge, mintAmount);
1017         ammGaugeMintDone = true;
1018         emit AMMRewardsMinted(mintAmount);
1019     }
1020 
1021     function mintTreasuryShare(address treasuryEscrow) external onlyMinter {
1022         require(!treasuryMintDone, "treasury rewards already minted");
1023         uint256 mintAmount = MAX_TOTAL_SUPPLY.mulDown(TREASURY_REWARDS_RATIO);
1024         _mint(treasuryEscrow, mintAmount);
1025         treasuryMintDone = true;
1026         emit TreasuryRewardsMinted(mintAmount);
1027     }
1028 
1029     function mintSeedShare(address treasury) external onlyMinter {
1030         require(!seedShareMintDone, "seed share already minted");
1031         uint256 mintAmount = MAX_TOTAL_SUPPLY.mulDown(TREASURY_SEED_RATIO);
1032         _mint(treasury, mintAmount);
1033         seedShareMintDone = true;
1034         emit SeedShareMinted(mintAmount);
1035     }
1036 
1037     function mint(address account, uint256 amount) external onlyMinter returns (uint256) {
1038         uint256 currentSupply = totalSupply();
1039         if (amount + currentSupply > MAX_TOTAL_SUPPLY) {
1040             amount = MAX_TOTAL_SUPPLY - currentSupply;
1041         }
1042         if (amount > 0) {
1043             _mint(account, amount);
1044         }
1045         return amount;
1046     }
1047 
1048     /// @dev this assumes that all the pre-mint events occured
1049     function inflationMintedRatio() external view returns (uint256) {
1050         uint256 currentSupply = totalSupply();
1051         uint256 totalToMint = MAX_TOTAL_SUPPLY.mulDown(INFLATION_RATIO);
1052         uint256 totalPreMinted = MAX_TOTAL_SUPPLY - totalToMint;
1053         uint256 totalInflationMinted = currentSupply - totalPreMinted;
1054         return totalInflationMinted.divDown(totalToMint);
1055     }
1056 
1057     function listMinters() external view returns (address[] memory) {
1058         return authorizedMinters.values();
1059     }
1060 }