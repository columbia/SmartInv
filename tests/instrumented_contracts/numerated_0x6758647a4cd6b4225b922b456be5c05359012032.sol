1 // File: @openzeppelin/contracts@4.4.2/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts@4.4.2/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard math utilities missing in the Solidity language.
56  */
57 library Math {
58     /**
59      * @dev Returns the largest of two numbers.
60      */
61     function max(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a >= b ? a : b;
63     }
64 
65     /**
66      * @dev Returns the smallest of two numbers.
67      */
68     function min(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a < b ? a : b;
70     }
71 
72     /**
73      * @dev Returns the average of two numbers. The result is rounded towards
74      * zero.
75      */
76     function average(uint256 a, uint256 b) internal pure returns (uint256) {
77         // (a + b) / 2 can overflow.
78         return (a & b) + (a ^ b) / 2;
79     }
80 
81     /**
82      * @dev Returns the ceiling of the division of two numbers.
83      *
84      * This differs from standard division with `/` in that it rounds up instead
85      * of rounding down.
86      */
87     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
88         // (a + b - 1) / b can overflow on addition, so we distribute.
89         return a / b + (a % b == 0 ? 0 : 1);
90     }
91 }
92 
93 // File: @openzeppelin/contracts@4.4.2/utils/Arrays.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 
101 /**
102  * @dev Collection of functions related to array types.
103  */
104 library Arrays {
105     /**
106      * @dev Searches a sorted `array` and returns the first index that contains
107      * a value greater or equal to `element`. If no such index exists (i.e. all
108      * values in the array are strictly less than `element`), the array length is
109      * returned. Time complexity O(log n).
110      *
111      * `array` is expected to be sorted in ascending order, and to contain no
112      * repeated elements.
113      */
114     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
115         if (array.length == 0) {
116             return 0;
117         }
118 
119         uint256 low = 0;
120         uint256 high = array.length;
121 
122         while (low < high) {
123             uint256 mid = Math.average(low, high);
124 
125             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
126             // because Math.average rounds down (it does integer division with truncation).
127             if (array[mid] > element) {
128                 high = mid;
129             } else {
130                 low = mid + 1;
131             }
132         }
133 
134         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
135         if (low > 0 && array[low - 1] == element) {
136             return low - 1;
137         } else {
138             return low;
139         }
140     }
141 }
142 
143 // File: @openzeppelin/contracts@4.4.2/utils/Context.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 // File: @openzeppelin/contracts@4.4.2/security/Pausable.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @dev Contract module which allows children to implement an emergency stop
180  * mechanism that can be triggered by an authorized account.
181  *
182  * This module is used through inheritance. It will make available the
183  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
184  * the functions of your contract. Note that they will not be pausable by
185  * simply including this module, only once the modifiers are put in place.
186  */
187 abstract contract Pausable is Context {
188     /**
189      * @dev Emitted when the pause is triggered by `account`.
190      */
191     event Paused(address account);
192 
193     /**
194      * @dev Emitted when the pause is lifted by `account`.
195      */
196     event Unpaused(address account);
197 
198     bool private _paused;
199 
200     /**
201      * @dev Initializes the contract in unpaused state.
202      */
203     constructor() {
204         _paused = false;
205     }
206 
207     /**
208      * @dev Returns true if the contract is paused, and false otherwise.
209      */
210     function paused() public view virtual returns (bool) {
211         return _paused;
212     }
213 
214     /**
215      * @dev Modifier to make a function callable only when the contract is not paused.
216      *
217      * Requirements:
218      *
219      * - The contract must not be paused.
220      */
221     modifier whenNotPaused() {
222         require(!paused(), "Pausable: paused");
223         _;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is paused.
228      *
229      * Requirements:
230      *
231      * - The contract must be paused.
232      */
233     modifier whenPaused() {
234         require(paused(), "Pausable: not paused");
235         _;
236     }
237 
238     /**
239      * @dev Triggers stopped state.
240      *
241      * Requirements:
242      *
243      * - The contract must not be paused.
244      */
245     function _pause() internal virtual whenNotPaused {
246         _paused = true;
247         emit Paused(_msgSender());
248     }
249 
250     /**
251      * @dev Returns to normal state.
252      *
253      * Requirements:
254      *
255      * - The contract must be paused.
256      */
257     function _unpause() internal virtual whenPaused {
258         _paused = false;
259         emit Unpaused(_msgSender());
260     }
261 }
262 
263 // File: @openzeppelin/contracts@4.4.2/access/Ownable.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() {
292         _transferOwnership(_msgSender());
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _transferOwnership(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Internal function without access restriction.
333      */
334     function _transferOwnership(address newOwner) internal virtual {
335         address oldOwner = _owner;
336         _owner = newOwner;
337         emit OwnershipTransferred(oldOwner, newOwner);
338     }
339 }
340 
341 // File: @openzeppelin/contracts@4.4.2/token/ERC20/IERC20.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @dev Interface of the ERC20 standard as defined in the EIP.
350  */
351 interface IERC20 {
352     /**
353      * @dev Returns the amount of tokens in existence.
354      */
355     function totalSupply() external view returns (uint256);
356 
357     /**
358      * @dev Returns the amount of tokens owned by `account`.
359      */
360     function balanceOf(address account) external view returns (uint256);
361 
362     /**
363      * @dev Moves `amount` tokens from the caller's account to `recipient`.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transfer(address recipient, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Returns the remaining number of tokens that `spender` will be
373      * allowed to spend on behalf of `owner` through {transferFrom}. This is
374      * zero by default.
375      *
376      * This value changes when {approve} or {transferFrom} are called.
377      */
378     function allowance(address owner, address spender) external view returns (uint256);
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * IMPORTANT: Beware that changing an allowance with this method brings the risk
386      * that someone may use both the old and the new allowance by unfortunate
387      * transaction ordering. One possible solution to mitigate this race
388      * condition is to first reduce the spender's allowance to 0 and set the
389      * desired value afterwards:
390      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391      *
392      * Emits an {Approval} event.
393      */
394     function approve(address spender, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Moves `amount` tokens from `sender` to `recipient` using the
398      * allowance mechanism. `amount` is then deducted from the caller's
399      * allowance.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) external returns (bool);
410 
411     /**
412      * @dev Emitted when `value` tokens are moved from one account (`from`) to
413      * another (`to`).
414      *
415      * Note that `value` may be zero.
416      */
417     event Transfer(address indexed from, address indexed to, uint256 value);
418 
419     /**
420      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
421      * a call to {approve}. `value` is the new allowance.
422      */
423     event Approval(address indexed owner, address indexed spender, uint256 value);
424 }
425 
426 // File: @openzeppelin/contracts@4.4.2/token/ERC20/extensions/IERC20Metadata.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 
434 /**
435  * @dev Interface for the optional metadata functions from the ERC20 standard.
436  *
437  * _Available since v4.1._
438  */
439 interface IERC20Metadata is IERC20 {
440     /**
441      * @dev Returns the name of the token.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the symbol of the token.
447      */
448     function symbol() external view returns (string memory);
449 
450     /**
451      * @dev Returns the decimals places of the token.
452      */
453     function decimals() external view returns (uint8);
454 }
455 
456 // File: @openzeppelin/contracts@4.4.2/token/ERC20/ERC20.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 
465 
466 /**
467  * @dev Implementation of the {IERC20} interface.
468  *
469  * This implementation is agnostic to the way tokens are created. This means
470  * that a supply mechanism has to be added in a derived contract using {_mint}.
471  * For a generic mechanism see {ERC20PresetMinterPauser}.
472  *
473  * TIP: For a detailed writeup see our guide
474  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
475  * to implement supply mechanisms].
476  *
477  * We have followed general OpenZeppelin Contracts guidelines: functions revert
478  * instead returning `false` on failure. This behavior is nonetheless
479  * conventional and does not conflict with the expectations of ERC20
480  * applications.
481  *
482  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
483  * This allows applications to reconstruct the allowance for all accounts just
484  * by listening to said events. Other implementations of the EIP may not emit
485  * these events, as it isn't required by the specification.
486  *
487  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
488  * functions have been added to mitigate the well-known issues around setting
489  * allowances. See {IERC20-approve}.
490  */
491 contract ERC20 is Context, IERC20, IERC20Metadata {
492     mapping(address => uint256) private _balances;
493 
494     mapping(address => mapping(address => uint256)) private _allowances;
495 
496     uint256 private _totalSupply;
497 
498     string private _name;
499     string private _symbol;
500 
501     /**
502      * @dev Sets the values for {name} and {symbol}.
503      *
504      * The default value of {decimals} is 18. To select a different value for
505      * {decimals} you should overload it.
506      *
507      * All two of these values are immutable: they can only be set once during
508      * construction.
509      */
510     constructor(string memory name_, string memory symbol_) {
511         _name = name_;
512         _symbol = symbol_;
513     }
514 
515     /**
516      * @dev Returns the name of the token.
517      */
518     function name() public view virtual override returns (string memory) {
519         return _name;
520     }
521 
522     /**
523      * @dev Returns the symbol of the token, usually a shorter version of the
524      * name.
525      */
526     function symbol() public view virtual override returns (string memory) {
527         return _symbol;
528     }
529 
530     /**
531      * @dev Returns the number of decimals used to get its user representation.
532      * For example, if `decimals` equals `2`, a balance of `505` tokens should
533      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
534      *
535      * Tokens usually opt for a value of 18, imitating the relationship between
536      * Ether and Wei. This is the value {ERC20} uses, unless this function is
537      * overridden;
538      *
539      * NOTE: This information is only used for _display_ purposes: it in
540      * no way affects any of the arithmetic of the contract, including
541      * {IERC20-balanceOf} and {IERC20-transfer}.
542      */
543     function decimals() public view virtual override returns (uint8) {
544         return 18;
545     }
546 
547     /**
548      * @dev See {IERC20-totalSupply}.
549      */
550     function totalSupply() public view virtual override returns (uint256) {
551         return _totalSupply;
552     }
553 
554     /**
555      * @dev See {IERC20-balanceOf}.
556      */
557     function balanceOf(address account) public view virtual override returns (uint256) {
558         return _balances[account];
559     }
560 
561     /**
562      * @dev See {IERC20-transfer}.
563      *
564      * Requirements:
565      *
566      * - `recipient` cannot be the zero address.
567      * - the caller must have a balance of at least `amount`.
568      */
569     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
570         _transfer(_msgSender(), recipient, amount);
571         return true;
572     }
573 
574     /**
575      * @dev See {IERC20-allowance}.
576      */
577     function allowance(address owner, address spender) public view virtual override returns (uint256) {
578         return _allowances[owner][spender];
579     }
580 
581     /**
582      * @dev See {IERC20-approve}.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      */
588     function approve(address spender, uint256 amount) public virtual override returns (bool) {
589         _approve(_msgSender(), spender, amount);
590         return true;
591     }
592 
593     /**
594      * @dev See {IERC20-transferFrom}.
595      *
596      * Emits an {Approval} event indicating the updated allowance. This is not
597      * required by the EIP. See the note at the beginning of {ERC20}.
598      *
599      * Requirements:
600      *
601      * - `sender` and `recipient` cannot be the zero address.
602      * - `sender` must have a balance of at least `amount`.
603      * - the caller must have allowance for ``sender``'s tokens of at least
604      * `amount`.
605      */
606     function transferFrom(
607         address sender,
608         address recipient,
609         uint256 amount
610     ) public virtual override returns (bool) {
611         _transfer(sender, recipient, amount);
612 
613         uint256 currentAllowance = _allowances[sender][_msgSender()];
614         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
615         unchecked {
616             _approve(sender, _msgSender(), currentAllowance - amount);
617         }
618 
619         return true;
620     }
621 
622     /**
623      * @dev Atomically increases the allowance granted to `spender` by the caller.
624      *
625      * This is an alternative to {approve} that can be used as a mitigation for
626      * problems described in {IERC20-approve}.
627      *
628      * Emits an {Approval} event indicating the updated allowance.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      */
634     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
636         return true;
637     }
638 
639     /**
640      * @dev Atomically decreases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      * - `spender` must have allowance for the caller of at least
651      * `subtractedValue`.
652      */
653     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
654         uint256 currentAllowance = _allowances[_msgSender()][spender];
655         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
656         unchecked {
657             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
658         }
659 
660         return true;
661     }
662 
663     /**
664      * @dev Moves `amount` of tokens from `sender` to `recipient`.
665      *
666      * This internal function is equivalent to {transfer}, and can be used to
667      * e.g. implement automatic token fees, slashing mechanisms, etc.
668      *
669      * Emits a {Transfer} event.
670      *
671      * Requirements:
672      *
673      * - `sender` cannot be the zero address.
674      * - `recipient` cannot be the zero address.
675      * - `sender` must have a balance of at least `amount`.
676      */
677     function _transfer(
678         address sender,
679         address recipient,
680         uint256 amount
681     ) internal virtual {
682         require(sender != address(0), "ERC20: transfer from the zero address");
683         require(recipient != address(0), "ERC20: transfer to the zero address");
684 
685         _beforeTokenTransfer(sender, recipient, amount);
686 
687         uint256 senderBalance = _balances[sender];
688         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
689         unchecked {
690             _balances[sender] = senderBalance - amount;
691         }
692         _balances[recipient] += amount;
693 
694         emit Transfer(sender, recipient, amount);
695 
696         _afterTokenTransfer(sender, recipient, amount);
697     }
698 
699     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
700      * the total supply.
701      *
702      * Emits a {Transfer} event with `from` set to the zero address.
703      *
704      * Requirements:
705      *
706      * - `account` cannot be the zero address.
707      */
708     function _mint(address account, uint256 amount) internal virtual {
709         require(account != address(0), "ERC20: mint to the zero address");
710 
711         _beforeTokenTransfer(address(0), account, amount);
712 
713         _totalSupply += amount;
714         _balances[account] += amount;
715         emit Transfer(address(0), account, amount);
716 
717         _afterTokenTransfer(address(0), account, amount);
718     }
719 
720     /**
721      * @dev Destroys `amount` tokens from `account`, reducing the
722      * total supply.
723      *
724      * Emits a {Transfer} event with `to` set to the zero address.
725      *
726      * Requirements:
727      *
728      * - `account` cannot be the zero address.
729      * - `account` must have at least `amount` tokens.
730      */
731     function _burn(address account, uint256 amount) internal virtual {
732         require(account != address(0), "ERC20: burn from the zero address");
733 
734         _beforeTokenTransfer(account, address(0), amount);
735 
736         uint256 accountBalance = _balances[account];
737         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
738         unchecked {
739             _balances[account] = accountBalance - amount;
740         }
741         _totalSupply -= amount;
742 
743         emit Transfer(account, address(0), amount);
744 
745         _afterTokenTransfer(account, address(0), amount);
746     }
747 
748     /**
749      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
750      *
751      * This internal function is equivalent to `approve`, and can be used to
752      * e.g. set automatic allowances for certain subsystems, etc.
753      *
754      * Emits an {Approval} event.
755      *
756      * Requirements:
757      *
758      * - `owner` cannot be the zero address.
759      * - `spender` cannot be the zero address.
760      */
761     function _approve(
762         address owner,
763         address spender,
764         uint256 amount
765     ) internal virtual {
766         require(owner != address(0), "ERC20: approve from the zero address");
767         require(spender != address(0), "ERC20: approve to the zero address");
768 
769         _allowances[owner][spender] = amount;
770         emit Approval(owner, spender, amount);
771     }
772 
773     /**
774      * @dev Hook that is called before any transfer of tokens. This includes
775      * minting and burning.
776      *
777      * Calling conditions:
778      *
779      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
780      * will be transferred to `to`.
781      * - when `from` is zero, `amount` tokens will be minted for `to`.
782      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
783      * - `from` and `to` are never both zero.
784      *
785      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
786      */
787     function _beforeTokenTransfer(
788         address from,
789         address to,
790         uint256 amount
791     ) internal virtual {}
792 
793     /**
794      * @dev Hook that is called after any transfer of tokens. This includes
795      * minting and burning.
796      *
797      * Calling conditions:
798      *
799      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
800      * has been transferred to `to`.
801      * - when `from` is zero, `amount` tokens have been minted for `to`.
802      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
803      * - `from` and `to` are never both zero.
804      *
805      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
806      */
807     function _afterTokenTransfer(
808         address from,
809         address to,
810         uint256 amount
811     ) internal virtual {}
812 }
813 
814 // File: @openzeppelin/contracts@4.4.2/token/ERC20/extensions/ERC20Snapshot.sol
815 
816 
817 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 
822 
823 
824 /**
825  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
826  * total supply at the time are recorded for later access.
827  *
828  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
829  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
830  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
831  * used to create an efficient ERC20 forking mechanism.
832  *
833  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
834  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
835  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
836  * and the account address.
837  *
838  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
839  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
840  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
841  *
842  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
843  * alternative consider {ERC20Votes}.
844  *
845  * ==== Gas Costs
846  *
847  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
848  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
849  * smaller since identical balances in subsequent snapshots are stored as a single entry.
850  *
851  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
852  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
853  * transfers will have normal cost until the next snapshot, and so on.
854  */
855 
856 abstract contract ERC20Snapshot is ERC20 {
857     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
858     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
859 
860     using Arrays for uint256[];
861     using Counters for Counters.Counter;
862 
863     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
864     // Snapshot struct, but that would impede usage of functions that work on an array.
865     struct Snapshots {
866         uint256[] ids;
867         uint256[] values;
868     }
869 
870     mapping(address => Snapshots) private _accountBalanceSnapshots;
871     Snapshots private _totalSupplySnapshots;
872 
873     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
874     Counters.Counter private _currentSnapshotId;
875 
876     /**
877      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
878      */
879     event Snapshot(uint256 id);
880 
881     /**
882      * @dev Creates a new snapshot and returns its snapshot id.
883      *
884      * Emits a {Snapshot} event that contains the same id.
885      *
886      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
887      * set of accounts, for example using {AccessControl}, or it may be open to the public.
888      *
889      * [WARNING]
890      * ====
891      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
892      * you must consider that it can potentially be used by attackers in two ways.
893      *
894      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
895      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
896      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
897      * section above.
898      *
899      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
900      * ====
901      */
902     function _snapshot() internal virtual returns (uint256) {
903         _currentSnapshotId.increment();
904 
905         uint256 currentId = _getCurrentSnapshotId();
906         emit Snapshot(currentId);
907         return currentId;
908     }
909 
910     /**
911      * @dev Get the current snapshotId
912      */
913     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
914         return _currentSnapshotId.current();
915     }
916 
917     /**
918      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
919      */
920     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
921         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
922 
923         return snapshotted ? value : balanceOf(account);
924     }
925 
926     /**
927      * @dev Retrieves the total supply at the time `snapshotId` was created.
928      */
929     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
930         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
931 
932         return snapshotted ? value : totalSupply();
933     }
934 
935     // Update balance and/or total supply snapshots before the values are modified. This is implemented
936     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
937     function _beforeTokenTransfer(
938         address from,
939         address to,
940         uint256 amount
941     ) internal virtual override {
942         super._beforeTokenTransfer(from, to, amount);
943 
944         if (from == address(0)) {
945             // mint
946             _updateAccountSnapshot(to);
947             _updateTotalSupplySnapshot();
948         } else if (to == address(0)) {
949             // burn
950             _updateAccountSnapshot(from);
951             _updateTotalSupplySnapshot();
952         } else {
953             // transfer
954             _updateAccountSnapshot(from);
955             _updateAccountSnapshot(to);
956         }
957     }
958 
959     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
960         require(snapshotId > 0, "ERC20Snapshot: id is 0");
961         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
962 
963         // When a valid snapshot is queried, there are three possibilities:
964         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
965         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
966         //  to this id is the current one.
967         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
968         //  requested id, and its value is the one to return.
969         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
970         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
971         //  larger than the requested one.
972         //
973         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
974         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
975         // exactly this.
976 
977         uint256 index = snapshots.ids.findUpperBound(snapshotId);
978 
979         if (index == snapshots.ids.length) {
980             return (false, 0);
981         } else {
982             return (true, snapshots.values[index]);
983         }
984     }
985 
986     function _updateAccountSnapshot(address account) private {
987         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
988     }
989 
990     function _updateTotalSupplySnapshot() private {
991         _updateSnapshot(_totalSupplySnapshots, totalSupply());
992     }
993 
994     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
995         uint256 currentId = _getCurrentSnapshotId();
996         if (_lastSnapshotId(snapshots.ids) < currentId) {
997             snapshots.ids.push(currentId);
998             snapshots.values.push(currentValue);
999         }
1000     }
1001 
1002     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1003         if (ids.length == 0) {
1004             return 0;
1005         } else {
1006             return ids[ids.length - 1];
1007         }
1008     }
1009 }
1010 
1011 // File: contract-49bb5e3adf.sol
1012 
1013 
1014 pragma solidity ^0.8.2;
1015 
1016 
1017 
1018 
1019 
1020 /// @custom:security-contact security@cyberlete.net
1021 contract Cyberlete is ERC20, ERC20Snapshot, Ownable, Pausable {
1022     constructor() ERC20("Cyberlete", "LEET") {
1023         _mint(msg.sender, 100000000000 * 10 ** decimals());
1024     }
1025 
1026     function snapshot() public onlyOwner {
1027         _snapshot();
1028     }
1029 
1030     function pause() public onlyOwner {
1031         _pause();
1032     }
1033 
1034     function unpause() public onlyOwner {
1035         _unpause();
1036     }
1037 
1038     function _beforeTokenTransfer(address from, address to, uint256 amount)
1039         internal
1040         whenNotPaused
1041         override(ERC20, ERC20Snapshot)
1042     {
1043         super._beforeTokenTransfer(from, to, amount);
1044     }
1045 }