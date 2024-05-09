1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 // 
7 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // 
87 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
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
110 // 
111 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
112 /**
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
131 
132 // 
133 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
134 /**
135  * @dev Implementation of the {IERC20} interface.
136  *
137  * This implementation is agnostic to the way tokens are created. This means
138  * that a supply mechanism has to be added in a derived contract using {_mint}.
139  * For a generic mechanism see {ERC20PresetMinterPauser}.
140  *
141  * TIP: For a detailed writeup see our guide
142  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
143  * to implement supply mechanisms].
144  *
145  * We have followed general OpenZeppelin Contracts guidelines: functions revert
146  * instead returning `false` on failure. This behavior is nonetheless
147  * conventional and does not conflict with the expectations of ERC20
148  * applications.
149  *
150  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
151  * This allows applications to reconstruct the allowance for all accounts just
152  * by listening to said events. Other implementations of the EIP may not emit
153  * these events, as it isn't required by the specification.
154  *
155  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
156  * functions have been added to mitigate the well-known issues around setting
157  * allowances. See {IERC20-approve}.
158  */
159 contract ERC20 is Context, IERC20, IERC20Metadata {
160     mapping(address => uint256) private _balances;
161 
162     mapping(address => mapping(address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165 
166     string private _name;
167     string private _symbol;
168 
169     /**
170      * @dev Sets the values for {name} and {symbol}.
171      *
172      * The default value of {decimals} is 18. To select a different value for
173      * {decimals} you should overload it.
174      *
175      * All two of these values are immutable: they can only be set once during
176      * construction.
177      */
178     constructor(string memory name_, string memory symbol_) {
179         _name = name_;
180         _symbol = symbol_;
181     }
182 
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() public view virtual override returns (string memory) {
187         return _name;
188     }
189 
190     /**
191      * @dev Returns the symbol of the token, usually a shorter version of the
192      * name.
193      */
194     function symbol() public view virtual override returns (string memory) {
195         return _symbol;
196     }
197 
198     /**
199      * @dev Returns the number of decimals used to get its user representation.
200      * For example, if `decimals` equals `2`, a balance of `505` tokens should
201      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
202      *
203      * Tokens usually opt for a value of 18, imitating the relationship between
204      * Ether and Wei. This is the value {ERC20} uses, unless this function is
205      * overridden;
206      *
207      * NOTE: This information is only used for _display_ purposes: it in
208      * no way affects any of the arithmetic of the contract, including
209      * {IERC20-balanceOf} and {IERC20-transfer}.
210      */
211     function decimals() public view virtual override returns (uint8) {
212         return 18;
213     }
214 
215     /**
216      * @dev See {IERC20-totalSupply}.
217      */
218     function totalSupply() public view virtual override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev See {IERC20-balanceOf}.
224      */
225     function balanceOf(address account) public view virtual override returns (uint256) {
226         return _balances[account];
227     }
228 
229     /**
230      * @dev See {IERC20-transfer}.
231      *
232      * Requirements:
233      *
234      * - `recipient` cannot be the zero address.
235      * - the caller must have a balance of at least `amount`.
236      */
237     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-allowance}.
244      */
245     function allowance(address owner, address spender) public view virtual override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     /**
250      * @dev See {IERC20-approve}.
251      *
252      * Requirements:
253      *
254      * - `spender` cannot be the zero address.
255      */
256     function approve(address spender, uint256 amount) public virtual override returns (bool) {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-transferFrom}.
263      *
264      * Emits an {Approval} event indicating the updated allowance. This is not
265      * required by the EIP. See the note at the beginning of {ERC20}.
266      *
267      * Requirements:
268      *
269      * - `sender` and `recipient` cannot be the zero address.
270      * - `sender` must have a balance of at least `amount`.
271      * - the caller must have allowance for ``sender``'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public virtual override returns (bool) {
279         _transfer(sender, recipient, amount);
280 
281         uint256 currentAllowance = _allowances[sender][_msgSender()];
282         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
283         unchecked {
284             _approve(sender, _msgSender(), currentAllowance - amount);
285         }
286 
287         return true;
288     }
289 
290     /**
291      * @dev Atomically increases the allowance granted to `spender` by the caller.
292      *
293      * This is an alternative to {approve} that can be used as a mitigation for
294      * problems described in {IERC20-approve}.
295      *
296      * Emits an {Approval} event indicating the updated allowance.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
303         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically decreases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      * - `spender` must have allowance for the caller of at least
319      * `subtractedValue`.
320      */
321     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
322         uint256 currentAllowance = _allowances[_msgSender()][spender];
323         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
324         unchecked {
325             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
326         }
327 
328         return true;
329     }
330 
331     /**
332      * @dev Moves `amount` of tokens from `sender` to `recipient`.
333      *
334      * This internal function is equivalent to {transfer}, and can be used to
335      * e.g. implement automatic token fees, slashing mechanisms, etc.
336      *
337      * Emits a {Transfer} event.
338      *
339      * Requirements:
340      *
341      * - `sender` cannot be the zero address.
342      * - `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      */
345     function _transfer(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) internal virtual {
350         require(sender != address(0), "ERC20: transfer from the zero address");
351         require(recipient != address(0), "ERC20: transfer to the zero address");
352 
353         _beforeTokenTransfer(sender, recipient, amount);
354 
355         uint256 senderBalance = _balances[sender];
356         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
357         unchecked {
358             _balances[sender] = senderBalance - amount;
359         }
360         _balances[recipient] += amount;
361 
362         emit Transfer(sender, recipient, amount);
363 
364         _afterTokenTransfer(sender, recipient, amount);
365     }
366 
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: mint to the zero address");
378 
379         _beforeTokenTransfer(address(0), account, amount);
380 
381         _totalSupply += amount;
382         _balances[account] += amount;
383         emit Transfer(address(0), account, amount);
384 
385         _afterTokenTransfer(address(0), account, amount);
386     }
387 
388     /**
389      * @dev Destroys `amount` tokens from `account`, reducing the
390      * total supply.
391      *
392      * Emits a {Transfer} event with `to` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      * - `account` must have at least `amount` tokens.
398      */
399     function _burn(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: burn from the zero address");
401 
402         _beforeTokenTransfer(account, address(0), amount);
403 
404         uint256 accountBalance = _balances[account];
405         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
406         unchecked {
407             _balances[account] = accountBalance - amount;
408         }
409         _totalSupply -= amount;
410 
411         emit Transfer(account, address(0), amount);
412 
413         _afterTokenTransfer(account, address(0), amount);
414     }
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
418      *
419      * This internal function is equivalent to `approve`, and can be used to
420      * e.g. set automatic allowances for certain subsystems, etc.
421      *
422      * Emits an {Approval} event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(
430         address owner,
431         address spender,
432         uint256 amount
433     ) internal virtual {
434         require(owner != address(0), "ERC20: approve from the zero address");
435         require(spender != address(0), "ERC20: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440 
441     /**
442      * @dev Hook that is called before any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * will be transferred to `to`.
449      * - when `from` is zero, `amount` tokens will be minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _beforeTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 
461     /**
462      * @dev Hook that is called after any transfer of tokens. This includes
463      * minting and burning.
464      *
465      * Calling conditions:
466      *
467      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
468      * has been transferred to `to`.
469      * - when `from` is zero, `amount` tokens have been minted for `to`.
470      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
471      * - `from` and `to` are never both zero.
472      *
473      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
474      */
475     function _afterTokenTransfer(
476         address from,
477         address to,
478         uint256 amount
479     ) internal virtual {}
480 }
481 
482 // 
483 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
484 /**
485  * @dev Extension of {ERC20} that allows token holders to destroy both their own
486  * tokens and those that they have an allowance for, in a way that can be
487  * recognized off-chain (via event analysis).
488  */
489 abstract contract ERC20Burnable is Context, ERC20 {
490     /**
491      * @dev Destroys `amount` tokens from the caller.
492      *
493      * See {ERC20-_burn}.
494      */
495     function burn(uint256 amount) public virtual {
496         _burn(_msgSender(), amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
501      * allowance.
502      *
503      * See {ERC20-_burn} and {ERC20-allowance}.
504      *
505      * Requirements:
506      *
507      * - the caller must have allowance for ``accounts``'s tokens of at least
508      * `amount`.
509      */
510     function burnFrom(address account, uint256 amount) public virtual {
511         uint256 currentAllowance = allowance(account, _msgSender());
512         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
513         unchecked {
514             _approve(account, _msgSender(), currentAllowance - amount);
515         }
516         _burn(account, amount);
517     }
518 }
519 
520 // 
521 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
522 /**
523  * @dev Standard math utilities missing in the Solidity language.
524  */
525 library Math {
526     /**
527      * @dev Returns the largest of two numbers.
528      */
529     function max(uint256 a, uint256 b) internal pure returns (uint256) {
530         return a >= b ? a : b;
531     }
532 
533     /**
534      * @dev Returns the smallest of two numbers.
535      */
536     function min(uint256 a, uint256 b) internal pure returns (uint256) {
537         return a < b ? a : b;
538     }
539 
540     /**
541      * @dev Returns the average of two numbers. The result is rounded towards
542      * zero.
543      */
544     function average(uint256 a, uint256 b) internal pure returns (uint256) {
545         // (a + b) / 2 can overflow.
546         return (a & b) + (a ^ b) / 2;
547     }
548 
549     /**
550      * @dev Returns the ceiling of the division of two numbers.
551      *
552      * This differs from standard division with `/` in that it rounds up instead
553      * of rounding down.
554      */
555     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
556         // (a + b - 1) / b can overflow on addition, so we distribute.
557         return a / b + (a % b == 0 ? 0 : 1);
558     }
559 }
560 
561 // 
562 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
563 /**
564  * @dev Collection of functions related to array types.
565  */
566 library Arrays {
567     /**
568      * @dev Searches a sorted `array` and returns the first index that contains
569      * a value greater or equal to `element`. If no such index exists (i.e. all
570      * values in the array are strictly less than `element`), the array length is
571      * returned. Time complexity O(log n).
572      *
573      * `array` is expected to be sorted in ascending order, and to contain no
574      * repeated elements.
575      */
576     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
577         if (array.length == 0) {
578             return 0;
579         }
580 
581         uint256 low = 0;
582         uint256 high = array.length;
583 
584         while (low < high) {
585             uint256 mid = Math.average(low, high);
586 
587             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
588             // because Math.average rounds down (it does integer division with truncation).
589             if (array[mid] > element) {
590                 high = mid;
591             } else {
592                 low = mid + 1;
593             }
594         }
595 
596         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
597         if (low > 0 && array[low - 1] == element) {
598             return low - 1;
599         } else {
600             return low;
601         }
602     }
603 }
604 
605 // 
606 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
607 /**
608  * @title Counters
609  * @author Matt Condon (@shrugs)
610  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
611  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
612  *
613  * Include with `using Counters for Counters.Counter;`
614  */
615 library Counters {
616     struct Counter {
617         // This variable should never be directly accessed by users of the library: interactions must be restricted to
618         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
619         // this feature: see https://github.com/ethereum/solidity/issues/4637
620         uint256 _value; // default: 0
621     }
622 
623     function current(Counter storage counter) internal view returns (uint256) {
624         return counter._value;
625     }
626 
627     function increment(Counter storage counter) internal {
628         unchecked {
629             counter._value += 1;
630         }
631     }
632 
633     function decrement(Counter storage counter) internal {
634         uint256 value = counter._value;
635         require(value > 0, "Counter: decrement overflow");
636         unchecked {
637             counter._value = value - 1;
638         }
639     }
640 
641     function reset(Counter storage counter) internal {
642         counter._value = 0;
643     }
644 }
645 
646 // 
647 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
648 /**
649  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
650  * total supply at the time are recorded for later access.
651  *
652  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
653  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
654  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
655  * used to create an efficient ERC20 forking mechanism.
656  *
657  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
658  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
659  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
660  * and the account address.
661  *
662  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
663  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
664  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
665  *
666  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
667  * alternative consider {ERC20Votes}.
668  *
669  * ==== Gas Costs
670  *
671  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
672  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
673  * smaller since identical balances in subsequent snapshots are stored as a single entry.
674  *
675  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
676  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
677  * transfers will have normal cost until the next snapshot, and so on.
678  */
679 abstract contract ERC20Snapshot is ERC20 {
680     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
681     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
682 
683     using Arrays for uint256[];
684     using Counters for Counters.Counter;
685 
686     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
687     // Snapshot struct, but that would impede usage of functions that work on an array.
688     struct Snapshots {
689         uint256[] ids;
690         uint256[] values;
691     }
692 
693     mapping(address => Snapshots) private _accountBalanceSnapshots;
694     Snapshots private _totalSupplySnapshots;
695 
696     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
697     Counters.Counter private _currentSnapshotId;
698 
699     /**
700      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
701      */
702     event Snapshot(uint256 id);
703 
704     /**
705      * @dev Creates a new snapshot and returns its snapshot id.
706      *
707      * Emits a {Snapshot} event that contains the same id.
708      *
709      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
710      * set of accounts, for example using {AccessControl}, or it may be open to the public.
711      *
712      * [WARNING]
713      * ====
714      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
715      * you must consider that it can potentially be used by attackers in two ways.
716      *
717      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
718      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
719      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
720      * section above.
721      *
722      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
723      * ====
724      */
725     function _snapshot() internal virtual returns (uint256) {
726         _currentSnapshotId.increment();
727 
728         uint256 currentId = _getCurrentSnapshotId();
729         emit Snapshot(currentId);
730         return currentId;
731     }
732 
733     /**
734      * @dev Get the current snapshotId
735      */
736     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
737         return _currentSnapshotId.current();
738     }
739 
740     /**
741      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
742      */
743     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
744         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
745 
746         return snapshotted ? value : balanceOf(account);
747     }
748 
749     /**
750      * @dev Retrieves the total supply at the time `snapshotId` was created.
751      */
752     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
753         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
754 
755         return snapshotted ? value : totalSupply();
756     }
757 
758     // Update balance and/or total supply snapshots before the values are modified. This is implemented
759     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
760     function _beforeTokenTransfer(
761         address from,
762         address to,
763         uint256 amount
764     ) internal virtual override {
765         super._beforeTokenTransfer(from, to, amount);
766 
767         if (from == address(0)) {
768             // mint
769             _updateAccountSnapshot(to);
770             _updateTotalSupplySnapshot();
771         } else if (to == address(0)) {
772             // burn
773             _updateAccountSnapshot(from);
774             _updateTotalSupplySnapshot();
775         } else {
776             // transfer
777             _updateAccountSnapshot(from);
778             _updateAccountSnapshot(to);
779         }
780     }
781 
782     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
783         require(snapshotId > 0, "ERC20Snapshot: id is 0");
784         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
785 
786         // When a valid snapshot is queried, there are three possibilities:
787         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
788         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
789         //  to this id is the current one.
790         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
791         //  requested id, and its value is the one to return.
792         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
793         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
794         //  larger than the requested one.
795         //
796         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
797         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
798         // exactly this.
799 
800         uint256 index = snapshots.ids.findUpperBound(snapshotId);
801 
802         if (index == snapshots.ids.length) {
803             return (false, 0);
804         } else {
805             return (true, snapshots.values[index]);
806         }
807     }
808 
809     function _updateAccountSnapshot(address account) private {
810         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
811     }
812 
813     function _updateTotalSupplySnapshot() private {
814         _updateSnapshot(_totalSupplySnapshots, totalSupply());
815     }
816 
817     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
818         uint256 currentId = _getCurrentSnapshotId();
819         if (_lastSnapshotId(snapshots.ids) < currentId) {
820             snapshots.ids.push(currentId);
821             snapshots.values.push(currentValue);
822         }
823     }
824 
825     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
826         if (ids.length == 0) {
827             return 0;
828         } else {
829             return ids[ids.length - 1];
830         }
831     }
832 }
833 
834 // 
835 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
836 /**
837  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
838  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
839  *
840  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
841  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
842  * need to send a transaction, and thus is not required to hold Ether at all.
843  */
844 interface IERC20Permit {
845     /**
846      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
847      * given ``owner``'s signed approval.
848      *
849      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
850      * ordering also apply here.
851      *
852      * Emits an {Approval} event.
853      *
854      * Requirements:
855      *
856      * - `spender` cannot be the zero address.
857      * - `deadline` must be a timestamp in the future.
858      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
859      * over the EIP712-formatted function arguments.
860      * - the signature must use ``owner``'s current nonce (see {nonces}).
861      *
862      * For more information on the signature format, see the
863      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
864      * section].
865      */
866     function permit(
867         address owner,
868         address spender,
869         uint256 value,
870         uint256 deadline,
871         uint8 v,
872         bytes32 r,
873         bytes32 s
874     ) external;
875 
876     /**
877      * @dev Returns the current nonce for `owner`. This value must be
878      * included whenever a signature is generated for {permit}.
879      *
880      * Every successful call to {permit} increases ``owner``'s nonce by one. This
881      * prevents a signature from being used multiple times.
882      */
883     function nonces(address owner) external view returns (uint256);
884 
885     /**
886      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
887      */
888     // solhint-disable-next-line func-name-mixedcase
889     function DOMAIN_SEPARATOR() external view returns (bytes32);
890 }
891 
892 // 
893 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
894 /**
895  * @dev String operations.
896  */
897 library Strings {
898     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
899 
900     /**
901      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
902      */
903     function toString(uint256 value) internal pure returns (string memory) {
904         // Inspired by OraclizeAPI's implementation - MIT licence
905         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
906 
907         if (value == 0) {
908             return "0";
909         }
910         uint256 temp = value;
911         uint256 digits;
912         while (temp != 0) {
913             digits++;
914             temp /= 10;
915         }
916         bytes memory buffer = new bytes(digits);
917         while (value != 0) {
918             digits -= 1;
919             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
920             value /= 10;
921         }
922         return string(buffer);
923     }
924 
925     /**
926      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
927      */
928     function toHexString(uint256 value) internal pure returns (string memory) {
929         if (value == 0) {
930             return "0x00";
931         }
932         uint256 temp = value;
933         uint256 length = 0;
934         while (temp != 0) {
935             length++;
936             temp >>= 8;
937         }
938         return toHexString(value, length);
939     }
940 
941     /**
942      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
943      */
944     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
945         bytes memory buffer = new bytes(2 * length + 2);
946         buffer[0] = "0";
947         buffer[1] = "x";
948         for (uint256 i = 2 * length + 1; i > 1; --i) {
949             buffer[i] = _HEX_SYMBOLS[value & 0xf];
950             value >>= 4;
951         }
952         require(value == 0, "Strings: hex length insufficient");
953         return string(buffer);
954     }
955 }
956 
957 // 
958 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
959 /**
960  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
961  *
962  * These functions can be used to verify that a message was signed by the holder
963  * of the private keys of a given address.
964  */
965 library ECDSA {
966     enum RecoverError {
967         NoError,
968         InvalidSignature,
969         InvalidSignatureLength,
970         InvalidSignatureS,
971         InvalidSignatureV
972     }
973 
974     function _throwError(RecoverError error) private pure {
975         if (error == RecoverError.NoError) {
976             return; // no error: do nothing
977         } else if (error == RecoverError.InvalidSignature) {
978             revert("ECDSA: invalid signature");
979         } else if (error == RecoverError.InvalidSignatureLength) {
980             revert("ECDSA: invalid signature length");
981         } else if (error == RecoverError.InvalidSignatureS) {
982             revert("ECDSA: invalid signature 's' value");
983         } else if (error == RecoverError.InvalidSignatureV) {
984             revert("ECDSA: invalid signature 'v' value");
985         }
986     }
987 
988     /**
989      * @dev Returns the address that signed a hashed message (`hash`) with
990      * `signature` or error string. This address can then be used for verification purposes.
991      *
992      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
993      * this function rejects them by requiring the `s` value to be in the lower
994      * half order, and the `v` value to be either 27 or 28.
995      *
996      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
997      * verification to be secure: it is possible to craft signatures that
998      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
999      * this is by receiving a hash of the original message (which may otherwise
1000      * be too long), and then calling {toEthSignedMessageHash} on it.
1001      *
1002      * Documentation for signature generation:
1003      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1004      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1005      *
1006      * _Available since v4.3._
1007      */
1008     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1009         // Check the signature length
1010         // - case 65: r,s,v signature (standard)
1011         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1012         if (signature.length == 65) {
1013             bytes32 r;
1014             bytes32 s;
1015             uint8 v;
1016             // ecrecover takes the signature parameters, and the only way to get them
1017             // currently is to use assembly.
1018             assembly {
1019                 r := mload(add(signature, 0x20))
1020                 s := mload(add(signature, 0x40))
1021                 v := byte(0, mload(add(signature, 0x60)))
1022             }
1023             return tryRecover(hash, v, r, s);
1024         } else if (signature.length == 64) {
1025             bytes32 r;
1026             bytes32 vs;
1027             // ecrecover takes the signature parameters, and the only way to get them
1028             // currently is to use assembly.
1029             assembly {
1030                 r := mload(add(signature, 0x20))
1031                 vs := mload(add(signature, 0x40))
1032             }
1033             return tryRecover(hash, r, vs);
1034         } else {
1035             return (address(0), RecoverError.InvalidSignatureLength);
1036         }
1037     }
1038 
1039     /**
1040      * @dev Returns the address that signed a hashed message (`hash`) with
1041      * `signature`. This address can then be used for verification purposes.
1042      *
1043      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1044      * this function rejects them by requiring the `s` value to be in the lower
1045      * half order, and the `v` value to be either 27 or 28.
1046      *
1047      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1048      * verification to be secure: it is possible to craft signatures that
1049      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1050      * this is by receiving a hash of the original message (which may otherwise
1051      * be too long), and then calling {toEthSignedMessageHash} on it.
1052      */
1053     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1054         (address recovered, RecoverError error) = tryRecover(hash, signature);
1055         _throwError(error);
1056         return recovered;
1057     }
1058 
1059     /**
1060      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1061      *
1062      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1063      *
1064      * _Available since v4.3._
1065      */
1066     function tryRecover(
1067         bytes32 hash,
1068         bytes32 r,
1069         bytes32 vs
1070     ) internal pure returns (address, RecoverError) {
1071         bytes32 s;
1072         uint8 v;
1073         assembly {
1074             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1075             v := add(shr(255, vs), 27)
1076         }
1077         return tryRecover(hash, v, r, s);
1078     }
1079 
1080     /**
1081      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1082      *
1083      * _Available since v4.2._
1084      */
1085     function recover(
1086         bytes32 hash,
1087         bytes32 r,
1088         bytes32 vs
1089     ) internal pure returns (address) {
1090         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1091         _throwError(error);
1092         return recovered;
1093     }
1094 
1095     /**
1096      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1097      * `r` and `s` signature fields separately.
1098      *
1099      * _Available since v4.3._
1100      */
1101     function tryRecover(
1102         bytes32 hash,
1103         uint8 v,
1104         bytes32 r,
1105         bytes32 s
1106     ) internal pure returns (address, RecoverError) {
1107         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1108         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1109         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1110         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1111         //
1112         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1113         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1114         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1115         // these malleable signatures as well.
1116         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1117             return (address(0), RecoverError.InvalidSignatureS);
1118         }
1119         if (v != 27 && v != 28) {
1120             return (address(0), RecoverError.InvalidSignatureV);
1121         }
1122 
1123         // If the signature is valid (and not malleable), return the signer address
1124         address signer = ecrecover(hash, v, r, s);
1125         if (signer == address(0)) {
1126             return (address(0), RecoverError.InvalidSignature);
1127         }
1128 
1129         return (signer, RecoverError.NoError);
1130     }
1131 
1132     /**
1133      * @dev Overload of {ECDSA-recover} that receives the `v`,
1134      * `r` and `s` signature fields separately.
1135      */
1136     function recover(
1137         bytes32 hash,
1138         uint8 v,
1139         bytes32 r,
1140         bytes32 s
1141     ) internal pure returns (address) {
1142         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1143         _throwError(error);
1144         return recovered;
1145     }
1146 
1147     /**
1148      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1149      * produces hash corresponding to the one signed with the
1150      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1151      * JSON-RPC method as part of EIP-191.
1152      *
1153      * See {recover}.
1154      */
1155     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1156         // 32 is the length in bytes of hash,
1157         // enforced by the type signature above
1158         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1159     }
1160 
1161     /**
1162      * @dev Returns an Ethereum Signed Message, created from `s`. This
1163      * produces hash corresponding to the one signed with the
1164      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1165      * JSON-RPC method as part of EIP-191.
1166      *
1167      * See {recover}.
1168      */
1169     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1170         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1171     }
1172 
1173     /**
1174      * @dev Returns an Ethereum Signed Typed Data, created from a
1175      * `domainSeparator` and a `structHash`. This produces hash corresponding
1176      * to the one signed with the
1177      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1178      * JSON-RPC method as part of EIP-712.
1179      *
1180      * See {recover}.
1181      */
1182     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1183         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1184     }
1185 }
1186 
1187 // 
1188 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1189 /**
1190  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1191  *
1192  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1193  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1194  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1195  *
1196  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1197  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1198  * ({_hashTypedDataV4}).
1199  *
1200  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1201  * the chain id to protect against replay attacks on an eventual fork of the chain.
1202  *
1203  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1204  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1205  *
1206  * _Available since v3.4._
1207  */
1208 abstract contract EIP712 {
1209     /* solhint-disable var-name-mixedcase */
1210     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1211     // invalidate the cached domain separator if the chain id changes.
1212     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1213     uint256 private immutable _CACHED_CHAIN_ID;
1214     address private immutable _CACHED_THIS;
1215 
1216     bytes32 private immutable _HASHED_NAME;
1217     bytes32 private immutable _HASHED_VERSION;
1218     bytes32 private immutable _TYPE_HASH;
1219 
1220     /* solhint-enable var-name-mixedcase */
1221 
1222     /**
1223      * @dev Initializes the domain separator and parameter caches.
1224      *
1225      * The meaning of `name` and `version` is specified in
1226      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1227      *
1228      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1229      * - `version`: the current major version of the signing domain.
1230      *
1231      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1232      * contract upgrade].
1233      */
1234     constructor(string memory name, string memory version) {
1235         bytes32 hashedName = keccak256(bytes(name));
1236         bytes32 hashedVersion = keccak256(bytes(version));
1237         bytes32 typeHash = keccak256(
1238             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1239         );
1240         _HASHED_NAME = hashedName;
1241         _HASHED_VERSION = hashedVersion;
1242         _CACHED_CHAIN_ID = block.chainid;
1243         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1244         _CACHED_THIS = address(this);
1245         _TYPE_HASH = typeHash;
1246     }
1247 
1248     /**
1249      * @dev Returns the domain separator for the current chain.
1250      */
1251     function _domainSeparatorV4() internal view returns (bytes32) {
1252         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1253             return _CACHED_DOMAIN_SEPARATOR;
1254         } else {
1255             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1256         }
1257     }
1258 
1259     function _buildDomainSeparator(
1260         bytes32 typeHash,
1261         bytes32 nameHash,
1262         bytes32 versionHash
1263     ) private view returns (bytes32) {
1264         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1265     }
1266 
1267     /**
1268      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1269      * function returns the hash of the fully encoded EIP712 message for this domain.
1270      *
1271      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1272      *
1273      * ```solidity
1274      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1275      *     keccak256("Mail(address to,string contents)"),
1276      *     mailTo,
1277      *     keccak256(bytes(mailContents))
1278      * )));
1279      * address signer = ECDSA.recover(digest, signature);
1280      * ```
1281      */
1282     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1283         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1284     }
1285 }
1286 
1287 // 
1288 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1289 /**
1290  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1291  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1292  *
1293  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1294  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1295  * need to send a transaction, and thus is not required to hold Ether at all.
1296  *
1297  * _Available since v3.4._
1298  */
1299 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1300     using Counters for Counters.Counter;
1301 
1302     mapping(address => Counters.Counter) private _nonces;
1303 
1304     // solhint-disable-next-line var-name-mixedcase
1305     bytes32 private immutable _PERMIT_TYPEHASH =
1306         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1307 
1308     /**
1309      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1310      *
1311      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1312      */
1313     constructor(string memory name) EIP712(name, "1") {}
1314 
1315     /**
1316      * @dev See {IERC20Permit-permit}.
1317      */
1318     function permit(
1319         address owner,
1320         address spender,
1321         uint256 value,
1322         uint256 deadline,
1323         uint8 v,
1324         bytes32 r,
1325         bytes32 s
1326     ) public virtual override {
1327         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1328 
1329         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1330 
1331         bytes32 hash = _hashTypedDataV4(structHash);
1332 
1333         address signer = ECDSA.recover(hash, v, r, s);
1334         require(signer == owner, "ERC20Permit: invalid signature");
1335 
1336         _approve(owner, spender, value);
1337     }
1338 
1339     /**
1340      * @dev See {IERC20Permit-nonces}.
1341      */
1342     function nonces(address owner) public view virtual override returns (uint256) {
1343         return _nonces[owner].current();
1344     }
1345 
1346     /**
1347      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1348      */
1349     // solhint-disable-next-line func-name-mixedcase
1350     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1351         return _domainSeparatorV4();
1352     }
1353 
1354     /**
1355      * @dev "Consume a nonce": return the current value and increment.
1356      *
1357      * _Available since v4.1._
1358      */
1359     function _useNonce(address owner) internal virtual returns (uint256 current) {
1360         Counters.Counter storage nonce = _nonces[owner];
1361         current = nonce.current();
1362         nonce.increment();
1363     }
1364 }
1365 
1366 // 
1367 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
1368 /**
1369  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1370  * checks.
1371  *
1372  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1373  * easily result in undesired exploitation or bugs, since developers usually
1374  * assume that overflows raise errors. `SafeCast` restores this intuition by
1375  * reverting the transaction when such an operation overflows.
1376  *
1377  * Using this library instead of the unchecked operations eliminates an entire
1378  * class of bugs, so it's recommended to use it always.
1379  *
1380  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1381  * all math on `uint256` and `int256` and then downcasting.
1382  */
1383 library SafeCast {
1384     /**
1385      * @dev Returns the downcasted uint224 from uint256, reverting on
1386      * overflow (when the input is greater than largest uint224).
1387      *
1388      * Counterpart to Solidity's `uint224` operator.
1389      *
1390      * Requirements:
1391      *
1392      * - input must fit into 224 bits
1393      */
1394     function toUint224(uint256 value) internal pure returns (uint224) {
1395         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1396         return uint224(value);
1397     }
1398 
1399     /**
1400      * @dev Returns the downcasted uint128 from uint256, reverting on
1401      * overflow (when the input is greater than largest uint128).
1402      *
1403      * Counterpart to Solidity's `uint128` operator.
1404      *
1405      * Requirements:
1406      *
1407      * - input must fit into 128 bits
1408      */
1409     function toUint128(uint256 value) internal pure returns (uint128) {
1410         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1411         return uint128(value);
1412     }
1413 
1414     /**
1415      * @dev Returns the downcasted uint96 from uint256, reverting on
1416      * overflow (when the input is greater than largest uint96).
1417      *
1418      * Counterpart to Solidity's `uint96` operator.
1419      *
1420      * Requirements:
1421      *
1422      * - input must fit into 96 bits
1423      */
1424     function toUint96(uint256 value) internal pure returns (uint96) {
1425         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1426         return uint96(value);
1427     }
1428 
1429     /**
1430      * @dev Returns the downcasted uint64 from uint256, reverting on
1431      * overflow (when the input is greater than largest uint64).
1432      *
1433      * Counterpart to Solidity's `uint64` operator.
1434      *
1435      * Requirements:
1436      *
1437      * - input must fit into 64 bits
1438      */
1439     function toUint64(uint256 value) internal pure returns (uint64) {
1440         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1441         return uint64(value);
1442     }
1443 
1444     /**
1445      * @dev Returns the downcasted uint32 from uint256, reverting on
1446      * overflow (when the input is greater than largest uint32).
1447      *
1448      * Counterpart to Solidity's `uint32` operator.
1449      *
1450      * Requirements:
1451      *
1452      * - input must fit into 32 bits
1453      */
1454     function toUint32(uint256 value) internal pure returns (uint32) {
1455         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1456         return uint32(value);
1457     }
1458 
1459     /**
1460      * @dev Returns the downcasted uint16 from uint256, reverting on
1461      * overflow (when the input is greater than largest uint16).
1462      *
1463      * Counterpart to Solidity's `uint16` operator.
1464      *
1465      * Requirements:
1466      *
1467      * - input must fit into 16 bits
1468      */
1469     function toUint16(uint256 value) internal pure returns (uint16) {
1470         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1471         return uint16(value);
1472     }
1473 
1474     /**
1475      * @dev Returns the downcasted uint8 from uint256, reverting on
1476      * overflow (when the input is greater than largest uint8).
1477      *
1478      * Counterpart to Solidity's `uint8` operator.
1479      *
1480      * Requirements:
1481      *
1482      * - input must fit into 8 bits.
1483      */
1484     function toUint8(uint256 value) internal pure returns (uint8) {
1485         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1486         return uint8(value);
1487     }
1488 
1489     /**
1490      * @dev Converts a signed int256 into an unsigned uint256.
1491      *
1492      * Requirements:
1493      *
1494      * - input must be greater than or equal to 0.
1495      */
1496     function toUint256(int256 value) internal pure returns (uint256) {
1497         require(value >= 0, "SafeCast: value must be positive");
1498         return uint256(value);
1499     }
1500 
1501     /**
1502      * @dev Returns the downcasted int128 from int256, reverting on
1503      * overflow (when the input is less than smallest int128 or
1504      * greater than largest int128).
1505      *
1506      * Counterpart to Solidity's `int128` operator.
1507      *
1508      * Requirements:
1509      *
1510      * - input must fit into 128 bits
1511      *
1512      * _Available since v3.1._
1513      */
1514     function toInt128(int256 value) internal pure returns (int128) {
1515         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1516         return int128(value);
1517     }
1518 
1519     /**
1520      * @dev Returns the downcasted int64 from int256, reverting on
1521      * overflow (when the input is less than smallest int64 or
1522      * greater than largest int64).
1523      *
1524      * Counterpart to Solidity's `int64` operator.
1525      *
1526      * Requirements:
1527      *
1528      * - input must fit into 64 bits
1529      *
1530      * _Available since v3.1._
1531      */
1532     function toInt64(int256 value) internal pure returns (int64) {
1533         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1534         return int64(value);
1535     }
1536 
1537     /**
1538      * @dev Returns the downcasted int32 from int256, reverting on
1539      * overflow (when the input is less than smallest int32 or
1540      * greater than largest int32).
1541      *
1542      * Counterpart to Solidity's `int32` operator.
1543      *
1544      * Requirements:
1545      *
1546      * - input must fit into 32 bits
1547      *
1548      * _Available since v3.1._
1549      */
1550     function toInt32(int256 value) internal pure returns (int32) {
1551         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1552         return int32(value);
1553     }
1554 
1555     /**
1556      * @dev Returns the downcasted int16 from int256, reverting on
1557      * overflow (when the input is less than smallest int16 or
1558      * greater than largest int16).
1559      *
1560      * Counterpart to Solidity's `int16` operator.
1561      *
1562      * Requirements:
1563      *
1564      * - input must fit into 16 bits
1565      *
1566      * _Available since v3.1._
1567      */
1568     function toInt16(int256 value) internal pure returns (int16) {
1569         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1570         return int16(value);
1571     }
1572 
1573     /**
1574      * @dev Returns the downcasted int8 from int256, reverting on
1575      * overflow (when the input is less than smallest int8 or
1576      * greater than largest int8).
1577      *
1578      * Counterpart to Solidity's `int8` operator.
1579      *
1580      * Requirements:
1581      *
1582      * - input must fit into 8 bits.
1583      *
1584      * _Available since v3.1._
1585      */
1586     function toInt8(int256 value) internal pure returns (int8) {
1587         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1588         return int8(value);
1589     }
1590 
1591     /**
1592      * @dev Converts an unsigned uint256 into a signed int256.
1593      *
1594      * Requirements:
1595      *
1596      * - input must be less than or equal to maxInt256.
1597      */
1598     function toInt256(uint256 value) internal pure returns (int256) {
1599         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1600         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1601         return int256(value);
1602     }
1603 }
1604 
1605 // 
1606 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Votes.sol)
1607 /**
1608  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1609  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1610  *
1611  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1612  *
1613  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1614  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1615  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1616  *
1617  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1618  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1619  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1620  * will significantly increase the base gas cost of transfers.
1621  *
1622  * _Available since v4.2._
1623  */
1624 abstract contract ERC20Votes is ERC20Permit {
1625     struct Checkpoint {
1626         uint32 fromBlock;
1627         uint224 votes;
1628     }
1629 
1630     bytes32 private constant _DELEGATION_TYPEHASH =
1631         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1632 
1633     mapping(address => address) private _delegates;
1634     mapping(address => Checkpoint[]) private _checkpoints;
1635     Checkpoint[] private _totalSupplyCheckpoints;
1636 
1637     /**
1638      * @dev Emitted when an account changes their delegate.
1639      */
1640     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1641 
1642     /**
1643      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1644      */
1645     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1646 
1647     /**
1648      * @dev Get the `pos`-th checkpoint for `account`.
1649      */
1650     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1651         return _checkpoints[account][pos];
1652     }
1653 
1654     /**
1655      * @dev Get number of checkpoints for `account`.
1656      */
1657     function numCheckpoints(address account) public view virtual returns (uint32) {
1658         return SafeCast.toUint32(_checkpoints[account].length);
1659     }
1660 
1661     /**
1662      * @dev Get the address `account` is currently delegating to.
1663      */
1664     function delegates(address account) public view virtual returns (address) {
1665         return _delegates[account];
1666     }
1667 
1668     /**
1669      * @dev Gets the current votes balance for `account`
1670      */
1671     function getVotes(address account) public view returns (uint256) {
1672         uint256 pos = _checkpoints[account].length;
1673         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1674     }
1675 
1676     /**
1677      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1678      *
1679      * Requirements:
1680      *
1681      * - `blockNumber` must have been already mined
1682      */
1683     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1684         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1685         return _checkpointsLookup(_checkpoints[account], blockNumber);
1686     }
1687 
1688     /**
1689      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1690      * It is but NOT the sum of all the delegated votes!
1691      *
1692      * Requirements:
1693      *
1694      * - `blockNumber` must have been already mined
1695      */
1696     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1697         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1698         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1699     }
1700 
1701     /**
1702      * @dev Lookup a value in a list of (sorted) checkpoints.
1703      */
1704     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1705         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1706         //
1707         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1708         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1709         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1710         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1711         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1712         // out of bounds (in which case we're looking too far in the past and the result is 0).
1713         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1714         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1715         // the same.
1716         uint256 high = ckpts.length;
1717         uint256 low = 0;
1718         while (low < high) {
1719             uint256 mid = Math.average(low, high);
1720             if (ckpts[mid].fromBlock > blockNumber) {
1721                 high = mid;
1722             } else {
1723                 low = mid + 1;
1724             }
1725         }
1726 
1727         return high == 0 ? 0 : ckpts[high - 1].votes;
1728     }
1729 
1730     /**
1731      * @dev Delegate votes from the sender to `delegatee`.
1732      */
1733     function delegate(address delegatee) public virtual {
1734         _delegate(_msgSender(), delegatee);
1735     }
1736 
1737     /**
1738      * @dev Delegates votes from signer to `delegatee`
1739      */
1740     function delegateBySig(
1741         address delegatee,
1742         uint256 nonce,
1743         uint256 expiry,
1744         uint8 v,
1745         bytes32 r,
1746         bytes32 s
1747     ) public virtual {
1748         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1749         address signer = ECDSA.recover(
1750             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1751             v,
1752             r,
1753             s
1754         );
1755         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1756         _delegate(signer, delegatee);
1757     }
1758 
1759     /**
1760      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1761      */
1762     function _maxSupply() internal view virtual returns (uint224) {
1763         return type(uint224).max;
1764     }
1765 
1766     /**
1767      * @dev Snapshots the totalSupply after it has been increased.
1768      */
1769     function _mint(address account, uint256 amount) internal virtual override {
1770         super._mint(account, amount);
1771         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1772 
1773         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1774     }
1775 
1776     /**
1777      * @dev Snapshots the totalSupply after it has been decreased.
1778      */
1779     function _burn(address account, uint256 amount) internal virtual override {
1780         super._burn(account, amount);
1781 
1782         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1783     }
1784 
1785     /**
1786      * @dev Move voting power when tokens are transferred.
1787      *
1788      * Emits a {DelegateVotesChanged} event.
1789      */
1790     function _afterTokenTransfer(
1791         address from,
1792         address to,
1793         uint256 amount
1794     ) internal virtual override {
1795         super._afterTokenTransfer(from, to, amount);
1796 
1797         _moveVotingPower(delegates(from), delegates(to), amount);
1798     }
1799 
1800     /**
1801      * @dev Change delegation for `delegator` to `delegatee`.
1802      *
1803      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1804      */
1805     function _delegate(address delegator, address delegatee) internal virtual {
1806         address currentDelegate = delegates(delegator);
1807         uint256 delegatorBalance = balanceOf(delegator);
1808         _delegates[delegator] = delegatee;
1809 
1810         emit DelegateChanged(delegator, currentDelegate, delegatee);
1811 
1812         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1813     }
1814 
1815     function _moveVotingPower(
1816         address src,
1817         address dst,
1818         uint256 amount
1819     ) private {
1820         if (src != dst && amount > 0) {
1821             if (src != address(0)) {
1822                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1823                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1824             }
1825 
1826             if (dst != address(0)) {
1827                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1828                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1829             }
1830         }
1831     }
1832 
1833     function _writeCheckpoint(
1834         Checkpoint[] storage ckpts,
1835         function(uint256, uint256) view returns (uint256) op,
1836         uint256 delta
1837     ) private returns (uint256 oldWeight, uint256 newWeight) {
1838         uint256 pos = ckpts.length;
1839         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1840         newWeight = op(oldWeight, delta);
1841 
1842         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1843             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1844         } else {
1845             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1846         }
1847     }
1848 
1849     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1850         return a + b;
1851     }
1852 
1853     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1854         return a - b;
1855     }
1856 }
1857 
1858 // 
1859 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1860 /**
1861  * @dev External interface of AccessControl declared to support ERC165 detection.
1862  */
1863 interface IAccessControl {
1864     /**
1865      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1866      *
1867      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1868      * {RoleAdminChanged} not being emitted signaling this.
1869      *
1870      * _Available since v3.1._
1871      */
1872     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1873 
1874     /**
1875      * @dev Emitted when `account` is granted `role`.
1876      *
1877      * `sender` is the account that originated the contract call, an admin role
1878      * bearer except when using {AccessControl-_setupRole}.
1879      */
1880     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1881 
1882     /**
1883      * @dev Emitted when `account` is revoked `role`.
1884      *
1885      * `sender` is the account that originated the contract call:
1886      *   - if using `revokeRole`, it is the admin role bearer
1887      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1888      */
1889     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1890 
1891     /**
1892      * @dev Returns `true` if `account` has been granted `role`.
1893      */
1894     function hasRole(bytes32 role, address account) external view returns (bool);
1895 
1896     /**
1897      * @dev Returns the admin role that controls `role`. See {grantRole} and
1898      * {revokeRole}.
1899      *
1900      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1901      */
1902     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1903 
1904     /**
1905      * @dev Grants `role` to `account`.
1906      *
1907      * If `account` had not been already granted `role`, emits a {RoleGranted}
1908      * event.
1909      *
1910      * Requirements:
1911      *
1912      * - the caller must have ``role``'s admin role.
1913      */
1914     function grantRole(bytes32 role, address account) external;
1915 
1916     /**
1917      * @dev Revokes `role` from `account`.
1918      *
1919      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1920      *
1921      * Requirements:
1922      *
1923      * - the caller must have ``role``'s admin role.
1924      */
1925     function revokeRole(bytes32 role, address account) external;
1926 
1927     /**
1928      * @dev Revokes `role` from the calling account.
1929      *
1930      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1931      * purpose is to provide a mechanism for accounts to lose their privileges
1932      * if they are compromised (such as when a trusted device is misplaced).
1933      *
1934      * If the calling account had been granted `role`, emits a {RoleRevoked}
1935      * event.
1936      *
1937      * Requirements:
1938      *
1939      * - the caller must be `account`.
1940      */
1941     function renounceRole(bytes32 role, address account) external;
1942 }
1943 
1944 // 
1945 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1946 /**
1947  * @dev Interface of the ERC165 standard, as defined in the
1948  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1949  *
1950  * Implementers can declare support of contract interfaces, which can then be
1951  * queried by others ({ERC165Checker}).
1952  *
1953  * For an implementation, see {ERC165}.
1954  */
1955 interface IERC165 {
1956     /**
1957      * @dev Returns true if this contract implements the interface defined by
1958      * `interfaceId`. See the corresponding
1959      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1960      * to learn more about how these ids are created.
1961      *
1962      * This function call must use less than 30 000 gas.
1963      */
1964     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1965 }
1966 
1967 // 
1968 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1969 /**
1970  * @dev Implementation of the {IERC165} interface.
1971  *
1972  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1973  * for the additional interface id that will be supported. For example:
1974  *
1975  * ```solidity
1976  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1977  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1978  * }
1979  * ```
1980  *
1981  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1982  */
1983 abstract contract ERC165 is IERC165 {
1984     /**
1985      * @dev See {IERC165-supportsInterface}.
1986      */
1987     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1988         return interfaceId == type(IERC165).interfaceId;
1989     }
1990 }
1991 
1992 // 
1993 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
1994 /**
1995  * @dev Contract module that allows children to implement role-based access
1996  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1997  * members except through off-chain means by accessing the contract event logs. Some
1998  * applications may benefit from on-chain enumerability, for those cases see
1999  * {AccessControlEnumerable}.
2000  *
2001  * Roles are referred to by their `bytes32` identifier. These should be exposed
2002  * in the external API and be unique. The best way to achieve this is by
2003  * using `public constant` hash digests:
2004  *
2005  * ```
2006  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2007  * ```
2008  *
2009  * Roles can be used to represent a set of permissions. To restrict access to a
2010  * function call, use {hasRole}:
2011  *
2012  * ```
2013  * function foo() public {
2014  *     require(hasRole(MY_ROLE, msg.sender));
2015  *     ...
2016  * }
2017  * ```
2018  *
2019  * Roles can be granted and revoked dynamically via the {grantRole} and
2020  * {revokeRole} functions. Each role has an associated admin role, and only
2021  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2022  *
2023  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2024  * that only accounts with this role will be able to grant or revoke other
2025  * roles. More complex role relationships can be created by using
2026  * {_setRoleAdmin}.
2027  *
2028  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2029  * grant and revoke this role. Extra precautions should be taken to secure
2030  * accounts that have been granted it.
2031  */
2032 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2033     struct RoleData {
2034         mapping(address => bool) members;
2035         bytes32 adminRole;
2036     }
2037 
2038     mapping(bytes32 => RoleData) private _roles;
2039 
2040     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2041 
2042     /**
2043      * @dev Modifier that checks that an account has a specific role. Reverts
2044      * with a standardized message including the required role.
2045      *
2046      * The format of the revert reason is given by the following regular expression:
2047      *
2048      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2049      *
2050      * _Available since v4.1._
2051      */
2052     modifier onlyRole(bytes32 role) {
2053         _checkRole(role, _msgSender());
2054         _;
2055     }
2056 
2057     /**
2058      * @dev See {IERC165-supportsInterface}.
2059      */
2060     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2061         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2062     }
2063 
2064     /**
2065      * @dev Returns `true` if `account` has been granted `role`.
2066      */
2067     function hasRole(bytes32 role, address account) public view override returns (bool) {
2068         return _roles[role].members[account];
2069     }
2070 
2071     /**
2072      * @dev Revert with a standard message if `account` is missing `role`.
2073      *
2074      * The format of the revert reason is given by the following regular expression:
2075      *
2076      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2077      */
2078     function _checkRole(bytes32 role, address account) internal view {
2079         if (!hasRole(role, account)) {
2080             revert(
2081                 string(
2082                     abi.encodePacked(
2083                         "AccessControl: account ",
2084                         Strings.toHexString(uint160(account), 20),
2085                         " is missing role ",
2086                         Strings.toHexString(uint256(role), 32)
2087                     )
2088                 )
2089             );
2090         }
2091     }
2092 
2093     /**
2094      * @dev Returns the admin role that controls `role`. See {grantRole} and
2095      * {revokeRole}.
2096      *
2097      * To change a role's admin, use {_setRoleAdmin}.
2098      */
2099     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
2100         return _roles[role].adminRole;
2101     }
2102 
2103     /**
2104      * @dev Grants `role` to `account`.
2105      *
2106      * If `account` had not been already granted `role`, emits a {RoleGranted}
2107      * event.
2108      *
2109      * Requirements:
2110      *
2111      * - the caller must have ``role``'s admin role.
2112      */
2113     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2114         _grantRole(role, account);
2115     }
2116 
2117     /**
2118      * @dev Revokes `role` from `account`.
2119      *
2120      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2121      *
2122      * Requirements:
2123      *
2124      * - the caller must have ``role``'s admin role.
2125      */
2126     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2127         _revokeRole(role, account);
2128     }
2129 
2130     /**
2131      * @dev Revokes `role` from the calling account.
2132      *
2133      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2134      * purpose is to provide a mechanism for accounts to lose their privileges
2135      * if they are compromised (such as when a trusted device is misplaced).
2136      *
2137      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2138      * event.
2139      *
2140      * Requirements:
2141      *
2142      * - the caller must be `account`.
2143      */
2144     function renounceRole(bytes32 role, address account) public virtual override {
2145         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2146 
2147         _revokeRole(role, account);
2148     }
2149 
2150     /**
2151      * @dev Grants `role` to `account`.
2152      *
2153      * If `account` had not been already granted `role`, emits a {RoleGranted}
2154      * event. Note that unlike {grantRole}, this function doesn't perform any
2155      * checks on the calling account.
2156      *
2157      * [WARNING]
2158      * ====
2159      * This function should only be called from the constructor when setting
2160      * up the initial roles for the system.
2161      *
2162      * Using this function in any other way is effectively circumventing the admin
2163      * system imposed by {AccessControl}.
2164      * ====
2165      *
2166      * NOTE: This function is deprecated in favor of {_grantRole}.
2167      */
2168     function _setupRole(bytes32 role, address account) internal virtual {
2169         _grantRole(role, account);
2170     }
2171 
2172     /**
2173      * @dev Sets `adminRole` as ``role``'s admin role.
2174      *
2175      * Emits a {RoleAdminChanged} event.
2176      */
2177     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2178         bytes32 previousAdminRole = getRoleAdmin(role);
2179         _roles[role].adminRole = adminRole;
2180         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2181     }
2182 
2183     /**
2184      * @dev Grants `role` to `account`.
2185      *
2186      * Internal function without access restriction.
2187      */
2188     function _grantRole(bytes32 role, address account) internal virtual {
2189         if (!hasRole(role, account)) {
2190             _roles[role].members[account] = true;
2191             emit RoleGranted(role, account, _msgSender());
2192         }
2193     }
2194 
2195     /**
2196      * @dev Revokes `role` from `account`.
2197      *
2198      * Internal function without access restriction.
2199      */
2200     function _revokeRole(bytes32 role, address account) internal virtual {
2201         if (hasRole(role, account)) {
2202             _roles[role].members[account] = false;
2203             emit RoleRevoked(role, account, _msgSender());
2204         }
2205     }
2206 }
2207 
2208 // 
2209 /// @title The core control module of TiTi Protocol
2210 /// @author TiTi Protocol
2211 /// @notice The module is used to update the key parameters in the protocol.
2212 /// @dev Only the owner can call the params' update function, the owner will be transferred to Timelock in the future.
2213 contract TiTiToken is ERC20Burnable, ERC20Snapshot, ERC20Votes, AccessControl {
2214     /// @notice TiTi's max supply is 1 billion.
2215     uint256 public constant MAX_TOTAL_SUPPLY = 1000000000 * 1e18;
2216 
2217     /// @notice Snapshot role's flag.
2218     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
2219 
2220     /// @notice Minter role's flag.
2221     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2222 
2223     /// @notice Emitted when new admin is set.
2224     event NewAdmin(address indexed oldAdmin, address indexed newAdmin);
2225 
2226     constructor() ERC20("TiTi", "TiTi") ERC20Permit("TiTi") {
2227         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2228         _setupRole(SNAPSHOT_ROLE, msg.sender);
2229         _setupRole(MINTER_ROLE, msg.sender);
2230         _setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
2231         _setRoleAdmin(SNAPSHOT_ROLE, DEFAULT_ADMIN_ROLE);
2232 
2233         _mint(msg.sender, MAX_TOTAL_SUPPLY);
2234     }
2235 
2236     /// @notice Set new admin and the old one's role will be revoked.
2237     /// @param _newAdmin New admin address.
2238     function setNewAdmin(address _newAdmin) external onlyRole(DEFAULT_ADMIN_ROLE) {
2239         require(_newAdmin != address(0), "TiTiToken: Zero Address");
2240         address _oldAdmin = msg.sender;
2241         _setupRole(DEFAULT_ADMIN_ROLE, _newAdmin);
2242         revokeRole(DEFAULT_ADMIN_ROLE, _oldAdmin);
2243         emit NewAdmin(_oldAdmin, _newAdmin);
2244     }
2245 
2246     /// @notice Batch set new minters.
2247     /// @param _newMinters New minters' address.
2248     function setNewMinters(address[] memory _newMinters) external onlyRole(DEFAULT_ADMIN_ROLE) {
2249         for (uint i; i < _newMinters.length; i++) {
2250             require(_newMinters[i] != address(0), "TiTiToken: Zero Address");
2251             _setupRole(MINTER_ROLE, _newMinters[i]);
2252         }
2253     }
2254 
2255     /// @notice Creates a new snapshot and returns its snapshot id.
2256     /// @return snapshot_id New snapshot id. 
2257     function snapshot() external onlyRole(SNAPSHOT_ROLE) returns (uint256) {
2258         return _snapshot();
2259     }
2260 
2261     /// @notice Mint more TiTi token.
2262     /// @param to Received address.
2263     /// @param amount Received amount.
2264     function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
2265         _mint(to, amount);
2266     }
2267 
2268     function _beforeTokenTransfer(address from, address to, uint256 amount)
2269         internal
2270         override(ERC20, ERC20Snapshot)
2271     {
2272         super._beforeTokenTransfer(from, to, amount);
2273     }
2274 
2275     function _afterTokenTransfer(address from, address to, uint256 amount)
2276         internal
2277         override(ERC20, ERC20Votes)
2278     {
2279         super._afterTokenTransfer(from, to, amount);
2280     }
2281 
2282     function _mint(address to, uint256 amount)
2283         internal
2284         override(ERC20, ERC20Votes)
2285     {
2286         uint256 lastTotalSupply = totalSupply();
2287         require(lastTotalSupply + amount <= MAX_TOTAL_SUPPLY, "TiTiToken: Exceeds the maximum supply");
2288         super._mint(to, amount);
2289     }
2290 
2291     function _burn(address account, uint256 amount)
2292         internal
2293         override(ERC20, ERC20Votes)
2294     {
2295         super._burn(account, amount);
2296     }
2297 }