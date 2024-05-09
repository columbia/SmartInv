1 //SPDX-License-Identifier: Unlicense
2 
3 /*
4                                                         ,----,
5                             ,--,     ,----..          ,/   .`|           ____
6                           ,--.'|    /   /   \       ,`   .'  :         ,'  , `.
7                        ,--,  | :   /   .     :    ;    ;     /      ,-+-,.' _ |
8                     ,---.'|  : '  .   /   ;.  \ .'___,/    ,'    ,-+-. ;   , ||
9                     |   | : _' | .   ;   /  ` ; |    :     |    ,--.'|'   |  ;|
10                     :   : |.'  | ;   |  ; \ ; | ;    |.';  ;   |   |  ,', |  ':t
11                     |   ' '  ; : |   :  | ; | ' `----'  |  |   |   | /  | |  ||
12                     '   |  .'. | .   |  ' ' ' :     '   :  ;   '   | :  | :  |,
13                     |   | :  | ' '   ;  \; /  |     |   |  '   ;   . |  ; |--'
14                     '   : |  : ;  \   \  ',  /      '   :  |   |   : |  | ,
15                     |   | '  ,/    ;   :    /       ;   |.'    |   : '  |/
16                     ;   : ;--'      \   \ .'        '---'      ;   | |`-'
17                     |   ,/           `---`                     |   ;/
18                     '---'                                      '---'
19 */
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Contract module that helps prevent reentrant calls to a function.
47  *
48  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
49  * available, which can be applied to functions to make sure there are no nested
50  * (reentrant) calls to them.
51  *
52  * Note that because there is a single `nonReentrant` guard, functions marked as
53  * `nonReentrant` may not call one another. This can be worked around by making
54  * those functions `private`, and then adding `external` `nonReentrant` entry
55  * points to them.
56  *
57  * TIP: If you would like to learn more about reentrancy and alternative ways
58  * to protect against it, check out our blog post
59  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
60  */
61 abstract contract ReentrancyGuard {
62     // Booleans are more expensive than uint256 or any type that takes up a full
63     // word because each write operation emits an extra SLOAD to first read the
64     // slot's contents, replace the bits taken up by the boolean, and then write
65     // back. This is the compiler's defense against contract upgrades and
66     // pointer aliasing, and it cannot be disabled.
67 
68     // The values being non-zero value makes deployment a bit more expensive,
69     // but in exchange the refund on every call to nonReentrant will be lower in
70     // amount. Since refunds are capped to a percentage of the total
71     // transaction's gas, it is best to keep them low in cases like this one, to
72     // increase the likelihood of the full refund coming into effect.
73     uint256 private constant _NOT_ENTERED = 1;
74     uint256 private constant _ENTERED = 2;
75 
76     uint256 private _status;
77 
78     constructor() {
79         _status = _NOT_ENTERED;
80     }
81 
82     /**
83      * @dev Prevents a contract from calling itself, directly or indirectly.
84      * Calling a `nonReentrant` function from another `nonReentrant`
85      * function is not supported. It is possible to prevent this from happening
86      * by making the `nonReentrant` function external, and make it call a
87      * `private` function that does the actual work.
88      */
89     modifier nonReentrant() {
90         // On the first call to nonReentrant, _notEntered will be true
91         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
92 
93         // Any calls to nonReentrant after this point will fail
94         _status = _ENTERED;
95 
96         _;
97 
98         // By storing the original value once again, a refund is triggered (see
99         // https://eips.ethereum.org/EIPS/eip-2200)
100         _status = _NOT_ENTERED;
101     }
102 }
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _setOwner(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _setOwner(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _setOwner(newOwner);
163     }
164 
165     function _setOwner(address newOwner) private {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Contract module which allows children to implement an emergency stop
176  * mechanism that can be triggered by an authorized account.
177  *
178  * This module is used through inheritance. It will make available the
179  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
180  * the functions of your contract. Note that they will not be pausable by
181  * simply including this module, only once the modifiers are put in place.
182  */
183 abstract contract Pausable is Context {
184     /**
185      * @dev Emitted when the pause is triggered by `account`.
186      */
187     event Paused(address account);
188 
189     /**
190      * @dev Emitted when the pause is lifted by `account`.
191      */
192     event Unpaused(address account);
193 
194     bool private _paused;
195 
196     /**
197      * @dev Initializes the contract in unpaused state.
198      */
199     constructor() {
200         _paused = false;
201     }
202 
203     /**
204      * @dev Returns true if the contract is paused, and false otherwise.
205      */
206     function paused() public view virtual returns (bool) {
207         return _paused;
208     }
209 
210     /**
211      * @dev Modifier to make a function callable only when the contract is not paused.
212      *
213      * Requirements:
214      *
215      * - The contract must not be paused.
216      */
217     modifier whenNotPaused() {
218         require(!paused(), "Pausable: paused");
219         _;
220     }
221 
222     /**
223      * @dev Modifier to make a function callable only when the contract is paused.
224      *
225      * Requirements:
226      *
227      * - The contract must be paused.
228      */
229     modifier whenPaused() {
230         require(paused(), "Pausable: not paused");
231         _;
232     }
233 
234     /**
235      * @dev Triggers stopped state.
236      *
237      * Requirements:
238      *
239      * - The contract must not be paused.
240      */
241     function _pause() internal virtual whenNotPaused {
242         _paused = true;
243         emit Paused(_msgSender());
244     }
245 
246     /**
247      * @dev Returns to normal state.
248      *
249      * Requirements:
250      *
251      * - The contract must be paused.
252      */
253     function _unpause() internal virtual whenPaused {
254         _paused = false;
255         emit Unpaused(_msgSender());
256     }
257 }
258 
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev Interface of the ERC20 standard as defined in the EIP.
264  */
265 interface IERC20 {
266     /**
267      * @dev Returns the amount of tokens in existence.
268      */
269     function totalSupply() external view returns (uint256);
270 
271     /**
272      * @dev Returns the amount of tokens owned by `account`.
273      */
274     function balanceOf(address account) external view returns (uint256);
275 
276     /**
277      * @dev Moves `amount` tokens from the caller's account to `recipient`.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transfer(address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Returns the remaining number of tokens that `spender` will be
287      * allowed to spend on behalf of `owner` through {transferFrom}. This is
288      * zero by default.
289      *
290      * This value changes when {approve} or {transferFrom} are called.
291      */
292     function allowance(address owner, address spender) external view returns (uint256);
293 
294     /**
295      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * IMPORTANT: Beware that changing an allowance with this method brings the risk
300      * that someone may use both the old and the new allowance by unfortunate
301      * transaction ordering. One possible solution to mitigate this race
302      * condition is to first reduce the spender's allowance to 0 and set the
303      * desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      *
306      * Emits an {Approval} event.
307      */
308     function approve(address spender, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Moves `amount` tokens from `sender` to `recipient` using the
312      * allowance mechanism. `amount` is then deducted from the caller's
313      * allowance.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) external returns (bool);
324 
325     /**
326      * @dev Emitted when `value` tokens are moved from one account (`from`) to
327      * another (`to`).
328      *
329      * Note that `value` may be zero.
330      */
331     event Transfer(address indexed from, address indexed to, uint256 value);
332 
333     /**
334      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
335      * a call to {approve}. `value` is the new allowance.
336      */
337     event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev Interface for the optional metadata functions from the ERC20 standard.
344  *
345  * _Available since v4.1._
346  */
347 interface IERC20Metadata is IERC20 {
348     /**
349      * @dev Returns the name of the token.
350      */
351     function name() external view returns (string memory);
352 
353     /**
354      * @dev Returns the symbol of the token.
355      */
356     function symbol() external view returns (string memory);
357 
358     /**
359      * @dev Returns the decimals places of the token.
360      */
361     function decimals() external view returns (uint8);
362 }
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @dev Implementation of the {IERC20} interface.
368  *
369  * This implementation is agnostic to the way tokens are created. This means
370  * that a supply mechanism has to be added in a derived contract using {_mint}.
371  * For a generic mechanism see {ERC20PresetMinterPauser}.
372  *
373  * TIP: For a detailed writeup see our guide
374  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
375  * to implement supply mechanisms].
376  *
377  * We have followed general OpenZeppelin Contracts guidelines: functions revert
378  * instead returning `false` on failure. This behavior is nonetheless
379  * conventional and does not conflict with the expectations of ERC20
380  * applications.
381  *
382  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
383  * This allows applications to reconstruct the allowance for all accounts just
384  * by listening to said events. Other implementations of the EIP may not emit
385  * these events, as it isn't required by the specification.
386  *
387  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
388  * functions have been added to mitigate the well-known issues around setting
389  * allowances. See {IERC20-approve}.
390  */
391 contract ERC20 is Context, IERC20, IERC20Metadata {
392     mapping(address => uint256) private _balances;
393 
394     mapping(address => mapping(address => uint256)) private _allowances;
395 
396     uint256 private _totalSupply;
397 
398     string private _name;
399     string private _symbol;
400 
401     /**
402      * @dev Sets the values for {name} and {symbol}.
403      *
404      * The default value of {decimals} is 18. To select a different value for
405      * {decimals} you should overload it.
406      *
407      * All two of these values are immutable: they can only be set once during
408      * construction.
409      */
410     constructor(string memory name_, string memory symbol_) {
411         _name = name_;
412         _symbol = symbol_;
413     }
414 
415     /**
416      * @dev Returns the name of the token.
417      */
418     function name() public view virtual override returns (string memory) {
419         return _name;
420     }
421 
422     /**
423      * @dev Returns the symbol of the token, usually a shorter version of the
424      * name.
425      */
426     function symbol() public view virtual override returns (string memory) {
427         return _symbol;
428     }
429 
430     /**
431      * @dev Returns the number of decimals used to get its user representation.
432      * For example, if `decimals` equals `2`, a balance of `505` tokens should
433      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
434      *
435      * Tokens usually opt for a value of 18, imitating the relationship between
436      * Ether and Wei. This is the value {ERC20} uses, unless this function is
437      * overridden;
438      *
439      * NOTE: This information is only used for _display_ purposes: it in
440      * no way affects any of the arithmetic of the contract, including
441      * {IERC20-balanceOf} and {IERC20-transfer}.
442      */
443     function decimals() public view virtual override returns (uint8) {
444         return 18;
445     }
446 
447     /**
448      * @dev See {IERC20-totalSupply}.
449      */
450     function totalSupply() public view virtual override returns (uint256) {
451         return _totalSupply;
452     }
453 
454     /**
455      * @dev See {IERC20-balanceOf}.
456      */
457     function balanceOf(address account) public view virtual override returns (uint256) {
458         return _balances[account];
459     }
460 
461     /**
462      * @dev See {IERC20-transfer}.
463      *
464      * Requirements:
465      *
466      * - `recipient` cannot be the zero address.
467      * - the caller must have a balance of at least `amount`.
468      */
469     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
470         _transfer(_msgSender(), recipient, amount);
471         return true;
472     }
473 
474     /**
475      * @dev See {IERC20-allowance}.
476      */
477     function allowance(address owner, address spender) public view virtual override returns (uint256) {
478         return _allowances[owner][spender];
479     }
480 
481     /**
482      * @dev See {IERC20-approve}.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      */
488     function approve(address spender, uint256 amount) public virtual override returns (bool) {
489         _approve(_msgSender(), spender, amount);
490         return true;
491     }
492 
493     /**
494      * @dev See {IERC20-transferFrom}.
495      *
496      * Emits an {Approval} event indicating the updated allowance. This is not
497      * required by the EIP. See the note at the beginning of {ERC20}.
498      *
499      * Requirements:
500      *
501      * - `sender` and `recipient` cannot be the zero address.
502      * - `sender` must have a balance of at least `amount`.
503      * - the caller must have allowance for ``sender``'s tokens of at least
504      * `amount`.
505      */
506     function transferFrom(
507         address sender,
508         address recipient,
509         uint256 amount
510     ) public virtual override returns (bool) {
511         _transfer(sender, recipient, amount);
512 
513         uint256 currentAllowance = _allowances[sender][_msgSender()];
514         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
515     unchecked {
516         _approve(sender, _msgSender(), currentAllowance - amount);
517     }
518 
519         return true;
520     }
521 
522     /**
523      * @dev Atomically increases the allowance granted to `spender` by the caller.
524      *
525      * This is an alternative to {approve} that can be used as a mitigation for
526      * problems described in {IERC20-approve}.
527      *
528      * Emits an {Approval} event indicating the updated allowance.
529      *
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      */
534     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
535         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
536         return true;
537     }
538 
539     /**
540      * @dev Atomically decreases the allowance granted to `spender` by the caller.
541      *
542      * This is an alternative to {approve} that can be used as a mitigation for
543      * problems described in {IERC20-approve}.
544      *
545      * Emits an {Approval} event indicating the updated allowance.
546      *
547      * Requirements:
548      *
549      * - `spender` cannot be the zero address.
550      * - `spender` must have allowance for the caller of at least
551      * `subtractedValue`.
552      */
553     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
554         uint256 currentAllowance = _allowances[_msgSender()][spender];
555         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
556     unchecked {
557         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
558     }
559 
560         return true;
561     }
562 
563     /**
564      * @dev Moves `amount` of tokens from `sender` to `recipient`.
565      *
566      * This internal function is equivalent to {transfer}, and can be used to
567      * e.g. implement automatic token fees, slashing mechanisms, etc.
568      *
569      * Emits a {Transfer} event.
570      *
571      * Requirements:
572      *
573      * - `sender` cannot be the zero address.
574      * - `recipient` cannot be the zero address.
575      * - `sender` must have a balance of at least `amount`.
576      */
577     function _transfer(
578         address sender,
579         address recipient,
580         uint256 amount
581     ) internal virtual {
582         require(sender != address(0), "ERC20: transfer from the zero address");
583         require(recipient != address(0), "ERC20: transfer to the zero address");
584 
585         _beforeTokenTransfer(sender, recipient, amount);
586 
587         uint256 senderBalance = _balances[sender];
588         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
589     unchecked {
590         _balances[sender] = senderBalance - amount;
591     }
592         _balances[recipient] += amount;
593 
594         emit Transfer(sender, recipient, amount);
595 
596         _afterTokenTransfer(sender, recipient, amount);
597     }
598 
599     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
600      * the total supply.
601      *
602      * Emits a {Transfer} event with `from` set to the zero address.
603      *
604      * Requirements:
605      *
606      * - `account` cannot be the zero address.
607      */
608     function _mint(address account, uint256 amount) internal virtual {
609         require(account != address(0), "ERC20: mint to the zero address");
610 
611         _beforeTokenTransfer(address(0), account, amount);
612 
613         _totalSupply += amount;
614         _balances[account] += amount;
615         emit Transfer(address(0), account, amount);
616 
617         _afterTokenTransfer(address(0), account, amount);
618     }
619 
620     /**
621      * @dev Destroys `amount` tokens from `account`, reducing the
622      * total supply.
623      *
624      * Emits a {Transfer} event with `to` set to the zero address.
625      *
626      * Requirements:
627      *
628      * - `account` cannot be the zero address.
629      * - `account` must have at least `amount` tokens.
630      */
631     function _burn(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: burn from the zero address");
633 
634         _beforeTokenTransfer(account, address(0), amount);
635 
636         uint256 accountBalance = _balances[account];
637         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
638     unchecked {
639         _balances[account] = accountBalance - amount;
640     }
641         _totalSupply -= amount;
642 
643         emit Transfer(account, address(0), amount);
644 
645         _afterTokenTransfer(account, address(0), amount);
646     }
647 
648     /**
649      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
650      *
651      * This internal function is equivalent to `approve`, and can be used to
652      * e.g. set automatic allowances for certain subsystems, etc.
653      *
654      * Emits an {Approval} event.
655      *
656      * Requirements:
657      *
658      * - `owner` cannot be the zero address.
659      * - `spender` cannot be the zero address.
660      */
661     function _approve(
662         address owner,
663         address spender,
664         uint256 amount
665     ) internal virtual {
666         require(owner != address(0), "ERC20: approve from the zero address");
667         require(spender != address(0), "ERC20: approve to the zero address");
668 
669         _allowances[owner][spender] = amount;
670         emit Approval(owner, spender, amount);
671     }
672 
673     /**
674      * @dev Hook that is called before any transfer of tokens. This includes
675      * minting and burning.
676      *
677      * Calling conditions:
678      *
679      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
680      * will be transferred to `to`.
681      * - when `from` is zero, `amount` tokens will be minted for `to`.
682      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
683      * - `from` and `to` are never both zero.
684      *
685      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
686      */
687     function _beforeTokenTransfer(
688         address from,
689         address to,
690         uint256 amount
691     ) internal virtual {}
692 
693     /**
694      * @dev Hook that is called after any transfer of tokens. This includes
695      * minting and burning.
696      *
697      * Calling conditions:
698      *
699      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
700      * has been transferred to `to`.
701      * - when `from` is zero, `amount` tokens have been minted for `to`.
702      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
703      * - `from` and `to` are never both zero.
704      *
705      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
706      */
707     function _afterTokenTransfer(
708         address from,
709         address to,
710         uint256 amount
711     ) internal virtual {}
712 }
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @dev Library for managing
718  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
719  * types.
720  *
721  * Sets have the following properties:
722  *
723  * - Elements are added, removed, and checked for existence in constant time
724  * (O(1)).
725  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
726  *
727  * ```
728  * contract Example {
729  *     // Add the library methods
730  *     using EnumerableSet for EnumerableSet.AddressSet;
731  *
732  *     // Declare a set state variable
733  *     EnumerableSet.AddressSet private mySet;
734  * }
735  * ```
736  *
737  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
738  * and `uint256` (`UintSet`) are supported.
739  */
740 library EnumerableSet {
741     // To implement this library for multiple types with as little code
742     // repetition as possible, we write it in terms of a generic Set type with
743     // bytes32 values.
744     // The Set implementation uses private functions, and user-facing
745     // implementations (such as AddressSet) are just wrappers around the
746     // underlying Set.
747     // This means that we can only create new EnumerableSets for types that fit
748     // in bytes32.
749 
750     struct Set {
751         // Storage of set values
752         bytes32[] _values;
753         // Position of the value in the `values` array, plus 1 because index 0
754         // means a value is not in the set.
755         mapping(bytes32 => uint256) _indexes;
756     }
757 
758     /**
759      * @dev Add a value to a set. O(1).
760      *
761      * Returns true if the value was added to the set, that is if it was not
762      * already present.
763      */
764     function _add(Set storage set, bytes32 value) private returns (bool) {
765         if (!_contains(set, value)) {
766             set._values.push(value);
767             // The value is stored at length-1, but we add 1 to all indexes
768             // and use 0 as a sentinel value
769             set._indexes[value] = set._values.length;
770             return true;
771         } else {
772             return false;
773         }
774     }
775 
776     /**
777      * @dev Removes a value from a set. O(1).
778      *
779      * Returns true if the value was removed from the set, that is if it was
780      * present.
781      */
782     function _remove(Set storage set, bytes32 value) private returns (bool) {
783         // We read and store the value's index to prevent multiple reads from the same storage slot
784         uint256 valueIndex = set._indexes[value];
785 
786         if (valueIndex != 0) {
787             // Equivalent to contains(set, value)
788             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
789             // the array, and then remove the last element (sometimes called as 'swap and pop').
790             // This modifies the order of the array, as noted in {at}.
791 
792             uint256 toDeleteIndex = valueIndex - 1;
793             uint256 lastIndex = set._values.length - 1;
794 
795             if (lastIndex != toDeleteIndex) {
796                 bytes32 lastvalue = set._values[lastIndex];
797 
798                 // Move the last value to the index where the value to delete is
799                 set._values[toDeleteIndex] = lastvalue;
800                 // Update the index for the moved value
801                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
802             }
803 
804             // Delete the slot where the moved value was stored
805             set._values.pop();
806 
807             // Delete the index for the deleted slot
808             delete set._indexes[value];
809 
810             return true;
811         } else {
812             return false;
813         }
814     }
815 
816     /**
817      * @dev Returns true if the value is in the set. O(1).
818      */
819     function _contains(Set storage set, bytes32 value) private view returns (bool) {
820         return set._indexes[value] != 0;
821     }
822 
823     /**
824      * @dev Returns the number of values on the set. O(1).
825      */
826     function _length(Set storage set) private view returns (uint256) {
827         return set._values.length;
828     }
829 
830     /**
831      * @dev Returns the value stored at position `index` in the set. O(1).
832      *
833      * Note that there are no guarantees on the ordering of values inside the
834      * array, and it may change when more values are added or removed.
835      *
836      * Requirements:
837      *
838      * - `index` must be strictly less than {length}.
839      */
840     function _at(Set storage set, uint256 index) private view returns (bytes32) {
841         return set._values[index];
842     }
843 
844     /**
845      * @dev Return the entire set in an array
846      *
847      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
848      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
849      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
850      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
851      */
852     function _values(Set storage set) private view returns (bytes32[] memory) {
853         return set._values;
854     }
855 
856     // Bytes32Set
857 
858     struct Bytes32Set {
859         Set _inner;
860     }
861 
862     /**
863      * @dev Add a value to a set. O(1).
864      *
865      * Returns true if the value was added to the set, that is if it was not
866      * already present.
867      */
868     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
869         return _add(set._inner, value);
870     }
871 
872     /**
873      * @dev Removes a value from a set. O(1).
874      *
875      * Returns true if the value was removed from the set, that is if it was
876      * present.
877      */
878     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
879         return _remove(set._inner, value);
880     }
881 
882     /**
883      * @dev Returns true if the value is in the set. O(1).
884      */
885     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
886         return _contains(set._inner, value);
887     }
888 
889     /**
890      * @dev Returns the number of values in the set. O(1).
891      */
892     function length(Bytes32Set storage set) internal view returns (uint256) {
893         return _length(set._inner);
894     }
895 
896     /**
897      * @dev Returns the value stored at position `index` in the set. O(1).
898      *
899      * Note that there are no guarantees on the ordering of values inside the
900      * array, and it may change when more values are added or removed.
901      *
902      * Requirements:
903      *
904      * - `index` must be strictly less than {length}.
905      */
906     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
907         return _at(set._inner, index);
908     }
909 
910     /**
911      * @dev Return the entire set in an array
912      *
913      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
914      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
915      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
916      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
917      */
918     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
919         return _values(set._inner);
920     }
921 
922     // AddressSet
923 
924     struct AddressSet {
925         Set _inner;
926     }
927 
928     /**
929      * @dev Add a value to a set. O(1).
930      *
931      * Returns true if the value was added to the set, that is if it was not
932      * already present.
933      */
934     function add(AddressSet storage set, address value) internal returns (bool) {
935         return _add(set._inner, bytes32(uint256(uint160(value))));
936     }
937 
938     /**
939      * @dev Removes a value from a set. O(1).
940      *
941      * Returns true if the value was removed from the set, that is if it was
942      * present.
943      */
944     function remove(AddressSet storage set, address value) internal returns (bool) {
945         return _remove(set._inner, bytes32(uint256(uint160(value))));
946     }
947 
948     /**
949      * @dev Returns true if the value is in the set. O(1).
950      */
951     function contains(AddressSet storage set, address value) internal view returns (bool) {
952         return _contains(set._inner, bytes32(uint256(uint160(value))));
953     }
954 
955     /**
956      * @dev Returns the number of values in the set. O(1).
957      */
958     function length(AddressSet storage set) internal view returns (uint256) {
959         return _length(set._inner);
960     }
961 
962     /**
963      * @dev Returns the value stored at position `index` in the set. O(1).
964      *
965      * Note that there are no guarantees on the ordering of values inside the
966      * array, and it may change when more values are added or removed.
967      *
968      * Requirements:
969      *
970      * - `index` must be strictly less than {length}.
971      */
972     function at(AddressSet storage set, uint256 index) internal view returns (address) {
973         return address(uint160(uint256(_at(set._inner, index))));
974     }
975 
976     /**
977      * @dev Return the entire set in an array
978      *
979      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
980      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
981      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
982      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
983      */
984     function values(AddressSet storage set) internal view returns (address[] memory) {
985         bytes32[] memory store = _values(set._inner);
986         address[] memory result;
987 
988         assembly {
989             result := store
990         }
991 
992         return result;
993     }
994 
995     // UintSet
996 
997     struct UintSet {
998         Set _inner;
999     }
1000 
1001     /**
1002      * @dev Add a value to a set. O(1).
1003      *
1004      * Returns true if the value was added to the set, that is if it was not
1005      * already present.
1006      */
1007     function add(UintSet storage set, uint256 value) internal returns (bool) {
1008         return _add(set._inner, bytes32(value));
1009     }
1010 
1011     /**
1012      * @dev Removes a value from a set. O(1).
1013      *
1014      * Returns true if the value was removed from the set, that is if it was
1015      * present.
1016      */
1017     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1018         return _remove(set._inner, bytes32(value));
1019     }
1020 
1021     /**
1022      * @dev Returns true if the value is in the set. O(1).
1023      */
1024     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1025         return _contains(set._inner, bytes32(value));
1026     }
1027 
1028     /**
1029      * @dev Returns the number of values on the set. O(1).
1030      */
1031     function length(UintSet storage set) internal view returns (uint256) {
1032         return _length(set._inner);
1033     }
1034 
1035     /**
1036      * @dev Returns the value stored at position `index` in the set. O(1).
1037      *
1038      * Note that there are no guarantees on the ordering of values inside the
1039      * array, and it may change when more values are added or removed.
1040      *
1041      * Requirements:
1042      *
1043      * - `index` must be strictly less than {length}.
1044      */
1045     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1046         return uint256(_at(set._inner, index));
1047     }
1048 
1049     /**
1050      * @dev Return the entire set in an array
1051      *
1052      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1053      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1054      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1055      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1056      */
1057     function values(UintSet storage set) internal view returns (uint256[] memory) {
1058         bytes32[] memory store = _values(set._inner);
1059         uint256[] memory result;
1060 
1061         assembly {
1062             result := store
1063         }
1064 
1065         return result;
1066     }
1067 }
1068 
1069 pragma solidity ^0.8.10;
1070 
1071 interface IYielder {
1072     function ownerOf(uint256 _tokenId) external view returns(address);
1073 }
1074 
1075 interface IBooster {
1076     function computeAmount(uint256 amount) external view returns(uint256);
1077     function computeAmounts(uint256[] calldata amounts, uint256[] calldata yieldingCores, uint256[] calldata tokens) external view returns(uint256);
1078 }
1079 
1080 contract HumansOfTheMetaverseToken is ERC20("HOTM", "HOTM"), Ownable, Pausable, ReentrancyGuard {
1081     using EnumerableSet for EnumerableSet.UintSet;
1082 
1083     struct YielderSettings {
1084         uint256 _defaultYieldRate; // fallback for yieldingCoresAmount absence
1085         uint256 _startTime;
1086         uint256 _endTime;
1087         uint256 _timeRate;
1088         mapping(uint256 => uint256) _tokenYieldingCoresMapping; // tokenId => yieldingCoreId (i.e. job)
1089         mapping(uint256 => uint256) _yieldingCoresAmountMapping; // yieldingCoreId => amount
1090         mapping(uint256 => uint256) _lastClaim; // tokenId => date
1091     }
1092 
1093     struct BoosterSettings {
1094         address _appliesFor; // yielder
1095         bool _status;
1096         EnumerableSet.UintSet _yieldingCores;
1097         mapping(uint256 => uint256) _boosterStartDates; // tokenId => boosterStartDate
1098     }
1099 
1100     mapping(address => YielderSettings) yielders;
1101 
1102     mapping(address => BoosterSettings) boosters;
1103 
1104     address[] public boostersAddresses; // boosters should be iterable
1105 
1106     mapping(address => mapping(address => EnumerableSet.UintSet)) tokensOwnerShip; // map econtract addrss => map owner address => yieldingToken
1107 
1108     uint256 public allowedPublicTokensMinted = 31207865 ether; // max total supply * 0.6
1109     uint256 public foundersAndOthersAllowedMinting = 20805244 ether;
1110     uint256 public foundersLinearDistributionPeriod = 365 days;
1111 
1112     uint256 public foundersAndOthersLastClaim;
1113 
1114     constructor() {
1115         _pause();
1116         foundersAndOthersLastClaim = block.timestamp;
1117     }
1118 
1119     // YIELDERS
1120 
1121     function setYielderSettings(
1122         uint256 _defaultYieldRate,
1123         uint256 _startTime,
1124         uint256 _endTime,
1125         uint256 _timeRate,
1126         address _yielderAddress
1127     ) external onlyOwner {
1128         YielderSettings storage yielderSettings =  yielders[_yielderAddress];
1129 
1130         yielderSettings._defaultYieldRate = _defaultYieldRate;
1131         yielderSettings._startTime = _startTime;
1132         yielderSettings._endTime = _endTime;
1133         yielderSettings._timeRate = _timeRate;
1134     }
1135 
1136     function getYielderSettings(address _address) internal view returns (YielderSettings storage) {
1137         YielderSettings storage yielderSettings = yielders[_address];
1138         require(yielderSettings._startTime != uint256(0), "There is no yielder with provided address");
1139 
1140         return yielderSettings;
1141     }
1142 
1143     function setTokenYielderMapping(
1144         address _yielderAddress,
1145         uint256[] calldata _tokenIds,
1146         uint256[] calldata _yieldingCores
1147     ) external onlyOwner {
1148         require(_tokenIds.length == _yieldingCores.length, "Provided arrays should have the same length");
1149 
1150         YielderSettings storage yielderSettings = getYielderSettings(_yielderAddress);
1151 
1152         for(uint256 i = 0; i < _tokenIds.length; ++i) {
1153             yielderSettings._tokenYieldingCoresMapping[_tokenIds[i]] = _yieldingCores[i];
1154         }
1155     }
1156 
1157     function setYieldingAmountMapping(
1158         address _yielderAddress,
1159         uint256[] calldata _yieldingCores,
1160         uint256[] calldata _amounts
1161     ) external onlyOwner {
1162         require(_amounts.length == _yieldingCores.length, "Provided arrays should have the same length");
1163 
1164         YielderSettings storage yielderSettings = getYielderSettings(_yielderAddress);
1165 
1166         for(uint256 i = 0; i < _yieldingCores.length; ++i) {
1167             yielderSettings._yieldingCoresAmountMapping[_yieldingCores[i]] = _amounts[i] * (10 ** 18); // cast to ether
1168         }
1169     }
1170 
1171     function setEndDateForYielder(uint256 _endTime, address _contract) external onlyOwner {
1172         YielderSettings storage yielderSettings = getYielderSettings(_contract);
1173         yielderSettings._endTime = _endTime;
1174     }
1175 
1176     function setStartDateForYielder(uint256 _startTime, address _contract) external onlyOwner {
1177         YielderSettings storage yielderSettings = getYielderSettings(_contract);
1178         yielderSettings._startTime = _startTime;
1179     }
1180 
1181     function setDefaultYieldRateForYielder(uint256 _defaultYieldRate, address _contract) external onlyOwner {
1182         YielderSettings storage yielderSettings = getYielderSettings(_contract);
1183         yielderSettings._defaultYieldRate = _defaultYieldRate * (10 ** 18);
1184     }
1185 
1186     function setTimeRateForYielder(uint256 _timeRate, address _contract) external onlyOwner {
1187         YielderSettings storage yielderSettings = getYielderSettings(_contract);
1188         yielderSettings._timeRate = _timeRate;
1189     }
1190 
1191     // BOOSTERS
1192 
1193     function setBoosterConfiguration(
1194         address _appliesFor,
1195         bool _status,
1196         address _boosterAddress
1197     ) external onlyOwner {
1198         boostersAddresses.push(_boosterAddress);
1199         BoosterSettings storage boosterSettings = boosters[_boosterAddress];
1200         boosterSettings._appliesFor=  _appliesFor;
1201         boosterSettings._status = _status;
1202     }
1203 
1204     function getBoosterSettings(address _address) internal view returns (BoosterSettings storage) {
1205         BoosterSettings storage boosterSettings = boosters[_address];
1206         require(boosterSettings._appliesFor != address(0), "There is no yielder with provided address");
1207 
1208         return boosterSettings;
1209     }
1210 
1211     function setBoosterCores(address _boosterAddress, uint256[] calldata _yieldingCoresIds) external onlyOwner {
1212         BoosterSettings storage boosterSettings = getBoosterSettings(_boosterAddress);
1213         for (uint256 i = 0; i < _yieldingCoresIds.length; ++i) {
1214             boosterSettings._yieldingCores.add(_yieldingCoresIds[i]);
1215         }
1216     }
1217 
1218     function setBoosterStatus(address _boosterAddress, bool _status) external onlyOwner {
1219         BoosterSettings storage boosterSettings = getBoosterSettings(_boosterAddress);
1220         boosterSettings._status = _status;
1221     }
1222 
1223     function setBoosterAppliesFor(address _boosterAddress, address _appliesFor) external onlyOwner{
1224         BoosterSettings storage boosterSettings = getBoosterSettings(_boosterAddress);
1225         boosterSettings._appliesFor = _appliesFor;
1226     }
1227 
1228     function replaceBoosterCores(address _boosterAddress, uint256[] calldata _yieldingCoresIds) external onlyOwner {
1229         BoosterSettings storage boosterSettings = getBoosterSettings(_boosterAddress);
1230 
1231         for (uint256 i = 0; i < boosterSettings._yieldingCores.length(); ++i) {
1232             boosterSettings._yieldingCores.remove(boosterSettings._yieldingCores.at(i));
1233         }
1234 
1235         for (uint256 i = 0; i < _yieldingCoresIds.length; ++i) {
1236             boosterSettings._yieldingCores.add(_yieldingCoresIds[i]);
1237         }
1238     }
1239 
1240 
1241     // TOKEN
1242 
1243     function claimRewards(
1244         address _contractAddress,
1245         uint256[] calldata _tokenIds
1246     ) external whenNotPaused nonReentrant() returns (uint256) {
1247         YielderSettings storage yielderSettings = getYielderSettings(_contractAddress);
1248 
1249         for(uint256 i = 0; i < _tokenIds.length; i++) {
1250             uint256 _tokenId = _tokenIds[i];
1251             processTokenOwnerShip(_contractAddress, _tokenId);
1252         }
1253         uint256 currentTime = block.timestamp;
1254 
1255         uint256 totalUnclaimedRewards = computeUnclaimedRewardsAndUpdate(yielderSettings, _contractAddress, _tokenIds, currentTime);
1256 
1257         claimTokens(totalUnclaimedRewards);
1258 
1259         for(uint256 i = 0; i < _tokenIds.length; i++) {
1260             uint256 _tokenId = _tokenIds[i];
1261             if (currentTime > yielderSettings._endTime) {
1262                 yielderSettings._lastClaim[_tokenId] = yielderSettings._endTime;
1263             } else {
1264                 yielderSettings._lastClaim[_tokenId] = currentTime;
1265             }
1266         }
1267 
1268         return totalUnclaimedRewards;
1269     }
1270 
1271     function checkClaimableAmount(address _contractAddress, uint256[] calldata _tokenIds) view external whenNotPaused returns(uint256) {
1272         YielderSettings storage yielderSettings = getYielderSettings(_contractAddress);
1273 
1274         uint256 totalUnclaimedRewards = computeUnclaimedRewardsSafe(yielderSettings, _contractAddress, _tokenIds, block.timestamp);
1275 
1276         return totalUnclaimedRewards;
1277     }
1278 
1279     function computeUnclaimedRewardsAndUpdate(
1280         YielderSettings storage _yielderSettings,
1281         address _yielderAddress,
1282         uint256[] calldata _tokenIds,
1283         uint256 _currentTime
1284     ) internal returns (uint256) {
1285         uint256 totalReward = 0;
1286 
1287         totalReward += computeBaseAccumulatedRewards(_yielderSettings, _tokenIds, _currentTime);
1288         totalReward += computeBoostersAccumulatedRewardsAndUpdate(_yielderAddress, _yielderSettings, _tokenIds, _currentTime);
1289 
1290         return totalReward;
1291     }
1292 
1293     function computeUnclaimedRewardsSafe(
1294         YielderSettings storage _yielderSettings,
1295         address _yielderAddress,
1296         uint256[] calldata _tokenIds,
1297         uint256 _currentTime
1298     ) internal view returns (uint256) {
1299         uint256 totalReward = 0;
1300 
1301         totalReward += computeBaseAccumulatedRewards(_yielderSettings, _tokenIds, _currentTime);
1302         totalReward += computeBoostersAccumulatedRewardsSafe(_yielderAddress, _yielderSettings, _tokenIds, _currentTime);
1303 
1304         return totalReward;
1305     }
1306 
1307     function computeBaseAccumulatedRewards(
1308         YielderSettings storage _yielderSettings,
1309         uint256[] calldata _tokenIds,
1310         uint256 _currentTime
1311     ) internal view returns (uint256) {
1312         uint256 baseAccumulatedRewards = 0;
1313 
1314         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1315             uint256 lastClaimDate = getLastClaimForYielder(_yielderSettings, _tokenIds[i]);
1316 
1317             if (lastClaimDate != _yielderSettings._endTime) {
1318                 uint256 secondsElapsed = _currentTime - lastClaimDate;
1319                 if (_yielderSettings._defaultYieldRate != uint256(0)) {
1320                     baseAccumulatedRewards += secondsElapsed * _yielderSettings._defaultYieldRate / _yielderSettings._timeRate;
1321                 } else {
1322                     baseAccumulatedRewards +=
1323                     secondsElapsed * _yielderSettings._yieldingCoresAmountMapping[_yielderSettings._tokenYieldingCoresMapping[_tokenIds[i]]] / _yielderSettings._timeRate;
1324                 }
1325             }
1326         }
1327 
1328         return baseAccumulatedRewards;
1329     }
1330 
1331     function computeBoostersAccumulatedRewardsAndUpdate(
1332         address _yielderAddress,
1333         YielderSettings storage _yielderSettings,
1334         uint256[] calldata _tokenIds,
1335         uint256 _currentTime
1336     ) internal returns (uint256) {
1337 
1338         uint256 boosterAccumulatedRewards = 0;
1339 
1340         for (uint256 boosterIndex = 0; boosterIndex < boostersAddresses.length; ++boosterIndex) {
1341             BoosterSettings storage boosterSettings = getBoosterSettings(boostersAddresses[boosterIndex]);
1342             uint256 toBeSentArraysIndex = 0;
1343             uint256[] memory accumulatedRewardsForBooster = new uint256[](_tokenIds.length);
1344             uint256[] memory validTokensCandidates = new uint256[](_tokenIds.length);
1345 
1346             if (boosterSettings._appliesFor == _yielderAddress && boosterSettings._status) {
1347                 for (uint256 i = 0; i < _tokenIds.length; ++i) {
1348                     uint256 boosterStartDate = getLastClaimForBooster(boosterSettings, _tokenIds[i]);
1349                     if (
1350                         (
1351                         boosterSettings._yieldingCores.length() == 0
1352                         || boosterSettings._yieldingCores.contains(_yielderSettings._tokenYieldingCoresMapping[_tokenIds[i]])
1353                         ) && getLastClaimForYielder(_yielderSettings, _tokenIds[i]) != _yielderSettings._endTime
1354                         && boosterStartDate != uint256(0)
1355                     ) {
1356                         uint256 secondsElapsed = _currentTime - boosterStartDate;
1357 
1358                         if (_yielderSettings._defaultYieldRate != uint256(0)) {
1359                             accumulatedRewardsForBooster[toBeSentArraysIndex] =
1360                             secondsElapsed * _yielderSettings._defaultYieldRate / _yielderSettings._timeRate;
1361                         } else {
1362                             uint256 tokenYieldingCoresMapping = _yielderSettings._tokenYieldingCoresMapping[_tokenIds[i]];
1363                             uint256 yieldingCoresAmountMapping = _yielderSettings._yieldingCoresAmountMapping[tokenYieldingCoresMapping];
1364                             accumulatedRewardsForBooster[toBeSentArraysIndex] =
1365                             secondsElapsed * yieldingCoresAmountMapping / _yielderSettings._timeRate;
1366                         }
1367                         validTokensCandidates[toBeSentArraysIndex] = _tokenIds[i];
1368                         toBeSentArraysIndex++;
1369                     }
1370                 }
1371                 if (boosterSettings._yieldingCores.length() != 0) {
1372                     uint256[] memory yieldingCores = new uint256[](validTokensCandidates.length);
1373 
1374                     for (uint256 i = 0; i < validTokensCandidates.length; ++i) {
1375                         yieldingCores[i] = _yielderSettings._tokenYieldingCoresMapping[validTokensCandidates[i]];
1376                     }
1377 
1378                     boosterAccumulatedRewards +=
1379                     IBooster(boostersAddresses[boosterIndex]).computeAmounts(accumulatedRewardsForBooster, yieldingCores, validTokensCandidates);
1380                 } else {
1381                     uint256 summedBoosterAccumulatedRewards = 0;
1382                     for (uint256 i = 0; i < validTokensCandidates.length; ++i) {
1383                         summedBoosterAccumulatedRewards += accumulatedRewardsForBooster[i];
1384                     }
1385                     boosterAccumulatedRewards += IBooster(boostersAddresses[boosterIndex]).computeAmount(summedBoosterAccumulatedRewards);
1386                 }
1387                 for (uint256 i = 0; i < validTokensCandidates.length; ++i) {
1388                     if (boosterSettings._boosterStartDates[validTokensCandidates[i]] != uint256(0)) {
1389                         boosterSettings._boosterStartDates[validTokensCandidates[i]] = _currentTime;
1390                     }
1391                 }
1392             }
1393         }
1394 
1395         return boosterAccumulatedRewards;
1396     }
1397 
1398     function computeBoostersAccumulatedRewardsSafe(
1399         address _yielderAddress,
1400         YielderSettings storage _yielderSettings,
1401         uint256[] calldata _tokenIds,
1402         uint256 _currentTime
1403     ) internal view returns (uint256) {
1404 
1405         uint256 boosterAccumulatedRewards = 0;
1406 
1407         for (uint256 boosterIndex = 0; boosterIndex < boostersAddresses.length; ++boosterIndex) {
1408             BoosterSettings storage boosterSettings = getBoosterSettings(boostersAddresses[boosterIndex]);
1409             uint256 toBeSentArraysIndex = 0;
1410             uint256[] memory accumulatedRewardsForBooster = new uint256[](_tokenIds.length);
1411             uint256[] memory validTokensCandidates = new uint256[](_tokenIds.length);
1412 
1413             if (boosterSettings._appliesFor == _yielderAddress && boosterSettings._status) {
1414                 for (uint256 i = 0; i < _tokenIds.length; ++i) {
1415                     uint256 boosterStartDate = getLastClaimForBooster(boosterSettings, _tokenIds[i]);
1416                     if (
1417                         (
1418                         boosterSettings._yieldingCores.length() == 0
1419                         || boosterSettings._yieldingCores.contains(_yielderSettings._tokenYieldingCoresMapping[_tokenIds[i]])
1420                         ) && getLastClaimForYielder(_yielderSettings, _tokenIds[i]) != _yielderSettings._endTime
1421                         && boosterStartDate != uint256(0)
1422                     ) {
1423 
1424                         uint256 secondsElapsed = _currentTime - boosterStartDate;
1425 
1426                         if (_yielderSettings._defaultYieldRate != uint256(0)) {
1427                             accumulatedRewardsForBooster[toBeSentArraysIndex] =
1428                             secondsElapsed * _yielderSettings._defaultYieldRate / _yielderSettings._timeRate;
1429                         } else {
1430                             uint256 tokenYieldingCoresMapping = _yielderSettings._tokenYieldingCoresMapping[_tokenIds[i]];
1431                             uint256 yieldingCoresAmountMapping = _yielderSettings._yieldingCoresAmountMapping[tokenYieldingCoresMapping];
1432                             accumulatedRewardsForBooster[toBeSentArraysIndex] =
1433                             secondsElapsed * yieldingCoresAmountMapping / _yielderSettings._timeRate;
1434                         }
1435                         validTokensCandidates[toBeSentArraysIndex] = _tokenIds[i];
1436                         toBeSentArraysIndex++;
1437                     }
1438                 }
1439                 if (boosterSettings._yieldingCores.length() != 0) {
1440                     uint256[] memory yieldingCores = new uint256[](validTokensCandidates.length);
1441 
1442                     for (uint256 i = 0; i < validTokensCandidates.length; ++i) {
1443                         yieldingCores[i] = _yielderSettings._tokenYieldingCoresMapping[validTokensCandidates[i]];
1444                     }
1445 
1446                     boosterAccumulatedRewards +=
1447                     IBooster(boostersAddresses[boosterIndex]).computeAmounts(accumulatedRewardsForBooster, yieldingCores, validTokensCandidates);
1448 
1449                 } else {
1450                     uint256 summedBoosterAccumulatedRewards = 0;
1451                     for (uint256 i = 0; i < validTokensCandidates.length; ++i) {
1452                         summedBoosterAccumulatedRewards += accumulatedRewardsForBooster[i];
1453                     }
1454                     boosterAccumulatedRewards += IBooster(boostersAddresses[boosterIndex]).computeAmount(summedBoosterAccumulatedRewards);
1455                 }
1456             }
1457         }
1458 
1459         return boosterAccumulatedRewards;
1460     }
1461 
1462     function getLastClaimForYielder(YielderSettings storage _yielderSettings, uint256 _tokenId) internal view returns (uint256) {
1463         uint256 lastClaimDate =  _yielderSettings._lastClaim[_tokenId];
1464         if (lastClaimDate == uint256(0)) {
1465             lastClaimDate = _yielderSettings._startTime;
1466         }
1467 
1468         return lastClaimDate;
1469     }
1470 
1471     function getLastClaim(address _yielderAddress, uint256 _tokenId) external whenNotPaused view returns (uint256) {
1472         YielderSettings storage yielderSettings = getYielderSettings(_yielderAddress);
1473 
1474         return getLastClaimForYielder(yielderSettings, _tokenId);
1475     }
1476 
1477     function getLastClaimForBooster(BoosterSettings storage _boosterSettings, uint256 _tokenId) view internal returns (uint256) {
1478         uint256 lastClaimDate = _boosterSettings._boosterStartDates[_tokenId];
1479 
1480         return lastClaimDate;
1481     }
1482 
1483 
1484     // UTILS
1485 
1486     function watchTransfer(address _from, address _to, uint256 _tokenId) external {
1487         getYielderSettings(msg.sender);
1488 
1489         if (_from == address(0)) {
1490             tokensOwnerShip[msg.sender][_to].add(_tokenId);
1491         } else {
1492             tokensOwnerShip[msg.sender][_to].add(_tokenId);
1493             if (tokensOwnerShip[msg.sender][_from].contains(_tokenId)) {
1494                 tokensOwnerShip[msg.sender][_from].remove(_tokenId);
1495                 if (tokensOwnerShip[msg.sender][_from].length() == 0) {
1496                     delete tokensOwnerShip[msg.sender][_from];
1497                 }
1498             }
1499         }
1500     }
1501 
1502     function watchBooster(address _collection, uint256[] calldata _tokenIds, uint256[] calldata _startDates) external {
1503         // boster shall send uint256(0) as start if removed
1504         BoosterSettings storage boosterSettings = getBoosterSettings(msg.sender);
1505 
1506         if (boosterSettings._appliesFor == _collection) {
1507             for (uint32 i = 0; i < _tokenIds.length; ++i) {
1508                 boosterSettings._boosterStartDates[_tokenIds[i]] = _startDates[i];
1509             }
1510         }
1511     }
1512 
1513     function claimTokens(uint256 _amount) internal {
1514         if (allowedPublicTokensMinted - _amount >= 0) {
1515             _mint(msg.sender, _amount);
1516             allowedPublicTokensMinted -= _amount;
1517         } else {
1518             IERC20(address(this)).transfer(msg.sender, _amount);
1519         }
1520     }
1521 
1522     function processTokenOwnerShip(address _contractAddress, uint256 _tokenId) internal {
1523         if (!tokensOwnerShip[_contractAddress][msg.sender].contains(_tokenId)) {
1524             address owner = IYielder(_contractAddress).ownerOf(_tokenId);
1525             if (owner == msg.sender) {
1526                 tokensOwnerShip[_contractAddress][msg.sender].add(_tokenId);
1527             }
1528         }
1529         require(tokensOwnerShip[_contractAddress][msg.sender].contains(_tokenId), "Not the owner of the token");
1530 
1531     }
1532 
1533     function reserveTeamTokens() external onlyOwner {
1534         uint256 currentDate = block.timestamp;
1535         _mint(msg.sender, foundersAndOthersAllowedMinting * (currentDate - foundersAndOthersLastClaim) / foundersLinearDistributionPeriod);
1536 
1537         foundersAndOthersLastClaim = block.timestamp;
1538     }
1539 
1540     function withdrawContractAdditionalTokens() external onlyOwner {
1541         IERC20(address(this)).transfer(msg.sender, IERC20(address(this)).balanceOf(address(this)));
1542     }
1543 
1544     function pause() external onlyOwner {
1545         _pause();
1546     }
1547 
1548     function unpause() external onlyOwner {
1549         _unpause();
1550     }
1551 
1552     function setPublicAllowedTokensToBeMinted(uint256 _amount) external onlyOwner {
1553         allowedPublicTokensMinted = _amount;
1554     }
1555 }