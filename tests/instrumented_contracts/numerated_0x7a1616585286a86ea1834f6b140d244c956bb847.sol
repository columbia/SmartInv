1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface for the optional metadata functions from the ERC20 standard.
109  *
110  * _Available since v4.1._
111  */
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the symbol of the token.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the decimals places of the token.
125      */
126     function decimals() external view returns (uint8);
127 }
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Implementation of the {IERC20} interface.
133  *
134  * This implementation is agnostic to the way tokens are created. This means
135  * that a supply mechanism has to be added in a derived contract using {_mint}.
136  * For a generic mechanism see {ERC20PresetMinterPauser}.
137  *
138  * TIP: For a detailed writeup see our guide
139  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
140  * to implement supply mechanisms].
141  *
142  * We have followed general OpenZeppelin Contracts guidelines: functions revert
143  * instead returning `false` on failure. This behavior is nonetheless
144  * conventional and does not conflict with the expectations of ERC20
145  * applications.
146  *
147  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
148  * This allows applications to reconstruct the allowance for all accounts just
149  * by listening to said events. Other implementations of the EIP may not emit
150  * these events, as it isn't required by the specification.
151  *
152  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
153  * functions have been added to mitigate the well-known issues around setting
154  * allowances. See {IERC20-approve}.
155  */
156 contract ERC20 is Context, IERC20, IERC20Metadata {
157     mapping(address => uint256) private _balances;
158 
159     mapping(address => mapping(address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162 
163     string private _name;
164     string private _symbol;
165 
166     /**
167      * @dev Sets the values for {name} and {symbol}.
168      *
169      * The default value of {decimals} is 18. To select a different value for
170      * {decimals} you should overload it.
171      *
172      * All two of these values are immutable: they can only be set once during
173      * construction.
174      */
175     constructor(string memory name_, string memory symbol_) {
176         _name = name_;
177         _symbol = symbol_;
178     }
179 
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() public view virtual override returns (string memory) {
184         return _name;
185     }
186 
187     /**
188      * @dev Returns the symbol of the token, usually a shorter version of the
189      * name.
190      */
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     /**
196      * @dev Returns the number of decimals used to get its user representation.
197      * For example, if `decimals` equals `2`, a balance of `505` tokens should
198      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
199      *
200      * Tokens usually opt for a value of 18, imitating the relationship between
201      * Ether and Wei. This is the value {ERC20} uses, unless this function is
202      * overridden;
203      *
204      * NOTE: This information is only used for _display_ purposes: it in
205      * no way affects any of the arithmetic of the contract, including
206      * {IERC20-balanceOf} and {IERC20-transfer}.
207      */
208     function decimals() public view virtual override returns (uint8) {
209         return 18;
210     }
211 
212     /**
213      * @dev See {IERC20-totalSupply}.
214      */
215     function totalSupply() public view virtual override returns (uint256) {
216         return _totalSupply;
217     }
218 
219     /**
220      * @dev See {IERC20-balanceOf}.
221      */
222     function balanceOf(address account) public view virtual override returns (uint256) {
223         return _balances[account];
224     }
225 
226     /**
227      * @dev See {IERC20-transfer}.
228      *
229      * Requirements:
230      *
231      * - `recipient` cannot be the zero address.
232      * - the caller must have a balance of at least `amount`.
233      */
234     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-allowance}.
241      */
242     function allowance(address owner, address spender) public view virtual override returns (uint256) {
243         return _allowances[owner][spender];
244     }
245 
246     /**
247      * @dev See {IERC20-approve}.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      */
253     function approve(address spender, uint256 amount) public virtual override returns (bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-transferFrom}.
260      *
261      * Emits an {Approval} event indicating the updated allowance. This is not
262      * required by the EIP. See the note at the beginning of {ERC20}.
263      *
264      * Requirements:
265      *
266      * - `sender` and `recipient` cannot be the zero address.
267      * - `sender` must have a balance of at least `amount`.
268      * - the caller must have allowance for ``sender``'s tokens of at least
269      * `amount`.
270      */
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public virtual override returns (bool) {
276         _transfer(sender, recipient, amount);
277 
278         uint256 currentAllowance = _allowances[sender][_msgSender()];
279         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
280     unchecked {
281         _approve(sender, _msgSender(), currentAllowance - amount);
282     }
283 
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         uint256 currentAllowance = _allowances[_msgSender()][spender];
320         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
321     unchecked {
322         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
323     }
324 
325         return true;
326     }
327 
328     /**
329      * @dev Moves `amount` of tokens from `sender` to `recipient`.
330      *
331      * This internal function is equivalent to {transfer}, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a {Transfer} event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(
343         address sender,
344         address recipient,
345         uint256 amount
346     ) internal virtual {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(sender, recipient, amount);
351 
352         uint256 senderBalance = _balances[sender];
353         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
354     unchecked {
355         _balances[sender] = senderBalance - amount;
356     }
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360 
361         _afterTokenTransfer(sender, recipient, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `account` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal virtual {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _beforeTokenTransfer(address(0), account, amount);
377 
378         _totalSupply += amount;
379         _balances[account] += amount;
380         emit Transfer(address(0), account, amount);
381 
382         _afterTokenTransfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398 
399         _beforeTokenTransfer(account, address(0), amount);
400 
401         uint256 accountBalance = _balances[account];
402         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
403     unchecked {
404         _balances[account] = accountBalance - amount;
405     }
406         _totalSupply -= amount;
407 
408         emit Transfer(account, address(0), amount);
409 
410         _afterTokenTransfer(account, address(0), amount);
411     }
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 
458     /**
459      * @dev Hook that is called after any transfer of tokens. This includes
460      * minting and burning.
461      *
462      * Calling conditions:
463      *
464      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
465      * has been transferred to `to`.
466      * - when `from` is zero, `amount` tokens have been minted for `to`.
467      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
468      * - `from` and `to` are never both zero.
469      *
470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
471      */
472     function _afterTokenTransfer(
473         address from,
474         address to,
475         uint256 amount
476     ) internal virtual {}
477 }
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * By default, the owner account will be the one that deploys the contract. This
487  * can later be changed with {transferOwnership}.
488  *
489  * This module is used through inheritance. It will make available the modifier
490  * `onlyOwner`, which can be applied to your functions to restrict their use to
491  * the owner.
492  */
493 abstract contract Ownable is Context {
494     address private _owner;
495 
496     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
497 
498     /**
499      * @dev Initializes the contract setting the deployer as the initial owner.
500      */
501     constructor() {
502         _setOwner(_msgSender());
503     }
504 
505     /**
506      * @dev Returns the address of the current owner.
507      */
508     function owner() public view virtual returns (address) {
509         return _owner;
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         require(owner() == _msgSender(), "Ownable: caller is not the owner");
517         _;
518     }
519 
520     /**
521      * @dev Leaves the contract without owner. It will not be possible to call
522      * `onlyOwner` functions anymore. Can only be called by the current owner.
523      *
524      * NOTE: Renouncing ownership will leave the contract without an owner,
525      * thereby removing any functionality that is only available to the owner.
526      */
527     function renounceOwnership() public virtual onlyOwner {
528         _setOwner(address(0));
529     }
530 
531     /**
532      * @dev Transfers ownership of the contract to a new account (`newOwner`).
533      * Can only be called by the current owner.
534      */
535     function transferOwnership(address newOwner) public virtual onlyOwner {
536         require(newOwner != address(0), "Ownable: new owner is the zero address");
537         _setOwner(newOwner);
538     }
539 
540     function _setOwner(address newOwner) private {
541         address oldOwner = _owner;
542         _owner = newOwner;
543         emit OwnershipTransferred(oldOwner, newOwner);
544     }
545 }
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @dev Contract module that helps prevent reentrant calls to a function.
551  *
552  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
553  * available, which can be applied to functions to make sure there are no nested
554  * (reentrant) calls to them.
555  *
556  * Note that because there is a single `nonReentrant` guard, functions marked as
557  * `nonReentrant` may not call one another. This can be worked around by making
558  * those functions `private`, and then adding `external` `nonReentrant` entry
559  * points to them.
560  *
561  * TIP: If you would like to learn more about reentrancy and alternative ways
562  * to protect against it, check out our blog post
563  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
564  */
565 abstract contract ReentrancyGuard {
566     // Booleans are more expensive than uint256 or any type that takes up a full
567     // word because each write operation emits an extra SLOAD to first read the
568     // slot's contents, replace the bits taken up by the boolean, and then write
569     // back. This is the compiler's defense against contract upgrades and
570     // pointer aliasing, and it cannot be disabled.
571 
572     // The values being non-zero value makes deployment a bit more expensive,
573     // but in exchange the refund on every call to nonReentrant will be lower in
574     // amount. Since refunds are capped to a percentage of the total
575     // transaction's gas, it is best to keep them low in cases like this one, to
576     // increase the likelihood of the full refund coming into effect.
577     uint256 private constant _NOT_ENTERED = 1;
578     uint256 private constant _ENTERED = 2;
579 
580     uint256 private _status;
581 
582     constructor() {
583         _status = _NOT_ENTERED;
584     }
585 
586     /**
587      * @dev Prevents a contract from calling itself, directly or indirectly.
588      * Calling a `nonReentrant` function from another `nonReentrant`
589      * function is not supported. It is possible to prevent this from happening
590      * by making the `nonReentrant` function external, and make it call a
591      * `private` function that does the actual work.
592      */
593     modifier nonReentrant() {
594         // On the first call to nonReentrant, _notEntered will be true
595         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
596 
597         // Any calls to nonReentrant after this point will fail
598         _status = _ENTERED;
599 
600         _;
601 
602         // By storing the original value once again, a refund is triggered (see
603         // https://eips.ethereum.org/EIPS/eip-2200)
604         _status = _NOT_ENTERED;
605     }
606 }
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Library for managing
612  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
613  * types.
614  *
615  * Sets have the following properties:
616  *
617  * - Elements are added, removed, and checked for existence in constant time
618  * (O(1)).
619  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
620  *
621  * ```
622  * contract Example {
623  *     // Add the library methods
624  *     using EnumerableSet for EnumerableSet.AddressSet;
625  *
626  *     // Declare a set state variable
627  *     EnumerableSet.AddressSet private mySet;
628  * }
629  * ```
630  *
631  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
632  * and `uint256` (`UintSet`) are supported.
633  */
634 library EnumerableSet {
635     // To implement this library for multiple types with as little code
636     // repetition as possible, we write it in terms of a generic Set type with
637     // bytes32 values.
638     // The Set implementation uses private functions, and user-facing
639     // implementations (such as AddressSet) are just wrappers around the
640     // underlying Set.
641     // This means that we can only create new EnumerableSets for types that fit
642     // in bytes32.
643 
644     struct Set {
645         // Storage of set values
646         bytes32[] _values;
647         // Position of the value in the `values` array, plus 1 because index 0
648         // means a value is not in the set.
649         mapping(bytes32 => uint256) _indexes;
650     }
651 
652     /**
653      * @dev Add a value to a set. O(1).
654      *
655      * Returns true if the value was added to the set, that is if it was not
656      * already present.
657      */
658     function _add(Set storage set, bytes32 value) private returns (bool) {
659         if (!_contains(set, value)) {
660             set._values.push(value);
661             // The value is stored at length-1, but we add 1 to all indexes
662             // and use 0 as a sentinel value
663             set._indexes[value] = set._values.length;
664             return true;
665         } else {
666             return false;
667         }
668     }
669 
670     /**
671      * @dev Removes a value from a set. O(1).
672      *
673      * Returns true if the value was removed from the set, that is if it was
674      * present.
675      */
676     function _remove(Set storage set, bytes32 value) private returns (bool) {
677         // We read and store the value's index to prevent multiple reads from the same storage slot
678         uint256 valueIndex = set._indexes[value];
679 
680         if (valueIndex != 0) {
681             // Equivalent to contains(set, value)
682             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
683             // the array, and then remove the last element (sometimes called as 'swap and pop').
684             // This modifies the order of the array, as noted in {at}.
685 
686             uint256 toDeleteIndex = valueIndex - 1;
687             uint256 lastIndex = set._values.length - 1;
688 
689             if (lastIndex != toDeleteIndex) {
690                 bytes32 lastvalue = set._values[lastIndex];
691 
692                 // Move the last value to the index where the value to delete is
693                 set._values[toDeleteIndex] = lastvalue;
694                 // Update the index for the moved value
695                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
696             }
697 
698             // Delete the slot where the moved value was stored
699             set._values.pop();
700 
701             // Delete the index for the deleted slot
702             delete set._indexes[value];
703 
704             return true;
705         } else {
706             return false;
707         }
708     }
709 
710     /**
711      * @dev Returns true if the value is in the set. O(1).
712      */
713     function _contains(Set storage set, bytes32 value) private view returns (bool) {
714         return set._indexes[value] != 0;
715     }
716 
717     /**
718      * @dev Returns the number of values on the set. O(1).
719      */
720     function _length(Set storage set) private view returns (uint256) {
721         return set._values.length;
722     }
723 
724     /**
725      * @dev Returns the value stored at position `index` in the set. O(1).
726      *
727      * Note that there are no guarantees on the ordering of values inside the
728      * array, and it may change when more values are added or removed.
729      *
730      * Requirements:
731      *
732      * - `index` must be strictly less than {length}.
733      */
734     function _at(Set storage set, uint256 index) private view returns (bytes32) {
735         return set._values[index];
736     }
737 
738     /**
739      * @dev Return the entire set in an array
740      *
741      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
742      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
743      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
744      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
745      */
746     function _values(Set storage set) private view returns (bytes32[] memory) {
747         return set._values;
748     }
749 
750     // Bytes32Set
751 
752     struct Bytes32Set {
753         Set _inner;
754     }
755 
756     /**
757      * @dev Add a value to a set. O(1).
758      *
759      * Returns true if the value was added to the set, that is if it was not
760      * already present.
761      */
762     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
763         return _add(set._inner, value);
764     }
765 
766     /**
767      * @dev Removes a value from a set. O(1).
768      *
769      * Returns true if the value was removed from the set, that is if it was
770      * present.
771      */
772     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
773         return _remove(set._inner, value);
774     }
775 
776     /**
777      * @dev Returns true if the value is in the set. O(1).
778      */
779     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
780         return _contains(set._inner, value);
781     }
782 
783     /**
784      * @dev Returns the number of values in the set. O(1).
785      */
786     function length(Bytes32Set storage set) internal view returns (uint256) {
787         return _length(set._inner);
788     }
789 
790     /**
791      * @dev Returns the value stored at position `index` in the set. O(1).
792      *
793      * Note that there are no guarantees on the ordering of values inside the
794      * array, and it may change when more values are added or removed.
795      *
796      * Requirements:
797      *
798      * - `index` must be strictly less than {length}.
799      */
800     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
801         return _at(set._inner, index);
802     }
803 
804     /**
805      * @dev Return the entire set in an array
806      *
807      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
808      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
809      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
810      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
811      */
812     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
813         return _values(set._inner);
814     }
815 
816     // AddressSet
817 
818     struct AddressSet {
819         Set _inner;
820     }
821 
822     /**
823      * @dev Add a value to a set. O(1).
824      *
825      * Returns true if the value was added to the set, that is if it was not
826      * already present.
827      */
828     function add(AddressSet storage set, address value) internal returns (bool) {
829         return _add(set._inner, bytes32(uint256(uint160(value))));
830     }
831 
832     /**
833      * @dev Removes a value from a set. O(1).
834      *
835      * Returns true if the value was removed from the set, that is if it was
836      * present.
837      */
838     function remove(AddressSet storage set, address value) internal returns (bool) {
839         return _remove(set._inner, bytes32(uint256(uint160(value))));
840     }
841 
842     /**
843      * @dev Returns true if the value is in the set. O(1).
844      */
845     function contains(AddressSet storage set, address value) internal view returns (bool) {
846         return _contains(set._inner, bytes32(uint256(uint160(value))));
847     }
848 
849     /**
850      * @dev Returns the number of values in the set. O(1).
851      */
852     function length(AddressSet storage set) internal view returns (uint256) {
853         return _length(set._inner);
854     }
855 
856     /**
857      * @dev Returns the value stored at position `index` in the set. O(1).
858      *
859      * Note that there are no guarantees on the ordering of values inside the
860      * array, and it may change when more values are added or removed.
861      *
862      * Requirements:
863      *
864      * - `index` must be strictly less than {length}.
865      */
866     function at(AddressSet storage set, uint256 index) internal view returns (address) {
867         return address(uint160(uint256(_at(set._inner, index))));
868     }
869 
870     /**
871      * @dev Return the entire set in an array
872      *
873      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
874      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
875      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
876      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
877      */
878     function values(AddressSet storage set) internal view returns (address[] memory) {
879         bytes32[] memory store = _values(set._inner);
880         address[] memory result;
881 
882         assembly {
883             result := store
884         }
885 
886         return result;
887     }
888 
889     // UintSet
890 
891     struct UintSet {
892         Set _inner;
893     }
894 
895     /**
896      * @dev Add a value to a set. O(1).
897      *
898      * Returns true if the value was added to the set, that is if it was not
899      * already present.
900      */
901     function add(UintSet storage set, uint256 value) internal returns (bool) {
902         return _add(set._inner, bytes32(value));
903     }
904 
905     /**
906      * @dev Removes a value from a set. O(1).
907      *
908      * Returns true if the value was removed from the set, that is if it was
909      * present.
910      */
911     function remove(UintSet storage set, uint256 value) internal returns (bool) {
912         return _remove(set._inner, bytes32(value));
913     }
914 
915     /**
916      * @dev Returns true if the value is in the set. O(1).
917      */
918     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
919         return _contains(set._inner, bytes32(value));
920     }
921 
922     /**
923      * @dev Returns the number of values on the set. O(1).
924      */
925     function length(UintSet storage set) internal view returns (uint256) {
926         return _length(set._inner);
927     }
928 
929     /**
930      * @dev Returns the value stored at position `index` in the set. O(1).
931      *
932      * Note that there are no guarantees on the ordering of values inside the
933      * array, and it may change when more values are added or removed.
934      *
935      * Requirements:
936      *
937      * - `index` must be strictly less than {length}.
938      */
939     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
940         return uint256(_at(set._inner, index));
941     }
942 
943     /**
944      * @dev Return the entire set in an array
945      *
946      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
947      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
948      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
949      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
950      */
951     function values(UintSet storage set) internal view returns (uint256[] memory) {
952         bytes32[] memory store = _values(set._inner);
953         uint256[] memory result;
954 
955         assembly {
956             result := store
957         }
958 
959         return result;
960     }
961 }
962 
963 pragma solidity ^0.8.0;
964 
965 /**
966  * @title ERC721 token receiver interface
967  * @dev Interface for any contract that wants to support safeTransfers
968  * from ERC721 asset contracts.
969  */
970 interface IERC721Receiver {
971     /**
972      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
973      * by `operator` from `from`, this function is called.
974      *
975      * It must return its Solidity selector to confirm the token transfer.
976      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
977      *
978      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
979      */
980     function onERC721Received(
981         address operator,
982         address from,
983         uint256 tokenId,
984         bytes calldata data
985     ) external returns (bytes4);
986 }
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @dev Interface of the ERC165 standard, as defined in the
992  * https://eips.ethereum.org/EIPS/eip-165[EIP].
993  *
994  * Implementers can declare support of contract interfaces, which can then be
995  * queried by others ({ERC165Checker}).
996  *
997  * For an implementation, see {ERC165}.
998  */
999 interface IERC165 {
1000     /**
1001      * @dev Returns true if this contract implements the interface defined by
1002      * `interfaceId`. See the corresponding
1003      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1004      * to learn more about how these ids are created.
1005      *
1006      * This function call must use less than 30 000 gas.
1007      */
1008     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1009 }
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 /**
1014  * @dev Required interface of an ERC721 compliant contract.
1015  */
1016 interface IERC721 is IERC165 {
1017     /**
1018      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1019      */
1020     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1021 
1022     /**
1023      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1024      */
1025     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1026 
1027     /**
1028      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1029      */
1030     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1031 
1032     /**
1033      * @dev Returns the number of tokens in ``owner``'s account.
1034      */
1035     function balanceOf(address owner) external view returns (uint256 balance);
1036 
1037     /**
1038      * @dev Returns the owner of the `tokenId` token.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      */
1044     function ownerOf(uint256 tokenId) external view returns (address owner);
1045 
1046     /**
1047      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1048      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1049      *
1050      * Requirements:
1051      *
1052      * - `from` cannot be the zero address.
1053      * - `to` cannot be the zero address.
1054      * - `tokenId` token must exist and be owned by `from`.
1055      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) external;
1065 
1066     /**
1067      * @dev Transfers `tokenId` token from `from` to `to`.
1068      *
1069      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1070      *
1071      * Requirements:
1072      *
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function transferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) external;
1085 
1086     /**
1087      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1088      * The approval is cleared when the token is transferred.
1089      *
1090      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1091      *
1092      * Requirements:
1093      *
1094      * - The caller must own the token or be an approved operator.
1095      * - `tokenId` must exist.
1096      *
1097      * Emits an {Approval} event.
1098      */
1099     function approve(address to, uint256 tokenId) external;
1100 
1101     /**
1102      * @dev Returns the account approved for `tokenId` token.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must exist.
1107      */
1108     function getApproved(uint256 tokenId) external view returns (address operator);
1109 
1110     /**
1111      * @dev Approve or remove `operator` as an operator for the caller.
1112      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1113      *
1114      * Requirements:
1115      *
1116      * - The `operator` cannot be the caller.
1117      *
1118      * Emits an {ApprovalForAll} event.
1119      */
1120     function setApprovalForAll(address operator, bool _approved) external;
1121 
1122     /**
1123      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1124      *
1125      * See {setApprovalForAll}
1126      */
1127     function isApprovedForAll(address owner, address operator) external view returns (bool);
1128 
1129     /**
1130      * @dev Safely transfers `tokenId` token from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `from` cannot be the zero address.
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must exist and be owned by `from`.
1137      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes calldata data
1147     ) external;
1148 }
1149 
1150 pragma solidity ^0.8.10;
1151 
1152 interface IProducer {
1153     function balanceOf(address _user) external view returns(uint256);
1154     function ownerOf(uint256 _tokenId) external view returns(address);
1155     function totalSupply() external view returns (uint256);
1156 }
1157 
1158 contract BonesYield is Ownable, ReentrancyGuard, IERC721Receiver {
1159     using EnumerableSet for EnumerableSet.UintSet;
1160 
1161     struct ContractSettings {
1162         bool isLocked;
1163         uint256 baseRate;
1164         uint256 start;
1165         uint256 end;
1166     }
1167 
1168     event RewardPaid(address indexed user, uint256 reward);
1169 
1170     address public stakingContractAddress;
1171     address public ERC20ContractAddress;
1172     uint256 stakingExpirationDate;
1173 
1174     uint256 constant CARDS_BOOSTER = 2;
1175     uint256 constant CARDS_REQUIRED_FOR_BOOST = 3;
1176 
1177 
1178     mapping(address => ContractSettings) public contractSettings;
1179     mapping(address => bool) public trustedContracts;
1180     mapping(bytes32 => uint256) public lastClaim;
1181 
1182 
1183     // mappings
1184     mapping(address => EnumerableSet.UintSet) private _deposits;
1185 
1186     // Prevents new contracts from being added or changes to disbursement if permanently locked
1187     bool public isClaimActive = false;
1188     bool public isStakingActive = false;
1189 
1190     constructor(address _stakingContractAddress, address _ERC20ContractAddress) {
1191         stakingContractAddress = _stakingContractAddress;
1192         ERC20ContractAddress = _ERC20ContractAddress;
1193     }
1194 
1195     function addContractConfig(
1196         address _address,
1197         uint256 _baseRate,
1198         uint256 _end
1199     ) external onlyOwner {
1200         trustedContracts[_address] = true;
1201         contractSettings[_address] = ContractSettings({
1202             isLocked: true,
1203             baseRate: _baseRate,
1204             start: block.timestamp,
1205             end: _end
1206         });
1207     }
1208 
1209 
1210     function setStakingContractAddress(address _contractAddress) external onlyOwner {
1211         stakingContractAddress = _contractAddress;
1212     }
1213 
1214     function setERC20ContractAddress(address _contractAddress) external onlyOwner {
1215         ERC20ContractAddress = _contractAddress;
1216     }
1217 
1218     function toggleClaim() external onlyOwner {
1219         isClaimActive = !isClaimActive;
1220     }
1221 
1222     function toggleStaking() external onlyOwner {
1223         isStakingActive = !isStakingActive;
1224     }
1225 
1226     function startYielding() external onlyOwner {
1227         isStakingActive = true;
1228         isClaimActive = true;
1229     }
1230 
1231     function toggleContractYielding(address _contractAddress) public onlyOwner {
1232         require(trustedContracts[_contractAddress], "Contract is not trusted");
1233         contractSettings[_contractAddress].isLocked = !contractSettings[_contractAddress].isLocked;
1234     }
1235 
1236     /**
1237         - sets an end date for when rewards officially end
1238      */
1239     function setEndDateForContract(address _contractAddress, uint256 _endTime) public onlyOwner {
1240         require(trustedContracts[_contractAddress], "The contract is not trusted");
1241         contractSettings[_contractAddress].end = _endTime;
1242     }
1243 
1244 
1245     function setRateForContract(address _contractAddress, uint256 _rate) public onlyOwner {
1246         require(trustedContracts[_contractAddress], "The contract is not trusted");
1247         contractSettings[_contractAddress].baseRate = _rate;
1248     }
1249 
1250     function claimRewards(address _contractAddress, uint256[] calldata _tokenIds) public returns (uint256) {
1251         require(isClaimActive, "Claim is active");
1252         require(trustedContracts[_contractAddress], "The contract address is not trusted");
1253         require(contractSettings[_contractAddress].end > block.timestamp, "Time for claiming has expired");
1254         uint256 totalUnclaimedRewards = 0;
1255 
1256         for(uint256 i = 0; i < _tokenIds.length; i++) {
1257             uint256 _tokenId = _tokenIds[i];
1258 
1259             require(IProducer(_contractAddress).ownerOf(_tokenId) == msg.sender, "Caller does not own the token being claimed for.");
1260 
1261             uint256 unclaimedReward = computeUnclaimedReward(_contractAddress, _tokenId);
1262             totalUnclaimedRewards += unclaimedReward;
1263 
1264             bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
1265             lastClaim[lastClaimKey] = block.timestamp;
1266         }
1267 
1268         IERC20(ERC20ContractAddress).transfer(msg.sender, totalUnclaimedRewards);
1269 
1270         emit RewardPaid(msg.sender, totalUnclaimedRewards);
1271 
1272         return totalUnclaimedRewards;
1273     }
1274 
1275     function getUnclaimedRewardsAmount(address contractAddress, uint256[] calldata _tokenIds) public view returns (uint256) {
1276 
1277         uint256 totalUnclaimedRewards = 0;
1278 
1279         for(uint256 i = 0; i < _tokenIds.length; i++) {
1280             totalUnclaimedRewards += computeUnclaimedReward(contractAddress, _tokenIds[i]);
1281         }
1282 
1283         return totalUnclaimedRewards;
1284     }
1285 
1286 
1287     function computeUnclaimedReward(address _contractAddress, uint256 _tokenId) internal view returns (uint256) {
1288         bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
1289         uint256 lastClaimDate = lastClaim[lastClaimKey];
1290         uint256 baseRate = contractSettings[_contractAddress].baseRate;
1291 
1292         // if there has been a lastClaim, compute the value since lastClaim
1293         if (lastClaimDate != uint256(0)) {
1294 
1295             return computeAccumulatedReward(lastClaimDate, baseRate);
1296         } else {
1297             uint256 totalReward = computeAccumulatedReward(contractSettings[_contractAddress].start, baseRate);
1298 
1299             return totalReward;
1300         }
1301     }
1302 
1303     function getLastClaimedTime(address _contractAddress, uint256 _tokenId) public view returns (uint256) {
1304         require(trustedContracts[_contractAddress], "The contract address is not trusted");
1305 
1306         bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
1307 
1308         return lastClaim[lastClaimKey];
1309     }
1310 
1311     function computeAccumulatedReward(uint256 _lastClaimDate, uint256 _baseRate) internal view returns (uint256) {
1312         require(block.timestamp > _lastClaimDate, "Last claim date must be smaller than block timestamp");
1313 
1314         uint256 secondsElapsed = block.timestamp - _lastClaimDate;
1315         uint256 accumulatedReward = secondsElapsed * _baseRate / 1 days;
1316 
1317         uint256 multiplier = getMultiplier(msg.sender);
1318 
1319         return accumulatedReward * multiplier;
1320     }
1321 
1322     // STAKING
1323 
1324     function setExpiration(uint256 _expiration) public onlyOwner {
1325         require(!isStakingActive, "Staking is not active");
1326         stakingExpirationDate = _expiration;
1327     }
1328 
1329     //check deposit amount.
1330     function depositsOf(address _account) external view returns (uint256[] memory) {
1331         require(isStakingActive, "Staking is not active");
1332 
1333         EnumerableSet.UintSet storage depositSet = _deposits[_account];
1334         uint256[] memory tokenIds = new uint256[] (depositSet.length());
1335 
1336         for (uint256 i; i < depositSet.length(); i++) {
1337             tokenIds[i] = depositSet.at(i);
1338         }
1339 
1340         return tokenIds;
1341     }
1342 
1343     function countDepositsOf(address _account) public view returns (uint256) {
1344         EnumerableSet.UintSet storage depositSet = _deposits[_account];
1345 
1346         return depositSet.length();
1347     }
1348 
1349     function getMultiplier(address _account) internal view returns (uint256) {
1350         if (countDepositsOf(_account) >= CARDS_REQUIRED_FOR_BOOST) {
1351             return CARDS_BOOSTER;
1352         }
1353 
1354         return 1;
1355     }
1356 
1357     //deposit function.
1358     function deposit(uint256[] calldata _tokenIds) external {
1359         require(isStakingActive, "Staking is not active");
1360 
1361         for (uint256 i; i < _tokenIds.length; i++) {
1362             IERC721(stakingContractAddress).safeTransferFrom(
1363                 msg.sender,
1364                 address(this),
1365                 _tokenIds[i],
1366                 ""
1367             );
1368 
1369             _deposits[msg.sender].add(_tokenIds[i]);
1370         }
1371     }
1372 
1373     //withdrawal function.
1374     function withdraw(uint256[] calldata _tokenIds) external nonReentrant() {
1375         require(isStakingActive, "Staking is not active");
1376 
1377         for (uint256 i; i < _tokenIds.length; i++) {
1378             require(
1379                 _deposits[msg.sender].contains(_tokenIds[i]),
1380                 "Token not deposited or not owned"
1381             );
1382 
1383             _deposits[msg.sender].remove(_tokenIds[i]);
1384 
1385             IERC721(stakingContractAddress).safeTransferFrom(
1386                 address(this),
1387                 msg.sender,
1388                 _tokenIds[i],
1389                 ""
1390             );
1391         }
1392     }
1393 
1394     function onERC721Received(
1395         address,
1396         address,
1397         uint256,
1398         bytes calldata
1399     ) external pure override returns (bytes4) {
1400         return IERC721Receiver.onERC721Received.selector;
1401     }
1402 }